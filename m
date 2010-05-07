Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0EGWg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:36:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:39201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab0EGWg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:36:57 -0400
Date: Fri, 7 May 2010 22:36:41 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1273269585-14346-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273269585-14346-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86: Avoid check hlt for newer cpus
Message-ID: <tip-2b107d93635616db0c3f893c8cc2e6d5cd8d77b2@git.kernel.org>
Git-Commit-ID: 2b107d93635616db0c3f893c8cc2e6d5cd8d77b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 22:36:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b107d93635616db0c3f893c8cc2e6d5cd8d77b2
Gitweb:     http://git.kernel.org/tip/2b107d93635616db0c3f893c8cc2e6d5cd8d77b2
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Fri, 7 May 2010 14:59:45 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 7 May 2010 15:31:17 -0700

x86: Avoid check hlt for newer cpus

Check hlt instruction was targeted for some older CPUs. It is an expensive
operation in that it takes 4 ticks to break out the check.  We can avoid
such check completely for newer x86 cpus (family >= 5).

[ hpa: corrected family > 5 to family >= 5 ]

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1273269585-14346-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/bugs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 01a2652..c39576c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -86,7 +86,7 @@ static void __init check_fpu(void)
 
 static void __init check_hlt(void)
 {
-	if (paravirt_enabled())
+	if (boot_cpu_data.x86 >= 5 || paravirt_enabled())
 		return;
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
