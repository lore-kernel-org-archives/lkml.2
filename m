Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2AXXGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:06:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:14727 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2AXXGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:06:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="102310758"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>
Subject: [GIT PULL] MCE recovery changes
Date: Tue, 24 Jan 2012 15:06:08 -0800
Message-Id: <4f1f396019579c94fb@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Time to move these from "ras" tree to "tip" so they will be nicely
seasoned for the 3.4 merge window.

I tried to follow the instructions in
 http://git-blame.blogspot.com/2012/01/using-signed-tag-in-pull-requests.html
to use the fancy new signed tag scheme. If something is wrong here, then it
is most likely that I typoed (or thinkoed) while following them.

-Tony

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-recovery-for-tip

for you to fetch changes up to 5f7b88d51e89771f64c15903b96b5933dd0bc6d8:

  x86/mce: Recognise machine check bank signature for data path error (2012-01-03 12:07:07 -0800)

----------------------------------------------------------------
MCE recovery (data path only)

----------------------------------------------------------------
Tony Luck (6):
      HWPOISON: Clean up memory_failure() vs. __memory_failure()
      HWPOISON: Add code to handle "action required" errors.
      x86/mce: Create helper function to save addr/misc when needed
      x86/mce: Add mechanism to safely save information in MCE handler
      x86/mce: Handle "action required" errors
      x86/mce: Recognise machine check bank signature for data path error

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 +++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  179 ++++++++++++++++++++---------
 drivers/base/memory.c                     |    2 +-
 include/linux/mm.h                        |    4 +-
 mm/hwpoison-inject.c                      |    4 +-
 mm/madvise.c                              |    2 +-
 mm/memory-failure.c                       |   96 ++++++++--------
 7 files changed, 197 insertions(+), 106 deletions(-)
