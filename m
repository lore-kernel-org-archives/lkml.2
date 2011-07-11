Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab1GKS6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:58:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:54877 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075Ab1GKS6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:58:22 -0400
Date: Mon, 11 Jul 2011 18:58:02 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-5da0ef9a8554a8d03dc880a53f213289fe7b576d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, conny.seidel@amd.com, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, conny.seidel@amd.com, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110711083432.GC943@htj.dyndns.org>
References: <20110711083432.GC943@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Disable AMD_NUMA for 32bit for now
Git-Commit-ID: 5da0ef9a8554a8d03dc880a53f213289fe7b576d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Jul 2011 18:58:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5da0ef9a8554a8d03dc880a53f213289fe7b576d
Gitweb:     http://git.kernel.org/tip/5da0ef9a8554a8d03dc880a53f213289fe7b576d
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Mon, 11 Jul 2011 10:34:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Jul 2011 16:25:30 +0200

x86: Disable AMD_NUMA for 32bit for now

Commit 2706a0bf7b ("x86, NUMA: Enable CONFIG_AMD_NUMA on 32bit
too") enabled AMD NUMA for 32bit too.  Unfortunately, SPARSEMEM
on 32bit had rather coarse (512MiB) addr->node mapping
granularity due to lack of space in page->flags.  This led to
boot failure on certain AMD NUMA machines which had 128MiB
alignment on nodes.

Patches to properly detect this condition and reject NUMA
configuration are posted[1] but deemed too pervasive for merge
at this point (-rc6).  Disable AMD NUMA for 32bit for now and
re-enable once the detection logic is merged.

[1] http://thread.gmane.org/gmane.linux.kernel/1161279/focus=1162583

Reported-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Conny Seidel <conny.seidel@amd.com>
Link: http://lkml.kernel.org/r/20110711083432.GC943@htj.dyndns.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..37357a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1170,7 +1170,7 @@ comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 config AMD_NUMA
 	def_bool y
 	prompt "Old style AMD Opteron NUMA detection"
-	depends on NUMA && PCI
+	depends on X86_64 && NUMA && PCI
 	---help---
 	  Enable AMD NUMA node topology detection.  You should say Y here if
 	  you have a multi processor AMD system. This uses an old method to
