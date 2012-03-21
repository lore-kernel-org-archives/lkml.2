Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916Ab2CUNI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:08:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786Ab2CUNI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:08:26 -0400
Subject: [PATCH] do not export kernel's NULL #define to userspace
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 14:08:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201203211408.25040.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC's NULL is actually __null, which allows detecting some questionable
NULL usage and warn about it. Moreover each platform/compiler should have
its own stddef.h anyway (which is different from linux/stddef.h).
So there's no good reason to leak kernel's NULL to userspace and
override what the compiler provides.

Signed-off-by: Luboš Luňák <l.lunak@suse.cz>
---
 include/linux/stddef.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..1747b67 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -3,14 +3,10 @@
 
 #include <linux/compiler.h>
 
+#ifdef __KERNEL__
+
 #undef NULL
-#if defined(__cplusplus)
-#define NULL 0
-#else
 #define NULL ((void *)0)
-#endif
-
-#ifdef __KERNEL__
 
 enum {
 	false	= 0,
-- 
1.7.3.4
-- 
 Lubos Lunak
 l.lunak@suse.cz
