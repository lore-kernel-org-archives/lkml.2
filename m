Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab1GKIei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:34:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42508 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab1GKIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:34:36 -0400
Date: Mon, 11 Jul 2011 10:34:32 +0200
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH x86/urgent] x86: Disable AMD_NUMA for 32bit for now
Message-ID: <20110711083432.GC943@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110701162239.GX3386@htj.dyndns.org>
 <20110701162327.GY3386@htj.dyndns.org>
 <20110709083206.GB943@htj.dyndns.org>
 <4E181477.5090405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E181477.5090405@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2706a0bf7b "x86, NUMA: Enable CONFIG_AMD_NUMA on 32bit too"
enabled AMD NUMA for 32bit too.  Unfortunately, SPARSEMEM on 32bit had
rather coarse (512MiB) addr->node mapping granularity due to lack of
space in page->flags.  This led to boot failure on certain AMD NUMA
machines which had 128MiB alignment on nodes.

Patches to properly detect this condition and reject NUMA
configuration are posted[1] but deemed too pervasive for merge at this
point (-rc6).  Disable AMD NUMA for 32bit for now and re-enable once
the detection logic is merged.

[1] http://thread.gmane.org/gmane.linux.kernel/1161279/focus=1162583

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
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
-- 
1.7.6

