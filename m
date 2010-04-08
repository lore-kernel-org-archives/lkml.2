Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab0DHMNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:13:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62976 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0DHMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=nzFFtOAXPgFDhELVMF/OkbHPQQBghCcrAHqdD6sCA9roUD7ZKhFKKNTlTtHOmir6II
         Y787/FZEncU/Elr/LCV+jC6R/bwXjeLg3/ocLi6Vcd70WghhjjTERWP1ezeeKXaboLbw
         yy0IzFmeO7xQ8yXcOpco6ZN9y4cy2ruBCd5rw=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 28/28] Staging: comedi: fix print(k) coding style issue in aio_aio12_8.c
Date: Thu,  8 Apr 2010 13:13:20 +0100
Message-Id: <1270728800-2388-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the aio_aio12_8.c that fixes up print(k) warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/aio_aio12_8.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index c4cac66..7a1c636 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -110,7 +110,7 @@ static int aio_aio12_8_ai_read(struct comedi_device *dev,
 		while (timeout &&
 		       !(inb(dev->iobase + AIO12_8_STATUS) & STATUS_ADC_EOC)) {
 			timeout--;
-			printk("timeout %d\n", timeout);
+			printk(KERN_ERR "timeout %d\n", timeout);
 			udelay(1);
 		}
 		if (timeout == 0) {
@@ -172,7 +172,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 	if (!request_region(iobase, 24, "aio_aio12_8")) {
-		printk("I/O port conflict");
+		printk(KERN_ERR "I/O port conflict");
 		return -EIO;
 	}
 
-- 
1.6.3.3

