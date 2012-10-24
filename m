Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936Ab2JXOXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:23:12 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:35063 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800Ab2JXOXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:23:11 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 24 Oct 2012 10:23:09 -0400
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>, linux@sierrawireless.com,
        linux-usb@vger.kernel.org
Subject: Fix memory leak in sierra_release() (this time with signed-off-by)
Message-ID: <20121024142309.GQ18610@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a memory leak in sierra_release() (well sierra_probe() I guess)
that looses 8 bytes each time the driver releases a device.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

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
