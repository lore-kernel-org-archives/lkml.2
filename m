Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919Ab0HFTS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:18:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54825 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0HFTSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:18:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH] x86, kvm: Remove cast obsoleted by set_64bit() prototype cleanup
Date: Fri,  6 Aug 2010 12:18:11 -0700
Message-Id: <1281122291-14094-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM ended up having to put a pretty ugly wrapper around set_64bit()
in order to get the type right.  Now set_64bit() takes the expected
u64 type, and this wrapper can be cleaned up.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>
LKML-Reference: <4C5C4E7A.8040603@kernel.org>
---
 arch/x86/kvm/mmu.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0dcc95e..311f6da 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -281,11 +281,7 @@ static gfn_t pse36_gfn_delta(u32 gpte)
 
 static void __set_spte(u64 *sptep, u64 spte)
 {
-#ifdef CONFIG_X86_64
-	set_64bit((unsigned long *)sptep, spte);
-#else
-	set_64bit((unsigned long long *)sptep, spte);
-#endif
+	set_64bit(sptep, spte);
 }
 
 static u64 __xchg_spte(u64 *sptep, u64 new_spte)
-- 
1.7.2

