Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab2J2WGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:06:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:47730 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761297Ab2J2Vhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 063/101] USB: serial: Fix memory leak in sierra_release()
Date: Mon, 29 Oct 2012 14:35:16 -0700
Message-Id: <20121029213247.303449575@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

commit f7bc5051667b74c3861f79eed98c60d5c3b883f7 upstream.

I found a memory leak in sierra_release() (well sierra_probe() I guess)
that looses 8 bytes each time the driver releases a device.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -961,6 +961,7 @@ static void sierra_release(struct usb_se
 			continue;
 		kfree(portdata);
 	}
+	kfree(serial->private);
 }
 
 #ifdef CONFIG_PM


