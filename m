Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2E0A6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:58:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56104 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2E0A6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:58:48 -0400
Message-Id: <20120527002617.366004498@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:36 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 23/55] USB: cdc-wdm: poll must return POLLHUP if device is gone
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 616b6937e348ef2b4c6ea5fef2cd3c441145efb0 upstream.

Else the poll will be restarted indefinitely in a tight loop,
preventing final device cleanup.

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -511,7 +511,7 @@ static unsigned int wdm_poll(struct file
 
 	spin_lock_irqsave(&desc->iuspin, flags);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
-		mask = POLLERR;
+		mask = POLLHUP | POLLERR;
 		spin_unlock_irqrestore(&desc->iuspin, flags);
 		goto desc_out;
 	}


