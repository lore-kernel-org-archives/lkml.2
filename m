Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2JVF5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:57:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:39696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2JVF5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:57:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="230478456"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.n
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 0/6] perf, x86: Haswell LBR call stack support
Date: Mon, 22 Oct 2012 13:57:10 +0800
Message-Id: <1350885436-5540-1-git-send-email-zheng.z.yan@intel.com>
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

Regards
Yan, Zheng
