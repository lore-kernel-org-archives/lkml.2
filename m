Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab2BIDhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:37:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34072 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab2BIDg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:36:57 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Feb 2012 19:36:37 -0800
X-Google-Sender-Auth: 6ioaucLkGlONjJGWc8fD_XMZt_g
Message-ID: <CA+55aFyDE+chjpt9N5yNG=+A_LL5qhZjPYfOjFGuZcXUPGEoOQ@mail.gmail.com>
Subject: Linux 3.3-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

No big surprises, which is just how I like it. About a third of the
patches are in ARM, but the bulk of that is due to the removal of the
unused DMA map code form the bcmring support. So no complaints.

The rest is fairly flat in the diffstat (== random small changes all
over), although mostly drivers. More sound/hda (and asoc) updates,
some target and IB updates, etc etc.

Shortlog appended for your perusal, you can see the kind of largely
"fix small details" almost all of it is,

                      Linus

---
Akinobu Mita (1):
      xtensa: fix memscan()

Alex Deucher (1):
      drm/radeon/kms: fix TRAVIS panel setup

Alex Elder (4):
      ceph: change "ceph.layout" xattr to be "ceph.file.layout"
      ceph: create a new session lock to avoid lock inversion
      rbd: fix a memory leak in rbd_get_client()
      rbd: fix safety of rbd_put_client()

Andrew Morton (1):
      mm/memcontrol.c: fix warning with CONFIG_NUMA=n

Andy Grover (2):
      target: Allow control CDBs with data > 1 page
      target: Change target_submit_cmd() to return void

Artem Bityutskiy (4):
      jffs2: do not initialize variable unnecessarily
      mtd: fix MTD suspend
      mtd: fix merge conflict resolution breakage
      Revert "mtd: atmel_nand: optimize read/write buffer functions"

Axel Lin (5):
      ALSA: Add #ifdef CONFIG_PCI guard for snd_pci_quirk_* functions
      ASoC: cs42l73: Fix Output [X|A|V]SP_SCLK Sourcing Mode setting
for master mode
      gpio: Add missing spin_lock_init in gpio-pch driver
      gpio: Add missing spin_lock_init in gpio-ml-ioh driver
      drivers/leds/leds-lm3530.c: fix setting pltfm->als_vmax

Bas van den Berg (1):
      ARM: davinci: DA850: remove non-existing pll1_sysclk4-7 clocks

Ben Skeggs (4):
      drm/nouveau/disp: check that panel power gpio is enabled at init time
      drm/nouveau/mxm: pretend to succeed, even if we can't shadow the MXM-SIS
      drm/nouveau: fix typo on mxmdcb option
      drm/nouveau/gem: fix fence_sync race / oops

Bernd Schubert (1):
      RDMA/core: Fix kernel panic by always initializing qp->usecnt

Carsten Otte (1):
      mm/filemap_xip.c: fix race condition in xip_file_fault()

Catalin Marinas (2):
      kmemleak: Disable early logging when kmemleak is off by default
      ARM: 7302/1: Add TLB flushing for both entries in a PMD

Chanho Min (1):
      sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW

Che-Liang Chiou (1):
      Input: serio_raw - return proper result when serio_raw_read fails

Christian Borntraeger (1):
      sched/s390: Fix compile error in sched/core.c

Christoph Hellwig (2):
      target: don't allocate bio headroom in iblock
      iblock: fix handling of large requests

Christopher Yeoh (1):
      Fix race in process_vm_rw_core

Clemens Ladisch (3):
      firewire: ohci: add reset packet quirk for SB Audigy
      ALSA: usb-audio: add Edirol UM-3G support
      ALSA: oxygen, virtuoso: fix exchanged L/R volumes of aux and CD inputs

Cong Wang (1):
      lkdtm: avoid calling lkdtm_do_action() with spinlock held

Cousson, Benoit (1):
      i2c: OMAP: Fix OMAP1 build error

Dan Carpenter (9):
      iscsi-target: make one-bit bitfields unsigned
      cifs: NULL dereference on allocation failure
      IB/ipath: Calling PTR_ERR() on right variable in create_file()
      x86/dumpstack: Remove unneeded check in dump_trace()
      intelfb: remove some dead code
      cifs: check offset in decode_ntlmssp_challenge()
      drm/nv50/pm: signedness bug in nv50_pm_clocks_pre()
      IB/srpt: Fix ERR_PTR() vs. NULL checking confusion
      target: handle empty string writes in sysfs

Danny Kukawka (1):
      spi-topcliff-pch: rename pch_spi_pcidev to pch_spi_pcidev_driver

Dave Airlie (1):
      drm/radeon: fix use after free in ATRM bios reading code.

Dave Martin (1):
      ARM: 7307/1: vfp: fix ptrace regset modification race

David Daney (1):
      perf tools: Fix broken build by defining _GNU_SOURCE in Makefile

David Henningsson (4):
      ALSA: HDA: Remove quirk for Asus N53Jq
      ALSA: HDA: Fix jack creation for codecs with front and rear Line In
      ALSA: HDA: Remove quirk for Toshiba Qosmio G50
      ALSA: HDA: Fix duplicated output to more than one codec

David Miller (2):
      lib: Fix multiple definitions of clz_tab
      lib: Fix 32-bit sparc udiv_qrnnd() definition in mpilib's longlong.h

Dax Kelson (1):
      iscsi: use IP_FREEBIND socket option

Denis 'GNUtoo' Carikli (1):
      ASoC: neo1973_wm8753: remove references to the neo1973-gta01 machine

Dmitry Kasatkin (11):
      lib/mpi: added missing NULL check
      lib/mpi: replaced MPI_NULL with normal NULL
      lib/mpi: return error code on dividing by zero
      lib/mpi: checks for zero divisor length
      lib/mpi: removed unused functions
      lib/digsig: additional sanity checks against badly formated key payload
      lib/digsig: pkcs_1_v1_5_decode_emsa cleanup
      lib/mpi: check for possible zero length
      lib/mpi: added comment on divide by 0 case
      lib/mpi: added missing NULL check
      lib/digsig: checks for NULL return value

Dr. David Alan Gilbert (1):
      dmaengine: fix missing 'cnt' in ?: in dmatest

Dylan Reid (1):
      ALSA: hda - Fix calling cs_automic twice for Cirrus codecs.

Fabio Baltieri (1):
      avr32: select generic atomic64_t support

Felipe Contreras (3):
      ARM: OMAP2: fix omap3 touchbook kconfig warning
      ARM: OMAP2: fix regulator warnings
      Input: twl4030_keypad - fix comment (trivial)

Gleb Natapov (1):
      KVM: do not #GP on perf MSR writes when vPMU is disabled

Grazvydas Ignotas (2):
      ARM: OMAP: fix erroneous mmc2 clock change on mmc3 setup
      ARM: OMAP: fix MMC2 loopback clock handling

Greg KH (1):
      MAINTAINERS: Greg's suse email address is dead

Guennadi Liakhovetski (2):
      dma: sh_dma: not all SH DMAC implementations support MEMCPY
      ARM: mach-shmobile: both USB DMAC instances on sh7372 are slave-only

Guenter Roeck (1):
      hwmon: (w83627ehf) Fix number of fans for NCT6776F

Heiko Carstens (1):
      exec: fix use-after-free bug in setup_new_exec()

Heiko Stübner (2):
      Input: evdev - fix variable initialisation
      Input: gpio_keys - fix struct device declared inside parameter list

Henrik Rydberg (1):
      Input: document device properties

Huang Shijie (1):
      mtd: gpmi-nand bugfix: reset the BCH module when it is not MX23

Hubert Feurstein (1):
      atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume

Hugh Dickins (1):
      mm: fix UP THP spin_is_locked BUGs

Igor Murzov (1):
      Input: i8042 - add Lenovo Ideapad U455 to 'reset' blacklist

Ilija Hadzic (1):
      drm/radeon/kms/blit: fix blit copy for very large buffers

Ilya Yanok (1):
      ARM: OMAP3: hwmod data: register dss hwmods after dss_core

JD Zheng (1):
      ARM: bcmring: remove unused DMA map code

Jack Morgenstein (1):
      IB/mlx4: pass SMP vendor-specific attribute MADs to firmware

Jan Beulich (1):
      x86: Properly parenthesize cmpxchg() macro arguments

Jaroslav Kysela (1):
      ALSA: hda - add support for Uniwill ECS M31EI notebook

Jean Delvare (1):
      drm/radeon/kms: Fix device tree linkage of DP i2c buses too

Jesper Juhl (4):
      iscsi-target: Fix up a few assignments
      IB/srpt: Remove unneeded <linux/version.h> include
      ALSA: emu8000: Remove duplicate linux/moduleparam.h include from
emu8000_patch.c
      IB/srpt: Don't return freed pointer from srpt_alloc_ioctx_ring()

Jiang Liu (1):
      kprobes: fix a memory leak in function pre_handler_kretprobe()

Jiri Kosina (1):
      HID: wiimote: fix invalid power_supply_powers call

Joe Perches (5):
      MAINTAINERS: update partitions block F: patterns
      MAINTAINERS: remove iMX5 section
      MAINTAINERS: remove staging sections
      MAINTAINERS: update lguest F: patterns
      checkpatch: Warn on code with 6+ tab indentation

Joerg Roedel (2):
      iommu/amd: Work around broken IVRS tables
      iommu/msm: Fix error handling in msm_iommu_unmap()

Jonathan Brassow (1):
      Prevent DM RAID from loading bitmap twice.

Josh Triplett (1):
      include/linux/lp8727.h: Remove executable bit

Julia Lawall (3):
      ARM: OMAP2+: arch/arm/mach-omap2/devices.c: introduce missing kfree
      ARM: OMAP2+: arch/arm/mach-omap2/smartreflex.c: add missing iounmap
      IB/qib: Use GFP_ATOMIC when locks are held

K. Y. Srinivasan (1):
      HID: hyperv: Properly disconnect the input device

Konstantin Khlebnikov (1):
      mm: postpone migrated page mapping reset

Larry Finger (1):
      Documentation: add missing tainted bits to Documentation/sysctl/kernel.txt

Linus Torvalds (1):
      Linux 3.3-rc3

Marco Sanvido (3):
      target: Use correct preempted registration sense code
      target: Allow PERSISTENT RESERVE IN for non-reservation holder
      target: Fix iblock se_dev_attrib.unmap_granularity

Mark Brown (13):
      ASoC: wm5100: Make sure we switch to button reporting mode
      ASoC: wm5100: Fix microphone configuration
      ASoC: wm8996: Mark register cache as dirty when regulators are disabled
      ASoC: wm8962: Mark register cache as dirty when regulators are disabled
      ASoC: wm5100: Mark register cache as dirty when regulators are disabled
      ASoC: wm_hubs: Enable line out VMID buffer for single ended line outputs
      ASoC: wm_hubs: Fix routing of input PGAs to line output mixer
      ASoC: wm8994: Remove ASoC level register cache sync
      ASoC: core: Better support for idle_bias_off suspend ignores
      ASoC: wm_hubs: Correct line input to line output 2 paths
      ASoC: wm8994: Enabling VMID should take a runtime PM reference
      ASoC: wm8994: Fix typo in VMID ramp setting
      ASoC: wm8994: Disable line output discharge prior to ramping VMID

Martin Svec (1):
      target: Fix unsupported WRITE_SAME sense payload

Mel Gorman (2):
      mm: compaction: check pfn_valid when entering a new
MAX_ORDER_NR_PAGES block during isolation for migration
      mm: compaction: check for overlapping nodes during isolation for migration

Michael D Labriola (2):
      x86/reboot: Skip DMI checks if reboot set by user
      x86/reboot: Remove VersaLogic Menlow reboot quirk

Michael Neuling (1):
      drivers/video: compile fixes for fsl-diu-fb.c

Michael S. Tsirkin (3):
      lib: add NO_GENERIC_PCI_IOPORT_MAP
      mips: use the the PCI controller's io_map_base
      sh: use the the PCI channels's io_map_base

Michal Simek (1):
      Revert "microblaze: Add topology init"

Michel Dänzer (1):
      drm/radeon: Set DESKTOP_HEIGHT register to the framebuffer (not
mode) height.

Mike Marciniszyn (1):
      IB/qib: Roll back PCIe tuning change

Ming Lei (1):
      HID: usbhid: fix dead lock between open and disconect

NeilBrown (1):
      md: two small fixes to handling interrupt resync.

Nicholas Bellinger (5):
      target: Add workaround for zero-length control CDB handling
      iscsi-target: Fix reject release handling in iscsit_free_cmd()
      iscsi-target: Fix double list_add with iscsit_alloc_buffs reject
      iscsi-target: Fix discovery with INADDR_ANY and IN6ADDR_ANY_INIT
      target: Fix target_submit_cmd() exception handling

Nikolaus Voss (1):
      at_hdmac: bugfix for enabling channel irq

Oleg Nesterov (3):
      proc: mem_release() should check mm != NULL
      proc: unify mem_read() and mem_write()
      proc: make sure mem_open() doesn't pin the target's memory

Paul Gortmaker (1):
      ARM: bcmring: fix build failure in mach-bcmring/arch.c

Paul Walmsley (2):
      ARM: OMAP2+: io: fix compilation breakage on 2420-only configs
      ARM: OMAP2/3: PRM: fix missing plat/irqs.h build breakage

Peter Ujfalusi (3):
      ARM: OMAP4: hwmod data: Add names for DMIC memory address space
      mfd: Store twl6040-codec mclk configuration
      mfd: Avoid twl6040-codec PLL reconfiguration when not needed

Peter Zijlstra (1):
      sched: Fix rq->nr_uninterruptible update race

Philippe Rétornaz (1):
      i.MX SDMA: Fix burstsize settings

Prarit Bhargava (1):
      bugs, x86: Fix printk levels for panic, softlockups and stack dumps

Przemo Firszt (1):
      HID: wacom: Fix invalid power_supply_powers calls

Randy Dunlap (4):
      cifs: fix printk format warnings
      docbook: fix fatal errors in device-drivers docbook and add DMA
Management section
      staging: fix go7007-usb license
      Documentation: update quilt tree location for Documentation patches

Roland Dreier (6):
      target: Correct sense key for INVALID FIELD IN {PARAMETER LIST,CDB}
      target: Return correct ASC for unimplemented VPD pages
      target: Fail INQUIRY commands with EVPD==0 but PAGE CODE!=0
      RDMA/nes: Add missing rcu_read_unlock() in nes_addr_resolve_neigh()
      IB/srpt: Use DEFINE_SPINLOCK()/LIST_HEAD()
      IB/srpt: Use ARRAY_SIZE() instead of open-coding

Roland Stigge (1):
      Correct bad gpio naming

Russell King (2):
      Revert "ARM: 7304/1: ioremap: fix boundary check when reusing
static mapping"
      pcmcia: fix socket refcount decrementing on each resume

Sage Weil (1):
      ceph: initialize client debugfs outside of monc->mutex

Samuel Thibault (1):
      drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer

Sean Hefty (1):
      RDMA/ucma: Discard all events for new connections until accepted

Sebastian Andrzej Siewior (4):
      target: avoid multiple outputs in scsi_dump_inquiry()
      target: use save/restore lock primitive in core_dec_lacl_count()
      target: fix return code of core_tpg_.*_lun
      target: accept REQUEST_SENSE with 18bytes

Sekhar Nori (1):
      ARM: davinci: update mdio bus name

Seth Forshee (1):
      drm/radeon/kms: disable output polling when suspended

Shaohua Li (1):
      readahead: fix pipeline break caused by block plug

Shirish Pargaonkar (1):
      cifs: Fix oops in session setup code for null user mounts

Srivatsa S. Bhat (2):
      PM / Hibernate: Thaw kernel threads in SNAPSHOT_CREATE_IMAGE ioctl path
      PM / Freezer: Thaw only kernel threads if freezing of kernel threads fails

Stefan Richter (1):
      firewire: ohci: disable MSI on Ricoh controllers

Stephan Bärwolf (2):
      KVM: x86: extend "struct x86_emulate_ops" with "get_cpuid"
      KVM: x86: fix missing checks in syscall emulation

Stephane Eranian (3):
      perf: Fix broken interrupt rate throttling
      perf tools: Fix strlen() bug in perf_event__synthesize_event_type()
      perf top: Fix number of samples displayed

Stephen Rothwell (1):
      iscsi_target: in_aton needs linux/inet.h

Steve French (1):
      [CIFS] Update cifs Kconfig title to match removal of
experimental dependency

Suresh Siddha (1):
      sched/nohz: Fix nohz cpu idle load balancing state with cpu hotplug

Susan Gao (1):
      ASoC: wm8962: Fix word length configuration

Sylwester Nawrocki (1):
      spi: Add spi-s3c64xx driver dependency on ARCH_EXYNOS4

Takashi Iwai (8):
      ALSA: hda - Apply 0x0f-VREF fix to all ASUS laptops with ALC861/660
      ALSA: hda - Check power-state before changing in patch_via.c
      ALSA: hda - Fix the logic to detect VIA analog low-current mode
      ALSA: hda - Allow analog low-current mode when dynamic power-control is on
      ALSA: hda - Disable dynamic-power control for VIA as default
      ALSA: hda/realtek - Add missing Bass and CLFE as vmaster slaves
      ALSA: hda/realtek - Fix a wrong condition
      ALSA: hda - Fix error handling in patch_ca0132.c

Takuya Yoshikawa (1):
      KVM: Fix __set_bit() race in mark_page_dirty() during dirty logging

Tatyana Nikolova (4):
      RDMA/nes: Fix for sending MPA reject frame
      RDMA/nes: Fix fast memory registration length
      RDMA/nes: Fix fast memory registration opcode
      RDMA/nes: Copyright update

Thomas Abraham (1):
      gpio: samsung: adapt to changes in gpio specifier translator
function declaration

Tiejun Chen (1):
      kmemleak: Only scan non-zero-size areas

Tomi Valkeinen (9):
      ARM: OMAP2+: hwmod data: split omap2/3 dispc hwmod class
      ARM: OMAP3: hwmod data: add SYSC_HAS_ENAWAKEUP for dispc
      OMAPDSS: use sync versions of pm_runtime_put
      OMAP: 4430SDP/Panda: use gpio_free_array to free HDMI gpios
      OMAP: 4430SDP/Panda: rename HPD GPIO to CT_CP_HPD
      OMAPDSS: remove wrong HDMI HPD muxing
      OMAP: 4430SDP/Panda: setup HDMI GPIO muxes
      OMAP: 4430SDP/Panda: add HDMI HPD gpio
      OMAPDSS: HDMI: PHY burnout fix

UK KIM (1):
      ASoC: wm_hubs: fix wrong bits for LINEOUT2 N/P mixer

Vaibhav Hiremath (1):
      ARM: OMAP2+: timer: Fix crash due to wrong arg to
__omap_dm_timer_read_counter

Venkatesh Pallipadi (1):
      PM / QoS: CPU C-state breakage with PM Qos change

Will Deacon (4):
      ARM: 7306/1: vfp: flush thread hwstate before restoring context
from sigframe
      ARM: 7308/1: vfp: flush thread hwstate before copying ptrace registers
      ARM: 7303/1: perf: add empty NODE event definitions for
Cortex-A5 and Cortex-A15
      ARM: 7314/1: kuser: consistently use usr_ret for returning from helpers

Wolfram Sang (1):
      mtd: nand: fix typo in comment

Xi Wang (2):
      ceph: fix length validation in parse_reply_info()
      nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()

Yasunori Goto (1):
      sched: Fix ancient race in do_exit()

Yegor Yefremov (1):
      ARM: OMAP2+: GPMC: fix device size setup

Yinghai Lu (1):
      ACPI: remove duplicated lines of merging problems with acpi_processor_add

roland@purestorage.com (1):
      target: Don't zero pages used for data buffers
