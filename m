Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2ACWgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab2ACWgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:34 2012
Message-Id: <20120103223034.385210208@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Ingo Molnar <mingo@elte.hu>
Subject: [36/67] oprofile, arm/sh: Fix oprofile_arch_exit() linkage issue
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>

commit 55205c916e179e09773d98d290334d319f45ac6b upstream.

This change fixes a linking problem, which happens if oprofile
is selected to be compiled as built-in:

  `oprofile_arch_exit' referenced in section `.init.text' of
  arch/arm/oprofile/built-in.o: defined in discarded section
  `.exit.text' of arch/arm/oprofile/built-in.o

The problem is appeared after commit 87121ca504, which
introduced oprofile_arch_exit() calls from __init function. Note
that the aforementioned commit has been backported to stable
branches, and the problem is known to be reproduced at least
with 3.0.13 and 3.1.5 kernels.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: oprofile-list <oprofile-list@lists.sourceforge.net>
Link: http://lkml.kernel.org/r/20111222151540.GB16765@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/oprofile/common.c |    2 +-
 arch/sh/oprofile/common.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -116,7 +116,7 @@ int __init oprofile_arch_init(struct opr
 	return oprofile_perf_init(ops);
 }
 
-void __exit oprofile_arch_exit(void)
+void oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 }
--- a/arch/sh/oprofile/common.c
+++ b/arch/sh/oprofile/common.c
@@ -49,7 +49,7 @@ int __init oprofile_arch_init(struct opr
 	return oprofile_perf_init(ops);
 }
 
-void __exit oprofile_arch_exit(void)
+void oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 	kfree(sh_pmu_op_name);
@@ -60,5 +60,5 @@ int __init oprofile_arch_init(struct opr
 	ops->backtrace = sh_backtrace;
 	return -ENODEV;
 }
-void __exit oprofile_arch_exit(void) {}
+void oprofile_arch_exit(void) {}
 #endif /* CONFIG_HW_PERF_EVENTS */


