Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab0GaRkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:40:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39928 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0GaRkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LOErJfv9KhrmuIeZhVcqZ3ORkTjjR1TVhrnpiyek6Th/IClfD9UkSybbVECBCHhh5E
         MbSwA9MoVYQcgrIBpbt4yIloH+1lEM0lMA5wtYE2gCOobVczK3c+zpLX10NmkQCfSV7s
         b0x+dSd8ijSL0+YpU2f4CUHmLJZEFqEdxE5xU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Daniel Mack <daniel@caiaq.de>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] usb: iowarrior: fix misuse of return value of copy_to_user()
Date: Sat, 31 Jul 2010 21:39:46 +0400
Message-Id: <1280597987-8565-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns number of not copied bytes, not error code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/misc/iowarrior.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 2de49c8..bc88c79 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -542,7 +542,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 			retval = io_res;
 		else {
 			io_res = copy_to_user(user_buffer, buffer, dev->report_size);
-			if (io_res < 0)
+			if (io_res)
 				retval = -EFAULT;
 		}
 		break;
@@ -574,7 +574,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 			}
 			io_res = copy_to_user((struct iowarrior_info __user *)arg, &info,
 					 sizeof(struct iowarrior_info));
-			if (io_res < 0)
+			if (io_res)
 				retval = -EFAULT;
 			break;
 		}
-- 
1.7.0.4

