Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1LMTKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:10:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:20855 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab1LMTKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:10:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95753814"
Message-Id: <cover.1323803130.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 13 Dec 2011 11:05:30 -0800
Subject: [PATCH 0/6] x86, mce: machine check recovery for applications
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another version ...

Some bits should look familiar (hopefully pieces that were not too controversial
from earlier versions). Other bits are all new (e.g. part 4/6 which sets up some
functions that can safely save away the physical address of the faulting address
in the machine check handler for later retrieval in a safer execution context).

Tony Luck (6):
  HWPOISON: clean up memory_failure() vs. __memory_failure()
  HWPOISON: Add code to handle "action required" errors.
  x86, mce: create helper function to save addr/misc when needed
  x86, mce: Add mechanism to safely save information in MCE handler
  x86, mce: handle "action required" errors
  x86, mce: Recognise machine check bank signature for data path error

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 +++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  153 ++++++++++++++++++++++-------
 drivers/base/memory.c                     |    2 +-
 include/linux/mm.h                        |    4 +-
 mm/hwpoison-inject.c                      |    4 +-
 mm/madvise.c                              |    2 +-
 mm/memory-failure.c                       |   96 ++++++++++---------
 7 files changed, 186 insertions(+), 89 deletions(-)

-- 
1.7.3.1

