Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab2IEKXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:23:48 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44283 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2IEKXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:23:46 -0400
Subject: [PATCH 0/3] x86:mce: Some cleanups and bios-set CMCI thresholds
To: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: gong.chen@linux.intel.com, ananth@in.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, gregkh@suse.de, linux-edac@vger.kernel.org
Date: Wed, 05 Sep 2012 15:51:51 +0530
Message-ID: <20120905102049.9423.6413.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12090510-8878-0000-0000-000003DEC396
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm putting together my previous set of patches for MCE.

The first two patches are cleanups, as per previous discussions. The first
patch makes mce sysfs tunables available under global machinecheck sysfs
directory. We no longer remove the existing entries in the per-cpu location.
The second patch consolidates some of the mce boot options into a single
bitfield. The structure name has been changed and is now in mce-internal.h

The third patch adds a new boot option to honour bios-set CMCI thresholds.
This has been rebased on the above patches.

This patch series applies on top of -tip.


Thanks,
Naveen

---

Naveen N. Rao (3):
      x86/mce: Make sysfs tunables available globally across all cpus
      x86/mce: Pack boolean MCE flags into a structure
      x86/mce: Honour bios-set CMCI threshold


 Documentation/x86/x86_64/boot-options.txt |    5 +
 Documentation/x86/x86_64/machinecheck     |    4 +
 arch/x86/include/asm/mce.h                |    2 -
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   10 +++
 arch/x86/kernel/cpu/mcheck/mce.c          |  112 ++++++++++++++++++++++-------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   41 ++++++++++-
 6 files changed, 140 insertions(+), 34 deletions(-)

-- 

