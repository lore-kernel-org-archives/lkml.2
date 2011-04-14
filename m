Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1DNW1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:27:32 -0400
Received: from mail.digium.com ([216.207.245.2]:47221 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1DNW13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:27:29 -0400
Date: Thu, 14 Apr 2011 17:27:19 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: Define 'crash_kexec_wait_realmode' for Non-SMP
	systems.
Message-ID: <20110414222719.GA16256@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression from b987812b3fcaf70fdf0037589e5d2f5f2453e6ce
"powerpc/kexec: Fix mismatched ifdefs for PPC64/SMP" which resulted in

arch/powerpc/kernel/crash.c: In function ‘default_machine_crash_shutdown’:
  arch/powerpc/kernel/crash.c:349: error: implicit declaration of function
  ‘crash_kexec_wait_realmode’

message on when compiling on Blue&White G3 and CONFIG_SMP is not defined.

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
---
 arch/powerpc/kernel/crash.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 3d3d416..5e6e37f 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -255,6 +255,9 @@ void crash_kexec_secondary(struct pt_regs *regs)
 {
 	cpus_in_sr = CPU_MASK_NONE;
 }
+
+static inline void crash_kexec_wait_realmode(int cpu) {}
+
 #endif
 
 /*
-- 
1.7.4.3
