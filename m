Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0KAJNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:13:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:53869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0KAJNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:13:37 -0400
Date: Mon, 1 Nov 2010 09:13:06 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, shaohua.li@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, shaohua.li@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <AANLkTinWQRG=HA9uB3ad0KAqRRTinL6L_4iKgF84coph@mail.gmail.com>
References: <AANLkTinWQRG=HA9uB3ad0KAqRRTinL6L_4iKgF84coph@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm: Fix section mismatch in tlb.c
Message-ID: <tip-cf38d0ba7efdc476815768b2b999b27cfae69747@git.kernel.org>
Git-Commit-ID: cf38d0ba7efdc476815768b2b999b27cfae69747
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Nov 2010 09:13:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf38d0ba7efdc476815768b2b999b27cfae69747
Gitweb:     http://git.kernel.org/tip/cf38d0ba7efdc476815768b2b999b27cfae69747
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Mon, 1 Nov 2010 12:53:50 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Nov 2010 10:09:07 +0100

x86, mm: Fix section mismatch in tlb.c

Mark tlb_cpuhp_notify as __cpuinit. It's basically a callback
function, which is called from __cpuinit init_smp_flash(). So -
it's safe.

We were warned by the following warning:

 WARNING: arch/x86/mm/built-in.o(.text+0x356d): Section mismatch
 in reference from the function tlb_cpuhp_notify() to the
 function .cpuinit.text:calculate_tlb_offset()
 The function tlb_cpuhp_notify() references
 the function __cpuinit calculate_tlb_offset().
 This is often because tlb_cpuhp_notify lacks a __cpuinit
 annotation or the annotation of calculate_tlb_offset is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <AANLkTinWQRG=HA9uB3ad0KAqRRTinL6L_4iKgF84coph@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/tlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 4935848..12cdbb1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -251,7 +251,7 @@ static void __cpuinit calculate_tlb_offset(void)
 	}
 }
 
-static int tlb_cpuhp_notify(struct notifier_block *n,
+static int __cpuinit tlb_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	switch (action & 0xf) {
