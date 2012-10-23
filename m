Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab2JWUKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:10:21 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:43103 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab2JWUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:10:18 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 16:10:17 EDT
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 23 Oct 2012 16:03:33 -0400
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>, linux@sierrawireless.com
Subject: Fix memory leak in sierra_release()
Message-ID: <20121023200333.GN18610@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a memory leak in sierra_release() (well sierra_probe() I guess)
that looses 8 bytes each time the driver releases a device.

Here is the patch to fix it.

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 01d882c..76ef95b 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -959,6 +959,7 @@ static void sierra_release(struct usb_serial *serial)
 			continue;
 		kfree(portdata);
 	}
+	kfree(serial->private);
 }
 
 #ifdef CONFIG_PM

-- 
Len Sorensen
