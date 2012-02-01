Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab2BAVPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:15:00 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49189 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932618Ab2BAVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:30 -0500
X-Sasl-enc: 1NHsq8Sa4gh6lfIaHvBlkFe05rfbAvQ4YI80CUIz01yu 1328130629
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.737815908@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Francis Moreau <francis.moro@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [55/89] USB: Realtek cr: fix autopm scheduling while atomic
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit b3ef051db763b640d1ff724b616ffba940896b44 upstream.

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=784345

Reported-by: Francis Moreau <francis.moro@gmail.com>
Reported-and-tested-by: Christian D <chrisudeussen@gmail.com>
Reported-and-tested-by: Jimmy Dorff <jdorff@phy.duke.edu>
Reported-and-tested-by: collura@ieee.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/realtek_cr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -791,7 +791,7 @@ static void rts51x_suspend_timer_fn(unsi
 			rts51x_set_stat(chip, RTS51X_STAT_SS);
 			/* ignore mass storage interface's children */
 			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
-			usb_autopm_put_interface(us->pusb_intf);
+			usb_autopm_put_interface_async(us->pusb_intf);
 			US_DEBUGP("%s: RTS51X_STAT_SS 01,"
 				"intf->pm_usage_cnt:%d, power.usage:%d\n",
 				__func__,


