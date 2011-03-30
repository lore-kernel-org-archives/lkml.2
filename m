Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068Ab1C3V3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:29:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042Ab1C3VI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133667"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kamal@canonical.com, ak@linux.intel.com, yinghai@kernel.org,
        len.brown@intel.com, rjw@sisk.pl, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [191/275] x86: Emit "mem=nopentium ignored" warning when not supported
Message-Id: <20110330210714.C90D13E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kamal Mostafa <kamal@canonical.com>

commit 9a6d44b9adb777ca9549e88cd55bd8f2673c52a2 upstream.

Emit warning when "mem=nopentium" is specified on any arch other
than x86_32 (the only that arch supports it).

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
BugLink: http://bugs.launchpad.net/bugs/553464
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1296783486-23033-2-git-send-email-kamal@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/e820.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/e820.c	2011-03-29 23:03:02.252242542 -0700
+++ linux-2.6.35.y/arch/x86/kernel/e820.c	2011-03-29 23:03:02.270242081 -0700
@@ -980,12 +980,15 @@
 	if (!p)
 		return -EINVAL;
 
-#ifdef CONFIG_X86_32
 	if (!strcmp(p, "nopentium")) {
+#ifdef CONFIG_X86_32
 		setup_clear_cpu_cap(X86_FEATURE_PSE);
 		return 0;
-	}
+#else
+		printk(KERN_WARNING "mem=nopentium ignored! (only supported on x86_32)\n");
+		return -EINVAL;
 #endif
+	}
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
