Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab2KDTn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 14:43:59 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34516 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2KDTnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 14:43:55 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 Nov 2012 11:43:33 -0800
X-Google-Sender-Auth: RSjV66f1G2y4U7ULdaFN6q5JLmk
Message-ID: <CA+55aFxGm+2-OiVL1JRYH12BZiMBjiaST+9jrQCtHeU-iVvmyA@mail.gmail.com>
Subject: Linux 3.7-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a pretty calm week, so here's a nice small -rc for you guys.

Rafael worried me for a while with what looked like a hard-to-debug
regression report, but it turned out to be user-space breakage
instead, so things are looking pretty stable. Things also look
entirely normal: most of the changes here are various device driver
issues, with a small smattering of other stuff (nfs client update,
some minor arch updates, and some networking stuff).

The driver fixes are pretty much all over - sound, gpu, HID and input,
i2c, networking ..

Perhaps notable just because of the noise it caused in certain
circles, there's the ext4 bitmap journaling fix for the issue that
caused such a ruckus. It's a tiny patch and despite all the noise
about it you couldn't actually trigger the problem unless you were
doing crazy things with special mount options.

Other things? Nothing really stands out. The appended shortlog gives a
reasonable view into the kinds of details people have been working on.
I'll be traveling the upcoming week, but I expect to have reasonable
access to wifi, and if it stays this quiet and calm, nobody will even
notice.

Go forth and test,

                Linus

---

Akinobu Mita (1):
      cciss: select CONFIG_CHECK_SIGNATURE

Al Viro (3):
      Return the right error value when dup[23]() newfd argument is too large
      frv: switch to saner kernel_execve() semantics
      frv: fix the broken preempt

Alan Cox (1):
      HID: multitouch: put the case in the right switch statement

Alex Deucher (1):
      drm/radeon: add load detection support for ext DAC on R200 (v2)

Alex Elder (1):
      rbd: reset BACKOFF if unable to re-queue

Andreas Herrmann (2):
      hwmon, fam15h_power: Change email address, MAINTAINERS entry
      cpufreq / powernow-k8: Change maintainer's email address

Andrew Lunn (1):
      GPIO: mvebu-gpio: Don't initialize the mask_cache

Anna Leuschner (1):
      vfs: fix: don't increase bio_slab_max if krealloc() fails

Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN

Ben Hutchings (1):
      nfs: Show original device name verbatim in /proc/*/mount{s,info}

Ben Skeggs (6):
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets
      drm/nouveau/i2c: fix typo when checking nvio i2c port validity
      drm/nouveau: allow creation of zero-sized mm
      drm/nv50/fb: prevent oops on chipsets without compression tags
      drm/nouveau: resurrect headless mode since rework
      drm/nouveau: headless mode by default if pci class != vga display

Bernhard Kohl (1):
      target: reintroduce some obsolete SCSI-2 commands

Bryan Schumaker (1):
      NFS: Wait for session recovery to finish before returning

Chris Wilson (1):
      drm/i915: Only kick out vesafb if we takeover the fbcon with KMS

Chris Zankel (3):
      xtensa: allow multi-inclusion for uapi/unistd.h
      xtensa: use physical addresses for bus addresses
      xtensa: reset windowbase/windowstart when cloning the VM

Dan Carpenter (1):
      gpio-timberdale: fix a potential wrapping issue

Daniel Vetter (3):
      drm/i915: fix overlay on i830M
      drm/i915: VGA needs to be on pipe A on i830M
      drm/i915: clear the entire sdvo infoframe buffer

Dave Airlie (1):
      drm/udl: fix stride issues scanning out stride != width*bpp

Dave Chinner (1):
      loop: Make explicit loop device destruction lazy

David Howells (6):
      UAPI: (Scripted) Disintegrate include/linux/raid
      FRV: Add missing linux/export.h #inclusions
      FRV: Don't objcopy the GNU build_id note
      FRV: gcc-4.1.2 also inlines weak functions
      FRV: Fix the preemption handling
      FRV: Fix the new-style kernel_thread() stuff

David Vrabel (3):
      xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF
      xen-fbfront: handle backend CLOSED without CLOSING
      xen-kbdfront: handle backend CLOSED without CLOSING

David Zafman (1):
      ceph: fix dentry reference leak in encode_fh()

Devendra Naga (1):
      thermal: solve compilation errors in rcar_thermal

Dirk Hohndel (1):
      HID: Add support for the MacBook Pro 10,2 keyboard / touchpad

Dmitry Kravkov (2):
      bnx2x: Disable FCoE for 57840 since not yet supported by FW
      bnx2x: fix HW initialization using fw 7.8.x

Egbert Eich (6):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.
      DRM/Radeon: Fix primary DAC Load Detection for RV100 chips.
      DRM/Radeon: On DVI-I use Load Detection when EDID is bogus.
      DRM/Radeon: Clean up code in TV DAC load detection.
      DRM/Radeon: Fix TV DAC Load Detection for single CRTC chips.
      DRM/radeon: For single CRTC GPUs move handling of CRTC_CRT_ON to
crtc_dpms().

Eric Dumazet (1):
      vmxnet3: must split too big fragments

Eric Sandeen (2):
      md faulty: use disk_stack_limits()
      ext4: fix unjournaled inode bitmap modification

Felix Fietkau (3):
      cfg80211: fix antenna gain handling
      cfg80211: fix initialization of chan->max_reg_power
      ath9k: fix stale pointers potentially causing access to free'd skbs

Gustavo Maciel Dias Vieira (1):
      ALSA: hda - Fix mute-LED setup for HP dv5 laptop

Hein Tibosch (1):
      netfilter: nf_defrag_ipv6: solve section mismatch in nf_conntrack_reasm

Herton Ronaldo Krzesinski (5):
      floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
      floppy: do put_disk on current dr if blk_init_queue fails
      floppy: properly handle failure on add_disk loop
      floppy: use common function to check if floppies can be registered
      floppy: remove dr, reuse drive on do_floppy_init

Hui Wang (1):
      Input: egalax_ts - get gpio from devicetree

Igor Murzov (2):
      drm/radeon: fix ATPX function documentation
      ACPI video: Ignore errors after _DOD evaluation.

Inki Dae (2):
      drm/exynos: fix display on issue
      MAINTAINERS: Add git repository for Exynos DRM

Jacob Keller (1):
      ixgbe: PTP get_ts_info missing software support

Jamie Lentin (1):
      hwmon: Only include of_match_table with CONFIG_OF_GPIO

Jan Beulich (1):
      xen/xenbus: fix overflow check in xenbus_file_write()

Jani Nikula (1):
      drm/i915: be less verbose about inability to provide vendor backlight

Jason Gerecke (2):
      Input: wacom - add INPUT_PROP_DIRECT flag to Cintiq 24HD
      Input: wacom - correct bad Cintiq 24HD check

Javier Cardona (3):
      mac80211: Only process mesh config header on frames that RA_MATCH
      mac80211: Don't drop frames received with mesh ttl == 1
      mac80211: don't inspect Sequence Control field on control frames

Jean Delvare (3):
      i2c-stub: Move to drivers/i2c
      i2c-i801: Simplify dependency towards GPIOLIB
      i2c-i801: Fix comment

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois

Jianpeng Ma (1):
      block: Add blk_rq_pos(rq) to sort rq when plushing

Jiri Kosina (1):
      pktcdvd: update MAINTAINERS

Jiri Slaby (1):
      HID: microsoft: fix invalid rdesc for 3k kbd

Johannes Berg (5):
      mac80211: use blacklist for duplicate IE check
      wireless: drop invalid mesh address extension frames
      mac80211: check management frame header length
      mac80211: verify that skb data is present
      mac80211: make sure data is accessible in EAPOL check

Jon Hunter (1):
      gpio/omap: fix off-mode bug: clear debounce settings on free/reset

Jonathan Brassow (1):
      MD RAID10: Fix oops when creating RAID10 arrays via dm-raid.c

Jonghwan Choi (1):
      exynos4_tmu_driver_ids should be exynos_tmu_driver_ids.

Julian Anastasov (2):
      netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper
      tcp: Fix double sizeof in new tcp_metrics code

Jun'ichi Nomura (2):
      blkcg: Fix use-after-free of q->root_blkg and q->root_rl.blkg
      blkcg: stop iteration early if root_rl is the only request list

Kees Cook (2):
      block: remove CONFIG_EXPERIMENTAL
      drivers/block: remove CONFIG_EXPERIMENTAL

Konrad Rzeszutek Wilk (2):
      xen/blkback: Fix compile warning
      xen/mmu: Use Xen specific TLB flush instead of the generic one.

Laxman Dewangan (1):
      i2c: tegra: set irq name as device name

Linus Torvalds (1):
      Linux 3.7-rc4

Masanari Iida (1):
      net: sctp: Fix typo in net/sctp

Mathias Nyman (1):
      gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios

Max Filippov (3):
      xtensa: switch to generic kernel_thread()
      xtensa: switch to generic kernel_execve()
      xtensa: switch to generic sys_execve()

NeilBrown (2):
      md/raid1: Fix assembling of arrays containing Replacements.
      NFS: fix bug in legacy DNS resolver.

Nicholas Bellinger (3):
      qla2xxx: Add missing ->vport_slock while calling qlt_update_vp_map
      target: Fix double-free of se_cmd in target_complete_tmr_failure
      target: Re-add explict zeroing of INQUIRY bounce buffer memory

Olaf Hering (1):
      x86: remove obsolete comment from asm/xen/hypervisor.h

Oliver Chick (1):
      xen/blkback: Change xen_vbd's flush_support and discard_secure
to have type unsigned int, rather than bool

Pavel Emelyanov (1):
      tcp-repair: Handle zero-length data put in rcv queue

Peter Senna Tschudin (3):
      drivers/gpu/drm/radeon/evergreen_cs.c: Remove unnecessary semicolon
      drivers/net/ethernet/nxp/lpc_eth.c: Call mdiobus_unregister
before mdiobus_free
      drivers/net/phy/mdio-bitbang.c: Call mdiobus_unregister before
mdiobus_free

Peter Ujfalusi (1):
      ASoC: omap-dmic: Correct functional clock name

Philippe Begnic (1):
      i2c-nomadik: Fixup clock handling

Rahul Sharma (1):
      drm: exynos: removed warning due to missing typecast for mixer driver data

Rob Clark (1):
      drm/exynos: add support for ARCH_MULTIPLATFORM

Roland Dreier (5):
      tcm_qla2xxx: Format VPD page 83h SCSI name string according to SPC
      qla2xxx: Update target lookup session tables when a target session changes
      target: Don't return success from module_init() if setup fails
      target: Avoid integer overflow in se_dev_align_max_sectors()
      iscsi-target: Fix missed wakeup race in TX thread

Roland Stigge (2):
      gpio-74x164: Fix buffer allocation size
      Input: lpc32xx-keys - select INPUT_MATRIXKMAP

Rolf Eike Beer (1):
      Input: tsc40 - remove wrong announcement of pressure support

Sage Weil (1):
      libceph: avoid NULL kref_put when osd reset races with alloc_msg

Sasha Levin (1):
      hashtable: introduce a small and naive hashtable

Scott Mayhew (1):
      nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd timeouts

Selvan Mani (1):
      mtip32xx:Added appropriate timeout value for secure erase

Stanislaw Gruszka (1):
      rt2800: validate step value for temperature compensation

Stefano Stabellini (1):
      xen/arm: use the __HVC macro

Steve Hodgson (1):
      target: Fix incorrect usage of nested IRQ spinlocks in ABORT_TASK path

Sven Eckelmann (1):
      ath9k: Test for TID only in BlockAcks while checking tx status

Takashi Iwai (7):
      ALSA: PCM: Fix some races at disconnection
      ALSA: usb-audio: Fix races at disconnection
      ALSA: usb-audio: Use rwsem for disconnect protection
      ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
      ALSA: Add a reference counter to card instance
      ALSA: Avoid endless sleep after disconnect
      ALSA: ice1724: Fix rate setup after resume

Thomas Petazzoni (1):
      gpio: mvebu: correctly set the value in direction_output()

Tom Parkin (1):
      l2tp: fix oops in l2tp_eth_create() error path

Tony Lindgren (1):
      ASoC: zoom2: Fix compile error by including correct header files

Trond Myklebust (3):
      NFSv4.1: We must release the sequence id when we fail to get a
session slot
      NFSv4: nfs4_locku_done must release the sequence id
      NFSv4: Initialise the NFSv4.1 slot table highest_used_slotid correctly

Ulrich Weber (1):
      netfilter: nf_nat: don't check for port change on ICMP tuples

Vasily Khoruzhick (1):
      Input: pxa27x_keypad - clear pending interrupts on keypad config

Vipul Pandya (1):
      cxgb4: Fix unable to get UP event from the LLD

Wei Yongjun (2):
      xen/blkback: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      cciss: remove unneeded memset()

Weston Andros Adamson (3):
      NFS: add nfs_sb_deactive_async to avoid deadlock
      SUNRPC: return proper errno from backchannel_rqst
      NFS4: nfs4_opendata_access should return errno

Wolfram Sang (1):
      i2c: mxs: remove broken PIOQUEUE support

Xianhan Yu (1):
      HID: multitouch: fix maxcontacts problem on GeneralTouch

Xiao Guangrong (1):
      KVM: x86: fix vcpu->mmio_fragments overflow

Yanchuan Nian (1):
      nfs: Check whether a layout pointer is NULL before free it

Yaniv Rosner (6):
      bnx2x: Fix 57810 1G-KR link against certain switches.
      bnx2x: Fix link down in 57712 following LFA
      bnx2x: Restore global registers back to default.
      bnx2x: Fix potential incorrect link speed provision
      bnx2x: Fix unrecognized SFP+ module after driver is loaded
      bnx2x: Fix no link on 577xx 10G-baseT

nikolay@redhat.com (2):
      bonding: fix off-by-one error
      bonding: fix second off-by-one error

stephen hemminger (1):
      vxlan: don't expire permanent entries
