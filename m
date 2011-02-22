Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1BVWgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:36:21 -0500
Received: from kroah.org ([198.145.64.141]:46584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab1BVWVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:12 -0500
Date: Tue, 22 Feb 2011 14:20:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/70] 2.6.37.2-stable review
Message-ID: <20110222222003.GA15831@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.37.2 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, Feb 24 22:00:00 UTC 2011.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/hwmon/jc42                     |   21 ++++++++---
 Documentation/hwmon/k10temp                  |    8 ++++-
 Makefile                                     |    2 +-
 arch/arm/kernel/signal.c                     |    4 ++-
 arch/arm/kernel/vmlinux.lds.S                |    9 +++++
 arch/arm/mach-sa1100/simpad.c                |    7 ++--
 arch/s390/include/asm/processor.h            |    5 ---
 arch/s390/kernel/traps.c                     |   37 --------------------
 arch/x86/include/asm/cpu.h                   |    1 +
 arch/x86/kernel/apb_timer.c                  |    8 +++--
 arch/x86/kernel/irq_32.c                     |    7 +---
 arch/x86/kernel/process.c                    |    5 ++-
 arch/x86/kernel/smpboot.c                    |    3 +-
 arch/x86/xen/mmu.c                           |   12 ++++++
 drivers/acpi/wakeup.c                        |    6 +++-
 drivers/char/tpm/tpm.c                       |   18 +---------
 drivers/char/tpm/tpm.h                       |    2 -
 drivers/char/tpm/tpm_tis.c                   |    4 +--
 drivers/gpu/drm/i915/intel_dp.c              |   27 ++++++++++++--
 drivers/gpu/drm/i915/intel_sdvo.c            |   32 +++++++++++++++---
 drivers/gpu/drm/nouveau/Kconfig              |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c       |   46 ++++++++-----------------
 drivers/gpu/drm/radeon/r600_cs.c             |   46 ++++++++++++++-----------
 drivers/gpu/drm/radeon/radeon_combios.c      |   47 ++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_display.c      |   10 +++++
 drivers/gpu/drm/radeon/radeon_encoders.c     |   20 ++++++++---
 drivers/gpu/drm/radeon/radeon_mode.h         |    1 +
 drivers/gpu/drm/radeon/radeon_ttm.c          |    4 +-
 drivers/hid/hid-cando.c                      |    2 +
 drivers/hid/hid-core.c                       |    2 +
 drivers/hid/hid-ids.h                        |    1 +
 drivers/hid/hid-magicmouse.c                 |    5 +++
 drivers/hid/hid-mosart.c                     |    1 +
 drivers/hid/usbhid/hid-quirks.c              |    1 -
 drivers/hwmon/Kconfig                        |   19 +++++-----
 drivers/hwmon/jc42.c                         |   35 ++++++++++++++++---
 drivers/hwmon/k10temp.c                      |    5 ++-
 drivers/hwmon/lm85.c                         |   23 +++++++++++-
 drivers/media/dvb/ttpci/av7110_ca.c          |    2 +-
 drivers/media/radio/radio-aimslab.c          |    1 +
 drivers/message/fusion/mptctl.c              |    8 ++++
 drivers/message/fusion/mptscsih.c            |    7 ++--
 drivers/net/can/janz-ican3.c                 |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    1 -
 drivers/pci/pci-sysfs.c                      |    3 +-
 drivers/pcmcia/pcmcia_resource.c             |    2 +
 drivers/platform/x86/acer-wmi.c              |    4 +-
 drivers/platform/x86/asus_acpi.c             |    8 +----
 drivers/platform/x86/tc1100-wmi.c            |    2 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c |    1 -
 drivers/tty/vt/vt.c                          |    9 ++++-
 fs/btrfs/ioctl.c                             |   10 ++++-
 fs/cifs/netmisc.c                            |    8 ++--
 fs/cifs/sess.c                               |    8 ++--
 fs/ecryptfs/inode.c                          |    2 +
 fs/file_table.c                              |    2 +-
 fs/nfsd/nfs4xdr.c                            |    8 ++--
 fs/nfsd/vfs.c                                |    2 +-
 fs/partitions/mac.c                          |   17 +++++----
 fs/proc/array.c                              |    3 --
 fs/xfs/quota/xfs_qm.c                        |   46 +++++++++++--------------
 include/linux/pci_ids.h                      |    1 +
 include/linux/security.h                     |    6 ++--
 include/pcmcia/ds.h                          |    1 +
 kernel/capability.c                          |    2 +-
 kernel/cred.c                                |   16 +++++---
 kernel/irq/internals.h                       |    6 +++
 kernel/irq/irqdesc.c                         |   11 +++++-
 kernel/irq/manage.c                          |    2 +-
 kernel/irq/resend.c                          |    2 +-
 kernel/perf_event.c                          |   19 ++++++++--
 kernel/power/snapshot.c                      |    7 +---
 kernel/workqueue.c                           |   13 ++++++-
 net/core/dev.c                               |    2 +
 net/netfilter/nf_conntrack_netlink.c         |   15 +++-----
 security/security.c                          |    5 +--
 security/selinux/hooks.c                     |    6 +++-
 sound/pci/hda/hda_intel.c                    |    1 +
 sound/pci/hda/patch_conexant.c               |    2 +-
 sound/soc/codecs/wm8903.c                    |    2 +-
 sound/usb/caiaq/audio.c                      |    2 +-
 sound/usb/caiaq/midi.c                       |    2 +-
 tools/perf/builtin-timechart.c               |    2 +-
 83 files changed, 482 insertions(+), 287 deletions(-)
