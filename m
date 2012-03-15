Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590Ab2COOgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:36:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34166 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761209Ab2COOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:36:36 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: johnstul@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 1/2] math: Introduce div64_long
Date: Thu, 15 Mar 2012 12:36:13 -0400
Message-Id: <1331829374-31543-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a div64_long macro which is used to devide a 64bit number by a long (which
can be 4 bytes on 32bit systems and 8 bytes on 64bit systems).

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/math64.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 23fcdfc..b8ba855 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -6,6 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
+#define div64_long(x,y) div64_s64((x),(y))
+
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
  *
@@ -45,6 +47,8 @@ static inline s64 div64_s64(s64 dividend, s64 divisor)
 
 #elif BITS_PER_LONG == 32
 
+#define div64_long(x,y) div_s64((x),(y))
+
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 {
-- 
1.7.8.4

