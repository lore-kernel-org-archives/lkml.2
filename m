Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1EPVWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:22:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:37243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab1EPVWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:22:45 -0400
Date: Mon, 16 May 2011 21:22:03 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-50e7534427283afd997d58481778c07bea79eb63@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hagen@jauu.net, hpa@zytor.com,
        mingo@redhat.com, farnold@amd64.org, tglx@linutronix.de,
        hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hagen@jauu.net,
        linux-kernel@vger.kernel.org, farnold@amd64.org, tglx@linutronix.de,
        hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1305553188-21061-2-git-send-email-bp@amd64.org>
References: <1305553188-21061-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD, cacheinfo: Fix fallout caused by max3 conversion
Git-Commit-ID: 50e7534427283afd997d58481778c07bea79eb63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 21:22:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50e7534427283afd997d58481778c07bea79eb63
Gitweb:     http://git.kernel.org/tip/50e7534427283afd997d58481778c07bea79eb63
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 16 May 2011 15:39:46 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 May 2011 11:24:23 -0700

x86, AMD, cacheinfo: Fix fallout caused by max3 conversion

732eacc0542d0aa48797f675888b85d6065af837 converted code around the
kernel using nested max() macros to use the new max3 macro but forgot to
remove the old line in intel_cacheinfo.c. Fix it.

Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Frank Arnold <farnold@amd64.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1305553188-21061-2-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
