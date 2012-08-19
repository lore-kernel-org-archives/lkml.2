Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2HSDCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:02:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:14941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab2HSC5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422068"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 43/74] lto, workaround: Disable LTO for sys_ni to work around alias bugs
Date: Sat, 18 Aug 2012 19:56:39 -0700
Message-Id: <1345345030-22211-44-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

LTO gcc has trouble with the weak alias definitions in sys_ni.
This leads to missing symbols.  Just disable LTO for this file.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index c0cc67a..4b37677 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -22,6 +22,8 @@ CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
+CFLAGS_sys_ni.o = $(DISABLE_LTO)
+
 obj-y += sched/
 obj-y += power/
 
-- 
1.7.7.6

