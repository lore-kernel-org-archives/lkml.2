Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761721Ab0GUAk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:40:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:58997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761597Ab0GUAkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:40:24 -0400
Date: Wed, 21 Jul 2010 00:40:04 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1279651857-24639-3-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: 32/64 bit boot cpu check unification in initialization
Message-ID: <tip-db10db48b2c530def21bfd76d576702c7df7f620@git.kernel.org>
Git-Commit-ID: db10db48b2c530def21bfd76d576702c7df7f620
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 00:40:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db10db48b2c530def21bfd76d576702c7df7f620
Gitweb:     http://git.kernel.org/tip/db10db48b2c530def21bfd76d576702c7df7f620
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 20 Jul 2010 20:50:49 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Jul 2010 16:21:38 -0700

x86, xsave: 32/64 bit boot cpu check unification in initialization

Boot cpu id is always 0, thus simplifying and unifying boot cpu check.

boot_cpu_id is there for historical reasons and was renamed to
boot_cpu_physical_apicid in patch:

 c70dcb7 x86: change boot_cpu_id to boot_cpu_physical_apicid

However, there are some remaining occurrences of boot_cpu_id that are
never touched in the kernel and thus its value is always 0.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279651857-24639-3-git-send-email-robert.richter@amd.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3f715ef..26804b2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1273,7 +1273,7 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-	if (smp_processor_id() == boot_cpu_id)
+	if (!smp_processor_id())
 		init_thread_xstate();
 
 	xsave_init();
