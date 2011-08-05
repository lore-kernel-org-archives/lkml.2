Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1HEGWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 02:22:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47107 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756040Ab1HEGW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 02:22:28 -0400
X-Sasl-enc: MRZ9Cl4NbkEzrWbhWUy6Xv9o9F+xonAwap3QEsMIetM0 1312525347
Date: Thu, 4 Aug 2011 23:21:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.1
Message-ID: <20110805062136.GA2472@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.0.1 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-3.0.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-3.0.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/alpha/kernel/time.c                             |    2 
 arch/arm/mach-pxa/cm-x300.c                          |    8 -
 arch/powerpc/kernel/crash.c                          |    6 -
 arch/powerpc/kernel/time.c                           |    2 
 arch/powerpc/platforms/pseries/hvconsole.c           |    2 
 arch/x86/include/asm/msr-index.h                     |    3 
 arch/x86/kernel/cpu/intel.c                          |   18 +++
 arch/x86/kernel/relocate_kernel_32.S                 |    2 
 arch/x86/kernel/relocate_kernel_64.S                 |    2 
 arch/x86/oprofile/backtrace.c                        |   56 +++++++--
 arch/xtensa/kernel/ptrace.c                          |    3 
 block/blk-core.c                                     |    3 
 block/blk-exec.c                                     |    7 +
 drivers/block/cciss.h                                |    2 
 drivers/firewire/core-cdev.c                         |   20 +--
 drivers/firmware/sigma.c                             |    3 
 drivers/gpu/drm/radeon/atombios_dp.c                 |   22 +++
 drivers/gpu/drm/radeon/radeon_combios.c              |    3 
 drivers/gpu/drm/radeon/radeon_pm.c                   |    3 
 drivers/infiniband/ulp/srp/ib_srp.c                  |    2 
 drivers/md/dm-io.c                                   |   29 ++++
 drivers/md/dm-mpath.c                                |    5 
 drivers/md/dm-snap-persistent.c                      |    2 
 drivers/md/dm.c                                      |   10 +
 drivers/misc/Kconfig                                 |    3 
 drivers/mmc/host/sdhci-esdhc-imx.c                   |    2 
 drivers/net/jme.c                                    |   20 ++-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c          |    3 
 drivers/net/wireless/ath/ath9k/mac.c                 |    3 
 drivers/net/wireless/rt2x00/rt2800pci.c              |    1 
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c          |    2 
 drivers/pci/pci.c                                    |    7 +
 drivers/pci/quirks.c                                 |   23 +++
 drivers/rtc/interface.c                              |   55 ++++++---
 drivers/rtc/rtc-tegra.c                              |    2 
 drivers/scsi/hpsa.h                                  |    2 
 drivers/scsi/libsas/sas_expander.c                   |    3 
 drivers/scsi/pmcraid.c                               |    3 
 drivers/scsi/scsi_devinfo.c                          |    2 
 drivers/scsi/scsi_lib.c                              |    2 
 drivers/scsi/ses.c                                   |    6 -
 drivers/scsi/sr.c                                    |   46 +++++++
 drivers/scsi/sr.h                                    |    7 +
 drivers/staging/ath6kl/os/linux/ar6000_drv.c         |   49 +++++---
 drivers/staging/ath6kl/os/linux/cfg80211.c           |   31 +++--
 drivers/staging/ath6kl/os/linux/include/ar6000_drv.h |    9 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c     |    5 
 drivers/staging/comedi/comedi_fops.c                 |    4 
 drivers/staging/hv/channel.c                         |    2 
 drivers/staging/hv/channel_mgmt.c                    |    2 
 drivers/staging/hv/connection.c                      |    2 
 drivers/staging/hv/netvsc.c                          |    4 
 drivers/staging/hv/rndis_filter.c                    |    6 -
 drivers/staging/hv/storvsc.c                         |    8 -
 drivers/staging/hv/storvsc_drv.c                     |    2 
 drivers/staging/rtl8192e/r8192E_core.c               |    6 +
 drivers/staging/usbip/vhci_hcd.c                     |    4 
 drivers/tty/hvc/hvc_console.c                        |    8 -
 drivers/tty/n_gsm.c                                  |    4 
 drivers/tty/serial/8250.c                            |    2 
 drivers/tty/serial/Kconfig                           |    2 
 drivers/usb/host/ehci-hcd.c                          |    8 -
 drivers/usb/host/ehci-hub.c                          |    3 
 drivers/usb/host/ehci-q.c                            |   85 +++++++-------
 drivers/usb/host/ehci.h                              |    4 
 drivers/usb/host/pci-quirks.c                        |   28 ++++
 drivers/usb/musb/musb_core.c                         |    1 
 drivers/usb/serial/pl2303.c                          |    1 
 drivers/usb/serial/pl2303.h                          |    4 
 drivers/watchdog/shwdt.c                             |    2 
 fs/cifs/dir.c                                        |    2 
 fs/ecryptfs/inode.c                                  |    1 
 fs/ecryptfs/keystore.c                               |   47 ++++---
 fs/ext3/xattr.c                                      |   12 +-
 fs/ext4/ext4.h                                       |    1 
 fs/ext4/extents.c                                    |   11 +
 fs/ext4/mballoc.c                                    |    2 
 fs/gfs2/ops_fstype.c                                 |    4 
 fs/nfs/delegation.c                                  |   16 +-
 fs/nfs/dir.c                                         |   56 +++++----
 fs/nfs/nfs4filelayout.c                              |    2 
 fs/nfs/nfs4proc.c                                    |    8 +
 fs/nfs/nfs4xdr.c                                     |    2 
 fs/nfs/pnfs.c                                        |   63 +++++-----
 fs/nfs/pnfs.h                                        |    6 -
 fs/nfsd/nfs4state.c                                  |   66 ++++-------
 fs/proc/base.c                                       |   16 ++
 include/linux/firewire-cdev.h                        |    3 
 include/linux/mm.h                                   |    2 
 include/linux/netdevice.h                            |    5 
 include/linux/nfs_fs.h                               |    3 
 include/linux/nfs_xdr.h                              |    2 
 ipc/sem.c                                            |   13 +-
 kernel/events/core.c                                 |    7 -
 kernel/futex.c                                       |    4 
 kernel/trace/trace.h                                 |    1 
 kernel/trace/trace_events.c                          |  113 +++++++++++++++----
 kernel/trace/trace_events_filter.c                   |    6 +
 lib/xz/xz_private.h                                  |    2 
 mm/backing-dev.c                                     |    1 
 mm/memcontrol.c                                      |    2 
 mm/memory.c                                          |   58 +++++++++
 mm/oom_kill.c                                        |    4 
 net/bridge/br_private.h                              |    1 
 net/bridge/br_stp.c                                  |    4 
 net/core/ethtool.c                                   |    4 
 net/mac80211/mlme.c                                  |    3 
 net/sunrpc/svc_xprt.c                                |   11 +
 net/wireless/reg.c                                   |    5 
 security/apparmor/domain.c                           |    2 
 security/apparmor/lsm.c                              |    2 
 sound/core/pcm_compat.c                              |    2 
 sound/pci/hda/patch_realtek.c                        |    7 -
 sound/pci/oxygen/xonar_pcm179x.c                     |    5 
 sound/soc/davinci/davinci-vcif.c                     |    9 -
 sound/soc/soc-core.c                                 |    1 
 tools/perf/Makefile                                  |    5 
 tools/perf/util/header.c                             |    5 
 tools/perf/util/session.c                            |   30 +++--
 tools/perf/util/session.h                            |    1 
 121 files changed, 931 insertions(+), 402 deletions(-)

Ajay Kumar Gupta (1):
      usb: musb: restore INDEX register in resume path

Alan Stern (3):
      USB: OHCI: fix another regression for NVIDIA controllers
      USB: EHCI: go back to using the system clock for QH unlinks
      EHCI: fix direction handling for interrupt data toggles

Alasdair G Kergon (1):
      dm: fix idr leak on module removal

Alex Deucher (2):
      drm/radeon/kms: fix i2c map for rv250/280
      drm/radeon/kms: add missing vddci setting on NI+

Anton Blanchard (1):
      powerpc/pseries/hvconsole: Fix dropped console output

Bart Van Assche (1):
      IB/srp: Avoid duplicate devices from LUN scan

Ben Hutchings (1):
      ethtool: Allow zero-length register dumps again

Benjamin Herrenschmidt (1):
      mm/futex: fix futex writes on archs with SW tracking of dirty & young

Casey Bodley (1):
      nfsd: don't break lease on CLAIM_DELEGATE_CUR

Chris Wright (1):
      PCI: ARI is a PCIe v2 feature

Clemens Ladisch (1):
      ALSA: virtuoso: fix silent analog output on Xonar Essence ST Deluxe

Daisuke Nishimura (1):
      memcg: fix behavior of mem_cgroup_resize_limit()

Dan Rosenberg (2):
      pmcraid: reject negative request size
      xtensa: prevent arbitrary read in ptrace

David Ahern (2):
      perf tools, x86: Fix 32-bit compile on 64-bit system
      perf tools: Fix endian conversion reading event attr from file header

David Engraf (1):
      watchdog: shwdt: fix usage of mod_timer

Douglas Gilbert (1):
      ses: requesting a fault indication

Du, Alek (1):
      n_gsm: fix the wrong FCS handling

Gertjan van Wingerde (1):
      rt2x00: Add device ID for RT539F device.

Greg Kroah-Hartman (1):
      Linux 3.0.1

Guo-Fu Tseng (1):
      jme: Fix unmap error (Causing system freeze)

Hendrik Brueckner (1):
      hvc_console: Improve tty/console put_chars handling

Herbert Xu (1):
      gro: Only reset frag0 when skb can be pulled

Huang Ying (1):
      kexec, x86: Fix incorrect jump back address if not preserving context

Igor Grinberg (1):
      ARM: pxa/cm-x300: fix V3020 RTC functionality

J. Bruce Fields (3):
      nfsd4: remember to put RW access on stateid destruction
      nfsd4: fix file leak on open_downgrade
      svcrpc: fix list-corrupting race on nfsd shutdown

James Bottomley (1):
      fix crash in scsi_dispatch_cmd()

Jan Kara (1):
      ext3: Fix oops in ext3_try_to_allocate_with_rsv()

Jerome Glisse (1):
      drm/radeon/kms: fix DP training for DPEncoderService revision bigger than 1.1

Jiaying Zhang (1):
      ext4: free allocated and pre-allocated blocks when check_eofblocks_fl fails

John Johansen (2):
      AppArmor: Fix reference to rcu protected pointer outside of rcu_read_lock
      AppArmor: Fix masking of capabilities in complain mode

Julia Lawall (1):
      ALSA: sound/core/pcm_compat.c: adjust array index

K. Y. Srinivasan (3):
      Staging: hv: storvsc: Increase the timeout value in the storvsc driver
      Staging: hv: vmbus: Increase the timeout value in the vmbus driver
      Staging: hv: netvsc: Increase the timeout value in the netvsc driver

Kalle Valo (2):
      ath6kl: cache firmware
      ath6kl: fix crash when interface is closed but scan is ongoing

Kay Sievers (1):
      sr: check_events() ignore GET_EVENT when TUR says otherwise

Larry Finger (2):
      staging: r8192e_pci: Handle duplicate PCI ID 0x10ec:0x8192 conflict with rtl8192se
      rtlwifi: rtl8192cu: Fix duplicate if test

Lasse Collin (1):
      XZ: Fix missing <linux/kernel.h> include

Len Brown (1):
      x86, intel, power: Initialize MSR_IA32_ENERGY_PERF_BIAS

Luben Tuikov (1):
      libsas: remove expander from dev list on error

Manfred Spraul (1):
      ipc/sem.c: fix race with concurrent semtimedop() timeouts and IPC_RMID

Manoj Iyer (1):
      mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency

Mark Brown (1):
      ASoC: Mark cache as dirty when suspending

Maxim Patlasov (1):
      ext4: fix i_blocks/quota accounting when extent insertion fails

Michael Neuling (1):
      powerpc/kdump: Fix timeout in crash_kexec_wait_realmode

Mike Snitzer (1):
      dm mpath: fix potential NULL pointer in feature arg processing

Mikulas Patocka (2):
      dm io: flush cpu cache with vmapped io
      dm snapshot: flush disk cache when merging

Oleg Nesterov (1):
      oom: task->mm == NULL doesn't mean the memory was freed

Pavel Shilovsky (1):
      CIFS: Fix oops while mounting with prefixpath

Peng Tao (4):
      pnfs: save layoutcommit lwb at layout header
      pnfs: save layoutcommit cred at layout header init
      pnfs: let layoutcommit handle a list of lseg
      pnfs: use lwb as layoutcommit length

Peter Zijlstra (4):
      irq_work, ppc: Fix up arch hooks
      perf: Fix software event overflow
      irq_work, alpha: Fix up arch hooks
      mm/backing-dev.c: reset bdi min_ratio in bdi_unregister()

Philip A. Prindeville (1):
      geode: reflect mfgpt dependency on mfd

Rajashekhara, Sudhakar (2):
      ASoC: davinci: add missing break statement
      ASoC: davinci: fix codec start and stop functions

Rajkumar Manoharan (1):
      mac80211: Restart STA timers only on associated state

Ralf Baechle (1):
      SERIAL: SC26xx: Fix link error.

Randy Dunlap (1):
      drivers/firmware/sigma.c needs MODULE_LICENSE

Robert Richter (1):
      oprofile, x86: Fix nmi-unsafe callgraph support

Roland Vossen (1):
      staging: brcm80211: fix for reported log spam problem

Senthil Balasubramanian (1):
      ath9k_hw: Fix incorrect key_miss handling

Sergei Shtylyov (1):
      EHCI: only power off port if over-current is active

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: SDHCI_CARD_PRESENT does not get cleared

Stefan Richter (2):
      firewire: cdev: return -ENOTTY for unimplemented ioctls, not -EINVAL
      firewire: cdev: prevent race between first get_info ioctl and bus reset event queuing

Stephen M. Cameron (2):
      hpsa: do not attempt to read from a write-only register
      cciss: do not attempt to read from a write-only register

Stephen Warren (1):
      tty/serial: Fix XSCALE serial ports, e.g. ce4100

Steven Rostedt (2):
      tracing: Fix bug when reading system filters on module removal
      tracing: Have "enable" file use refcounts like the "filter" file

Steven Whitehouse (1):
      GFS2: Fix mount hang caused by certain access pattern to sysfs files

Sven Neumann (1):
      cfg80211: really ignore the regulatory request

Takashi Iwai (1):
      ALSA: hda - Fix duplicated DAC assignments for Realtek

Thieu Le (1):
      ecryptfs: Make inode bdi consistent with superblock bdi

Thomas Gleixner (3):
      rtc: handle errors correctly in rtc_irq_set_state()
      rtc: fix hrtimer deadlock
      rtc: limit frequency

Tobias Klauser (1):
      Staging: usbip: vhci-hcd: Do not kill already dead RX/TX kthread

Trond Myklebust (2):
      NFSv4: Don't use the delegation->inode in nfs_mark_return_delegation()
      NFS: Fix spurious readdir cookie loop messages

Tyler Hicks (1):
      eCryptfs: Unlock keys needed by ecryptfsd

Uwe Kleine-König (1):
      drivers/rtc/rtc-tegra.c: properly initialize spinlock

Vasiliy Kulikov (2):
      staging: comedi: fix infoleak to userspace
      proc: fix a race in do_io_accounting()

Werner Fink (1):
      Blacklist Traxdata CDR4120 and IOMEGA Zip drive to avoid lock ups.

Wolfgang Denk (1):
      USB: serial: add IDs for WinChipHead USB->RS232 adapter

stephen hemminger (1):
      bridge: send proper message_age in config BPDU

