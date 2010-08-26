Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab0HZKw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:52:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42220 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0HZKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rpK943H0zFVzjk49qduR7hpEeezzuX9eK1YpGXAqqFaY3Ub6zH7bWM4wt9BpgDUsKZ
         b7LPcpDSbTe07U9gzD0PGAMtJgzAKKa6h1wKfmiwLl3WvyPeTQB5gdwbYLj7d+0EoBCm
         3gEPbGD4i4kF2/hlqqLfUyBkQD2SwM0/YB8wg=
From: Namhyung Kim <namhyung@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] h8300: fix a bug on get_user()
Date: Thu, 26 Aug 2010 19:52:45 +0900
Message-Id: <1282819965-6025-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current implementation of get_user() lacks parenthesis when it derefers ptr
so usage like get_user(val, addr + i) had a potential bug. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/h8300/include/asm/uaccess.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/include/asm/uaccess.h b/arch/h8300/include/asm/uaccess.h
index 356068c..b0e5cb9 100644
--- a/arch/h8300/include/asm/uaccess.h
+++ b/arch/h8300/include/asm/uaccess.h
@@ -91,7 +91,7 @@ extern int __put_user_bad(void);
 #define get_user(x, ptr)					\
 ({								\
     int __gu_err = 0;						\
-    typeof(*(ptr)) __gu_val = *ptr;				\
+    typeof(*(ptr)) __gu_val = *(ptr);				\
     switch (sizeof(*(ptr))) {					\
     case 1:							\
     case 2:							\
-- 
1.7.2.2

