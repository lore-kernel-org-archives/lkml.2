Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab0GaRkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:40:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51516 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0GaRk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QsAfrT5cB++BdhZaXZV3lG0fDrfGAozj/Qt1BmxsbfSfVF2kTIbv7o28gvDcpT4kmT
         gQy5jdmIw41l91TyDEfI/lLllSkQ3J1xtHWC2vLAIQ0IZdOhntKp4ii2UEImaL3HQCii
         K+CaOafYEi2yCB6N4efny2gZTp0Wkvi7XJagA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?q?N=C3=A9meth=20M=C3=A1rton?= <nm127@freemail.hu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] usb: adutux: fix misuse of return value of copy_to_user()
Date: Sat, 31 Jul 2010 21:40:07 +0400
Message-Id: <1280598008-8605-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns number of not copied bytes, not error code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/misc/adutux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index d240de0..801324a 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -439,7 +439,7 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 			/* drain secondary buffer */
 			int amount = bytes_to_read < data_in_secondary ? bytes_to_read : data_in_secondary;
 			i = copy_to_user(buffer, dev->read_buffer_secondary+dev->secondary_head, amount);
-			if (i < 0) {
+			if (i) {
 				retval = -EFAULT;
 				goto exit;
 			}
-- 
1.7.0.4

