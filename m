Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0HRUzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:55:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:48209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab0HRUzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:55:07 -0400
Date: Wed, 18 Aug 2010 20:54:48 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1282141190-930137-1-git-send-email-hans.rosenfeld@amd.com>
References: <1282141190-930137-1-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpu: Fix regression in AMD errata checking code
Message-ID: <tip-07a7795ca2e6e66d00b184efb46bd0e23d90d3fe@git.kernel.org>
Git-Commit-ID: 07a7795ca2e6e66d00b184efb46bd0e23d90d3fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 Aug 2010 20:54:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07a7795ca2e6e66d00b184efb46bd0e23d90d3fe
Gitweb:     http://git.kernel.org/tip/07a7795ca2e6e66d00b184efb46bd0e23d90d3fe
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Wed, 18 Aug 2010 16:19:50 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 18 Aug 2010 09:16:28 -0700

x86, cpu: Fix regression in AMD errata checking code

A bug in the family-model-stepping matching code caused the presence of
errata to go undetected when OSVW was not used. This causes hangs on
some K8 systems because the E400 workaround is not enabled.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1282141190-930137-1-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 60a57b1..ba5f62f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -669,7 +669,7 @@ bool cpu_has_amd_erratum(const int *erratum)
 	}
 
 	/* OSVW unavailable or ID unknown, match family-model-stepping range */
-	ms = (cpu->x86_model << 8) | cpu->x86_mask;
+	ms = (cpu->x86_model << 4) | cpu->x86_mask;
 	while ((range = *erratum++))
 		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
 		    (ms >= AMD_MODEL_RANGE_START(range)) &&
