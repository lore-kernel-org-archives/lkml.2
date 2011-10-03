Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1JCUgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:36:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41347 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932198Ab1JCUgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:36:42 -0400
X-Sasl-enc: Xcfn/VU4L7wKo+T8FpC+m2XFBZDxQA+wV9x4LMIjmwfS 1317674200
Date: Mon, 3 Oct 2011 13:32:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.5
Message-ID: <20111003203249.GA22113@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.5 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/Kconfig                                     |   14 +
 arch/arm/include/asm/futex.h                         |   34 +--
 arch/arm/include/asm/hardware/cache-l2x0.h           |    2=20
 arch/arm/kernel/smp_scu.c                            |   10 +
 arch/arm/mach-davinci/board-da850-evm.c              |   28 ++
 arch/arm/mach-davinci/sleep.S                        |    6=20
 arch/arm/mach-dove/common.c                          |    2=20
 arch/arm/mach-integrator/integrator_ap.c             |    6=20
 arch/arm/mm/cache-v7.S                               |   20 ++
 arch/arm/mm/dma-mapping.c                            |    2=20
 arch/arm/plat-mxc/include/mach/iomux-v3.h            |    2=20
 arch/powerpc/sysdev/fsl_rio.c                        |    5=20
 arch/sparc/Kconfig                                   |    1=20
 arch/sparc/include/asm/sigcontext.h                  |   14 +
 arch/sparc/include/asm/spinlock_32.h                 |   11 -
 arch/sparc/include/asm/spinlock_64.h                 |    6=20
 arch/sparc/kernel/Makefile                           |    1=20
 arch/sparc/kernel/irq.h                              |    2=20
 arch/sparc/kernel/pcic.c                             |    4=20
 arch/sparc/kernel/setup_64.c                         |   10 -
 arch/sparc/kernel/signal32.c                         |  184 ++++++++++----=
-----
 arch/sparc/kernel/signal_32.c                        |  172 ++++++++------=
---
 arch/sparc/kernel/signal_64.c                        |  108 ++++-------
 arch/sparc/kernel/sigutil.h                          |    9=20
 arch/sparc/kernel/sigutil_32.c                       |  120 ++++++++++++
 arch/sparc/kernel/sigutil_64.c                       |   93 +++++++++
 arch/x86/kernel/amd_iommu.c                          |   18 +
 arch/x86/kernel/cpu/perf_event.c                     |    3=20
 arch/x86/kernel/cpu/perf_event_intel.c               |    1=20
 arch/x86/xen/setup.c                                 |   21 ++
 arch/x86/xen/smp.c                                   |   10 +
 arch/x86/xen/xen-asm_32.S                            |    8=20
 block/blk-cgroup.c                                   |   37 +--
 block/blk-core.c                                     |   13 -
 block/blk-sysfs.c                                    |    5=20
 drivers/acpi/acpica/acconfig.h                       |    2=20
 drivers/acpi/acpica/aclocal.h                        |    1=20
 drivers/acpi/acpica/nspredef.c                       |    1=20
 drivers/acpi/acpica/nsrepair2.c                      |   15 +
 drivers/ata/ahci.c                                   |    1=20
 drivers/ata/pata_via.c                               |   18 +
 drivers/base/firmware_class.c                        |   11 -
 drivers/block/floppy.c                               |    8=20
 drivers/char/tpm/tpm.c                               |    9=20
 drivers/cpufreq/pcc-cpufreq.c                        |    3=20
 drivers/firewire/ohci.c                              |    3=20
 drivers/gpu/drm/nouveau/nouveau_sgdma.c              |    5=20
 drivers/gpu/drm/radeon/evergreen.c                   |   42 +++-
 drivers/gpu/drm/radeon/ni.c                          |   16 +
 drivers/gpu/drm/radeon/r100.c                        |   18 -
 drivers/gpu/drm/radeon/r200.c                        |    4=20
 drivers/gpu/drm/radeon/r600.c                        |   14 -
 drivers/gpu/drm/radeon/radeon.h                      |    7=20
 drivers/gpu/drm/radeon/radeon_asic.h                 |    8=20
 drivers/gpu/drm/radeon/radeon_clocks.c               |    3=20
 drivers/gpu/drm/radeon/radeon_combios.c              |    8=20
 drivers/gpu/drm/radeon/radeon_encoders.c             |    9=20
 drivers/gpu/drm/radeon/radeon_ttm.c                  |    7=20
 drivers/hwmon/ds620.c                                |    2=20
 drivers/hwmon/max16065.c                             |    2=20
 drivers/infiniband/hw/cxgb3/iwch_cm.c                |   10 -
 drivers/leds/ledtrig-timer.c                         |    2=20
 drivers/md/linear.h                                  |    2=20
 drivers/md/md.c                                      |   12 +
 drivers/media/dvb/dvb-usb/vp7045.c                   |   26 --
 drivers/media/rc/nuvoton-cir.c                       |   45 ----
 drivers/media/rc/nuvoton-cir.h                       |    1=20
 drivers/mfd/omap-usb-host.c                          |    1=20
 drivers/mfd/tps65910-irq.c                           |    2=20
 drivers/mmc/core/core.c                              |   35 +++
 drivers/mmc/core/host.c                              |   12 -
 drivers/mmc/core/host.h                              |    8=20
 drivers/mmc/host/sdhci-s3c.c                         |    2=20
 drivers/net/bnx2.c                                   |    7=20
 drivers/net/bnx2x/bnx2x_dcb.c                        |    1=20
 drivers/net/bnx2x/bnx2x_main.c                       |    6=20
 drivers/net/bnx2x/bnx2x_reg.h                        |   12 +
 drivers/net/cnic.c                                   |   57 ++---
 drivers/net/cxgb3/cxgb3_offload.c                    |   23 +-
 drivers/net/cxgb3/l2t.c                              |   15 +
 drivers/net/cxgb3/l2t.h                              |   16 +
 drivers/net/e1000/e1000_hw.c                         |    6=20
 drivers/net/ibmveth.c                                |   31 ++-
 drivers/net/igb/igb_main.c                           |    2=20
 drivers/net/irda/smsc-ircc2.c                        |    2=20
 drivers/net/ixgbe/ixgbe_main.c                       |    4=20
 drivers/net/rionet.c                                 |   23 --
 drivers/net/sfc/efx.c                                |   18 -
 drivers/net/sfc/io.h                                 |   15 -
 drivers/net/sfc/mcdi.c                               |   46 +---
 drivers/net/sfc/nic.c                                |    7=20
 drivers/net/sfc/nic.h                                |    2=20
 drivers/net/sfc/siena.c                              |   25 --
 drivers/net/sfc/workarounds.h                        |    2=20
 drivers/net/tg3.c                                    |   30 +--
 drivers/net/usb/asix.c                               |    4=20
 drivers/net/usb/cdc_ncm.c                            |  156 +++++---------=
--
 drivers/net/wireless/ath/ath9k/ar9002_calib.c        |    3=20
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |    2=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c       |    2=20
 drivers/net/wireless/ath/ath9k/main.c                |    4=20
 drivers/net/wireless/ath/carl9170/main.c             |    4=20
 drivers/net/wireless/b43/main.c                      |    3=20
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c          |   13 -
 drivers/net/wireless/iwlegacy/iwl-core.c             |    4=20
 drivers/net/wireless/iwlegacy/iwl-hcmd.c             |    2=20
 drivers/net/wireless/iwlegacy/iwl-tx.c               |    4=20
 drivers/net/wireless/iwlegacy/iwl3945-base.c         |    8=20
 drivers/net/wireless/iwlegacy/iwl4965-base.c         |   10 -
 drivers/net/wireless/iwlwifi/iwl-agn.c               |    5=20
 drivers/net/wireless/iwlwifi/iwl-scan.c              |   30 +--
 drivers/net/wireless/iwlwifi/iwl-tx.c                |    2=20
 drivers/net/wireless/rt2x00/rt2800lib.c              |   64 ++++--
 drivers/net/wireless/rt2x00/rt2800usb.c              |    4=20
 drivers/net/wireless/rt2x00/rt2x00usb.c              |   14 -
 drivers/net/wireless/rtlwifi/core.c                  |    8=20
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c         |   11 -
 drivers/net/wireless/rtlwifi/usb.c                   |    1=20
 drivers/pci/dmar.c                                   |    2=20
 drivers/rapidio/rio-scan.c                           |    3=20
 drivers/regulator/tps65910-regulator.c               |    7=20
 drivers/rtc/interface.c                              |    2=20
 drivers/s390/cio/qdio_thinint.c                      |   15 -
 drivers/scsi/3w-9xxx.c                               |    2=20
 drivers/scsi/Makefile                                |    2=20
 drivers/scsi/aacraid/commsup.c                       |    2=20
 drivers/scsi/bnx2fc/bnx2fc.h                         |    8=20
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                    |   28 ++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                     |   24 ++
 drivers/scsi/bnx2fc/bnx2fc_io.c                      |    2=20
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                   |    2=20
 drivers/scsi/fcoe/fcoe.c                             |   19 +
 drivers/scsi/hpsa.c                                  |   57 +++--
 drivers/scsi/isci/host.c                             |    3=20
 drivers/scsi/isci/phy.c                              |   13 +
 drivers/scsi/isci/registers.h                        |   12 +
 drivers/scsi/isci/request.c                          |   30 +--
 drivers/scsi/isci/unsolicited_frame_control.c        |    2=20
 drivers/scsi/isci/unsolicited_frame_control.h        |    2=20
 drivers/scsi/iscsi_tcp.c                             |   61 ++++--
 drivers/scsi/libfc/fc_rport.c                        |   14 +
 drivers/scsi/libiscsi_tcp.c                          |   14 -
 drivers/scsi/libsas/sas_expander.c                   |    2=20
 drivers/scsi/lpfc/lpfc.h                             |    8=20
 drivers/scsi/lpfc/lpfc_attr.c                        |  147 +++++++--------
 drivers/scsi/lpfc/lpfc_bsg.c                         |   52 ++---
 drivers/scsi/lpfc/lpfc_crtn.h                        |    2=20
 drivers/scsi/lpfc/lpfc_els.c                         |  103 ++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c                     |    2=20
 drivers/scsi/lpfc/lpfc_hw.h                          |    7=20
 drivers/scsi/lpfc/lpfc_hw4.h                         |   30 +--
 drivers/scsi/lpfc/lpfc_init.c                        |   82 ++++++--
 drivers/scsi/lpfc/lpfc_mbox.c                        |    2=20
 drivers/scsi/lpfc/lpfc_scsi.c                        |   97 +++-------
 drivers/scsi/lpfc/lpfc_sli.c                         |  106 ++++++----
 drivers/scsi/lpfc/lpfc_sli4.h                        |    2=20
 drivers/scsi/mpt2sas/mpt2sas_base.c                  |   19 +
 drivers/scsi/mpt2sas/mpt2sas_base.h                  |    3=20
 drivers/scsi/mpt2sas/mpt2sas_scsih.c                 |    3=20
 drivers/scsi/qla2xxx/qla_init.c                      |    3=20
 drivers/scsi/qla2xxx/qla_isr.c                       |    1=20
 drivers/tty/pty.c                                    |   17 +
 drivers/tty/serial/8250.c                            |    8=20
 drivers/tty/serial/8250_pci.c                        |    6=20
 drivers/tty/serial/8250_pnp.c                        |    3=20
 drivers/tty/serial/max3107-aava.c                    |    2=20
 drivers/tty/serial/max3107.c                         |    2=20
 drivers/tty/serial/mrst_max3110.c                    |    2=20
 drivers/tty/serial/omap-serial.c                     |    3=20
 drivers/tty/tty_io.c                                 |    3=20
 drivers/usb/host/ehci-hub.c                          |    7=20
 drivers/usb/host/ehci-s5p.c                          |    1=20
 drivers/usb/host/pci-quirks.c                        |   28 ++
 drivers/usb/host/xhci-hub.c                          |   19 +
 drivers/usb/host/xhci-ring.c                         |   90 ++++++---
 drivers/usb/host/xhci.c                              |   28 ++
 drivers/usb/musb/cppi_dma.c                          |   26 +-
 drivers/usb/serial/ftdi_sio.c                        |   20 +-
 drivers/usb/serial/option.c                          |  104 ++++++++++
 drivers/usb/serial/pl2303.c                          |   26 ++
 drivers/video/savage/savagefb.h                      |    2=20
 drivers/zorro/zorro.c                                |    7=20
 fs/9p/acl.c                                          |   22 +-
 fs/9p/acl.h                                          |    6=20
 fs/9p/cache.c                                        |   20 --
 fs/9p/cache.h                                        |    9=20
 fs/9p/v9fs.c                                         |   45 +++-
 fs/9p/v9fs.h                                         |   29 ++
 fs/9p/v9fs_vfs.h                                     |    6=20
 fs/9p/vfs_file.c                                     |   36 ++-
 fs/9p/vfs_inode.c                                    |  177 ++++++++++++--=
----
 fs/9p/vfs_inode_dotl.c                               |  162 +++++++++++++-=
--
 fs/9p/vfs_super.c                                    |    2=20
 fs/block_dev.c                                       |    7=20
 fs/btrfs/inode.c                                     |    5=20
 fs/cifs/cifssmb.c                                    |    3=20
 fs/cifs/connect.c                                    |    4=20
 fs/ext4/inode.c                                      |    4=20
 fs/fs-writeback.c                                    |   26 +-
 fs/namei.c                                           |    4=20
 fs/proc/task_mmu.c                                   |   80 +++++---
 include/linux/mfd/wm8994/pdata.h                     |    2=20
 include/linux/rio_regs.h                             |   18 -
 include/linux/rtc.h                                  |    3=20
 include/linux/tty.h                                  |    2=20
 include/linux/tty_driver.h                           |    3=20
 include/linux/writeback.h                            |    1=20
 include/net/9p/9p.h                                  |   29 ++
 ipc/mqueue.c                                         |  125 ++++++------
 kernel/irq/chip.c                                    |    2=20
 kernel/printk.c                                      |    2=20
 kernel/sched.c                                       |   41 ++--
 kernel/time/alarmtimer.c                             |   18 +
 kernel/workqueue.c                                   |    7=20
 lib/xz/xz_dec_bcj.c                                  |   27 ++
 mm/page-writeback.c                                  |    4=20
 mm/page_alloc.c                                      |   58 ++++-
 mm/vmalloc.c                                         |    8=20
 mm/vmscan.c                                          |   18 +
 net/8021q/vlan_core.c                                |    2=20
 net/9p/client.c                                      |   13 -
 net/9p/trans_virtio.c                                |   17 +
 net/atm/br2684.c                                     |    7=20
 net/bluetooth/hci_event.c                            |   17 -
 net/bridge/br_if.c                                   |    6=20
 net/bridge/br_multicast.c                            |   21 +-
 net/core/fib_rules.c                                 |    4=20
 net/core/neighbour.c                                 |    8=20
 net/core/scm.c                                       |    2=20
 net/ipv4/igmp.c                                      |    2=20
 net/ipv4/netfilter.c                                 |   18 -
 net/ipv4/route.c                                     |    8=20
 net/ipv4/syncookies.c                                |    2=20
 net/ipv4/tcp_input.c                                 |    2=20
 net/ipv6/ipv6_sockglue.c                             |    9=20
 net/ipv6/mcast.c                                     |    2=20
 net/ipv6/syncookies.c                                |    2=20
 net/mac80211/sta_info.c                              |    2=20
 net/sched/sch_prio.c                                 |    2=20
 net/socket.c                                         |   10 -
 net/wireless/nl80211.c                               |    5=20
 net/wireless/reg.c                                   |    1=20
 net/xfrm/xfrm_input.c                                |    5=20
 sound/core/pcm_lib.c                                 |   33 ++-
 sound/pci/fm801.c                                    |   15 +
 sound/pci/hda/patch_cirrus.c                         |    2=20
 sound/pci/hda/patch_realtek.c                        |   13 -
 sound/pci/hda/patch_sigmatel.c                       |    2=20
 sound/soc/blackfin/bf5xx-ad193x.c                    |    4=20
 sound/soc/codecs/ad193x.c                            |    3=20
 sound/soc/codecs/ad193x.h                            |    5=20
 sound/soc/codecs/ssm2602.c                           |    3=20
 sound/soc/fsl/mpc5200_dma.c                          |    6=20
 sound/soc/omap/omap-mcbsp.c                          |    6=20
 sound/soc/soc-jack.c                                 |    4=20
 sound/usb/card.c                                     |    7=20
 tools/perf/util/symbol.c                             |    2=20
 258 files changed, 3091 insertions(+), 1664 deletions(-)

Al Cooper (1):
      8250: Fix race condition in serial8250_backup_timeout().

Al Viro (2):
      9p: close ACL leaks
      restore pinning the victim dentry in vfs_rmdir()/vfs_rename_dir()

Alex Deucher (4):
      drm/radeon/kms: add s/r quirk for Compaq Presario V5245EU
      drm/radeon/kms: make sure pci max read request size is valid on everg=
reen+ (v2)
      drm/radeon/kms: Make GPU/CPU page size handling consistent in blit co=
de (v2)
      drm/radeon/kms: fix DDIA enable on some rs690 systems

Alexandre Bounine (1):
      rapidio: fix use of non-compatible registers

Alexey Khoroshilov (1):
      carl9170: Fix mismatch in carl9170_op_set_key mutex lock-unlock

Anand Gadiyar (1):
      mfd: Make omap-usb-host TLL mode work again

Andiry Xu (2):
      xHCI: fix port U3 status check condition
      xHCI: report USB2 port in resuming as suspend

Andrew Bird (3):
      USB option driver add PID of Huawei Vodafone K3806
      USB option driver add PID of Huawei Vodafone K4605
      USB option driver K3765/K4505 avoid CDC_DATA interface

Andrew Vasquez (1):
      qla2xxx: Correct inadvertent loop state transitions during port-updat=
e handling.

Andrey Vagin (1):
      x86, perf: Check that current->mm is alive before getting user callch=
ain

Aneesh Kumar K.V (8):
      fs/9p: Fid is not valid after a failed clunk.
      fs/9p: When doing inode lookup compare qid details and inode mode bit=
s.
      fs/9p: Always ask new inode in create
      fs/9p: Add fid before dentry instantiation
      fs/9p: Don't update file type when updating file attributes
      fs/9p: Add OS dependent open flags in 9p protocol
      net/9p: Fix kernel crash with msize 512K
      fs/9p: Always ask new inode in lookup for cache mode disabled

Anisse Astier (2):
      ehci: refactor pci quirk to use standard dmi_check_system method
      ehci: add pci quirk for Ordissimo and RM Slate 100 too

Anton Blanchard (4):
      ibmveth: Fix leak when recycling skb and hypervisor returns error
      ibmveth: Fix issue with DMA mapping failure
      ibmveth: Checksum offload is always disabled
      perf symbols: Fix ppc64 SEGV in dso__load_sym with debuginfo files

Arjan van de Ven (1):
      ALSA: pcm - fix race condition in wait_for_avail()

Arnaud Lacombe (1):
      usb/host/pci-quirks.c: correct annotation of `ehci_dmi_nohandoff_tabl=
e'

Axel Lin (3):
      ASoC: soc-jack: Fix checking return value of request_any_context_irq
      tty: Add "spi:" prefix for spi modalias
      regulator: tps65910: Add missing breaks in switch/case

Ben Hutchings (3):
      Revert "sfc: Use write-combining to reduce TX latency" and follow-ups
      ALSA: fm801: Fix double free in case of error in tuner detection
      ALSA: fm801: Gracefully handle failure of tuner auto-detect

Bhanu Prakash Gollapudi (2):
      bnx2fc: Fix kernel panic when deleting NPIV ports
      bnx2fc: scsi_dma_unmap() not invoked on IO completions

Bjorn Helgaas (1):
      serial: 8250_pnp: add Intermec CV60 touchscreen device

Brian King (1):
      ibmveth: Fix DMA unmap error

Carolyn Wyborny (1):
      igb: fix WOL on second port of i350 device

Carsten Emde (1):
      floppy: use del_timer_sync() in init cleanup

Dan Williams (3):
      isci: fix sata response handling
      isci: fix 32-bit operation when CONFIG_HIGHMEM64G=3Dn
      isci: fix event-get pointer increment

Daniel Baluta (1):
      ipv6: Fix ipv6_getsockopt for IPV6_2292PKTOPTIONS

Daniel Schwierzeck (1):
      atm: br2684: Fix oops due to skb->dev being NULL

Dave Airlie (1):
      drm/radeon/kms: set a default max_pixel_clock

Dave Hansen (3):
      make /proc/$pid/numa_maps gather_stats() take variable page size
      break out numa_maps gather_pte_stats() checks
      teach /proc/$pid/numa_maps about transparent hugepages

David Henningsson (3):
      ALSA: HDA: Cirrus - fix "Surround Speaker" volume control name
      ALSA: HDA: No power nids on 92HD93
      ALSA: HDA: Add support for IDT 92HD93

David S. Miller (3):
      sparc: Allow handling signals when stack is corrupted.
      sparc64: Set HAVE_C_RECORDMCOUNT
      sparc64: Only Panther cheetah+ chips have POPC.

David Vrabel (3):
      mm: sync vmalloc address space page tables in alloc_vm_area()
      xen: use maximum reservation to limit amount of usable RAM
      xen/e820: if there is no dom0_mem=3D, don't tweak extra_pages.

Dmitry Kravkov (1):
      bnx2x: fix hw attention handling

Don Fry (1):
      iwlagn: workaround bug crashing some APs

Eddie Wai (1):
      cnic: Randomize initial TCP port for iSCSI connections

Eric Dumazet (3):
      arp: fix rcu lockdep splat in arp_process()
      bridge: fix a possible net_device leak
      bridge: fix a possible use after free

Eric Smith (1):
      8250_pci: add support for Rosewill RC-305 4x serial port card

Eric Van Hensbergen (1):
      net/9p: fix client code to fail more gracefully on protocol error

Felix Fietkau (1):
      ath9k_hw: fix calibration on 5 ghz

Fenghua Yu (1):
      ACPICA: Do not repair _TSS return package if _PSS is present

Florian Mickler (1):
      vp7045: fix buffer setup

Florian Westphal (1):
      net_sched: prio: use qdisc_dequeue_peeked

Gao feng (1):
      fib:fix BUG_ON in fib_nl_newrule when add new fib rule

Gavin.zhu (1):
      USB: option: add YUGA device id to driver

Geert Uytterhoeven (2):
      genirq: Make irq_shutdown() symmetric vs. irq_startup again
      zorro: Defer device_register() until all devices have been identified

George (2):
      rtlwifi: rtl8192su: Fix problem connecting to HT-enabled AP
      rtlwifi: Fix problem when switching connections

Girish K S (1):
      mmc: sdhci-s3c: Fix mmc card I/O problem

Giuseppe Scrivano (1):
      cdc_ncm: fix endianness problem.

Greg Kroah-Hartman (1):
      Linux 3.0.5

Guenter Roeck (1):
      hwmon: (max16065) Fix current calculation

Hannes Reinecke (1):
      block: Free queue resources at blk_release_queue()

Hidetoshi Seto (1):
      btrfs: fix d_off in the first dirent

Ian Campbell (1):
      sparc: fix array bounds error setting up PCIC NMI trap

Igor Mammedov (1):
      xen: x86_32: do not enable iterrupts when returning from exception in=
 interrupt context

James Bottomley (1):
      3w-9xxx: fix iommu_iova leak

James Smart (5):
      lpfc 8.3.25: T10 DIF Fixes
      lpfc 8.3.25: Miscellaneous Bug fixes and code cleanup
      lpfc 8.3.25: Adapter Interface fixes and changes
      lpfc 8.3.25: Fabric and Target Discovery Fixes
      lpfc 8.3.25: PCI and SR-IOV Fixes

Jan Glauber (1):
      qdio: clear shared DSCI before scheduling the queue handler

Jarkko Nikula (1):
      ASoC: omap-mcbsp: Do not attempt to change DAI sysclk if stream is ac=
tive

Jarod Wilson (1):
      nuvoton-cir: simplify raw IR sample handling

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add Calao reference board support

Jeff Kirsher (1):
      e1000: Fix driver to be used on PA RISC C8000 workstations

Jeff Layton (1):
      cifs: fix possible memory corruption in CIFSFindNext

Jeff Skirvin (1):
      isci: Leave requests alone if already terminating.

Jerome Glisse (1):
      drm/radeon/kms: evergreen & ni reset SPI block on CP resume

Jesse Brandeburg (1):
      ixgbe: fix possible null buffer error

Jim Garlick (1):
      fs/9p: Use protocol-defined value for lock/getlock 'type' field.

Jiri Pirko (1):
      vlan: reset headers on accel emulation path

Jiri Slaby (3):
      TTY: pty, fix pty counting
      ipc/mqueue.c: refactor failure handling
      ipc/mqueue.c: fix mq_open() return value

Joerg Roedel (2):
      iommu/amd: Don't take domain->lock recursivly
      iommu/amd: Make sure iommu->need_sync contains correct value

Johan Hovold (2):
      mfd: Fix initialisation of tps65910 interrupts
      drivers/leds/ledtrig-timer.c: fix broken sysfs delay handling

Johannes Berg (3):
      mac80211: fix missing sta_lock in __sta_info_destroy
      iwlagn: fix command queue timeout
      iwlagn: fix dangling scan request

John Stanley (1):
      savagedb: Fix typo causing regression in savage4 series video chip de=
tection

John Stultz (4):
      alarmtimers: Avoid possible null pointer traversal
      alarmtimers: Memset itimerspec passed into alarm_timer_get
      alarmtimers: Avoid possible denial of service with high freq periodic=
 timers
      rtc: Fix RTC PIE frequency limit

Jouni Malinen (1):
      cfg80211: Fix validation of AKM suites

Julian Anastasov (2):
      ipv4: some rt_iif -> rt_route_iif conversions
      netfilter: TCP and raw fix for ip_route_me_harder

KAMEZAWA Hiroyuki (1):
      memcg: fix vmscan count in small memcgs

Kashyap, Desai (2):
      mpt2sas: Added DID_NO_CONNECT return when driver remove and avoid shu=
tdown call
      mpt2sas: Adding support for customer specific branding

Kiran Patil (2):
      libfc: Enhancement to RPORT state machine applicable only for VN2VN m=
ode
      fcoe: Unable to select the exchangeID from offload pool for storage t=
argets

Kjetil Oftedal (1):
      sparc32,sun4d: Change IPI IRQ level to prevent collision between IPI =
and timer interrupt

Konrad Rzeszutek Wilk (1):
      xen/smp: Warn user why they keel over - nosmp or noapic and what to u=
se instead.

Larry Finger (3):
      rt2800pci: Fix compiler error on PowerPC
      rtl2800usb: Fix incorrect storage of MAC address on big-endian platfo=
rms
      rtlwifi: rtl8192cu: Fix unitialized struct

Lars-Peter Clausen (2):
      ASoC: Blackfin: bf5xx-ad193x: Fix codec device name
      ASoC: ssm2602: Re-enable oscillator after suspend

Lasse Collin (1):
      XZ: Fix incorrect XZ_BUF_ERROR

Len Brown (1):
      acpica: ACPI_MAX_SLEEP should be 2 sec, not 20

Linus Torvalds (1):
      firmware loader: allow builtin firmware load even if usermodehelper i=
s disabled

Linus Walleij (2):
      ARM: 7081/1: mach-integrator: fix the clocksource
      ARM: davinci: fix cache flush build error

Liu Gang-B34182 (1):
      arch/powerpc/sysdev/fsl_rio.c: correct IECSR register clear value

Manual Munz (1):
      b43: Fix beacon problem in ad-hoc mode

Marcin Slusarz (1):
      drm/nouveau: properly handle allocation failure in nouveau_sgdma_popu=
late

Marcin Tomczak (1):
      isci: change sas phy timeouts from 54us to 59us

Marek Vasut (1):
      ASIX: Add AX88772B USB ID

Mark Brown (2):
      ASoC: Fix reporting of partial jack updates
      mfd: Fix value of WM8994_CONFIGURE_GPIO

Mark Salyzyn (1):
      libsas: fix failure to revalidate domain for anything but the first e=
xpander child.

Mathieu Desnoyers (1):
      sendmmsg/sendmsg: fix unsafe user pointer access

Matt Carlson (3):
      tg3: Fix io failures after chip reset
      tg3: Add 5719 and 5720 to EEE_CAP list
      tg3: Fix int selftest for recent devices.

Mel Gorman (2):
      mm: page allocator: initialise ZLC for first zone eligible for zone_r=
eclaim
      mm: page allocator: reconsider zones for allocation after direct recl=
aim

Michael Chan (4):
      cnic: Fix interrupt logic
      cnic: Fix race conditions with firmware
      cnic: Improve NETDEV_UP event handling
      cnic, bnx2: Check iSCSI support early in bnx2_init_one()

Michal Sroczynski (1):
      USB: PL2303: correctly handle baudrates above 115200

Michel D=E4nzer (1):
      drm/radeon: Don't read from CP ring write pointer registers.

Mika Westerberg (3):
      mmc: rename mmc_host_clk_{ungate|gate} to mmc_host_clk_{hold|release}
      mmc: core: prevent aggressive clock gating racing with ios updates
      mmc: core: use non-reentrant workqueue for clock gating

Mikael Pettersson (2):
      sparc64: remove unnecessary macros from spinlock_64.h
      sparc32: unbreak arch_write_unlock()

Mike Christie (2):
      iscsi_tcp: fix locking around iscsi sk user data
      libiscsi_tcp: fix LLD data allocation

Mike Waychison (1):
      tcp: initialize variable ecn_ok in syncookies path

Ming Lei (1):
      firewire: ohci: add no MSI quirk for O2Micro controller

Mohammed Shafi Shajakhan (1):
      ath9k: Fix PS wrappers in ath9k_set_coverage_class

Naga Chumbalkar (1):
      drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer dereference

Neil Horman (1):
      cxgb3i: convert cdev->l2opt to use rcu to prevent NULL dereference

NeilBrown (3):
      md/linear: avoid corrupting structure while waiting for rcu_free to c=
omplete.
      Avoid dereferencing a 'request_queue' after last close.
      md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.

Nick Pelly (1):
      omap-serial: Allow IXON and IXOFF to be disabled.

Nicolas Pitre (1):
      ARM: Dove: fix second SPI initialization call

Nishanth Aravamudan (1):
      kernel/printk: do not turn off bootconsole in printk_late_init() if k=
eep_bootcon

Oliver Neukum (1):
      Bluetooth: Fix timeout on scanning for the second time

Per Forlin (1):
      usb: musb: cppi: fix build errors due to DBG and missing musb variable

Peter Huewe (2):
      TPM: Call tpm_transmit with correct size
      TPM: Zero buffer after copying to userspace

Prem Karat (1):
      fs/9p: Fix invalid mount options/args

Rajkumar Manoharan (2):
      wireless: Reset beacon_found while updating regulatory
      ath9k_hw: Fix Rx DMA stuck for AR9003 chips

Randy Dunlap (2):
      irda: fix smsc-ircc2 section mismatch warning
      scsi: qla4xxx needs libiscsi.o

Roland Stigge (1):
      hwmon: (ds620) Fix handling of negative temperatures

Russell King (1):
      ARM: dma-mapping: free allocated page if unable to map

Sarah Sharp (5):
      xhci: Fix memory leak during failed enqueue.
      xhci: Fix failed enqueue in the middle of isoch TD.
      xhci: Remove TDs from TD lists when URBs are canceled.
      xhci: Handle zero-length isochronous packets.
      USB: xhci: Set change bit when warm reset change is set.

Scott Jiang (2):
      ASoC: ad193x: fix registers definition
      ASoC: ad193x: fix dac word len setting

Senthil Balasubramanian (1):
      ath9k_hw: Fix STA (AR9485) bringup issue due to incorrect MAC address

Seth Heasley (1):
      ahci: RAID-mode SATA patch for Intel Panther Point DeviceIDs

Shmulik Ravid (1):
      bnx2x: add missing break in bnx2x_dcbnl_get_cap

Srinivas Kandagatla (1):
      ARM: 7014/1: cache-l2x0: Fix L2 Cache size calculation.

Stanislaw Gruszka (6):
      rt2x00: do not drop usb dev reference counter on suspend
      rt2x00: fix crash in rt2800usb_write_tx_desc
      rt2x00: fix crash in rt2800usb_get_txwi
      iwlegacy: fix BUG_ON(info->control.rates[0].idx < 0)
      iwlegacy: fix command queue timeout
      iwlegacy: do not use interruptible waits

Steffen Klassert (1):
      xfrm: Perform a replay check after return from async codepaths

Stephen M. Cameron (2):
      hpsa: fix problem that OBDR devices are not detected
      hpsa: fix physical device lun and target numbering problem

Steve French (1):
      Fix the conflict between rwpidforward and rw mount options

Sudhakar Rajashekhara (1):
      ARM: davinci: da850 EVM: read mac address from SPI flash

Takashi Iwai (2):
      ALSA: hda/realtek - Fix auto-mute with HP+LO configuration
      ALSA: hda/realtek - Avoid bogus HP-pin assignment

Tejun Heo (1):
      pata_via: disable ATAPI DMA on AVERATEC 3200

Thomas Gleixner (3):
      sched: Separate the scheduler entry for preemption
      sched: Move blk_schedule_flush_plug() out of __schedule()
      x86, iommu: Mark DMAR IRQ as non-threaded

Thomas Pfaff (2):
      ALSA: usb-audio - clear chip->probing on error exit
      ALSA: usb-audio: Check for possible chip NULL pointer before clearing=
 probing flag

Thomas Tuttle (1):
      workqueue: lock cwq access in drain_workqueue

Tim Chen (1):
      scm: Capture the full credentials of the scm sender

Timur Tabi (1):
      ASoC: MPC5200: replace of_device with platform_device

Troy Kisky (1):
      MXC: iomux-v3: correct NO_PAD_CTRL definition

Vasily Averin (1):
      aacraid: reset should disable MSI interrupt

Venkateswararao Jujjuri (JV) (1):
      net/9p: Fix the msize calculation.

WANG Cong (1):
      sched: Fix a memory leak in __sdt_free()

Wang Zhi (1):
      USB: EHCI: Do not rely on PORT_SUSPEND to stop USB resuming in ehci_b=
us_resume().

Wanlong Gao (1):
      blk-cgroup: be able to remove the record of unplugged device

Will Deacon (2):
      ARM: 7091/1: errata: D-cache line maintenance operation by MVA may no=
t succeed
      ARM: 7099/1: futex: preserve oldval in SMP __futex_atomic_op

Wu Fengguang (2):
      writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync sta=
ge
      writeback: update dirtied_when for synced inode to prevent livelock

Yan, Zheng (2):
      mcast: Fix source address selection for multicast listener report
      bridge: Pseudo-header required for the checksum of ICMPv6

Youquan Song (1):
      perf, x86: Add model 45 SandyBridge support

Yulgon Kim (1):
      usb: s5p-ehci: fix a NULL pointer deference

Zheng Yan (1):
      tcp: fix validation of D-SACK

jvrao (2):
      Fix the size of receive buffer packing onto VirtIO ring.
      VirtIO can transfer VIRTQUEUE_NUM of pages.


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOihvxAAoJEDjbvchgkmk+K5oP+QFIRPhVIOwMVvwh5VzVQiua
ywhK0H6CvIlijYgwMaAk7K3ihZFaWnISA7h1laYK8tmRI/7ELD4qOgYMSsHG5CW2
WaUGOGu8/CkyCzwLQFUBbbqh6wffAMplnoFE157L7l6Xvw3T3+if1MmbHuHVZ7X7
gjHyfHOAu0VFga302OAwjcqdD+adQWLxyB9YsKh5PhfaptPqzAt/I3m8URfK9uAO
UZ+IfRJrECWN9507wlTeJ77ePPTQWGf+mQZntHLTD5ft6Hda8227z8wCmTG9lBTD
STy2MFXTdqhrBMb/wAOoNZkcK33smRRP6QQmqnj1tcSF+kok5VqUc1WyrPM/NOQB
ASQeMl/ibCa6hWNzIldaiiTCZ4bo2JkzYQ+8gnYxOzT5ay/kuLgEWNZbbAxGD2al
wQmImmh6Ls7uYjhk7tPD55MFJWe7Ner1hyR4QL9bGnqT3+/H849+Xy0Hg96Po0Ff
gf9uSqkr3JRk76cJjtYj/SSVl9/ki6RzytTGKXwRhs3zZQeSfnYOSoE6PBvW2B34
ehstdgtYYueL9lwjAudHtkrRSnjpaCRe2mxTqSuyicT2VjI1mB28dBmieZl34e+H
Qyh9+6lKD9uNe2a73lVptcEvD3JeJusCOlgD499SN7M3n4YidefWn+Z5C/in2Iov
D2aCao6CAn/3rfya0ASO
=n5L1
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
