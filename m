Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab1LOVRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:17:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:5030 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759502Ab1LOVRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:17:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96686088"
Message-Id: <cover.1323979146.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 15 Dec 2011 11:59:06 -0800
Subject: [PATCH 0/6] x86, mce: machine check recovery for applications [updated]
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

machine check recovery - updates since December 13th version

part1:
	Change printk from:
		Action optional memory failure at %lx ignored
	to:
		Uncorrected memory error in page 0x%lx ignored
		Rebuild kernel with CONFIG_MEMORY_FAILURE=y for smarter handling
part3:
	Fix spelling of granularity.
	Add Boris' ACK line
part4:
	Some code style fixes from Ingo
	Use "struct mce_info *" as iterator in mce_{save,find}_info().
	Make mce_find_info() return pointer, so mce_clear_info() becomes trivial
part5:
	Update comments in several places to reflect changes for recovery

part2: part6:
	Code unchanged - Added Boris' ACK line

Tony Luck (6):
  HWPOISON: clean up memory_failure() vs. __memory_failure()
  HWPOISON: Add code to handle "action required" errors.
  x86, mce: create helper function to save addr/misc when needed
  x86, mce: Add mechanism to safely save information in MCE handler
  x86, mce: handle "action required" errors
  x86, mce: Recognise machine check bank signature for data path error

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 +++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  155 ++++++++++++++++++++++-------
 drivers/base/memory.c                     |    2 +-
 include/linux/mm.h                        |    4 +-
 mm/hwpoison-inject.c                      |    4 +-
 mm/madvise.c                              |    2 +-
 mm/memory-failure.c                       |   96 +++++++++---------
 7 files changed, 187 insertions(+), 90 deletions(-)

-- 
1.7.3.1

