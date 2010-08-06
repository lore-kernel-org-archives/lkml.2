Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934933Ab0HFMqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:46:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32793 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0HFMqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ba+US2eiQtKmzd9MKwwTOrJVA8+vi10Qvu9g80hs32F0Wt09kGzcCUzdmUfwV5Moz9
         5DhpBLmjtqcOqnWN+k0PoL5KPF+tb+0NxzQkWriWEZ5pdreLqzo4K/8bJkuvGBnEo3O2
         YCkTUXP8jF1qrOEbUwxgIY029OW4wEdwHZc8A=
From: Namhyung Kim <namhyung@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] percpu: remove address_space attribute if !SMP
Date: Fri,  6 Aug 2010 21:46:08 +0900
Message-Id: <1281098768-5724-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu data has no special meaning in case of !CONFIG_SMP.
This removes lots of sparse warnings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index a5a472b..8dfd41d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -15,7 +15,11 @@
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
-# define __percpu	__attribute__((noderef, address_space(3)))
+# ifdef CONFIG_SMP
+#  define __percpu	__attribute__((noderef, address_space(3)))
+# else
+#  define __percpu
+# endif
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
-- 
1.7.0.4

