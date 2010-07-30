Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab0G3LIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:08:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54240 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab0G3LIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q26OSgsX9SdSS6vsydiBcORxmhqxCoZRCbsd1EK2LNkGVM2OTaSwq/AcUldLceQTsc
         TGs73VUKF3sumu/qtRZboq7gXWoCO/NNO6ezfPqYdA9znJQUS7hZnBslEm0RZal3hBGt
         hZTnMY+mVSyn+0UBhvFO+7HUJm0x+FMxU+3bc=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Beregalov <a.beregalov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] staging: otus: check kmalloc() return value
Date: Fri, 30 Jul 2010 15:08:00 +0400
Message-Id: <1280488080-20777-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() may fail, if so return error from zfwUsbSubmitControl().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/otus/wrap_usb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/otus/wrap_usb.c b/drivers/staging/otus/wrap_usb.c
index 93459ca..9f04047 100644
--- a/drivers/staging/otus/wrap_usb.c
+++ b/drivers/staging/otus/wrap_usb.c
@@ -104,6 +104,11 @@ u32_t zfwUsbSubmitControl(zdev_t *dev, u8_t req, u16_t value, u16_t index,
 
 	if (size > 0) {
 		buf = kmalloc(size, GFP_KERNEL);
+		if (buf == NULL) {
+			pr_err("zfwUsbSubmitControl() failed, "
+				  "kmalloc() returned NULL\n");
+			return 1;
+		}
 		memcpy(buf, (u8_t *)data, size);
 	} else
 		buf = NULL;
-- 
1.7.0.4

