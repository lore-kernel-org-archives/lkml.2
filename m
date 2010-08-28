Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0H1RNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:13:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54877 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0H1RNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vld0pMqCSkeTFYxiyUPjdSqcp8SS4FlnF2+i6Ti3RgaPVSHv3swF3b4oTXcfHNjWU1
         9aZpWBUTgfR2247dds1S0+0xRcH6eVr8wcLLgrn8lK95ijR5p3wOO8aAR0bE3a8C1HL7
         bBcrtFnP8OJqsd4nUQiOLlFYZRw+EwzwrEpXY=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86-64: Remove system_64.h
Date: Sat, 28 Aug 2010 13:11:48 -0400
Message-Id: <1283015508-17547-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header is no longer used.  The %cr8 funtions are now in system.h.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/system_64.h |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)
 delete mode 100644 arch/x86/include/asm/system_64.h

diff --git a/arch/x86/include/asm/system_64.h b/arch/x86/include/asm/system_64.h
deleted file mode 100644
index 1159e09..0000000
--- a/arch/x86/include/asm/system_64.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _ASM_X86_SYSTEM_64_H
-#define _ASM_X86_SYSTEM_64_H
-
-#include <asm/segment.h>
-#include <asm/cmpxchg.h>
-
-
-static inline unsigned long read_cr8(void)
-{
-	unsigned long cr8;
-	asm volatile("movq %%cr8,%0" : "=r" (cr8));
-	return cr8;
-}
-
-static inline void write_cr8(unsigned long val)
-{
-	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
-}
-
-#include <linux/irqflags.h>
-
-#endif /* _ASM_X86_SYSTEM_64_H */
-- 
1.7.2.2

