Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0HJSt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:49:26 -0400
Received: from kroah.org ([198.145.64.141]:55450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab0HJStO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:49:14 -0400
Date: Tue, 10 Aug 2010 11:46:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.18
Message-ID: <20100810184646.GC10346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.18 kernel.

All users of the 2.6.32 kernel series are strongly encouraged to
upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm/plat-mxc/gpio.c                    |    8 ++
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 
 arch/parisc/kernel/firmware.c               |   12 ---
 arch/x86/xen/enlighten.c                    |    2 
 arch/x86/xen/time.c                         |   39 ------------
 drivers/edac/amd64_edac.c                   |    4 -
 drivers/gpu/drm/i915/i915_dma.c             |    9 ++
 drivers/gpu/drm/i915/i915_drv.h             |    2 
 drivers/gpu/drm/i915/intel_bios.c           |   65 ++++++++++++++++++++
 drivers/gpu/drm/i915/intel_bios.h           |   17 +++++
 drivers/gpu/drm/i915/intel_lvds.c           |   90 ++++++++++------------------
 drivers/misc/enclosure.c                    |    7 +-
 drivers/net/e1000e/hw.h                     |    2 
 drivers/net/e1000e/netdev.c                 |   13 ++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    2 
 drivers/net/wireless/ath/ath9k/hw.c         |   19 ++++-
 drivers/net/wireless/ath/ath9k/xmit.c       |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   18 ++---
 drivers/parisc/led.c                        |    6 +
 drivers/ssb/driver_chipcommon_pmu.c         |   17 +++--
 drivers/ssb/pci.c                           |   20 +-----
 drivers/staging/comedi/Kconfig              |    5 +
 drivers/staging/comedi/drivers/Makefile     |    4 -
 fs/cifs/dns_resolve.c                       |    2 
 fs/cifs/dns_resolve.h                       |    4 -
 fs/gfs2/dir.c                               |    2 
 fs/nfs/file.c                               |   14 +++-
 fs/nfs/nfs4xdr.c                            |    2 
 fs/xfs/xfs_dfrag.c                          |    5 +
 include/linux/ssb/ssb.h                     |    5 +
 include/linux/ssb/ssb_driver_chipcommon.h   |   15 ++++
 kernel/sched.c                              |    8 +-
 kernel/slow-work.c                          |    2 
 mm/memory.c                                 |   16 ++++
 net/9p/trans_fd.c                           |    2 
 net/wireless/mlme.c                         |    8 +-
 net/wireless/scan.c                         |    5 +
 38 files changed, 285 insertions(+), 185 deletions(-)

Adam Jackson (1):
      drm/i915: Fix LVDS presence check

Baruch Siach (1):
      arm/imx/gpio: add spinlock protection

Bob Peterson (1):
      GFS2: rename causes kernel Oops

Borislav Petkov (2):
      amd64_edac: Fix DCT base address selector
      amd64_edac: Correct scrub rate setting

Bruce Allan (1):
      e1000e: 82577/82578 PHY register access issues

Christoph Fritz (1):
      ssb: fix NULL ptr deref when pcihost_wrapper is used

Dan Carpenter (1):
      9p: strlen() doesn't count the terminator

Dan Rosenberg (1):
      xfs: prevent swapext from operating on write-only files

Dave Airlie (1):
      slow-work: use get_ref wrapper instead of directly calling get_ref

David Howells (1):
      CIFS: Remove __exit mark from cifs_exit_dns_resolver()

Dean Nelson (1):
      e1000e: don't inadvertently re-set INTX_DISABLE

Felix Fietkau (3):
      ath9k_hw: fix an off-by-one error in the PDADC boundaries calculation
      ath9k: fix TSF after reset on AR913x
      ath9k: fix yet another buffer leak in the tx aggregation code

Greg Kroah-Hartman (2):
      Revert "ssb: Handle Netbook devices where the SPROM address is changed"
      Linux 2.6.32.18

Helge Deller (1):
      PARISC: led.c - fix potential stack overflow in led_proc_write()

Hugh Dickins (1):
      mm: fix ia64 crash when gcore reads gate area

Ian Abbott (1):
      comedi: Uncripple 8255-based DIO subdevices

J. Bruce Fields (1):
      acl trouble after upgrading ubuntu

James Bottomley (1):
      SCSI: enclosure: fix error path - actually return ERR_PTR() on error

Jeremy Fitzhardinge (1):
      xen: drop xen_sched_clock in favour of using plain wallclock time

Johannes Berg (2):
      cfg80211: ignore spurious deauth
      cfg80211: don't get expired BSSes

John W. Linville (2):
      ath9k: enable serialize_regmode for non-PCIE AR9160
      ssb: do not read SPROM if it does not exist

Kyle McMartin (1):
      parisc: pass through '\t' to early (iodc) console

Larry Finger (1):
      ssb: Handle alternate SSPROM location

Michael Neuling (1):
      CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition

Peter Zijlstra (1):
      sched: cgroup: Implement different treatment for idle shares

Rafał Miłecki (1):
      ssb: Look for SPROM at different offset on higher rev CC

Stanislaw Gruszka (1):
      iwlwifi: fix scan abort

Trond Myklebust (1):
      NFS: kswapd must not block in nfs_release_page

Zhao Yakui (1):
      drm/i915: parse child device from VBT

