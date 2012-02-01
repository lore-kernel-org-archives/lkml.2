Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2BAV7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:59:38 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54360 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269Ab2BAVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:37 -0500
X-Sasl-enc: 4xrY/BOWGTUD/Gyi7jUhUPIxs1iZIk1nez5bBK5TWEWK 1328130456
Date: Wed, 1 Feb 2012 13:05:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/89] 3.2.3-stable review
Message-ID: <20120201210505.GA26028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.3 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, February 3, 2012, 20:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                         |    4 +-
 arch/arm/mach-at91/setup.c                       |    7 +-
 arch/arm/mach-ux500/Kconfig                      |    1 +
 arch/arm/mach-ux500/board-mop500-sdi.c           |    2 +
 arch/arm/mm/proc-v7.S                            |    6 -
 arch/m68k/atari/config.c                         |    8 +-
 arch/m68k/kernel/process_mm.c                    |    4 +-
 arch/m68k/kernel/process_no.c                    |    4 +-
 arch/m68k/kernel/traps.c                         |   36 ++++----
 arch/m68k/mm/cache.c                             |    6 +-
 arch/x86/include/asm/uv/uv_hub.h                 |    4 +-
 arch/x86/kernel/microcode_amd.c                  |   24 +++++-
 arch/x86/net/bpf_jit_comp.c                      |   36 +++++---
 arch/x86/platform/uv/tlb_uv.c                    |    2 +
 arch/x86/platform/uv/uv_irq.c                    |    2 +-
 arch/x86/xen/spinlock.c                          |   27 +++++-
 crypto/sha512_generic.c                          |   62 +++++++------
 drivers/char/tpm/tpm_tis.c                       |    3 +
 drivers/gpu/drm/drm_auth.c                       |    6 +-
 drivers/gpu/drm/drm_fops.c                       |    5 +
 drivers/gpu/drm/i915/i915_suspend.c              |    4 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c          |   27 +++++-
 drivers/gpu/drm/i915/intel_sdvo.c                |    8 +-
 drivers/gpu/drm/radeon/atombios_dp.c             |   22 ++---
 drivers/gpu/drm/radeon/atombios_encoders.c       |   26 ++++-
 drivers/gpu/drm/radeon/radeon_irq_kms.c          |    6 +
 drivers/gpu/drm/radeon/radeon_mode.h             |    3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c              |    2 +-
 drivers/hwmon/f71805f.c                          |   10 +-
 drivers/hwmon/sht15.c                            |    3 +-
 drivers/hwmon/w83627ehf.c                        |    6 +
 drivers/net/bonding/bond_alb.c                   |   27 ++----
 drivers/net/macvlan.c                            |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c   |   10 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c              |   20 ++---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c             |    3 +-
 drivers/tty/serial/amba-pl011.c                  |   14 +++
 drivers/tty/serial/jsm/jsm_driver.c              |    1 +
 drivers/tty/tty_port.c                           |   12 ++-
 drivers/usb/class/cdc-wdm.c                      |   59 ++++++++----
 drivers/usb/dwc3/ep0.c                           |   14 +--
 drivers/usb/gadget/langwell_udc.c                |   18 ++--
 drivers/usb/gadget/storage_common.c              |    6 +-
 drivers/usb/host/ehci-fsl.c                      |    2 +-
 drivers/usb/host/xhci-ring.c                     |    6 +-
 drivers/usb/misc/usbsevseg.c                     |    2 +-
 drivers/usb/musb/davinci.c                       |    3 -
 drivers/usb/serial/cp210x.c                      |  107 +++++++++++++++-------
 drivers/usb/serial/ftdi_sio.c                    |   14 ++-
 drivers/usb/serial/ftdi_sio_ids.h                |   19 ++++
 drivers/usb/serial/io_ti.c                       |   10 +--
 drivers/usb/serial/option.c                      |    5 +
 drivers/usb/serial/qcaux.c                       |    7 +-
 drivers/usb/storage/realtek_cr.c                 |    2 +-
 fs/ecryptfs/crypto.c                             |   49 +---------
 fs/ecryptfs/inode.c                              |   48 +++++++---
 fs/ecryptfs/miscdev.c                            |   56 ++++++++----
 fs/ecryptfs/read_write.c                         |   19 +++-
 fs/jbd/checkpoint.c                              |   27 +++++-
 fs/jbd/recovery.c                                |    4 +
 fs/sysfs/file.c                                  |    6 +
 fs/sysfs/inode.c                                 |    5 +-
 fs/xfs/xfs_vnodeops.c                            |    3 +-
 include/drm/drmP.h                               |    1 +
 include/net/netns/generic.h                      |    1 +
 net/caif/caif_dev.c                              |   11 +--
 net/caif/cfcnfg.c                                |    1 -
 net/core/net-sysfs.c                             |    6 +-
 net/core/net_namespace.c                         |   31 +++---
 net/core/netpoll.c                               |    2 +-
 net/decnet/dn_dev.c                              |    4 +-
 net/ipv4/devinet.c                               |    2 +-
 net/ipv4/fib_trie.c                              |   10 +-
 net/ipv4/igmp.c                                  |    8 +-
 net/ipv4/ipip.c                                  |    8 +-
 net/ipv4/ipmr.c                                  |    2 +-
 net/ipv4/tcp_ipv4.c                              |    2 +-
 net/ipv4/tcp_output.c                            |    6 +-
 net/ipv6/addrconf.c                              |    2 +-
 net/ipv6/ip6_tunnel.c                            |    8 +-
 net/ipv6/raw.c                                   |    2 +-
 net/ipv6/sit.c                                   |   10 +-
 net/ipv6/tcp_ipv6.c                              |    2 +-
 net/l2tp/l2tp_ip.c                               |    5 -
 net/mac80211/agg-rx.c                            |    2 +-
 net/mac80211/cfg.c                               |    4 +-
 net/mac80211/ibss.c                              |    2 +-
 net/mac80211/mlme.c                              |   38 ++++++--
 net/mac80211/sta_info.c                          |    6 +-
 net/netfilter/nf_conntrack_core.c                |    2 +-
 net/netfilter/nf_conntrack_ecache.c              |    4 +-
 net/netfilter/nf_conntrack_extend.c              |    2 +-
 net/netfilter/nf_conntrack_helper.c              |    2 +-
 net/netfilter/nf_conntrack_netlink.c             |    2 +-
 net/netfilter/nf_log.c                           |    6 +-
 net/netfilter/nf_queue.c                         |    2 +-
 net/netfilter/nfnetlink.c                        |    4 +-
 net/netlabel/netlabel_domainhash.c               |    4 +-
 net/netlabel/netlabel_unlabeled.c                |    6 +-
 net/phonet/af_phonet.c                           |    2 +-
 net/phonet/pn_dev.c                              |    2 +-
 net/phonet/socket.c                              |    2 +-
 net/rds/af_rds.c                                 |   20 ++---
 net/socket.c                                     |    2 +-
 net/sunrpc/auth_gss/auth_gss.c                   |    2 +-
 net/unix/af_unix.c                               |   19 +---
 net/xfrm/xfrm_user.c                             |    2 +-
 sound/pci/hda/hda_intel.c                        |    6 +-
 sound/pci/hda/patch_realtek.c                    |   11 ++
 sound/pci/hda/patch_sigmatel.c                   |   17 +++-
 sound/soc/codecs/wm5100.c                        |    3 +
 sound/soc/codecs/wm8996.c                        |    7 +-
 sound/soc/codecs/wm8996.h                        |    4 +
 114 files changed, 767 insertions(+), 491 deletions(-)
