Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1CWQkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1CWQkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:40:46 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH] expose async pf through our standard mechanism
Date: Wed, 23 Mar 2011 13:40:42 -0300
Message-Id: <1300898442-13704-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Avi recently mentioned, the new standard mechanism for exposing features
is KVM_GET_SUPPORTED_CPUID, not spanning CAPs. For some reason async pf missed that.

So expose async_pf here.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1e4025..e6a1cd8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2418,6 +2418,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
+			     (1 << KVM_FEATURE_ASYNC_PF) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
 		entry->ebx = 0;
 		entry->ecx = 0;
-- 
1.7.2.3

