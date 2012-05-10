Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380Ab2EJSjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:39:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:65515 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761358Ab2EJSjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:39:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141530124"
Message-Id: <cover.1336674796.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 10 May 2012 11:33:16 -0700
Subject: [PATCH 0/2] Add machine check recovery for instruction fetch
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part 1 fixes an oversight in the existing code that didn't show
up while I was testing the data recovery case (because I never tried
injecting an error into a clean LRU data page ... only to dirty pages
where "memory_failure()" says we have to SIGBUS the process).

Part simply adds the right entries to the severity table so that we
will recognise instruction fetch faults.

Tony Luck (2):
  x86/mce: Only restart instruction after machine check recovery if it
    is safe
  x86/mce: Add instruction recovery signatures to mce-severity table

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   10 ++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c          |    9 ++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
1.7.9.rc2.1.g69204

