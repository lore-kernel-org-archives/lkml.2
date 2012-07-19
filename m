Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2GSTBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:01:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:44056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab2GSTBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="195181867"
Message-Id: <cover.1342723082.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 19 Jul 2012 11:38:02 -0700
Subject: [PATCH 0/2] Fix machine check recovery for instruction fault on Sandy Bridge
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a workaround for some strange
asymmetry between how machine checks are reported for
data and instruction fetches. For instruction fetch
error the processor does not set the EIPV bit in the
MCG_STATUS register on the affected processor, leading
us to believe that the cs/ip values saved on the stack
are not associated with the machine check ... which in
turn makes us unable to determine whether the machine
check was taken in kernel or user mode. The workaround
is to fake the presence of the EIPV bit for this error
on this processor model. Not pretty, but avoids having
to make special cases later in the code.

Tony Luck (2):
  x86/mce: Move MCACOD defines from mce-severity.c to <asm/mce.h>
  x86/mce: Add quirk for instruction recovery on Sandy Bridge
    processors

 arch/x86/include/asm/mce.h                |  8 ++++++
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  7 -----
 arch/x86/kernel/cpu/mcheck/mce.c          | 43 ++++++++++++++++++++++++++++---
 3 files changed, 48 insertions(+), 10 deletions(-)

-- 
1.7.10.2.552.gaa3bb87

