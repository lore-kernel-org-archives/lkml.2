Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab2KCUaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:30:39 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:36725
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757502Ab2KCUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:30:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161264926"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-janitors@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] arch/x86/kernel/cpu/mtrr/cleanup.c: drop if around WARN_ON
Date: Sat,  3 Nov 2012 21:30:20 +0100
Message-Id: <1351974625-10282-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Just use WARN_ON rather than an if containing only WARN_ON(1).

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) WARN_ON(1);
+ WARN_ON(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 35ffda5..dd833bf 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -967,8 +967,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	if (total_trim_size) {
 		pr_warning("WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing %lluMB of RAM.\n", total_trim_size >> 20);
 
-		if (!changed_by_mtrr_cleanup)
-			WARN_ON(1);
+		WARN_ON(!changed_by_mtrr_cleanup);
 
 		pr_info("update e820 for mtrr\n");
 		update_e820();

