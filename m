Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0HJSuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:50:23 -0400
Received: from kroah.org ([198.145.64.141]:55466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588Ab0HJStU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:49:20 -0400
Date: Tue, 10 Aug 2010 11:48:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.1
Message-ID: <20100810184844.GG10346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.1 kernel.

All users of the 2.6.35 kernel series should upgrade.

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/arm/plat-mxc/gpio.c                       |    8 +
 arch/arm/plat-mxc/include/mach/gpio.h          |    1 
 arch/parisc/kernel/firmware.c                  |   12 --
 arch/x86/xen/enlighten.c                       |    2 
 arch/x86/xen/time.c                            |   39 ------
 drivers/edac/amd64_edac.c                      |    6 -
 drivers/gpu/drm/i915/intel_display.c           |  144 ++++++++++++++++---------
 drivers/gpu/drm/i915/intel_drv.h               |    8 +
 drivers/gpu/drm/i915/intel_overlay.c           |    7 -
 drivers/gpu/drm/radeon/r600.c                  |   24 +++-
 drivers/gpu/drm/radeon/r600d.h                 |    1 
 drivers/gpu/drm/radeon/radeon_object.c         |   27 +++-
 drivers/gpu/drm/radeon/rs690.c                 |   27 +---
 drivers/gpu/drm/radeon/rv515.c                 |   23 +--
 drivers/gpu/drm/radeon/rv770.c                 |    5 
 drivers/gpu/drm/radeon/rv770d.h                |    1 
 drivers/misc/enclosure.c                       |    7 -
 drivers/net/e1000e/hw.h                        |    2 
 drivers/net/e1000e/netdev.c                    |   13 +-
 drivers/net/igb/igb_main.c                     |    8 -
 drivers/net/wireless/ath/ath9k/ar9002_calib.c  |    2 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 
 drivers/net/wireless/ath/ath9k/eeprom.h        |    2 
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    4 
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    4 
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    6 -
 drivers/net/wireless/ath/ath9k/hw.c            |   23 +++
 drivers/net/wireless/ath/ath9k/xmit.c          |   95 ++++++++++------
 drivers/net/wireless/iwlwifi/iwl-scan.c        |   18 +--
 drivers/net/xen-netfront.c                     |    1 
 drivers/parisc/led.c                           |    6 -
 drivers/ssb/driver_chipcommon.c                |    1 
 drivers/ssb/pci.c                              |   15 ++
 fs/block_dev.c                                 |    4 
 include/drm/drm_pciids.h                       |    7 +
 include/linux/netdevice.h                      |    2 
 include/linux/notifier.h                       |    1 
 kernel/signal.c                                |    9 +
 net/9p/trans_fd.c                              |    2 
 net/ipv4/devinet.c                             |    1 
 net/mac80211/mesh_plink.c                      |   42 +++++--
 net/sched/sch_generic.c                        |   18 +++
 net/wireless/mlme.c                            |    8 -
 net/wireless/scan.c                            |    5 
 45 files changed, 395 insertions(+), 250 deletions(-)

Alex Deucher (3):
      drm/radeon: add new pci ids
      drm/radeon/kms/r7xx: add workaround for hw issue with HDP flush
      drm/radeon/kms: handle the case of no active displays properly in the bandwidth code

Baruch Siach (1):
      arm/imx/gpio: add spinlock protection

Borislav Petkov (3):
      amd64_edac: Fix DCT base address selector
      amd64_edac: Correct scrub rate setting
      amd64_edac: Fix operator precendence error

Bruce Allan (1):
      e1000e: 82577/82578 PHY register access issues

Chris Wilson (2):
      drm/i915: Unset cursor if out-of-bounds upon mode change (v4)
      drm/i915: Check overlay stride errata for i830 and i845

Dan Carpenter (1):
      9p: strlen() doesn't count the terminator

David Howells (1):
      CRED: Fix RCU warning due to previous patch fixing __task_cred()'s checks

Dean Nelson (1):
      e1000e: don't inadvertently re-set INTX_DISABLE

Felix Fietkau (10):
      ath9k: fix a potential buffer leak in the STA teardown path
      ath9k_hw: prevent a fast channel change after a rx DMA stuck issue
      ath9k_hw: fix a sign error in the IQ calibration code
      ath9k_hw: fix an off-by-one error in the PDADC boundaries calculation
      ath9k: fix retry count for A-MPDU rate control status reports
      ath9k: fix a buffer leak in A-MPDU completion
      ath9k: another fix for the A-MPDU buffer leak
      ath9k: fix TSF after reset on AR913x
      ath9k: fix yet another buffer leak in the tx aggregation code
      ath9k_hw: fix antenna diversity on AR9285

Greg Kroah-Hartman (1):
      Linux 2.6.35.1

Greg Rose (1):
      igb: Use only a single Tx queue in SR-IOV mode

Helge Deller (1):
      PARISC: led.c - fix potential stack overflow in led_proc_write()

Ian Campbell (2):
      arp_notify: allow drivers to explicitly request a notification event.
      xen: netfront: explicitly generate arp_notify event after migration.

James Bottomley (1):
      SCSI: enclosure: fix error path - actually return ERR_PTR() on error

Jeremy Fitzhardinge (1):
      xen: drop xen_sched_clock in favour of using plain wallclock time

Johannes Berg (2):
      cfg80211: ignore spurious deauth
      cfg80211: don't get expired BSSes

John W. Linville (2):
      ath9k: enable serialize_regmode for non-PCIE AR9160
      mac80211: avoid scheduling while atomic in mesh_rx_plink_frame

Kyle McMartin (1):
      parisc: pass through '\t' to early (iodc) console

Larry Finger (1):
      ssb: Handle alternate SSPROM location

Michel Dänzer (1):
      drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.

Stanislaw Gruszka (1):
      iwlwifi: fix scan abort

Tejun Heo (1):
      block_dev: always serialize exclusive open attempts

