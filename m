Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1EQNrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:47:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:33638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab1EQNrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:47:16 -0400
Date: Tue, 17 May 2011 13:47:00 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-14fb57dccb6e1defe9f89a66f548fcb24c374c1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com,
        Boris.Ostrovsky@amd.com, nbowler@elliptictech.com, hpa@zytor.com,
        mingo@redhat.com, andreas.herrmann3@amd.com, greg@kroah.com,
        jvpeetz@web.de, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, nbowler@elliptictech.com,
        Boris.Ostrovsky@amd.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com,
        greg@kroah.com, jvpeetz@web.de, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <1305636919-31165-3-git-send-email-bp@amd64.org>
References: <1305636919-31165-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, AMD: Fix ARAT feature setting again
Git-Commit-ID: 14fb57dccb6e1defe9f89a66f548fcb24c374c1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 May 2011 13:47:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14fb57dccb6e1defe9f89a66f548fcb24c374c1d
Gitweb:     http://git.kernel.org/tip/14fb57dccb6e1defe9f89a66f548fcb24c374c1d
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 17 May 2011 14:55:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 May 2011 15:28:34 +0200

x86, AMD: Fix ARAT feature setting again

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
