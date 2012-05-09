Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2EIFwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab2EIFwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:05 -0400
Message-Id: <20120509055029.588587017@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/167] 3.2.17-stable review
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.17 release.
There are 167 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri May 11 13:00:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series should shortly be available in one patch at:
	kernel.org/pub/linux/kernel/v3.2/stable-review/patch-3.2.17-rc1.gz
and the diffstat can be found below.

Ben.

-------------
 Makefile                                       |    4 +-
 arch/arm/Kconfig                               |    9 +
 arch/arm/include/asm/tls.h                     |    4 +
 arch/arm/kernel/irq.c                          |    6 +-
 arch/arm/kernel/smp.c                          |    4 +-
 arch/arm/kernel/sys_arm.c                      |    2 +-
 arch/arm/mach-omap1/timer.c                    |    4 +-
 arch/arm/mm/abort-ev6.S                        |   17 +-
 arch/arm/mm/cache-l2x0.c                       |   25 ++-
 arch/x86/boot/compressed/relocs.c              |    2 -
 arch/x86/kernel/apic/apic.c                    |   34 +--
 arch/x86/kernel/microcode_core.c               |    4 +-
 arch/x86/kernel/setup_percpu.c                 |   14 +-
 arch/x86/xen/enlighten.c                       |    7 +-
 arch/x86/xen/mmu.c                             |    7 +-
 arch/x86/xen/smp.c                             |   15 ++
 arch/x86/xen/xen-asm.S                         |    2 +-
 crypto/sha512_generic.c                        |    2 +-
 drivers/ata/libata-eh.c                        |    3 +-
 drivers/bluetooth/ath3k.c                      |    2 +
 drivers/bluetooth/btusb.c                      |    1 +
 drivers/dma/at_hdmac.c                         |    4 -
 drivers/firmware/efivars.c                     |  196 +++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_execbuffer.c     |   40 ++--
 drivers/gpu/drm/i915/i915_reg.h                |    2 +
 drivers/gpu/drm/i915/intel_hdmi.c              |    2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c        |   16 ++
 drivers/gpu/drm/i915/intel_sdvo.c              |   40 ++--
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c         |    4 +-
 drivers/hwmon/coretemp.c                       |    6 +-
 drivers/hwmon/fam15h_power.c                   |   42 ++++
 drivers/i2c/busses/i2c-pnx.c                   |    3 +-
 drivers/md/md.c                                |    7 +-
 drivers/media/dvb/frontends/drxk_hard.c        |    6 +-
 drivers/media/rc/winbond-cir.c                 |    1 +
 drivers/mmc/card/block.c                       |   54 +++--
 drivers/mmc/card/queue.c                       |    2 +-
 drivers/mmc/core/core.c                        |    9 +-
 drivers/mmc/host/sdhci-esdhc-imx.c             |    3 +-
 drivers/net/bonding/bond_main.c                |    6 +-
 drivers/net/dummy.c                            |    6 +-
 drivers/net/ethernet/atheros/atlx/atl1.c       |   12 +-
 drivers/net/ethernet/atheros/atlx/atl1.h       |    3 +-
 drivers/net/ethernet/atheros/atlx/atlx.c       |    2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c       |    2 +-
 drivers/net/ethernet/micrel/ksz884x.c          |    2 +-
 drivers/net/ethernet/realtek/8139cp.c          |   10 +-
 drivers/net/ethernet/smsc/smsc911x.c           |   14 +-
 drivers/net/ethernet/ti/davinci_mdio.c         |    5 +
 drivers/net/ppp/ppp_generic.c                  |    3 +-
 drivers/net/usb/smsc75xx.c                     |    1 +
 drivers/net/usb/smsc95xx.c                     |    2 +-
 drivers/net/wimax/i2400m/netdev.c              |    3 +-
 drivers/net/wireless/b43/main.c                |   10 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 +
 drivers/net/wireless/ipw2x00/ipw2200.c         |   13 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c        |   16 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   11 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |   17 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |    3 -
 drivers/net/wireless/iwlwifi/iwl-core.c        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h          |   24 ++-
 drivers/net/wireless/iwlwifi/iwl-prph.h        |   27 ++-
 drivers/net/wireless/mwifiex/pcie.h            |   18 +-
 drivers/net/wireless/rt2x00/rt2800usb.c        |   28 +--
 drivers/net/wireless/rtlwifi/pci.c             |    1 +
 drivers/net/wireless/wl1251/main.c             |    1 +
 drivers/net/wireless/wl1251/sdio.c             |    2 +-
 drivers/pci/quirks.c                           |   34 +++
 drivers/platform/x86/dell-laptop.c             |   29 +++
 drivers/scsi/libsas/sas_expander.c             |   26 ++-
 drivers/spi/spi.c                              |    2 +-
 drivers/staging/rtl8712/os_intfs.c             |    3 -
 drivers/staging/rtl8712/usb_intf.c             |    5 +
 drivers/tty/amiserial.c                        |    4 +-
 drivers/tty/serial/clps711x.c                  |   14 +-
 drivers/tty/serial/pch_uart.c                  |    4 +-
 drivers/usb/class/cdc-wdm.c                    |    7 +-
 drivers/usb/core/hcd-pci.c                     |    9 +
 drivers/usb/core/hub.c                         |    3 -
 drivers/usb/core/message.c                     |    6 +-
 drivers/usb/dwc3/ep0.c                         |    3 +-
 drivers/usb/gadget/dummy_hcd.c                 |    1 -
 drivers/usb/gadget/f_fs.c                      |    2 +-
 drivers/usb/gadget/f_mass_storage.c            |    2 +-
 drivers/usb/gadget/file_storage.c              |    2 +-
 drivers/usb/gadget/udc-core.c                  |    6 +-
 drivers/usb/gadget/uvc.h                       |    2 +-
 drivers/usb/gadget/uvc_v4l2.c                  |    2 +-
 drivers/usb/host/ehci-hcd.c                    |    9 +-
 drivers/usb/host/ehci-pci.c                    |    8 +
 drivers/usb/misc/yurex.c                       |   10 +-
 drivers/usb/musb/omap2430.c                    |    9 +-
 drivers/usb/serial/cp210x.c                    |    9 +-
 drivers/usb/serial/sierra.c                    |    6 +-
 drivers/uwb/hwa-rc.c                           |    3 +-
 drivers/uwb/neh.c                              |   12 +-
 drivers/xen/gntdev.c                           |    2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c     |   69 ++++--
 fs/autofs4/autofs_i.h                          |   12 +-
 fs/autofs4/dev-ioctl.c                         |    3 +-
 fs/autofs4/inode.c                             |    4 +-
 fs/autofs4/waitq.c                             |   22 +-
 fs/btrfs/ctree.h                               |    2 +-
 fs/cifs/cifssmb.c                              |    6 +-
 fs/eventpoll.c                                 |    4 +
 fs/exec.c                                      |    3 +
 fs/ext4/extents.c                              |    2 +-
 fs/hfsplus/catalog.c                           |    4 +
 fs/hfsplus/dir.c                               |   11 +
 fs/jbd2/commit.c                               |    4 +-
 fs/lockd/clnt4xdr.c                            |    2 +-
 fs/lockd/clntxdr.c                             |    2 +-
 fs/nfs/nfs4proc.c                              |   23 +-
 fs/nfs/read.c                                  |    2 +-
 fs/nfs/super.c                                 |    8 +-
 fs/nfs/write.c                                 |    2 +-
 fs/nfsd/nfs3xdr.c                              |   22 +-
 fs/nfsd/nfs4proc.c                             |   15 +-
 fs/nfsd/nfs4state.c                            |   23 +-
 fs/nfsd/nfs4xdr.c                              |    2 +-
 fs/nfsd/vfs.c                                  |    2 +-
 fs/ocfs2/alloc.c                               |    2 +-
 fs/ocfs2/refcounttree.c                        |   12 +-
 fs/ocfs2/suballoc.c                            |    4 +-
 fs/pipe.c                                      |   31 ++-
 fs/splice.c                                    |    5 +-
 include/asm-generic/statfs.h                   |    2 +-
 include/linux/efi.h                            |   13 +-
 include/linux/kvm_host.h                       |    6 +
 include/linux/netdevice.h                      |    2 -
 include/linux/pipe_fs_i.h                      |    1 +
 include/linux/seqlock.h                        |    2 +-
 include/linux/skbuff.h                         |   13 ++
 include/linux/socket.h                         |    2 +-
 include/linux/usb/hcd.h                        |    2 +
 kernel/exit.c                                  |   19 --
 kernel/power/swap.c                            |   28 ++-
 kernel/sched.c                                 |   75 ++++---
 kernel/signal.c                                |    9 +
 kernel/trace/trace_output.c                    |    5 +
 mm/swap_state.c                                |    2 +-
 net/ax25/af_ax25.c                             |    9 +-
 net/bridge/br_multicast.c                      |   81 -------
 net/bridge/br_private.h                        |    4 -
 net/core/dev.c                                 |   58 ++---
 net/core/dev_addr_lists.c                      |    3 +-
 net/core/net_namespace.c                       |   33 +--
 net/core/skbuff.c                              |    8 +-
 net/ipv4/tcp.c                                 |   10 +-
 net/ipv4/tcp_input.c                           |    8 +-
 net/ipv4/tcp_output.c                          |   16 +-
 net/ipv6/mcast.c                               |    2 +-
 net/ipv6/tcp_ipv6.c                            |    4 +
 net/mac80211/tx.c                              |    3 +-
 net/netlink/af_netlink.c                       |   24 ++-
 net/phonet/pep.c                               |    3 +
 net/sched/sch_gred.c                           |    7 +-
 net/sctp/socket.c                              |    5 +-
 net/socket.c                                   |    6 +-
 net/wireless/nl80211.c                         |   29 +--
 net/wireless/util.c                            |    2 +-
 scripts/mod/file2alias.c                       |    4 +
 sound/pci/hda/patch_conexant.c                 |   37 +++-
 sound/pci/hda/patch_realtek.c                  |    1 +
 sound/soc/codecs/tlv320aic23.c                 |    4 +-
 sound/soc/codecs/wm8994.c                      |  276 +++++++++++++++++++-----
 sound/soc/soc-dapm.c                           |    2 +
 tools/perf/util/hist.c                         |    4 +-
 virt/kvm/iommu.c                               |   12 +-
 virt/kvm/kvm_main.c                            |    5 +-
 173 files changed, 1551 insertions(+), 702 deletions(-)

-- 
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lennon

