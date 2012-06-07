Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2FHNIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:08:06 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:58849 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2FHNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:08:04 -0400
Date: Thu, 7 Jun 2012 14:32:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD thresholding fixes for 3.6
Message-ID: <20120607123259.GB11153@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

those didn't make it in time for the merge window so I'm sending them
now so at they can spend their quality time in linux-next.

Please pull, thanks.

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/amd-thresholding-fixes-for-3.6

for you to fetch changes up to 11122570193a429f72014703ce6b849640f8d7e5:

  x86, MCE, AMD: Update copyrights and boilerplate (2012-06-07 12:43:50 +0200)

----------------------------------------------------------------
AMD thresholding fixes for 3.6

Those are a bunch of patches which give the MCE thresholding code a
hard look and a scrubbing to remove a couple of annoyances like sysfs
warnings when running CPU off-/online tests and the threshold_bank4 node
under /sys/devices/system/machinecheck/ is a symlink.

It also gives proper names to the thresholding banks instead of simply
enumerating them, like this:

     /sys/devices/system/machinecheck/machinecheck0/
     |-- bank0
     |-- bank1
     |-- bank2
     |-- bank3
     |-- bank4
     |-- bank5
     |-- bank6
     |-- check_interval
     |-- cmci_disabled
     |-- combined_unit
     |   |-- combined_unit
     |       |-- error_count
     |       |-- threshold_limit
     |-- dont_log_ce
     |-- execution_unit
     |   |-- execution_unit
     |       |-- error_count
     |       |-- threshold_limit
     |-- ignore_ce
     |-- insn_fetch
     |   |-- insn_fetch
     |       |-- error_count
     |       |-- threshold_limit
     |-- load_store
     |   |-- load_store
     |       |-- error_count
     |       |-- threshold_limit
     |-- monarch_timeout
     |-- northbridge
     |   |-- dram
     |   |   |-- error_count
     |   |   |-- interrupt_enable
     |   |   |-- threshold_limit
     |   |-- ht_links
     |   |   |-- error_count
     |   |   |-- interrupt_enable
     |   |   |-- threshold_limit
     |   |-- l3_cache
     |       |-- error_count
     |       |-- interrupt_enable
     |       |-- threshold_limit
    ...

It is tested on all our families >= K8.

----------------------------------------------------------------
Borislav Petkov (9):
      x86, amd_nb: Export model 0x10 and later PCI id
      x86, MCE, AMD: Remove shared banks sysfs linking
      x86, MCE, AMD: Remove local_allocate_... wrapper
      x86, MCE, AMD: Move shared bank to node descriptor
      x86, MCE, AMD: Print decimal thresholding values
      x86, MCE, AMD: Cleanup reading of error_count
      x86, MCE, AMD: Make error_count read only
      x86, MCE, AMD: Give proper names to the thresholding banks
      x86, MCE, AMD: Update copyrights and boilerplate

 arch/x86/include/asm/amd_nb.h        |  21 +++
 arch/x86/kernel/amd_nb.c             |   1 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 264 ++++++++++++++++-------------------
 drivers/hwmon/k10temp.c              |   5 +-
 include/linux/pci_ids.h              |   1 +
 5 files changed, 147 insertions(+), 145 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
