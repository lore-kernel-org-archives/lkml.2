Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1IPQdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:33:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54894 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1IPQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:32:59 -0400
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk, Tzu-Jung Lee <tjlee@ambarella.com>
Subject: [PATCH] ARM: tlb: Compile out MULTI_TLB specific code when MULTI_TLB is undefined
Date: Sat, 17 Sep 2011 00:31:06 +0800
Message-Id: <1316190666-18905-1-git-send-email-tjlee@ambarella.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eliminate the 'undefined cpu_tlb' errors when the kernel is built with -O0

Change-Id: Ie5afea022b30dbe23a7ee3f3fc6af0dd6479b980
Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>

diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
index d2005de..a3f7aea 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -230,23 +230,22 @@ struct cpu_tlb_fns {
  */
 #ifdef MULTI_TLB
 
+extern struct cpu_tlb_fns cpu_tlb;
 #define __cpu_flush_user_tlb_range	cpu_tlb.flush_user_range
 #define __cpu_flush_kern_tlb_range	cpu_tlb.flush_kern_range
+#define __cpu_tlb_flags			cpu_tlb.tlb_flags
 
 #else
 
 #define __cpu_flush_user_tlb_range	__glue(_TLB,_flush_user_tlb_range)
 #define __cpu_flush_kern_tlb_range	__glue(_TLB,_flush_kern_tlb_range)
+#define __cpu_tlb_flags			0
 
 extern void __cpu_flush_user_tlb_range(unsigned long, unsigned long, struct vm_area_struct *);
 extern void __cpu_flush_kern_tlb_range(unsigned long, unsigned long);
 
 #endif
 
-extern struct cpu_tlb_fns cpu_tlb;
-
-#define __cpu_tlb_flags			cpu_tlb.tlb_flags
-
 /*
  *	TLB Management
  *	==============
-- 
1.7.6.1

