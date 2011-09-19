Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1ISEUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 00:20:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49076 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1ISEUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 00:20:05 -0400
From: Zhao Jin <cronozhj@gmail.com>
To: avi@redhat.com
Cc: mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] kvm, mmu: fix incorrect return of spte
Date: Mon, 19 Sep 2011 12:19:51 +0800
Message-Id: <1316405991-14903-1-git-send-email-cronozhj@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__update_clear_spte_slow should return original spte while the
current code returns low half of original spte combined with high
half of new spte.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
---
 arch/x86/kvm/mmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1c5b693..8e8da79 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -400,7 +400,8 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
 
 	/* xchg acts as a barrier before the setting of the high bits */
 	orig.spte_low = xchg(&ssptep->spte_low, sspte.spte_low);
-	orig.spte_high = ssptep->spte_high = sspte.spte_high;
+	orig.spte_high = ssptep->spte_high;
+	ssptep->spte_high = sspte.spte_high;
 	count_spte_clear(sptep, spte);
 
 	return orig.spte;
-- 
1.7.4.1

