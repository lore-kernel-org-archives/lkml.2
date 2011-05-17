Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1EQM4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:56:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36736 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab1EQM4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:56:11 -0400
From: Borislav Petkov <bp@amd64.org>
To: Nick Bowler <nbowler@elliptictech.com>,
        =?UTF-8?q?J=C3=B6rg-Volker=20Peetz?= <jvpeetz@web.de>
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Subject: [PATCH 2/2] x86, AMD: Fix ARAT feature setting again
Date: Tue, 17 May 2011 14:55:19 +0200
Message-Id: <1305636919-31165-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1305636919-31165-1-git-send-email-bp@amd64.org>
References: <1305636919-31165-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Trying to enable the local APIC timer on early K8 revisions uncovers
a number of other issues with it, in conjunction with the C1E enter
path on AMD. Fixing those causes much more churn and troubles than the
benefit of using that timer brings so don't enable it on K8 at all,
falling back to the original functionality the kernel had wrt to that.

Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Link: http://lkml.kernel.org/r/20110514195741.GA10757@elliptictech.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3532d3b..6f9d1f6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -613,7 +613,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
-- 
1.7.4.rc2

