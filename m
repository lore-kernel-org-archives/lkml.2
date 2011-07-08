Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1GHAWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 20:22:53 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:45990 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175Ab1GHAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 20:22:52 -0400
X-Sasl-enc: hOgbDPU1iuo8bUcmxUVzPRtsn+Y6GN088VOUV1lmS6mk 1310084571
Date: Thu, 7 Jul 2011 17:17:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/107] 2.6.39.3 review
Message-ID: <20110708001740.GA14031@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.39.3 release.
There are 107 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sat, Jul 9, 2011, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.39.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/filesystems/caching/netfs-api.txt  |   16 ++++++
 Makefile                                         |    2 +-
 arch/arm/mach-exynos4/init.c                     |    1 +
 arch/arm/plat-samsung/include/plat/regs-serial.h |    2 +
 arch/x86/include/asm/pvclock.h                   |    9 +++-
 arch/x86/kernel/acpi/realmode/wakeup.S           |   14 +++++
 arch/x86/kernel/acpi/realmode/wakeup.h           |    6 ++
 arch/x86/kernel/acpi/sleep.c                     |    6 ++
 arch/x86/oprofile/nmi_int.c                      |   14 ++++--
 arch/x86/pci/xen.c                               |   40 +++++++++++---
 arch/x86/xen/mmu.c                               |   14 +++++-
 arch/x86/xen/smp.c                               |    7 +++
 block/cfq-iosched.c                              |   11 +++-
 drivers/base/platform.c                          |    2 +-
 drivers/base/power/main.c                        |   28 ++++++++---
 drivers/connector/connector.c                    |    1 +
 drivers/gpu/drm/drm_pci.c                        |    3 +-
 drivers/gpu/drm/i915/i915_irq.c                  |   10 ++++
 drivers/gpu/drm/i915/intel_i2c.c                 |    3 +-
 drivers/gpu/drm/radeon/radeon_encoders.c         |    6 ++-
 drivers/gpu/drm/radeon/rv770.c                   |    6 ++
 drivers/hwmon/ibmaem.c                           |    2 +
 drivers/hwmon/ibmpex.c                           |    1 +
 drivers/hwmon/s3c-hwmon.c                        |    2 +
 drivers/i2c/busses/i2c-taos-evm.c                |    8 ++--
 drivers/i2c/muxes/pca954x.c                      |    7 ++-
 drivers/input/input.c                            |    2 +-
 drivers/input/mousedev.c                         |    4 +-
 drivers/md/md.c                                  |    1 +
 drivers/media/rc/ir-raw.c                        |    4 +-
 drivers/media/rc/ite-cir.c                       |   12 +++-
 drivers/media/rc/ite-cir.h                       |    3 +
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c   |   58 ++++++++++-----------
 drivers/media/video/uvc/uvc_queue.c              |    2 +
 drivers/misc/lkdtm.c                             |    8 +++
 drivers/mmc/host/tmio_mmc_pio.c                  |    4 +-
 drivers/net/hamradio/6pack.c                     |    4 +-
 drivers/net/hamradio/mkiss.c                     |    4 +-
 drivers/net/pxa168_eth.c                         |    2 +-
 drivers/net/wireless/ath/ath5k/base.c            |   11 ++++-
 drivers/net/wireless/ath/ath5k/eeprom.c          |    8 +--
 drivers/net/wireless/ath/ath5k/reset.c           |    5 ++-
 drivers/net/wireless/ath/ath9k/pci.c             |    6 ++
 drivers/net/wireless/iwlwifi/iwl-core.c          |    3 +-
 drivers/pci/pci-driver.c                         |    4 +-
 drivers/pci/quirks.c                             |    2 +
 drivers/staging/lirc/lirc_zilog.c                |    4 +-
 drivers/tty/serial/pch_uart.c                    |    4 +-
 drivers/tty/serial/s5pv210.c                     |    4 +-
 drivers/tty/tty_ldisc.c                          |    4 +-
 drivers/usb/core/driver.c                        |   17 +++++--
 drivers/usb/core/hub.c                           |   16 ++++--
 drivers/usb/core/message.c                       |   17 ++++++-
 drivers/usb/host/xhci-pci.c                      |    8 +++
 drivers/usb/host/xhci-ring.c                     |   11 ++--
 drivers/usb/host/xhci.c                          |   24 +++++++--
 drivers/usb/host/xhci.h                          |    1 +
 drivers/usb/serial/ftdi_sio.c                    |   19 +++++--
 drivers/usb/serial/ftdi_sio.h                    |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h                |    1 +
 drivers/watchdog/mtx-1_wdt.c                     |    8 +++
 fs/block_dev.c                                   |   14 +++++-
 fs/cifs/fscache.c                                |    1 +
 fs/fscache/page.c                                |   44 ++++++++++++++++
 fs/hfsplus/wrapper.c                             |    7 ++-
 fs/lockd/clntproc.c                              |    8 +++-
 fs/locks.c                                       |   30 +++++++----
 fs/nfs/fscache.c                                 |    8 +--
 fs/nfs/inode.c                                   |    6 ++-
 fs/nfs/internal.h                                |   11 ++++
 fs/nfs/nfs4filelayout.c                          |   15 ++++--
 fs/nfs/nfs4proc.c                                |   33 ++++++++----
 fs/nfs/nfs4xdr.c                                 |   14 +++---
 fs/nfsd/Kconfig                                  |    1 +
 fs/nfsd/nfsctl.c                                 |   19 ++-----
 fs/nfsd/vfs.c                                    |   19 ++++---
 include/asm-generic/bug.h                        |    3 -
 include/linux/blk_types.h                        |    2 +-
 include/linux/clocksource.h                      |    1 +
 include/linux/connector.h                        |    2 +-
 include/linux/device.h                           |    4 +-
 include/linux/fscache.h                          |   21 ++++++++
 include/linux/if_packet.h                        |    2 +
 include/linux/netfilter/ipset/ip_set_ahash.h     |    4 +-
 include/linux/netfilter/ipset/ip_set_timeout.h   |   18 ++++---
 include/linux/pci_ids.h                          |    1 +
 include/linux/pm.h                               |    3 +-
 include/linux/ratelimit.h                        |   40 ++++++++++++++
 include/linux/sunrpc/sched.h                     |    3 +-
 include/net/ip_vs.h                              |    3 +-
 init/calibrate.c                                 |   14 +++--
 kernel/power/snapshot.c                          |    6 ++-
 kernel/power/user.c                              |    4 +-
 kernel/taskstats.c                               |   15 ++++-
 kernel/time/clocksource.c                        |   24 +++++----
 lib/debugobjects.c                               |    2 +-
 mm/hugetlb.c                                     |    8 +++
 mm/ksm.c                                         |    6 ++
 mm/memory-failure.c                              |    4 +-
 mm/memory_hotplug.c                              |    2 +-
 mm/migrate.c                                     |    2 +-
 net/8021q/vlan_dev.c                             |    2 +-
 net/bridge/br_netfilter.c                        |    6 ++
 net/core/ethtool.c                               |   25 +++++++++-
 net/core/filter.c                                |    5 ++-
 net/ipv4/af_inet.c                               |    3 +
 net/ipv4/inet_diag.c                             |   14 ++---
 net/ipv4/inetpeer.c                              |   42 ++++++++++-----
 net/ipv4/netfilter.c                             |   60 ++++++++--------------
 net/ipv4/netfilter/ipt_REJECT.c                  |   14 ++----
 net/ipv4/route.c                                 |    4 +-
 net/ipv4/udp.c                                   |    3 +
 net/ipv6/udp.c                                   |    5 ++-
 net/netfilter/ipset/ip_set_core.c                |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c                  |   10 +++-
 net/netfilter/ipvs/ip_vs_core.c                  |    1 +
 net/netfilter/ipvs/ip_vs_ftp.c                   |   27 +++++++---
 net/packet/af_packet.c                           |    2 +
 net/sunrpc/auth_gss/auth_gss.c                   |    4 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c              |    3 +-
 net/sunrpc/clnt.c                                |    5 ++-
 net/sunrpc/sched.c                               |    1 +
 net/xfrm/xfrm_replay.c                           |    4 +-
 security/keys/request_key.c                      |    3 +-
 sound/pci/hda/patch_conexant.c                   |    3 +
 sound/pci/hda/patch_realtek.c                    |    1 -
 sound/soc/pxa/pxa2xx-pcm.c                       |    4 +-
 virt/kvm/assigned-dev.c                          |    5 +--
 128 files changed, 857 insertions(+), 334 deletions(-)
