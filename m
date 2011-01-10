Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1AJQf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:35:28 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:23375 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753153Ab1AJQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:35:25 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: U5VUihcVM1kIG8cc8yetThjkAjkr2Jolrk2QlQT_Gb8JeAZ
 ooaFTkVPVsSiRHRV0ysFRNgi0gVit7QQ0Fe.dSempnoILmNf6507ZEWJVJX_
 s5gp3fRUWXp.lExIOXDIBFZDRJP8mBSRiULXj60Od_82ePkw9rdrcMKL892T
 kyp6PDQ79lAGEX4J5eSbTrMy6FA9x6cBnaYYV3Au3tYcRs8Pd.MTC_uTUON5
 f_wuQGpMcuVoXUdIF7c2nK5xIFF9bT6AhUwy6Sh_lp0o09_ZSgb0ldpSJCsc
 .Mu3gWQ4ua1rG997ueV.DkbZJiiY6pD243GoQLNpSaTxr1Zg-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 10 Jan 2011 10:35:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: x86,percpu: Move out of place 64 bit ops into X86_64 section
Message-ID: <alpine.DEB.2.00.1101101034290.12243@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86,percpu: Move out of place 64 bit ops into X86_64 section

Some operations that operate on 64 bit operands are defined for 32 bit.
Move them into the correct section.

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 arch/x86/include/asm/percpu.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-01-10 10:29:29.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2011-01-10 10:30:22.000000000 -0600
@@ -414,8 +414,6 @@ do {									\
 #define this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)

 #define irqsafe_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
@@ -432,8 +430,6 @@ do {									\
 #define irqsafe_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define irqsafe_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define irqsafe_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)

 #ifndef CONFIG_M386
 #define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
@@ -475,11 +471,15 @@ do {									\
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
+#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)

 #define irqsafe_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #endif

 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
