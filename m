Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab0GUUxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:53:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:37547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0GUUx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:53:29 -0400
Date: Wed, 21 Jul 2010 20:53:02 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20100721124705.GA674@aftab>
References: <20100721124705.GA674@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, tlb: Clean up and correct used type
Message-ID: <tip-3f8afb77cd8a672f024e4a16763ef177bc16c8f8@git.kernel.org>
Git-Commit-ID: 3f8afb77cd8a672f024e4a16763ef177bc16c8f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 20:53:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f8afb77cd8a672f024e4a16763ef177bc16c8f8
Gitweb:     http://git.kernel.org/tip/3f8afb77cd8a672f024e4a16763ef177bc16c8f8
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 21 Jul 2010 14:47:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Jul 2010 21:48:15 +0200

x86, tlb: Clean up and correct used type

smp_processor_id() returns an int and not an unsigned long.
Also, since the function is small enough, there's no need for a
local variable caching its value.

No functionality change, just cleanup.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100721124705.GA674@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/tlb.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 426f3a1..c03f14a 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -278,11 +278,9 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 
 static void do_flush_tlb_all(void *info)
 {
-	unsigned long cpu = smp_processor_id();
-
 	__flush_tlb_all();
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
+		leave_mm(smp_processor_id());
 }
 
 void flush_tlb_all(void)
