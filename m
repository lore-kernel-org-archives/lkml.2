Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0LIIrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:47:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55522 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab0LIIrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=et3NC4Iqvaa2DqNBNRQFTFQ7upvnWiW5QqWFz92Gz2nvYFzFUaFEuUoYJyAHIYQa7S
         0D/nMWduombA1Y4UQ96pypvE/c0DrJ37m5DZ3tnlyBkzPrMx3r6svwpLRX70kpSvxbwG
         v9xH3zKskNTW92TyKbAMVZL2J3eSgxZYW11c0=
MIME-Version: 1.0
Date: Thu, 9 Dec 2010 14:47:34 +0600
Message-ID: <AANLkTi=rcc38QzoKa6LFy4m++-p_9=Zt4_kDQE=GeKxf@mail.gmail.com>
Subject: [PATCH] x86: Fix warning in hw_nmi.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        x86@kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0e2af2a9abf94b408ff70679b692a8644fed4aab fixed this warning, it
again introduced by commit 5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a.
This patch fixes it by moving arch_trigger_all_cpu_backtrace few lines
above backtrace_mask's declaration.

We were warned by the following warning:

arch/x86/kernel/apic/hw_nmi.c:29: warning: ‘backtrace_mask’ defined but not used


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a0e71cb..0c294b3 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -25,10 +25,11 @@ u64 hw_nmi_get_sample_period(void)
 #endif


+#ifdef arch_trigger_all_cpu_backtrace
+
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;

-#ifdef arch_trigger_all_cpu_backtrace
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
