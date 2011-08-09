Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab1HIEIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 00:08:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:36643 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1HIEIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 00:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,341,1309762800"; 
   d="scan'208";a="5307112"
Message-ID: <4E40B2BF.3030608@linux.intel.com>
Date: Mon, 08 Aug 2011 21:08:31 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Ashfield, Bruce" <Bruce.Ashfield@windriver.com>
Subject: [PATCH][RT] fix KM_TYPE_NR undeclared in sched.h on 32 bit x86
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch peter_zijlstra-re-_3_0-rt4.patch causes 32 bit compilations to fail with:
sched.h:1592:17: error: ‘KM_TYPE_NR’ undeclared here (not in a function)

Including asm/kmap_types in sched.h resolves the issue.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Bruce Ashfield <bruce.ashfield@windriver.com>
---
 include/linux/sched.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-3.0-rt/include/linux/sched.h
===================================================================
--- linux-3.0-rt.orig/include/linux/sched.h
+++ linux-3.0-rt/include/linux/sched.h
@@ -63,6 +63,7 @@ struct sched_param {
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
 
+#include <asm/kmap_types.h>
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
