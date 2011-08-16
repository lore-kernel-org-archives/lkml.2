Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1HPBzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 21:55:33 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50823 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab1HPBzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 21:55:32 -0400
X-Sasl-enc: LU4Uta0dztd/nxPF7vZkDXQk5DW9gcAgs1BHLFVy30k0 1313459731
Date: Mon, 15 Aug 2011 18:54:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.2
Message-ID: <20110816015447.GA28885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.0.2 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-3.0.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-3.0.y.git;a=summary

thanks,

greg k-h

------------


 Makefile                                        |    2 
 arch/cris/arch-v10/drivers/sync_serial.c        |    6 
 arch/cris/arch-v10/kernel/irq.c                 |    3 
 arch/cris/include/asm/thread_info.h             |    6 
 arch/parisc/include/asm/atomic.h                |    4 
 arch/parisc/include/asm/futex.h                 |   66 ++++
 arch/parisc/include/asm/unistd.h                |    3 
 arch/parisc/kernel/syscall_table.S              |    1 
 arch/powerpc/kernel/prom_init.c                 |    6 
 arch/powerpc/platforms/pseries/dtl.c            |    2 
 arch/powerpc/platforms/pseries/kexec.c          |   11 
 arch/powerpc/platforms/pseries/lpar.c           |    2 
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    4 
 arch/sparc/include/asm/bitops_64.h              |   49 ---
 arch/sparc/include/asm/elf_64.h                 |   63 ++--
 arch/sparc/include/asm/hypervisor.h             |   14 +
 arch/sparc/include/asm/spitfire.h               |    1 
 arch/sparc/include/asm/tsb.h                    |   51 +--
 arch/sparc/include/asm/xor_64.h                 |    3 
 arch/sparc/kernel/cpu.c                         |    8 
 arch/sparc/kernel/cpumap.c                      |    1 
 arch/sparc/kernel/ds.c                          |   31 ++
 arch/sparc/kernel/entry.h                       |   14 +
 arch/sparc/kernel/head_64.S                     |   33 ++
 arch/sparc/kernel/hvapi.c                       |    7 
 arch/sparc/kernel/hvcalls.S                     |    7 
 arch/sparc/kernel/kernel.h                      |   15 +
 arch/sparc/kernel/ktlb.S                        |   24 -
 arch/sparc/kernel/mdesc.c                       |   30 +-
 arch/sparc/kernel/pcr.c                         |   11 
 arch/sparc/kernel/perf_event.c                  |    3 
 arch/sparc/kernel/setup_64.c                    |  186 +++++++++++++
 arch/sparc/kernel/sparc_ksyms_64.c              |   11 
 arch/sparc/kernel/sstate.c                      |    9 
 arch/sparc/kernel/unaligned_64.c                |   15 -
 arch/sparc/kernel/vmlinux.lds.S                 |   21 +
 arch/sparc/lib/Makefile                         |    4 
 arch/sparc/lib/NG2page.S                        |   61 ----
 arch/sparc/lib/NGpage.S                         |  114 +++++---
 arch/sparc/lib/ffs.S                            |   84 ++++++
 arch/sparc/lib/hweight.S                        |   51 +++
 arch/sparc/mm/init_64.c                         |   42 ++-
 arch/x86/xen/Makefile                           |    2 
 arch/x86/xen/enlighten.c                        |    8 
 arch/x86/xen/vga.c                              |   67 ++++
 arch/x86/xen/xen-ops.h                          |   11 
 crypto/md5.c                                    |   92 ------
 drivers/char/random.c                           |  334 ------------------------
 drivers/gpu/drm/drm_edid.c                      |   24 +
 drivers/gpu/drm/i915/i915_dma.c                 |    6 
 drivers/gpu/drm/i915/i915_irq.c                 |    3 
 drivers/gpu/drm/i915/intel_display.c            |    8 
 drivers/gpu/drm/i915/intel_panel.c              |    4 
 drivers/gpu/drm/i915/intel_ringbuffer.c         |    3 
 drivers/gpu/drm/radeon/radeon_connectors.c      |   54 +++
 drivers/gpu/drm/radeon/radeon_device.c          |    5 
 drivers/gpu/drm/radeon/radeon_display.c         |    9 
 drivers/gpu/drm/radeon/radeon_i2c.c             |   32 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |    6 
 drivers/isdn/i4l/isdn_net.c                     |    3 
 drivers/net/Makefile                            |    1 
 drivers/net/bonding/bond_main.c                 |    6 
 drivers/net/bonding/bond_sysfs.c                |  133 +++++----
 drivers/net/e1000e/lib.c                        |    3 
 drivers/net/gianfar_ptp.c                       |    9 
 drivers/net/ifb.c                               |    2 
 drivers/net/macvlan.c                           |    2 
 drivers/net/niu.c                               |    4 
 drivers/net/phy/dp83640.c                       |    5 
 drivers/net/r8169.c                             |    1 
 drivers/net/sis190.c                            |   12 
 drivers/net/tun.c                               |    1 
 drivers/net/veth.c                              |    2 
 drivers/net/wan/hdlc_fr.c                       |    5 
 drivers/net/wireless/airo.c                     |    1 
 drivers/net/wireless/ath/ath9k/ar9002_hw.c      |    6 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c  |    6 
 drivers/net/wireless/ath/ath9k/ar9003_hw.c      |    6 
 drivers/net/wireless/ath/ath9k/ar9003_phy.h     |    2 
 drivers/net/wireless/ath/ath9k/hw.c             |   11 
 drivers/net/wireless/ath/ath9k/hw.h             |    3 
 drivers/net/wireless/ath/ath9k/init.c           |    2 
 drivers/net/wireless/ath/ath9k/pci.c            |   27 +
 drivers/net/wireless/hostap/hostap_main.c       |    1 
 drivers/net/wireless/iwlegacy/iwl-3945.c        |    6 
 drivers/net/wireless/iwlegacy/iwl-4965.c        |    8 
 drivers/net/wireless/iwlwifi/iwl-5000.c         |    1 
 drivers/net/wireless/iwlwifi/iwl-core.h         |    2 
 drivers/net/wireless/iwlwifi/iwl-power.c        |    3 
 drivers/net/wireless/rt2x00/rt2800lib.c         |    3 
 drivers/net/wireless/rt2x00/rt2x00mac.c         |    5 
 drivers/net/wireless/rtlwifi/pci.c              |   20 -
 drivers/platform/x86/asus-wmi.c                 |   17 -
 drivers/scsi/mpt2sas/mpt2sas_base.c             |   65 +---
 drivers/scsi/mpt2sas/mpt2sas_base.h             |   53 +++
 drivers/scsi/mpt2sas/mpt2sas_ctl.c              |   10 
 drivers/scsi/mpt2sas/mpt2sas_debug.h            |    2 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c            |   12 
 drivers/scsi/mpt2sas/mpt2sas_transport.c        |   24 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c    |    1 
 fs/cifs/cifsfs.c                                |    4 
 fs/cifs/inode.c                                 |   14 -
 fs/cifs/transport.c                             |    2 
 fs/ecryptfs/main.c                              |   23 +
 fs/ecryptfs/read_write.c                        |   18 -
 fs/ext3/namei.c                                 |    6 
 fs/ext4/namei.c                                 |    6 
 include/drm/drm_crtc.h                          |    1 
 include/drm/i915_drm.h                          |    2 
 include/linux/cryptohash.h                      |    5 
 include/linux/if.h                              |    2 
 include/linux/mm.h                              |   12 
 include/linux/random.h                          |   11 
 include/net/ipv6.h                              |   12 
 include/net/secure_seq.h                        |   20 +
 include/net/transp_v6.h                         |    2 
 include/xen/interface/xen.h                     |   39 ++
 kernel/futex.c                                  |   54 +++
 lib/Makefile                                    |    2 
 lib/md5.c                                       |   95 ++++++
 net/8021q/vlan_dev.c                            |    2 
 net/bluetooth/bnep/netdev.c                     |    1 
 net/core/Makefile                               |    2 
 net/core/link_watch.c                           |    2 
 net/core/pktgen.c                               |    8 
 net/core/secure_seq.c                           |  184 +++++++++++++
 net/dccp/ipv4.c                                 |    1 
 net/dccp/ipv6.c                                 |    9 
 net/ethernet/eth.c                              |    1 
 net/ipv4/devinet.c                              |   16 -
 net/ipv4/gre.c                                  |   21 -
 net/ipv4/icmp.c                                 |   14 -
 net/ipv4/igmp.c                                 |    2 
 net/ipv4/inet_hashtables.c                      |    1 
 net/ipv4/inetpeer.c                             |    1 
 net/ipv4/ip_output.c                            |    6 
 net/ipv4/ipmr.c                                 |    2 
 net/ipv4/netfilter/nf_nat_proto_common.c        |    1 
 net/ipv4/route.c                                |    6 
 net/ipv4/tcp_ipv4.c                             |    1 
 net/ipv6/af_inet6.c                             |    2 
 net/ipv6/inet6_hashtables.c                     |    1 
 net/ipv6/ip6_output.c                           |   40 ++
 net/ipv6/tcp_ipv6.c                             |    1 
 net/ipv6/udp.c                                  |    2 
 net/l2tp/l2tp_eth.c                             |    2 
 net/mac80211/iface.c                            |    1 
 net/netfilter/ipvs/ip_vs_ctl.c                  |    1 
 net/sched/sch_sfq.c                             |    7 
 net/socket.c                                    |   73 ++---
 net/xfrm/xfrm_algo.c                            |    4 
 sound/core/timer.c                              |    2 
 sound/soc/codecs/sgtl5000.c                     |  128 ++-------
 sound/usb/caiaq/input.c                         |    2 
 sound/usb/endpoint.c                            |    2 
 sound/usb/mixer.c                               |   25 -
 sound/usb/mixer.h                               |    1 
 157 files changed, 1966 insertions(+), 1172 deletions(-)


Adam Jackson (1):
      drm/i915/pch: Fix integer math bugs in panel fitting

Alex Hacker (1):
      ath9k: fix a misprint which leads to incorrect calibration

Andy Gospodarek (1):
      bonding: fix string comparison errors

Anton Blanchard (5):
      net: sendmmsg should only return an error if no messages were sent
      net: Cap number of elements for sendmmsg
      powerpc/pseries: Fix kexec on recent firmware versions
      powerpc: Fix device tree claim code
      powerpc: pseries: Fix kexec on machines with more than 4TB of RAM

Bill Sommerfeld (1):
      ipv4: Constrain UFO fragment sizes to multiples of 8 bytes

Bruce Allan (1):
      e1000e: alternate MAC address does not work on device id 0x1060

Carlos O'Donell (1):
      Fix futex support

Chris Clayton (1):
      Fix cdc-phonet build

Clemens Ladisch (1):
      ALSA: snd-usb: Accept UAC2 FORMAT_TYPE descriptors with bLength > 6

Corentin Chary (2):
      asus-wmi: fix hwmon/pwm1
      asus-wmi: return proper value in store_cpufv()

Daniel Mack (2):
      ALSA: snd-usb-caiaq: Fix keymap for RigKontrol3
      ALSA: snd-usb: operate on given mixer interface only

David S. Miller (18):
      crypto: Move md5_transform to lib/md5.c
      net: Compute protocol sequence numbers and fragment IDs using MD5.
      icmp: Fix regression in nexthop resolution during replies.
      sparc: Don't leave sparc_pmu_type NULL on sun4v.
      sparc: Add T3 sun4v cpu type and hypervisor group defines.
      sparc: Don't do expensive hypervisor PCR write unless necessary.
      sparc: Detect and handle UltraSPARC-T3 cpu types.
      sparc: Sanitize cpu feature detection and reporting.
      sparc: Minor tweaks to Niagara page copy/clear.
      sparc: Use popc if possible for hweight routines.
      sparc: Use hweight64() in popc emulation.
      sparc: Add some missing hypervisor API groups.
      sparc: Set reboot-cmd using reboot data hypervisor call if available.
      sparc: Use popc when possible for ffs/__ffs/ffz.
      sparc: Access kernel TSB using physical addressing when possible.
      sparc: Size mondo queues more sanely.
      sparc: Fix build with DEBUG_PAGEALLOC enabled.
      sparc: Don't do hypervisor calls on non-sun4v in DS driver.

Eric Dumazet (2):
      ipv6: make fragment identifications less predictable
      sch_sfq: fix sfq_enqueue()

Eric Sandeen (2):
      ext3: Properly count journal credits for long symlinks
      ext4: Properly count journal credits for long symlinks

Felix Fietkau (1):
      ath9k: initialize tx chainmask before testing channel tx power values

Greg Kroah-Hartman (1):
      Linux 3.0.2

James Bottomley (1):
      wire up sendmmsg syscall

Jeff Layton (2):
      cifs: cope with negative dentries in cifs_get_root
      cifs: convert prefixpath delimiters in cifs_build_path_to_root

Jeremy Fitzhardinge (1):
      xen: allow enable use of VGA console on dom0

Jesse Barnes (1):
      drm/i915: load the LUT before pipe enable on ILK+

John David Anglin (1):
      fix return type of __atomic64_add_return

John Johansen (1):
      Ecryptfs: Add mount option to check uid of device being mounted = expect uid

Julia Lawall (2):
      net: adjust array index
      drivers/net/niu.c: adjust array index

Julian Anastasov (2):
      ipv4: fix the reusing of routing cache entries
      ipv4: use RT_TOS after some rt_tos conversions

Kashyap, Desai (1):
      mpt2sas: Fixed Big Indian Issues on 32 bit PPC

Keith Packard (3):
      drm/i915: Initialize RCS ring status page address in intel_render_ring_init_dri
      drm/i915: Hold mode_config->mutex during hotplug processing
      drm/i915: Fixup for 'Hold mode_config->mutex during hotplug'

Klement Fish (1):
      sis190: Rx filter init is needed for MAC address change.

Larry Finger (1):
      rtlwifi: Fix kernel oops on ARM SOC

Lennart Sorensen (1):
      r8169: Add support for D-Link 530T rev C1 (Kernel Bug 38862)

Neil Horman (2):
      net: add IFF_SKB_TX_SHARED flag to priv_flags
      net: Audit drivers to identify those needing IFF_TX_SKB_SHARING cleared

Nicolai Krakowiak (1):
      ALSA: snd-usb: avoid dividing by zero on invalid input

Ole Henrik Jahren (1):
      drm/i915: Fix typo in DRM_I915_OVERLAY_PUT_IMAGE ioctl define

Pavel Shilovsky (1):
      CIFS: Fix missing a decrement of inFlight value

Peter Zijlstra (1):
      mm: Fix fixup_user_fault() for MMU=n

Rajkumar Manoharan (1):
      ath9k_hw: Fix incorrect Tx control power in AR9003 template

Richard Cochran (2):
      gianfar: fix fiper alignment after resetting the time
      dp83640: increase receive time stamp buffer size

Shawn Bohrer (1):
      futex: Fix regression with read only mappings

Simon Horman (1):
      IPVS: Free resources on module removal

Stanislaw Gruszka (4):
      rt2x00: rt2800: fix zeroing skb structure
      rt2x00: fix usage of NULL queue
      iwlegacy: set tx power after rxon_assoc
      ath9k: skip ->config_pci_powersave() if PCIe port has ASPM disabled

Takashi Iwai (1):
      ALSA: timer - Fix Oops at closing slave timer

Tetsuo Handa (1):
      net: Fix security_socket_sendmsg() bypass problem.

Thomas Reim (4):
      drm: Separate EDID Header Check from EDID Block Check
      drm/radeon: Extended DDC Probing for Connectors with Improperly Wired DDC Lines (here: Asus M2A-VM HDMI)
      drm/radeon: Extended DDC Probing for ECS A740GM-M DVI-D Connector
      drm/radeon: Log Subsystem Vendor and Device Information

Tushar Gohad (1):
      xfrm: Fix key lengths for rfc3686(ctr(aes))

Tyler Hicks (1):
      eCryptfs: Return error when lower file pointer is NULL

WANG Cong (4):
      cris: fix a build error in kernel/fork.c
      cris: fix a build error in sync_serial_open()
      cris: fix the prototype of sync_serial_ioctl()
      cris: add missing declaration of kgdb_init() and breakpoint()

Wey-Yi Guy (1):
      iwlagn: 5000 do not support idle mode

Wolfram Sang (1):
      ASoC: sgtl5000: fix cache handling

Zoltan Kiss (1):
      IPv4: Send gratuitous ARP for secondary IP addresses also

stephen hemminger (1):
      net: allow netif_carrier to be called safely from IRQ

xeb@mail.ru (1):
      gre: fix improper error handling

