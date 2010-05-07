Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab0EGWE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:04:57 -0400
Received: from mga05.intel.com ([192.55.52.89]:25708 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095Ab0EGWE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:04:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,350,1270450800"; 
   d="scan'208";a="565220322"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>, Alek Du <alek.du@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86: avoid check hlt for newer cpus
Date: Fri,  7 May 2010 14:59:45 -0700
Message-Id: <1273269585-14346-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check hlt instruction was targeted for some older CPUs. It is an expensive
operation in that it takes 4 ticks to break out the check.  We can avoid
such check completely for newer x86 cpus ( family > 5).
http://lkml.org/lkml/2010/5/7/395

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 01a2652..36d9bcf 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -86,7 +86,7 @@ static void __init check_fpu(void)
 
 static void __init check_hlt(void)
 {
-	if (paravirt_enabled())
+	if (paravirt_enabled() || boot_cpu_data.x86 > 5)
 		return;
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
-- 
1.6.3.3

