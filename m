Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0EGWTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:19:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:33472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0EGWTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:19:04 -0400
Date: Fri, 7 May 2010 22:18:46 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1273269585-14346-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273269585-14346-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86: Avoid check hlt for newer cpus
Message-ID: <tip-d081dd5fe0ed8449433b972d3080f9d776e9424b@git.kernel.org>
Git-Commit-ID: d081dd5fe0ed8449433b972d3080f9d776e9424b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 22:18:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d081dd5fe0ed8449433b972d3080f9d776e9424b
Gitweb:     http://git.kernel.org/tip/d081dd5fe0ed8449433b972d3080f9d776e9424b
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Fri, 7 May 2010 14:59:45 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 7 May 2010 15:15:47 -0700

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
index 01a2652..38f20e8 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -86,7 +86,7 @@ static void __init check_fpu(void)
 
 static void __init check_hlt(void)
 {
-	if (paravirt_enabled())
+	if (boot_cpu_data >= 5 || paravirt_enabled())
 		return;
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
