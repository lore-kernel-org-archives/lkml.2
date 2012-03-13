Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030222Ab2CMAZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:25:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:49084 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188Ab2CMAZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <Boris.Ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Joerg-Volker-Peetz <jvpeetz@web.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 181/196] x86, AMD: Fix ARAT feature setting again
Date: Mon, 12 Mar 2012 20:21:34 -0400
Message-Id: <1331598109-31424-136-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 14fb57dccb6e1defe9f89a66f548fcb24c374c1d upstream.

Trying to enable the local APIC timer on early K8 revisions
uncovers a number of other issues with it, in conjunction with
the C1E enter path on AMD. Fixing those causes much more churn
and troubles than the benefit of using that timer brings so
don't enable it on K8 at all, falling back to the original
functionality the kernel had wrt to that.

Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Joerg-Volker-Peetz <jvpeetz@web.de>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1305636919-31165-3-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index d618dc1..76a7f76 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -567,7 +567,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
-- 
1.7.9.3

