Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992885Ab2K3TBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:01:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:59268 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992830Ab2K3TBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:01:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/54] 3.6.9-stable review
Date: Fri, 30 Nov 2012 10:55:31 -0800
Message-Id: <20121130185207.894301294@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.6.9 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  2 18:51:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.6.9-rc1

NeilBrown <neilb@suse.de>
    md/raid10: close race that lose writes lost when replacement completes.

Jaehoon Chung <jh80.chung@samsung.com>
    mmc: sdhci-s3c: fix the wrong number of max bus clocks

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Lock module while handling EEH event

Tao Ma <boyu.mt@taobao.com>
    ext4: remove erroneous ext4_superblock_csum_set() in update_backups()

Manuel Lauss <manuel.lauss@gmail.com>
    MPI: Fix compilation on MIPS with GCC 4.4 and newer

Chuansheng Liu <chuansheng.liu@intel.com>
    watchdog: using u64 in get_sample_period()

Mel Gorman <mgorman@suse.de>
    mm: vmscan: check for fatal signals iff the process was throttled

Thierry Escande <thierry.escande@linux.intel.com>
    NFC: Fix nfc_llcp_local chained list insertion

Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
    NFC: pn533: Fix mem leak in pn533_in_dep_link_up

Thierry Escande <thierry.escande@linux.intel.com>
    NFC: Fix pn533 target mode memory leak

Szymon Janc <szymon.janc@tieto.com>
    NFC: pn533: Fix use after free

Mauro Carvalho Chehab <mchehab@redhat.com>
    get_dvb_firmware: fix download site for tda10046 firmware

David Milburn <dmilburn@redhat.com>
    sata_svw: check DMA start bit before reset

joshua.a.hay@intel.com <joshua.a.hay@intel.com>
    ixgbe: add support for X540-AT1

Petr Matousek <pmatouse@redhat.com>
    KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-2012-4461)

Marek Vasut <marex@denx.de>
    HID: add quirk for Freescale i.MX28 ROM recovery

Randy Dunlap <rdunlap@xenotime.net>
    pstore/ram: Fix printk format warning

Tilman Schmidt <tilman@imap.cc>
    bas_gigaset: fix pre_reset handling

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add support for Realtek ALC292

Duncan Roe <duncan_roe@acslink.net.au>
    ALSA: hda - Fix missing beep on ASUS X43U notebook

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Add new codec ALC283 ALC290 support

Jan Kara <jack@suse.cz>
    writeback: put unused inodes to LRU after writeback completion

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    PM / QoS: fix wrong error-checking condition

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()

Jan Kara <jack@suse.cz>
    jbd: Fix lock ordering bug in journal_unmap_buffer()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: initialize ifindex for timeouts without previous frame reception

Oliver Hartkopp <socketcan@hartkopp.net>
    can: peak_usb: fix hwtstamp assignment

Paul Bolle <pebolle@tiscali.nl>
    radeon: add AGPMode 1 quirk for RV250

Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
    mac80211: deinitialize ibss-internals after emptiness check

Darren Hart <dvhart@linux.intel.com>
    futex: avoid wake_futex() for a PI futex_q

Jens Axboe <axboe@kernel.dk>
    dm: fix deadlock with request based dm and queue request_fn recursion

Roland Dreier <roland@purestorage.com>
    block: Don't access request after it might be freed

NeilBrown <neilb@suse.de>
    md/raid10: decrement correct pending counter when writing to replacement.

majianpeng <majianpeng@gmail.com>
    md: Avoid write invalid address if read_seqretry returned true.

majianpeng <majianpeng@gmail.com>
    md: Reassigned the parameters if read_seqretry returned true in func md_is_badblock.

Thomas Betker <thomas.betker@freenet.de>
    jffs2: Fix lock acquisition order bug in jffs2_write_begin

Sachin Kamat <sachin.kamat@linaro.org>
    mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()

Jiri Engelthaler <engycz@gmail.com>
    mtd: slram: invalid checking of absolute end address

Al Viro <viro@ZenIV.linux.org.uk>
    PARISC: fix user-triggerable panic on parisc

James Bottomley <James.Bottomley@HansenPartnership.com>
    PARISC: fix virtual aliasing issue in get_shared_area()

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Cirrus: Correctly clear line_out_pins when moving to speaker

Clemens Ladisch <clemens@ladisch.de>
    ALSA: ua101, usx2y: fix broken MIDI output

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add new SI pci id

Maciej Patelczyk <maciej.patelczyk@intel.com>
    SCSI: isci: copy fis 0x34 response into proper buffer

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix system hang issue in cmd timeout error case

Bing Zhao <bzhao@marvell.com>
    mwifiex: report error to MMC core if we cannot suspend

Albert Pool <albertpool@solcon.nl>
    rtlwifi: rtl8192cu: Add new USB ID

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix monitor mode FCS flag

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't WARN when a non empty queue is disabled

H. Peter Anvin <hpa@linux.intel.com>
    x86-32: Export kernel_stack_pointer() for modules

Boris Ostrovsky <boris.ostrovsky@amd.com>
    x86, microcode, AMD: Add support for family 16h processors

Matt Fleming <matt.fleming@intel.com>
    x86, efi: Fix processor-specific memcpy() build error

Robert Richter <robert.richter@amd.com>
    x86-32: Fix invalid stack address while in softirq

Johannes Berg <johannes.berg@intel.com>
    wireless: add back sysfs directory


-------------

Diffstat:

 Documentation/dvb/get_dvb_firmware              |   2 +-
 Makefile                                        |   4 +-
 arch/parisc/kernel/signal32.c                   |   6 +-
 arch/parisc/kernel/sys_parisc.c                 |   2 +
 arch/powerpc/platforms/pseries/eeh_driver.c     |  95 +++++++++++++++++++++++++-------
 arch/sparc/kernel/signal_64.c                   |   4 +-
 arch/x86/boot/compressed/eboot.c                |   2 +
 arch/x86/include/asm/ptrace.h                   |  15 ++---
 arch/x86/kernel/microcode_amd.c                 |   4 ++
 arch/x86/kernel/ptrace.c                        |  30 ++++++++++
 arch/x86/kvm/cpuid.h                            |   3 +
 arch/x86/kvm/x86.c                              |   3 +
 block/blk-exec.c                                |   8 ++-
 drivers/ata/sata_svw.c                          |  35 ++++++++++++
 drivers/base/power/qos.c                        |   2 +-
 drivers/gpu/drm/radeon/radeon_agp.c             |   5 +-
 drivers/hid/hid-ids.h                           |   3 +
 drivers/hid/usbhid/hid-quirks.c                 |   1 +
 drivers/isdn/gigaset/bas-gigaset.c              |  19 ++++++-
 drivers/md/dm.c                                 |   8 ++-
 drivers/md/md.c                                 |  11 ++--
 drivers/md/raid10.c                             | 112 ++++++++++++++++++++------------------
 drivers/mmc/host/sdhci-s3c.c                    |   2 +-
 drivers/mtd/devices/slram.c                     |   2 +-
 drivers/mtd/ofpart.c                            |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c         |   8 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c     |   8 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |   1 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |  14 +++++
 drivers/net/wireless/iwlwifi/pcie/tx.c          |   8 ---
 drivers/net/wireless/mwifiex/cmdevt.c           |  11 +++-
 drivers/net/wireless/mwifiex/sdio.c             |  11 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c     |   1 +
 drivers/nfc/pn533.c                             |  22 ++++----
 drivers/scsi/isci/request.c                     |   2 +-
 fs/ext4/resize.c                                |   2 -
 fs/fs-writeback.c                               |   2 +
 fs/inode.c                                      |  16 +++++-
 fs/internal.h                                   |   1 +
 fs/jbd/transaction.c                            |   2 +
 fs/jffs2/file.c                                 |  39 +++++++------
 fs/pstore/ram.c                                 |   2 +-
 include/drm/drm_pciids.h                        |   1 +
 kernel/futex.c                                  |  18 +++++-
 kernel/watchdog.c                               |   4 +-
 lib/mpi/longlong.h                              |  19 ++++++-
 mm/vmscan.c                                     |  37 +++++++++----
 net/can/bcm.c                                   |   3 +
 net/core/net-sysfs.c                            |  20 +++++++
 net/mac80211/ibss.c                             |   8 +--
 net/nfc/llcp/llcp.c                             |   2 +-
 sound/pci/hda/patch_cirrus.c                    |   1 +
 sound/pci/hda/patch_realtek.c                   |   4 ++
 sound/usb/midi.c                                |   8 ++-
 56 files changed, 473 insertions(+), 185 deletions(-)


