Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2HMBcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 21:32:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:11850 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2HMBcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 21:32:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,757,1336374000"; 
   d="scan'208";a="180134502"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>,
        bp@amd64.org, x86@kernel.org
Subject: [GIT PULL] x86 - handle CMCI storms gracefully
Date: Sun, 12 Aug 2012 18:32:52 -0700
Message-Id: <50285944174651edb3@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-cmci-storm3

for you to fetch changes up to 55babd8f41f122f5f4c7cebf520c766c983282c6:

  x86/mce: Add CMCI poll mode (2012-08-09 11:44:51 -0700)

----------------------------------------------------------------
Handle CMCI storm gracefully by switching to polling mode if there
are too many interrupts, and switching back to interrupt mode when the
storm abates.

----------------------------------------------------------------
Chen Gong (1):
      x86/mce: Add CMCI poll mode

Thomas Gleixner (4):
      x86: mce: Disable preemption when calling raise_local()
      x86: mce: Serialize mce injection
      x86: mce: Split timer init
      x86: mce: Remove the frozen cases in the hotplug code

Tony Luck (1):
      x86/mce: Make cmci_discover() quiet

 arch/x86/kernel/cpu/mcheck/mce-inject.c   |   8 ++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  12 +++
 arch/x86/kernel/cpu/mcheck/mce.c          |  84 +++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    | 133 +++++++++++++++++++++++++-----
 4 files changed, 192 insertions(+), 45 deletions(-)
