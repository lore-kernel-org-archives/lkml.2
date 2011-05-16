Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1EPNkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:40:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58856 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab1EPNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:40:30 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Frank Arnold <farnold@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Subject: [PATCH 1/3] x86, AMD, cacheinfo: Fix fallout caused by max3 conversion
Date: Mon, 16 May 2011 15:39:46 +0200
Message-Id: <1305553188-21061-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1305553188-21061-1-git-send-email-bp@amd64.org>
References: <1305553188-21061-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

732eacc0542d0aa48797f675888b85d6065af837 converted code around the
kernel using nested max() macros to use the new max3 macro but forgot to
remove the old line in intel_cacheinfo.c. Fix it.

Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Frank Arnold <farnold@amd64.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1ce1af2..31590a0 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -327,7 +327,6 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
 	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
-	l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
-- 
1.7.4.rc2

