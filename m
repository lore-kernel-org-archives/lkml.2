Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab2JXF7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:59:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:54001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632Ab2JXF7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:59:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,638,1344236400"; 
   d="scan'208";a="209831794"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V2 0/7] perf, x86: Haswell LBR call stack support
Date: Wed, 24 Oct 2012 13:59:03 +0800
Message-Id: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are executed
the last captured branch record is popped from the on-chip LBR registers.
The LBR call stack facility can help perf to get call chains of progam 
without frame pointer.

The LBR call stack has following known limitations
 1. Zero length calls are not filtered out by hardware
 2. Exception handing such as setjmp/longjmp will have calls/returns not
    match
 3. Pushing different return address onto the stack will have calls/returns
    not match

The patch series depends on Andi's "perf PMU support for Haswel" patches

---
Changes since v1
 - not expose PERF_SAMPLE_BRANCH_CALL_STACK to user space
 - save/restore LBR stack on context switch for all sampling branch modes
 - reduce lbr_sel_map size
