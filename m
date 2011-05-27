Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1E0EBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:01:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38943 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1E0EBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:01:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF21DE.9040705@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:00:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 00/12] minor cleanups/fixes for MCE codes
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of minor changes for MCE codes.

Though I know there are many people expecting new RAS architecture
such as one that integrates RAS/EDAC with MCE, I hope these small
steps will be a help for future works.

Thanks,
H.Seto

 arch/x86/include/asm/entry_arch.h         |    4 -
 arch/x86/include/asm/hw_irq.h             |    1 -
 arch/x86/include/asm/irq_vectors.h        |    5 -
 arch/x86/include/asm/mce.h                |   19 ++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  152 ++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c          |  276 +++++++++++++----------------
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |   10 +-
 arch/x86/kernel/entry_64.S                |    5 -
 arch/x86/kernel/irqinit.c                 |    3 -
 9 files changed, 241 insertions(+), 234 deletions(-)

Hidetoshi Seto (11):
      mce-severity: cleanup severity table, prep
      mce-severity: cleanup severity table
      mce-severity: trivial cleanups
      x86, mce: replace MCE_SELF_VECTOR by irq_work
      x86, mce: replace MCM_ to MCI_MISC_
      x86, mce: introduce mce_gather_info()
      x86, mce: check the result of ancient_init()
      x86, mce: cleanup mce_create/remove_device
      x86, mce: cleanup mce_read
      x86, mce: use prefix mce_chrdev_ to group functions
      x86, mce: use prefix mce_sysdev_ to group functions

Tony Luck (1):
      mce-severity: fixes for mce severity table

