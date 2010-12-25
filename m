Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0LYGDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 01:03:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49554 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0LYGDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 01:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n1BP9lEpdJL2xLfREWgbCqGab+99dIpw6sD9Fvt2FwC9BZOKBeMSQr+nOU3EKf0Vr/
         BSDR1t0pRj3qgwMk0fA8RVEDRDw3cn3nMlbr0ypkSiGsZI+llxvVygkSRfCMSpP9IVnn
         n5tcR+wooyycOEXBo2vwETs+xKaXGplbzNKZk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] uml: use simple_write_to_buffer
Date: Sat, 25 Dec 2010 15:03:57 +0900
Message-Id: <1293257039-2580-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify write file operation for mmapper by using
simple_write_to_buffer().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
 arch/um/drivers/mmapper_kern.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index 8501e7d..4ad91c6 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -37,13 +37,7 @@ static ssize_t mmapper_write(struct file *file, const char __user *buf,
 	if (*ppos > mmapper_size)
 		return -EINVAL;
 
-	if (count > mmapper_size - *ppos)
-		count = mmapper_size - *ppos;
-
-	if (copy_from_user(&v_buf[*ppos], buf, count))
-		return -EFAULT;
-
-	return count;
+	return simple_write_to_buffer(v_buf, mmapper_size, ppos, buf, count);
 }
 
 static long mmapper_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-- 
1.7.3.4

