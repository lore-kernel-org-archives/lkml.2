Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2EaLBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:01:38 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34340 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2EaLBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:01:37 -0400
Date: Thu, 31 May 2012 16:24:52 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: apw@canonical.com
Subject: checkpatch: False positive on wrong indentation within block.
Message-ID: <20120531105452.GI7511@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12053100-9264-0000-0000-0000019E9841
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch does not warns about the wrong indentation within a block.
When checkpatch is run on following patch, it does not complain about
the wrong indentation of if block.

[...]
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fd019d7..a8d78f3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -382,7 +382,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		if ((i == cpu) || (has_mc && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);

-		if ((i == cpu) || (has_mc && match_mc(c, o))) {
+	}
+
+	for_each_cpu(i, cpu_sibling_setup_mask) {
+		o = &cpu_data(i);
+
+	if ((i == cpu) || (has_mc && match_mc(c, o))) {
 			link_mask(core, cpu, i);

 			/*

$ ./scripts/checkpatch.pl Fix-booted_cores-reporting.patch
total: 0 errors, 0 warnings, 13 lines checked

Fix-booted_cores-reporting.patch has no obvious style problems and is ready for submission.

Thanks,
Kamalesh.

