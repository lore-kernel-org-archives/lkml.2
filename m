Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2LMOAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:00:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2LMOAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:00:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: =?UTF-8?q?=5B=203=2E5=2Ey=2Ez=20extended=20stable=20=5D=20Linux=203=2E5=2E7=2E2=20stable=20review?=
Date: Thu, 13 Dec 2012 11:56:05 -0200
Message-Id: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the review cycle for the 3.5.7.2 release of stable patches.
This new release contains 241 patches. Proposed patches are posted as a
response to this message. The same patches are also available at the
following repository:

git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y-review

If there are any problems, or if anything is missing, please answer to
this or to any of the followup patches. Note that any answer should be
made at maximum in 3 days, after that the final release of 3.5.7.2 will be
made.

I believe to have caught up on the queue, including most or all of what
was pending and applicable for 3.5 until now. Thus I expect next versions
to not have a huge number of patches like the previous 3.5.7.1 and this one.

For more information about the 3.5.y.z extended stable tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Included below are the diffstat and shortlog for this release.

-Herton

-- 
 Documentation/cgroups/memory.txt                  |    4 +
 Documentation/dvb/get_dvb_firmware                |    2 +-
 arch/arm/Kconfig                                  |    1 +
 arch/arm/boot/dts/tegra30.dtsi                    |    4 +-
 arch/arm/mach-dove/include/mach/pm.h              |    2 +-
 arch/arm/mach-dove/irq.c                          |   14 +-
 arch/arm/mach-imx/ehci-imx25.c                    |    2 +-
 arch/arm/mach-imx/ehci-imx35.c                    |    2 +-
 arch/arm/mach-kirkwood/pcie.c                     |   11 +-
 arch/arm/plat-omap/include/plat/omap-serial.h     |    4 +-
 arch/m68k/include/asm/signal.h                    |    6 +-
 arch/parisc/kernel/signal32.c                     |    6 +-
 arch/parisc/kernel/sys_parisc.c                   |    2 +
 arch/s390/include/asm/compat.h                    |    2 +-
 arch/s390/include/asm/ptrace.h                    |    4 +-
 arch/s390/kernel/compat_signal.c                  |   14 +-
 arch/s390/kernel/signal.c                         |   14 +-
 arch/s390/mm/gup.c                                |    2 +-
 arch/sparc/kernel/perf_event.c                    |   15 +-
 arch/sparc/kernel/signal_64.c                     |    4 +-
 arch/sparc/kernel/sys_sparc_64.c                  |   10 +-
 arch/sparc/kernel/syscalls.S                      |   32 ++--
 arch/sparc/mm/init_64.c                           |   28 ++-
 arch/x86/boot/compressed/eboot.c                  |    2 +
 arch/x86/include/asm/fpu-internal.h               |   15 +-
 arch/x86/include/asm/ptrace.h                     |   15 +-
 arch/x86/kernel/cpu/amd.c                         |   14 ++
 arch/x86/kernel/microcode_amd.c                   |    4 +
 arch/x86/kernel/ptrace.c                          |   30 ++++
 arch/x86/kernel/smpboot.c                         |    5 +
 arch/x86/kvm/cpuid.h                              |    3 +
 arch/x86/kvm/x86.c                                |    3 +
 arch/x86/xen/mmu.c                                |   21 ++-
 block/blk-exec.c                                  |   10 +-
 crypto/cryptd.c                                   |   11 +-
 drivers/acpi/processor_driver.c                   |    1 +
 drivers/acpi/video.c                              |   11 +-
 drivers/ata/sata_svw.c                            |   35 ++++
 drivers/base/power/qos.c                          |    2 +-
 drivers/block/floppy.c                            |   30 ++--
 drivers/bluetooth/ath3k.c                         |    1 +
 drivers/bluetooth/btusb.c                         |    1 +
 drivers/edac/i7300_edac.c                         |    8 +-
 drivers/edac/i82975x_edac.c                       |   11 +-
 drivers/gpio/gpio-timberdale.c                    |    4 +-
 drivers/gpio/gpiolib.c                            |   10 +-
 drivers/gpu/drm/drm_fops.c                        |    5 +-
 drivers/gpu/drm/i915/i915_gem.c                   |    5 +
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |    1 +
 drivers/gpu/drm/i915/intel_bios.c                 |   11 +-
 drivers/gpu/drm/i915/intel_display.c              |   11 ++
 drivers/gpu/drm/i915/intel_lvds.c                 |   24 +++
 drivers/gpu/drm/i915/intel_overlay.c              |   14 +-
 drivers/gpu/drm/i915/intel_sdvo.c                 |   84 ++++++---
 drivers/gpu/drm/i915/intel_sdvo_regs.h            |    2 +
 drivers/gpu/drm/nouveau/nouveau_drv.c             |   20 ++-
 drivers/gpu/drm/nouveau/nouveau_state.c           |    4 +-
 drivers/gpu/drm/nouveau/nv04_dac.c                |   16 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c                |   14 +-
 drivers/gpu/drm/nouveau/nv04_tv.c                 |    9 +-
 drivers/gpu/drm/radeon/atombios_encoders.c        |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                |  191 +++++++++++----------
 drivers/gpu/drm/radeon/evergreen_cs.c             |    3 +
 drivers/gpu/drm/radeon/evergreen_reg.h            |    2 +
 drivers/gpu/drm/radeon/evergreend.h               |   11 ++
 drivers/gpu/drm/radeon/radeon_agp.c               |    5 +-
 drivers/gpu/drm/radeon/radeon_asic.h              |    1 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c   |    1 +
 drivers/gpu/drm/radeon/si.c                       |    1 +
 drivers/gpu/drm/radeon/sid.h                      |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c              |    5 +-
 drivers/gpu/drm/udl/udl_drv.h                     |    2 +-
 drivers/gpu/drm/udl/udl_fb.c                      |   12 +-
 drivers/gpu/drm/udl/udl_transfer.c                |    5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c            |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c               |    5 +
 drivers/hid/hid-ids.h                             |    3 +
 drivers/hid/hid-microsoft.c                       |   18 +-
 drivers/hid/usbhid/hid-quirks.c                   |    1 +
 drivers/hwmon/w83627ehf.c                         |    1 +
 drivers/i2c/muxes/i2c-mux-pinctrl.c               |    2 +-
 drivers/infiniband/core/cma.c                     |    3 +-
 drivers/infiniband/core/netlink.c                 |    1 +
 drivers/input/matrix-keymap.c                     |    3 +
 drivers/input/touchscreen/tsc40.c                 |    1 -
 drivers/isdn/gigaset/bas-gigaset.c                |   19 +-
 drivers/md/dm.c                                   |    8 +-
 drivers/md/md.c                                   |   11 +-
 drivers/md/raid1.c                                |    2 +-
 drivers/md/raid10.c                               |  115 +++++++------
 drivers/media/video/au0828/au0828-video.c         |   12 +-
 drivers/media/video/s5p-fimc/fimc-lite.c          |    3 +-
 drivers/misc/hpilo.c                              |   11 +-
 drivers/mmc/host/sdhci.c                          |   23 +--
 drivers/mmc/host/sh_mmcif.c                       |    8 +-
 drivers/mtd/devices/slram.c                       |    2 +-
 drivers/mtd/ofpart.c                              |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c           |    8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c       |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   11 +-
 drivers/net/ethernet/calxeda/xgmac.c              |   19 +-
 drivers/net/ethernet/freescale/gianfar.c          |   28 +--
 drivers/net/ethernet/freescale/gianfar.h          |    2 -
 drivers/net/ethernet/freescale/ucc_geth.c         |   29 +---
 drivers/net/ethernet/freescale/ucc_geth.h         |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c   |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |    3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h     |    1 +
 drivers/net/ethernet/marvell/mv643xx_eth.c        |   18 +-
 drivers/net/ethernet/marvell/skge.c               |    7 +
 drivers/net/ethernet/marvell/sky2.c               |    4 +-
 drivers/net/ethernet/nxp/lpc_eth.c                |    1 +
 drivers/net/ethernet/realtek/8139cp.c             |   22 +--
 drivers/net/ethernet/realtek/r8169.c              |    7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |    1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   20 +--
 drivers/net/usb/usbnet.c                          |    3 +
 drivers/net/wireless/ath/ath9k/xmit.c             |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   12 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   14 ++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   23 ++-
 drivers/net/wireless/mwifiex/cmdevt.c             |   11 +-
 drivers/net/wireless/mwifiex/sdio.c               |   11 +-
 drivers/net/wireless/rt2x00/rt2800lib.c           |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |    1 +
 drivers/nfc/pn533.c                               |   16 +-
 drivers/scsi/hpsa.c                               |   32 +++-
 drivers/scsi/isci/request.c                       |    2 +-
 drivers/scsi/qla2xxx/qla_target.c                 |   25 ++-
 drivers/scsi/qla2xxx/qla_target.h                 |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |   73 ++++++++
 drivers/staging/android/android_alarm.h           |    4 +-
 drivers/staging/telephony/ixj.c                   |   24 +--
 drivers/target/iscsi/iscsi_target.c               |    4 +-
 drivers/target/iscsi/iscsi_target_core.h          |    1 +
 drivers/target/iscsi/iscsi_target_login.c         |    1 +
 drivers/target/iscsi/iscsi_target_util.c          |   22 ++-
 drivers/target/iscsi/iscsi_target_util.h          |    1 +
 drivers/target/target_core_configfs.c             |    3 +-
 drivers/target/target_core_device.c               |   18 +-
 drivers/target/target_core_tmr.c                  |    6 +-
 drivers/target/target_core_transport.c            |    1 -
 drivers/tty/serial/omap-serial.c                  |   12 +-
 drivers/usb/serial/mos7840.c                      |    1 -
 drivers/usb/serial/option.c                       |    9 +
 drivers/usb/serial/usb_wwan.c                     |   15 +-
 drivers/virtio/virtio.c                           |    4 +-
 drivers/xen/events.c                              |    2 +-
 drivers/xen/gntdev.c                              |   36 ++--
 fs/cifs/cifsacl.c                                 |   49 +++---
 fs/ext4/ialloc.c                                  |   19 +-
 fs/fs-writeback.c                                 |    2 +
 fs/gfs2/file.c                                    |   12 +-
 fs/gfs2/lops.c                                    |   14 +-
 fs/gfs2/super.c                                   |    3 +-
 fs/gfs2/trans.c                                   |    8 +
 fs/inode.c                                        |   16 +-
 fs/internal.h                                     |    1 +
 fs/jbd/transaction.c                              |    2 +
 fs/jffs2/file.c                                   |   39 +++--
 fs/nfs/dns_resolve.c                              |    5 +-
 fs/nfs/internal.h                                 |    5 +-
 fs/nfs/mount_clnt.c                               |    2 +-
 fs/nfs/namespace.c                                |   19 +-
 fs/nfs/nfs4namespace.c                            |    3 +-
 fs/nfs/nfs4proc.c                                 |   40 +++--
 fs/nfs/super.c                                    |    2 +-
 fs/notify/fanotify/fanotify.c                     |    1 +
 fs/reiserfs/inode.c                               |   10 +-
 fs/reiserfs/stree.c                               |    4 +
 fs/reiserfs/super.c                               |   60 +++++--
 fs/ubifs/find.c                                   |   12 +-
 fs/ubifs/lprops.c                                 |    6 +
 fs/ubifs/ubifs.h                                  |    3 +
 fs/xfs/xfs_buf.c                                  |   14 +-
 fs/xfs/xfs_buf_item.c                             |   18 ++
 fs/xfs/xfs_log_recover.c                          |    2 +-
 include/drm/drm_pciids.h                          |    1 +
 include/linux/if_vlan.h                           |    8 +-
 include/linux/mempolicy.h                         |   16 --
 include/linux/mmzone.h                            |    2 +-
 include/linux/netlink.h                           |   21 ++-
 include/linux/pci_ids.h                           |    1 +
 include/linux/ptp_clock_kernel.h                  |    3 +-
 include/linux/skbuff.h                            |   24 ---
 include/linux/sunrpc/xprt.h                       |    3 +
 include/net/cfg80211.h                            |    9 +
 include/rdma/rdma_netlink.h                       |    1 +
 include/sound/core.h                              |    3 +
 include/trace/events/xen.h                        |    8 +
 kernel/futex.c                                    |   59 ++++---
 kernel/module.c                                   |   27 +--
 kernel/sched/auto_group.c                         |    4 -
 kernel/sched/auto_group.h                         |    5 -
 kernel/watchdog.c                                 |    4 +-
 kernel/workqueue.c                                |    4 +-
 mm/memcontrol.c                                   |   67 ++++++--
 mm/memory-failure.c                               |    8 +
 mm/mempolicy.c                                    |   22 ---
 mm/mmzone.c                                       |    6 +-
 mm/page_alloc.c                                   |    2 +-
 mm/shmem.c                                        |   44 +++--
 mm/sparse.c                                       |   10 +-
 mm/vmscan.c                                       |   29 +++-
 net/8021q/vlan_core.c                             |   10 +-
 net/batman-adv/bridge_loop_avoidance.c            |    8 +-
 net/batman-adv/routing.c                          |    8 +-
 net/bluetooth/mgmt.c                              |   11 +-
 net/can/bcm.c                                     |    3 +
 net/core/dev.c                                    |   13 +-
 net/core/dev_addr_lists.c                         |    3 +-
 net/core/neighbour.c                              |    6 +-
 net/core/skbuff.c                                 |   47 -----
 net/ipv4/inet_diag.c                              |    5 +-
 net/ipv4/ip_sockglue.c                            |   35 ++--
 net/ipv4/netfilter/nf_nat_standalone.c            |    6 +-
 net/ipv4/tcp.c                                    |   12 +-
 net/ipv4/tcp_illinois.c                           |    8 +-
 net/ipv4/tcp_input.c                              |    3 +
 net/ipv4/tcp_ipv4.c                               |    7 +-
 net/ipv4/tcp_output.c                             |    4 +
 net/ipv6/addrconf.c                               |   15 +-
 net/ipv6/ipv6_sockglue.c                          |    1 +
 net/ipv6/ndisc.c                                  |    3 +-
 net/ipv6/route.c                                  |    4 +-
 net/ipv6/tcp_ipv6.c                               |    3 +-
 net/l2tp/l2tp_eth.c                               |    1 +
 net/mac80211/ibss.c                               |   10 +-
 net/mac80211/ieee80211_i.h                        |    2 +
 net/mac80211/rx.c                                 |   72 ++++++--
 net/mac80211/sta_info.c                           |   11 +-
 net/mac80211/status.c                             |    9 +
 net/mac80211/tx.c                                 |    9 +-
 net/mac80211/util.c                               |   42 ++++-
 net/netfilter/nf_conntrack_proto_tcp.c            |   29 ++--
 net/netlink/af_netlink.c                          |   48 ++++--
 net/nfc/llcp/llcp.c                               |    2 +-
 net/rds/send.c                                    |    2 +-
 net/sctp/sm_sideeffect.c                          |    3 +-
 net/sunrpc/xprt.c                                 |   34 ++--
 net/sunrpc/xprtrdma/transport.c                   |    1 +
 net/sunrpc/xprtsock.c                             |    4 +
 net/wireless/core.c                               |    3 +-
 net/wireless/reg.c                                |    5 +-
 net/wireless/util.c                               |   14 +-
 security/selinux/netnode.c                        |    3 +-
 sound/core/compress_offload.c                     |    9 +-
 sound/core/control.c                              |    5 +
 sound/core/hwdep.c                                |   12 +-
 sound/core/init.c                                 |   50 +++---
 sound/core/oss/mixer_oss.c                        |   11 +-
 sound/core/oss/pcm_oss.c                          |    7 +
 sound/core/pcm.c                                  |   13 +-
 sound/core/pcm_native.c                           |   35 +++-
 sound/core/rawmidi.c                              |   26 ++-
 sound/core/sound.c                                |   11 +-
 sound/core/sound_oss.c                            |   10 +-
 sound/pci/hda/patch_analog.c                      |    1 +
 sound/pci/hda/patch_cirrus.c                      |   16 +-
 sound/pci/hda/patch_realtek.c                     |   30 ++--
 sound/pci/hda/patch_via.c                         |   25 ++-
 sound/soc/Makefile                                |    5 +-
 sound/soc/codecs/cs42l52.c                        |    3 +-
 sound/soc/codecs/wm8978.c                         |    2 +-
 sound/soc/soc-core.c                              |    5 +-
 sound/soc/soc-dapm.c                              |    2 +-
 sound/usb/card.c                                  |   14 +-
 sound/usb/card.h                                  |    1 +
 sound/usb/midi.c                                  |    8 +-
 sound/usb/mixer.c                                 |   65 ++++---
 sound/usb/mixer_quirks.c                          |   58 ++++++-
 sound/usb/pcm.c                                   |   49 ++++--
 sound/usb/proc.c                                  |    4 +-
 sound/usb/stream.c                                |    1 +
 sound/usb/usbaudio.h                              |    2 +-
 276 files changed, 2253 insertions(+), 1252 deletions(-)

Al Viro (3):
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()
      fix user-triggerable panic on parisc
      sparc64: fix ptrace interaction with force_successful_syscall_return()

Alan Cox (1):
      ACPI: missing break

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Alex Deucher (8):
      drm/radeon/cayman: add some missing regs to the VM reg checker
      drm/radeon/si: add some missing regs to the VM reg checker
      drm/radeon: fix logic error in atombios_encoders.c
      drm/radeon/dce4+: don't use radeon_crtc for vblank callback
      drm/radeon: properly handle mc_stop/mc_resume on evergreen+ (v2)
      drm/radeon: properly track the crtc not_enabled case evergreen_mc_stop()
      drm/radeon: add new SI pci id
      drm/radeon: fix typo in evergreen_mc_resume()

Alexander Stein (1):
      ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Alexey Kuznetsov (1):
      tcp: resets are misrouted

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions

Andrew Vagin (1):
      tcp: fix retransmission in repair mode

Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN

Ariel Elior (1):
      bnx2x: remove redundant warning log

Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues

Artem Bityutskiy (2):
      UBIFS: introduce categorized lprops counter
      UBIFS: fix mounting problems after power cuts

Ben Hutchings (1):
      nfs: Show original device name verbatim in /proc/*/mount{s,info}

Ben Skeggs (3):
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets
      drm/nouveau: fix suspend/resume when in headless mode
      drm/nouveau: headless mode by default if pci class != vga display

Benjamin Marzinski (2):
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held
      GFS2: Don't call file_accessed() with a shared glock

Bing Zhao (2):
      mwifiex: fix system hang issue in cmd timeout error case
      mwifiex: report error to MMC core if we cannot suspend

Boris Ostrovsky (1):
      x86, microcode, AMD: Add support for family 16h processors

Bryan Schumaker (2):
      NFS: Wait for session recovery to finish before returning
      SUNRPC: Set alloc_slot for backchannel tcp ops

Calvin Walton (1):
      i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Chris Ball (2):
      mmc: sdhci: fix NULL dereference in sdhci_request() tuning
      Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"

Chris Wilson (2):
      drm/i915: Use cpu relocations if the object is in the GTT but not mappable
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H

Christoph Fritz (1):
      ARM: imx: ehci: fix host power mask bit

Chuansheng Liu (1):
      watchdog: using u64 in get_sample_period()

Clemens Ladisch (1):
      ALSA: ua101, usx2y: fix broken MIDI output

Colin Cross (1):
      Revert "Staging: Android alarm: IOCTL command encoding fix"

Cornelia Huck (1):
      virtio: Don't access index after unregister.

Cyril Brulebois (1):
      r8169: Fix WoL on RTL8168d/8111d.

Cyrill Gorcunov (1):
      net: inet_diag -- Return error code if protocol handler is missed

Dan Carpenter (2):
      gpio-timberdale: fix a potential wrapping issue
      telephony: ijx: buffer overflow in ixj_write_cid()

Dan Williams (2):
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
      USB: option: add Alcatel X220/X500D USB IDs

Daniel J Blueman (1):
      ALSA: HDA: Fix digital microphone on CS420x

Daniel Vetter (2):
      drm/i915: fix overlay on i830M
      drm/i915: clear the entire sdvo infoframe buffer

Darren Hart (1):
      futex: avoid wake_futex() for a PI futex_q

Dave Airlie (1):
      drm/udl: fix stride issues scanning out stride != width*bpp

Dave Chinner (3):
      xfs: fix buffer shudown reference count mismatch
      xfs: fix reading of wrapped log data
      xfs: drop buffer io reference when a bad bio is built

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference

David Henningsson (1):
      ALSA: hda - Add support for Realtek ALC292

David Milburn (1):
      sata_svw: check DMA start bit before reset

David S. Miller (3):
      sparc64: Like x86 we should check current->mm during perf backtrace generation.
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().
      sparc64: Be less verbose during vmemmap population.

David Vrabel (1):
      xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF

Devin Heitmueller (1):
      [media] au0828: fix case where STREAMOFF being called on stopped stream causes BUG()

Dmitry Rogozhkin (1):
      drm/i915: EBUSY status handling added to i915_gem_fault().

Egbert Eich (1):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.

Emmanuel Grumbach (1):
      iwlwifi: fix the basic CCK rates calculation

Eric Dumazet (4):
      net: remove skb recycling
      ipv6: addrconf: fix /proc/net/if_inet6
      netlink: use kfree_rcu() in netlink_release()
      tcp: fix FIONREAD/SIOCINQ

Eric Leblond (1):
      af-packet: fix oops when socket is not present

Eric Millbrandt (1):
      ASoC: wm8978: pll incorrectly configured when codec is master

Eric Paris (1):
      fanotify: fix missing break

Eric Sandeen (1):
      ext4: fix unjournaled inode bitmap modification

Felipe Balbi (1):
      Revert "serial: omap: fix software flow control"

Felix Fietkau (3):
      cfg80211: fix antenna gain handling
      ath9k: fix stale pointers potentially causing access to free'd skbs
      mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge

Florian Fainelli (1):
      Input: matrix-keymap - provide proper module license

Florian Zumbiehl (1):
      vlan: don't deliver frames for unknown vlans to protocols

Gao feng (2):
      netlink: add reference of module in netlink_dump_start
      infiniband: pass rdma_cm module to netlink_dump_start

Graham Gower (1):
      skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboard

Guennadi Liakhovetski (2):
      PM / QoS: fix wrong error-checking condition
      mmc: sh-mmcif: avoid oops on spurious interrupts (second try)

Guenter Roeck (1):
      i2c-mux-pinctrl: Fix probe error path

H. Peter Anvin (1):
      x86-32: Export kernel_stack_pointer() for modules

Hannes Frederic Sowa (2):
      ipv6: send unsolicited neighbour advertisements to all-nodes
      ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set return value

Heiko Carstens (1):
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()

Hemant Kumar (1):
      net: usb: Fix memory leak on Tx data path

Herton Ronaldo Krzesinski (3):
      floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
      floppy: do put_disk on current dr if blk_init_queue fails
      floppy: properly handle failure on add_disk loop

Hugh Dickins (3):
      memcg: fix hotplugged memory zone oops
      tmpfs: fix shmem_getpage_gfp() VM_BUG_ON
      tmpfs: change final i_blocks BUG to WARNING

Igor Murzov (1):
      ACPI video: Ignore errors after _DOD evaluation.

Ilija Hadzic (1):
      drm: restore open_count if drm_setup fails

Jacob Keller (2):
      ixgbe: PTP get_ts_info missing software support
      ptp: update adjfreq callback description

James Bottomley (1):
      fix virtual aliasing issue in get_shared_area()

Jan Kara (6):
      reiserfs: Fix lock ordering during remount
      reiserfs: Protect reiserfs_quota_on() with write lock
      reiserfs: Protect reiserfs_quota_write() with write lock
      reiserfs: Move quota calls out of write lock
      jbd: Fix lock ordering bug in journal_unmap_buffer()
      writeback: put unused inodes to LRU after writeback completion

Jani Nikula (3):
      drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
      drm/i915: do not ignore eDP bpc settings from vbt
      drm/i915: do not default to 18 bpp for eDP if missing from VBT

Jason Gunthorpe (1):
      ARM: Kirkwood: Update PCI-E fixup

Javier Cardona (2):
      mac80211: Only process mesh config header on frames that RA_MATCH
      mac80211: don't inspect Sequence Control field on control frames

Jean Delvare (2):
      hwmon: (w83627ehf) Force initial bank selection
      i7300_edac: Fix error flag testing

Jeff Layton (1):
      cifs: fix potential buffer overrun in cifs.idmap handling code

Jens Axboe (1):
      dm: fix deadlock with request based dm and queue request_fn recursion

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois

Jianguo Wu (1):
      mm/vmemmap: fix wrong use of virt_to_page

Jiri Engelthaler (1):
      mtd: slram: invalid checking of absolute end address

Jiri Kosina (2):
      sparc64: do not clobber personality flags in sys_sparc64_personality()
      floppy: destroy floppy workqueue before cleaning up the queue

Jiri Pirko (1):
      net: correct check in dev_addr_del()

Jiri Slaby (3):
      HID: microsoft: fix invalid rdesc for 3k kbd
      HID: microsoft: do not use compound literal - fix build
      MISC: hpilo, remove pci_disable_device

Johan Hedberg (1):
      Bluetooth: Fix having bogus entries in mgmt_read_index_list reply

Johan Hovold (2):
      USB: usb_wwan: fix bulk-urb allocation
      USB: mos7840: remove unused variable

Johannes Berg (9):
      mac80211: use blacklist for duplicate IE check
      wireless: drop invalid mesh address extension frames
      mac80211: check management frame header length
      mac80211: verify that skb data is present
      mac80211: make sure data is accessible in EAPOL check
      iwlwifi: handle DMA mapping failures
      mac80211: don't send null data packet when not associated
      wireless: allow 40 MHz on world roaming channels 12/13
      iwlwifi: fix monitor mode FCS flag

Johannes Weiner (1):
      mm: vmscan: fix endless loop in kswapd balancing

Jozsef Kadlecsik (2):
      netfilter: Mark SYN/ACK packets as invalid from original direction
      netfilter: Validate the sequence number of dataless ACK packets as well

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption

Kailang Yang (3):
      ALSA: hda - Improve HP depop when system enter to S3
      ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)
      ALSA: hda - Add new codec ALC283 ALC290 support

Konrad Rzeszutek Wilk (1):
      xen/mmu: Use Xen specific TLB flush instead of the generic one.

Li RongQing (1):
      ipv6: Set default hoplimit as zero.

Linus Lüssing (1):
      batman-adv: Fix broadcast packet CRC calculation

Maciej Patelczyk (1):
      isci: copy fis 0x34 response into proper buffer

Marcos Chaparro (1):
      Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Marek Vasut (1):
      HID: add quirk for Freescale i.MX28 ROM recovery

Martin Schwidefsky (1):
      s390/signal: set correct address space control

Mathias Nyman (1):
      gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios

Matt Fleming (1):
      x86, efi: Fix processor-specific memcpy() build error

Mauro Carvalho Chehab (2):
      get_dvb_firmware: fix download site for tda10046 firmware
      i82975x_edac: Fix dimm label initialization

Mel Gorman (1):
      tmpfs: fix shared mempolicy leak

Michal Hocko (1):
      memcg: oom: fix totalpages calculation for memory.swappiness==0

Michal Schmidt (1):
      r8169: use unlimited DMA burst for TX

Mike Galbraith (2):
      workqueue: exit rescuer_thread() as TASK_RUNNING
      Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Mike Miller (1):
      [SCSI] hpsa: gen8plus Smart Array IDs

Mirko Lindner (1):
      sky2: Fix for interrupt handler

Misael Lopez Cruz (1):
      ASoC: dapm: Use card_list during DAPM shutdown

Mojiong Qiu (1):
      xen/events: fix RCU warning, or Call idle notifier after irq_enter()

Mukund Navada (1):
      ASoC: core: Double control update err for snd_soc_put_volsw_sx

Naoya Horiguchi (1):
      mm: soft offline: split thp at the beginning of soft_offline_page()

Nathan Walp (1):
      r8169: allow multicast packets on sub-8168f chipset.

NeilBrown (4):
      md/raid1: Fix assembling of arrays containing Replacements.
      NFS: fix bug in legacy DNS resolver.
      md/raid10: close race that lose writes lost when replacement completes.
      md/raid10: decrement correct pending counter when writing to replacement.

Nicholas Bellinger (1):
      target: Fix double-free of se_cmd in target_complete_tmr_failure

Oliver Hartkopp (2):
      can: peak_usb: fix hwtstamp assignment
      can: bcm: initialize ifindex for timeouts without previous frame reception

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250

Pavel Emelyanov (1):
      tcp-repair: Handle zero-length data put in rcv queue

Peter Senna Tschudin (1):
      drivers/net/ethernet/nxp/lpc_eth.c: Call mdiobus_unregister before mdiobus_free

Peter Ujfalusi (1):
      ASoC: dmaengine: Correct Makefile when sound is built as module

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-2012-4461)

Pritesh Raithatha (1):
      ARM: dt: tegra: fix length of pad control and mux registers

Robert Richter (1):
      x86-32: Fix invalid stack address while in softirq

Roland Dreier (5):
      qla2xxx: Update target lookup session tables when a target session changes
      target: Don't return success from module_init() if setup fails
      target: Avoid integer overflow in se_dev_align_max_sectors()
      iscsi-target: Fix missed wakeup race in TX thread
      block: Don't access request after it might be freed

Rolf Eike Beer (1):
      Input: tsc40 - remove wrong announcement of pressure support

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
      Dove: Fix irq_to_pmu()

Rusty Russell (1):
      module: fix out-by-one error in kallsyms

Sachin Kamat (1):
      mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()

Scott Mayhew (1):
      nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd timeouts

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check

Sjoerd Simons (1):
      drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13

Stanislaw Gruszka (1):
      rt2800: validate step value for temperature compensation

Steve Hodgson (1):
      target: Fix incorrect usage of nested IRQ spinlocks in ABORT_TASK path

Sven Eckelmann (1):
      ath9k: Test for TID only in BlockAcks while checking tx status

Sylwester Nawrocki (1):
      [media] fimc-lite: Don't use mutex_lock_interruptible() in device release()

Szymon Janc (1):
      NFC: pn533: Fix use after free

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()

Takashi Iwai (12):
      ALSA: PCM: Fix some races at disconnection
      ALSA: usb-audio: Fix races at disconnection
      ALSA: usb-audio: Use rwsem for disconnect protection
      ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
      ALSA: Add a reference counter to card instance
      ALSA: Avoid endless sleep after disconnect
      ALSA: hda - Force to reset IEC958 status bits for AD codecs
      ALSA: hda - Fix empty DAC filling in patch_via.c
      ALSA: hda - Fix invalid connections in VT1802 codec
      ALSA: Fix card refcount unbalance
      ALSA: hda - Add a missing quirk entry for iMac 9,1
      ALSA: usb-audio: Fix mutex deadlock at disconnection

Thierry Escande (1):
      NFC: Fix nfc_llcp_local chained list insertion

Thomas Betker (1):
      jffs2: Fix lock acquisition order bug in jffs2_write_begin

Thomas Gleixner (1):
      futex: Handle futex_pi OWNER_DIED take over correctly

Thomas Hellstrom (2):
      drm/vmwgfx: Fix hibernation device reset
      drm/vmwgfx: Fix a case where the code would BUG when trying to pin GMR memory

Tilman Schmidt (1):
      bas_gigaset: fix pre_reset handling

Tom Herbert (1):
      net-rps: Fix brokeness causing OOO packets

Tom Parkin (1):
      l2tp: fix oops in l2tp_eth_create() error path

Trond Myklebust (3):
      NFSv4.1: We must release the sequence id when we fail to get a session slot
      NFSv4: nfs4_locku_done must release the sequence id
      SUNRPC: Fix a UDP transport regression

Ulrich Weber (1):
      netfilter: nf_nat: don't check for port change on ICMP tuples

Vincent Palatin (1):
      x86, fpu: Avoid FPU lazy restore after suspend

Waldemar Rymarkiewicz (1):
      NFC: pn533: Fix mem leak in pn533_in_dep_link_up

Wei Yongjun (1):
      ASoC: cs42l52: fix the return value of cs42l52_set_fmt()

Xi Wang (1):
      ipv4: avoid undefined behavior in do_ip_setsockopt()

Zhao Yakui (1):
      ttm: Clear the ttm page allocated from high memory zone correctly

Zijie Pan (1):
      sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()

françois romieu (1):
      8139cp: revert "set ring address before enabling receiver"

jeff.liu (1):
      RDS: fix rds-ping spinlock recursion

joshua.a.hay@intel.com (1):
      ixgbe: add support for X540-AT1

majianpeng (2):
      md: Reassigned the parameters if read_seqretry returned true in func md_is_badblock.
      md: Avoid write invalid address if read_seqretry returned true.

ramesh.nagappa@gmail.com (1):
      net: Fix skb_under_panic oops in neigh_resolve_output
