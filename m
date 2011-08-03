Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1HCU3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:29:36 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44853 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719Ab1HCU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:29:28 -0400
X-Sasl-enc: cSCA8mqkjvHYegI3sQxjGLuP8IKglx777YmT3NWlEQZ5 1312403367
Date: Wed, 3 Aug 2011 13:28:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.39.4
Message-ID: <20110803202839.GA5685@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.39.4 kernel.

All users of the 2.6.39 kernel series must upgrade.

Please note, this is the LAST release of the 2.6.39 kernel series.  All
users of 2.6.39 should be moving to 3.0 right now.  This tree is now
end-of-life, please plan accordingly.

The updated 2.6.39.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.39.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.39.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/alpha/kernel/osf_sys.c                  |   11 +
 arch/arm/kernel/perf_event.c                 |    6 
 arch/arm/mach-davinci/board-dm365-evm.c      |    4 
 arch/arm/mach-mmp/pxa168.c                   |    2 
 arch/arm/mach-mmp/pxa910.c                   |    2 
 arch/arm/mach-pxa/mfp-pxa2xx.c               |    4 
 arch/x86/kernel/reboot.c                     |    8 +
 drivers/ata/libata-eh.c                      |   12 +
 drivers/firewire/ohci.c                      |    6 
 drivers/gpu/drm/radeon/evergreen.c           |  162 +++++++++++++++----------
 drivers/gpu/drm/radeon/evergreend.h          |    4 
 drivers/gpu/drm/radeon/ni.c                  |    1 
 drivers/gpu/drm/radeon/r600.c                |    1 
 drivers/gpu/drm/radeon/r600d.h               |    2 
 drivers/gpu/drm/radeon/radeon_display.c      |   13 +-
 drivers/gpu/drm/radeon/rv770.c               |    1 
 drivers/hwmon/asus_atk0110.c                 |    1 
 drivers/hwmon/it87.c                         |    2 
 drivers/hwmon/lm95241.c                      |   22 ++-
 drivers/hwmon/max1111.c                      |   11 +
 drivers/hwmon/pmbus.c                        |   19 ++
 drivers/hwmon/pmbus_core.c                   |   31 ++--
 drivers/media/dvb/frontends/dib0070.c        |   40 +-----
 drivers/media/dvb/frontends/dib0090.c        |   71 ++---------
 drivers/media/dvb/frontends/dib7000m.c       |   49 ++-----
 drivers/media/dvb/frontends/dib7000p.c       |   72 +++--------
 drivers/media/dvb/frontends/dib8000.c        |  126 +++++--------------
 drivers/media/dvb/frontends/dib9000.c        |  172 +++++++++------------------
 drivers/media/dvb/frontends/dibx000_common.c |  109 ++++++-----------
 drivers/media/dvb/frontends/dibx000_common.h |    5 
 drivers/media/radio/si4713-i2c.c             |    4 
 drivers/media/video/bt8xx/bttv-driver.c      |    2 
 drivers/media/video/cx23885/cx23885-core.c   |    9 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c    |    4 
 drivers/media/video/tuner-core.c             |   59 ++++-----
 drivers/media/video/v4l2-ioctl.c             |    6 
 drivers/mmc/host/sdhci-esdhc-imx.c           |    2 
 drivers/net/wireless/ath/ath5k/pci.c         |    7 -
 drivers/net/wireless/ath/ath5k/sysfs.c       |    9 -
 drivers/net/wireless/ath/ath9k/xmit.c        |    3 
 drivers/net/wireless/ath/carl9170/usb.c      |    2 
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c  |    1 
 drivers/pci/quirks.c                         |   23 +++
 drivers/platform/x86/dell-laptop.c           |   24 ---
 drivers/usb/serial/pl2303.c                  |    1 
 drivers/usb/serial/pl2303.h                  |    4 
 fs/cifs/connect.c                            |   64 ++++++----
 fs/ext4/super.c                              |    3 
 fs/fscache/page.c                            |   14 --
 fs/gfs2/file.c                               |   10 +
 fs/namei.c                                   |    7 -
 fs/nfs/nfs4xdr.c                             |    2 
 fs/partitions/efi.c                          |    9 +
 fs/proc/base.c                               |    7 -
 fs/xfs/xfs_alloc.c                           |    6 
 include/drm/drm_pciids.h                     |    2 
 include/linux/netdevice.h                    |    5 
 mm/compaction.c                              |   42 +++++-
 mm/nommu.c                                   |    9 -
 mm/oom_kill.c                                |    4 
 mm/vmscan.c                                  |   80 ++++++++----
 net/bridge/br_private.h                      |    1 
 net/bridge/br_stp.c                          |    4 
 net/mac80211/wpa.c                           |   16 ++
 net/sunrpc/rpcb_clnt.c                       |    2 
 net/sunrpc/sched.c                           |   27 +---
 sound/soc/blackfin/bf5xx-i2s-pcm.c           |   13 +-
 sound/soc/codecs/ak4642.c                    |    2 
 sound/soc/codecs/wm8994.c                    |   11 +
 70 files changed, 739 insertions(+), 732 deletions(-)

Alex Deucher (5):
      drm/radeon/kms: fix typo in evergreen disp int status register
      drm/radeon/kms: fix typo in IH_CNTL swap bitfield
      drm/radeon/kms: fix backend map typo on juniper
      drm/radeon/kms: add new NI pci ids
      drm/radeon/kms: clean up multiple crtc handling for evergreen+ (v2)

Amir Goldstein (1):
      ext4: fix oops in ext4_quota_off()

Andrea Arcangeli (1):
      mm: vmscan: do not use page_count without a page pin

Andy Adamson (1):
      NFSv4.1: update nfs4_fattr_bitmap_maxsz

Ben Greear (1):
      SUNRPC: Fix use of static variable in rpcb_getport_async

Benjamin Marzinski (1):
      GFS2: make sure fallocate bytes is a multiple of blksize

Bob Liu (1):
      mm/nommu.c: fix remap_pfn_range()

Christian Lamparter (1):
      carl9170: add NEC WL300NU-AG usbid

Dan Rosenberg (1):
      alpha: fix several security issues

Daniel J Blueman (1):
      x86: Make Dell Latitude E5420 use reboot=pci

Dave Airlie (1):
      drm/radeon: fix oops in ttm reserve when pageflipping (v2)

Eric Sandeen (1):
      xfs [stable only]: restart busy extent search after node removal

Greg Kroah-Hartman (2):
      Revert "DiBxxxx: get rid of DMA buffer on stack"
      Linux 2.6.39.4

Guenter Roeck (7):
      hwmon: (lm95241) Fix chip detection code
      hwmon: (lm95241) Fix negative temperature results
      hwmon: (pmbus) Auto-detect temp2 and temp3 registers/attributes
      hwmon: (pmbus) Drop check for PMBus revision register in probe function
      hwmon: (pmbus) Improve fan detection
      hwmon: (pmbus) Use long variables for register to data conversions
      hwmon: (pmbus) Improve auto-detection of temperature status register

Hans Verkuil (5):
      v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
      tuner-core: fix s_std and s_tuner
      tuner-core: fix tuner_resume: use t->mode instead of t->type
      pvrusb2: fix g/s_tuner support
      bttv: fix s_tuner for radio

Herbert Xu (1):
      gro: Only reset frag0 when skb can be pulled

Jan Beulich (1):
      FS-Cache: Fix __fscache_uncache_all_inode_pages()'s outer loop

Jarod Wilson (1):
      Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"

Jean Delvare (1):
      hwmon: (it87) Fix label group removal

Jeff Layton (3):
      cifs: clean up wsize negotiation and allow for larger wsize
      cifs: fix wsize negotiation to respect max buffer size and active signing (try #4)
      cifs: lower default and max wsize to what 2.6.39 can handle

Jerome Glisse (1):
      drm/radeon/kms: free ib pool on module unloading

Johannes Berg (1):
      mac80211: fix TKIP replay vulnerability

Jon Povey (1):
      davinci: DM365 EVM: fix video input mux bits

Keng-Yu Lin (1):
      Revert: "dell-laptop: Toggle the unsupported hardware killswitch"

Kuninori Morimoto (1):
      ASoC: ak4642: fixup snd_soc_update_bits mask for PW_MGMT2

Lei Wen (2):
      ARM: pxa168: correct nand pmu setting
      ARM: pxa910: correct nand pmu setting

Linus Torvalds (1):
      vfs: fix race in rcu lookup of pruned dentry

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Fix memory leak

Manoj Iyer (1):
      mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency

Mark Brown (4):
      ASoC: Fix Blackfin I2S _pointer() implementation return in bounds values
      ASoC: Ensure we delay long enough for WM8994 FLL to lock when starting
      ASoC: Correct WM8994 MICBIAS supply widget hookup
      ASoC: Fix shift in WM8958 accessory detection default implementation

Mauro Carvalho Chehab (1):
      si4713-i2c: avoid potential buffer overflow on si4713

Mel Gorman (6):
      mm: vmscan: correct check for kswapd sleeping in sleeping_prematurely
      mm: vmscan: evaluate the watermarks against the correct classzone
      mm: compaction: ensure that the compaction free scanner does not move to the next zone
      mm: compaction: abort compaction if too many pages are isolated and caller is asynchronous V2
      mm: vmscan: do not apply pressure to slab if we are not applying pressure to zone
      mm: vmscan: only read new_classzone_idx from pgdat when reclaiming successfully

Oleg Nesterov (1):
      oom: task->mm == NULL doesn't mean the memory was freed

Paul Parsons (1):
      ARM: pxa: fix PGSR register address calculation

Pavel Herrmann (1):
      hwmon: (max1111) Fix race condition causing NULL pointer exception

Pavel Roskin (2):
      ath5k: fix incorrect use of drvdata in sysfs code
      ath5k: fix incorrect use of drvdata in PCI suspend/resume code

Rajkumar Manoharan (1):
      ath9k: Fix tx throughput drops for AR9003 chips with AES encryption

Shaohua Li (1):
      vmscan: fix a livelock in kswapd

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: SDHCI_CARD_PRESENT does not get cleared

Stefan Richter (1):
      firewire: ohci: do not bind to Pinnacle cards, avert panic

Tejun Heo (1):
      libata: fix unexpectedly frozen port after ata_eh_reset()

Timo Warns (1):
      fs/partitions/efi.c: corrupted GUID partition tables can cause kernel oops

Trond Myklebust (1):
      SUNRPC: Fix a race between work-queue and rpc_killall_tasks

Vasiliy Kulikov (1):
      proc: restrict access to /proc/PID/io

Will Deacon (1):
      ARM: 6989/1: perf: do not start the PMU when no events are present

Wolfgang Denk (1):
      USB: serial: add IDs for WinChipHead USB->RS232 adapter

Yoann DI-RUZZA (1):
      rtlwifi: rtl8192cu: Add new USB ID for Netgear WNA1000M

stephen hemminger (1):
      bridge: send proper message_age in config BPDU

