Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2KKNSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 08:18:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48246 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2KKNSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 08:18:08 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Nov 2012 14:17:46 +0100
X-Google-Sender-Auth: ETWYN70IbJlqaS26gygx13sANyo
Message-ID: <CA+55aFzS+3_4-wXo48Gm042xUYp6NNpwVwXq4CAu_4ZH=wf0+A@mail.gmail.com>
Subject: Linux 3.7-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been another week (modulo timezone differences), so -rc5 is out there.

This is quite a small -rc, I'm happy to say. -rc4 was already fairly
calm, and -rc5 has fewer commits still. And more importantly, apart
from one revert, and a pinctl driver update, it's not just a fairly
small number of commits, they really are mostly one-liners. The
diffstat looks quite nice and flat.

The updates are
 - arch (sparc, arm/arm64 and s390)
 - drivers (drm, mmc, net, pinctrl, hid, sound, hwmon, pci)
 - misc (net, akpm, xen, virtio, modules and crypto)
 - filesystem (gfs2, xfs and cifs)
but it's really all pretty small.

Shortlog appended.

Please test - although I'm hopeful that it's quiet because things are
in good shape, I'd like to get that verified.

                  Linus

---
Adrian Hunter (1):
      mmc: sdhci-pci: fix 'Invalid iomem size' error message condition

Adrian Knoth (1):
      ALSA: hdspm - Fix sync check reporting on RME RayDAT

Alex Deucher (4):
      drm/radeon: fix typo in evergreen_mc_resume()
      drm/radeon/dce3: switch back to old pll allocation order for discrete
      drm/radeon/cayman: add some missing regs to the VM reg checker
      drm/radeon/si: add some missing regs to the VM reg checker

Alexander Stein (1):
      ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Andreas Larsson (3):
      sparc: Add sparc support for platform_get_irq()
      sparc32, leon: Check for existent irq_map entry in leon_handle_ext_irq
      of/address: sparc: Declare of_address_to_resource() as an extern
function for sparc again

Andrew Morton (1):
      revert "epoll: support for disabling items, and a self-test app"

Andrew Price (3):
      GFS2: Fix an unchecked error from gfs2_rs_alloc
      GFS2: Fix possible null pointer deref in gfs2_rs_alloc
      GFS2: Clean up some unused assignments

Arnd Bergmann (2):
      mmc: dw_mmc: fix modular build for exynos back-end
      mmc: dw_mmc: constify dw_mci_idmac_ops in exynos back-end

Axel Lin (1):
      pinctrl: samsung and exynos need to depend on OF && GPIOLIB

Balaji T K (2):
      mmc: omap_hsmmc: fix host reference after mmc_free_host
      mmc: omap_hsmmc: fix NULL pointer dereference for dt boot

Benjamin Marzinski (2):
      GFS2: Don't call file_accessed() with a shared glock
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held

Catalin Marinas (2):
      arm64: Use pgprot_t as the last argument when invoking __ioremap()
      arm64: Move PCI_IOBASE closer to MODULES_VADDR

Chris Ball (1):
      mmc: sdhci: fix NULL dereference in sdhci_request() tuning

Cornelia Huck (2):
      s390: Move css limits from drivers/s390/cio/ to include/asm/.
      virtio: Don't access index after unregister.

Cyril Brulebois (1):
      r8169: Fix WoL on RTL8168d/8111d.

Cyrill Gorcunov (1):
      net: inet_diag -- Return error code if protocol handler is missed

Daniel J Blueman (2):
      ALSA: HDA: Fix digital microphone on CS420x
      ALSA: HDA: Mark CS260x immutable structures const

Dave Chinner (9):
      xfs: only update the last_sync_lsn when a transaction completes
      xfs: introduce XFS_BMAPI_STACK_SWITCH
      xfs: move allocation stack switch up to xfs_bmapi_allocate
      xfs: growfs: don't read garbage for new secondary superblocks
      xfs: silence uninitialised f.file warning.
      xfs: invalidate allocbt blocks moved to the free list
      xfs: don't vmap inode cluster buffers during free
      xfs: fix buffer shudown reference count mismatch
      xfs: fix reading of wrapped log data

David S. Miller (9):
      sparc64: Make montmul/montsqr/mpmul usable in 32-bit threads.
      sparc64: Fix cpu strand yielding.
      sparc64: Use pause instruction when available.
      sparc64: Improvde documentation and readability of atomic backoff code.
      sparc: Wire up sys_kcmp.
      qlogicpti: Fix build warning.
      sparc: Allow OF_GPIO on sparc.
      sparc: Support atomic64_dec_if_positive properly.
      sparc64: Fix build with mix of modular vs. non-modular crypto drivers.

Deepak Sikri (2):
      pinctrl: SPEAr320: Correct pad mux entries for rmii/smii
      pinctrl: SPEAr1340: Make DDR reset & clock pads as gpio

Eric Leblond (1):
      af-packet: fix oops when socket is not present

Eric Paris (1):
      fanotify: fix missing break

Fabio Estevam (1):
      mmc: mxcmmc: Fix MODULE_ALIAS

Felipe Balbi 2 (1):
      ARM: 7565/1: sched: stop sched_clock() during suspend

Fengguang Wu (1):
      h8300: add missing L1_CACHE_SHIFT

Gerald Schaefer (2):
      s390/mm: use pmd_large() instead of pmd_huge()
      s390/thp: respect page protection in pmd_none() and pmd_present()

Guennadi Liakhovetski (1):
      mmc: sh_mmcif: fix use after free

Hannes Frederic Sowa (1):
      ipv6: send unsolicited neighbour advertisements to all-nodes

Heiko Carstens (1):
      s390/sclp: fix addressing mode clobber

Huang Ying (3):
      PCI/PM: Fix deadlock when unbinding device if parent in D3cold
      PCI/PM: Resume device before shutdown
      PCI/PM: Fix proc config reg access for D3cold and bridge suspending

Ian Coolidge (2):
      usb: gadget: g_ether: fix frame size check for 802.1Q
      net: usb: cdc_eem: Fix rx skb allocation for 802.1Q VLANs

Ilija Hadzic (2):
      drm: restore open_count if drm_setup fails
      drm: set dev_mapping before calling drm_open_helper

Jacob Keller (1):
      ptp: update adjfreq callback description

James Hogan (1):
      mmc: dw_mmc: fix multiple drv_data NULL dereferences

Jan Beulich (1):
      xen/hypercall: fix hypercall fallback code for very old hypervisors

Jean Delvare (2):
      hwmon: (w83627ehf) Force initial bank selection
      hwmon: Fix chip feature table headers

Jeff Layton (1):
      cifs: fix potential buffer overrun in cifs.idmap handling code

Jerry Huang (1):
      mmc: sdhci-of-esdhc: disable CMD23 for some Freescale SoCs

Jiri Kosina (1):
      HID: hidraw: put old deallocation mechanism in place

Joe Perches (1):
      checkpatch: improve network block comment style checking

John Fastabend (1):
      rtnetlink: Use nlmsg type RTM_NEWNEIGH from dflt fdb dump

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to
prevent data corruption

Kailang Yang (2):
      ALSA: hda - Improve HP depop when system enter to S3
      ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)

Kelly Doran (1):
      drm/nvc0/disp: fix regression in vblank semaphore release

Kevin Liu (1):
      mmc: sdhci: fix IS_ERR() checking of regulator_get()

Konrad Rzeszutek Wilk (3):
      xen/hvm: If we fail to fetch an HVM parameter print out which flag it is.
      xen/generic: Disable fallback build on ARM.
      xen/arm: Fix compile errors when drivers are compiled as modules.

Lars R. Damerow (1):
      ALSA: hda - support Teradici 2200 host card audio

Lee Jones (1):
      isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES

Linus Torvalds (1):
      Linux 3.7-rc5

Lukas Czerner (2):
      GFS2: Require user to provide argument for FITRIM
      GFS2: Fix FITRIM argument handling

Maarten Lankhorst (1):
      drm/nouveau: fix acpi edid retrieval

Marcin Slusarz (3):
      drm/nv41/vm: fix typo in type name
      drm/nv40/graph: fix typo in type names
      drm/nv40/mpeg: fix context handling

Mark Tinguely (1):
      xfs: zero allocation_args on the kernel stack

Masanari Iida (2):
      net: bnx2x: Fix typo in bnx2x driver
      ALSA: Fix typo in drivers sound

Mojiong Qiu (1):
      xen/events: fix RCU warning, or Call idle notifier after irq_enter()

Nathan Walp (1):
      r8169: allow multicast packets on sub-8168f chipset.

Nicolas Dichtel (1):
      gre6: fix rtnl dump messages

Ondrej Zary (1):
      ALSA: es1968: Add ESS vendor ID to pm_whitelist

Paolo Valente (1):
      pkt_sched: enable QFQ to support TSO/GSO

Paul Walmsley (1):
      ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3
and CONFIG_VFPv3 set

Russell King - ARM Linux (1):
      mmc: fix sdhci-dove probe/removal

Rusty Russell (2):
      module: fix out-by-one error in kallsyms
      modules: don't break modules_install on external modules with no key.

Sachin Prabhu (1):
      cifs: Do not lookup hashed negative dentry in cifs_atomic_open

Sebastian Ott (2):
      s390/cio: suppress 2nd path verification during resume
      s390/cio: fix length calculation in idset.c

Seungwon Jeon (3):
      mmc: dw_mmc: convert the variable type of irq
      mmc: dw_mmc: remove _dev_info compile warning
      mmc: sdhci-s3c: fix the card detection in runtime-pm

Shiraz Hashim (3):
      pinctrl: SPEAr3xx: correct register space to configure pwm
      pinctrl: SPEAr1310: fix clcd high resolution pin group name
      pinctrl: SPEAr1310: add register entries for enabling pad direction

Stefano Stabellini (1):
      xen/arm: Fix compile errors when drivers are compiled as modules
(export more).

Steve Glendinning (2):
      smsc95xx: fix tx checksum offload for big endian
      usbnet: ratelimit kevent may have been dropped warnings

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning
from kswapd()

Takashi Iwai (6):
      ALSA: hda - Force to reset IEC958 status bits for AD codecs
      ALSA: hda - Fix empty DAC filling in patch_via.c
      ALSA: hda - Fix invalid connections in VT1802 codec
      ALSA: hda - Add pin fixups for ASUS G75
      ALSA: usb-audio: Fix crash at re-preparing the PCM stream
      ALSA: Fix card refcount unbalance

Taku Izumi (1):
      PCI/portdrv: Don't create hotplug slots unless port supports hotplug

Thomas Abraham (1):
      mmc: sdhci-s3c: use clk_prepare_enable and clk_disable_unprepare

Thomas Hellstrom (2):
      drm/vmwgfx: Fix hibernation device reset
      drm/vmwgfx: Fix a case where the code would BUG when trying to
pin GMR memory

Vipul Kumar Samar (3):
      pinctrl: SPEAr1310: Fix value of PERIP_CFG reigster and MCIF_SEL_SHIFT
      pinctrl: SPEAr1310: Separate out pci pins from pcie_sata pin group
      pinctrl: SPEAr1340: Add clcd sleep mode pin configuration

Vipul Pandya (2):
      cxgb4: Initialize data structures before using.
      cxgb4: Fix initialization of SGE_CONTROL register

Viresh Kumar (1):
      pinctrl: SPEAr: Don't update all non muxreg bits on pinctrl_disable

Wang Dongsheng (1):
      gianfar: ethernet vanishes after restoring from hibernation

Will Deacon (6):
      ARM: 7567/1: io: avoid GCC's offsettable addressing modes for
halfword accesses
      arm64: perf: use architected event for CPU cycle counter
      arm64: elf: fix core dumping definitions for GP and FP registers
      arm64: compat: select CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
      arm64: smp: add missing completion for secondary boot
      arm64: mm: fix booting on systems with no memory below 4GB

Xiaotian Feng (2):
      tipc: do not use tasklet_disable before tasklet_kill
      drivers/net: use tasklet_kill in device remove/close process

Yuvaraj CD (1):
      mmc: dw_mmc: enable controller interrupt before calling mmc_start_host

viresh kumar (1):
      ARM: 7569/1: mm: uninitialized warning corrections
