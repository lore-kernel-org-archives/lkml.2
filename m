Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1KORob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 12:44:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62593 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1KORoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 12:44:30 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Nov 2011 15:44:07 -0200
X-Google-Sender-Auth: 3CUA7U0VbDSEKmPODb8lUg_HA7M
Message-ID: <CA+55aFzWkXNtLe4jxuXfTJzbXgDF+ig2OuGY3ca+nNCJxAtOZQ@mail.gmail.com>
Subject: Linux 3.2-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 3.2-rc2 is out there now. Well, the git trees are there
(kernel.org and github), and the tar-file should be all done, but the
patch is still uploading.

One thng worth noting: I got the new release scripts right, so now the
-rc2 files are found in their proper location under "v3.x/testing",
unlike -rc1 that got put directly in "v3.x". I'll fix the -rc1
location when I'm somewhere with better network.

And for being an -rc2 release of a pretty large merge-window, it seems
to be quite reasonably sized. In fact, despite this having been the
largest linux-next in a release in our linux-next history (I think),
rc2 has the exact same number of commits since rc1 as we had during
the 3.1 release.

About half the changes are architecture fixups (m68k and arm, with
some powerpc and a smattering of others) Of the rest, about half is
drivers (much of it drm), and the rest is "filesystems and sundry
updates".

The shortlog is appended for people who enjoy that level of detail.

               Linus

---

Adam Jackson (1):
      drm/nouveau: Fix bandwidth calculation for DisplayPort

Alan Cox (1):
      n_gsm: Fix timings

Alex Deucher (7):
      drm/radeon/kms: fix use of vram scratch page on evergreen/ni
      drm/radeon/kms: make an aux failure debug only
      drm/radeon/kms: remove extraneous calls to radeon_pm_compute_clocks()
      drm/radeon/kms/pm: add a proper pm profile init function for fusion
      drm/radeon/kms: optimize r600_pm_profile_init
      drm/radeon/kms/pm: switch to dynamically allocating clock mode array
      drm/radeon/kms/combios: fix dynamic allocation of PM clock modes

Alexander Graf (1):
      powerpc/kvm: Fix build failure with HV KVM and CBE

Alexey Fisher (1):
      ALSA: snd_usb_audio: add Logitech HD Webcam c510 to quirk-384

Andrew Jones (3):
      ktest: Create outputdir if it does not exist
      ktest: Only need to save .config when doing mrproper
      ktest: Include monitor in reboot code

Anton Blanchard (1):
      powerpc: Add System RAM to /proc/iomem

Anton Vorontsov (1):
      pata_of_platform: Don't use NO_IRQ

Arne Jansen (1):
      Btrfs: handle bio_add_page failure gracefully in scrub

Axel Lin (4):
      hwspinlock/u8500: include linux/module.h
      hwspinlock: Don't return a value in __hwspin_unlock
      hwspinlock/u8500: fix build error due to undefined label
      [CPUFREQ] db8500: fix build error due to undeclared i variable

Barry Song (1):
      pinctrl: fix "warning: 'struct pinctrl_dev' declared inside
parameter list"

Ben Skeggs (12):
      drm: make sure drm_vblank_init() has been called before touching vbl_lock
      drm/nouveau: fix oops if i2c bus not found in nouveau_i2c_identify()
      drm/nv50/bios: fixup mpll programming from the init table parser
      drm/nv50/gr: typo fix, how about we not reset fifo during graph init?
      drm/nv50/vram: fix incorrect detection of bank count on newer chipsets
      drm/nv40/pm: fix issues on igp chipsets, which don't have memory
      drm/nvc0/vram: skip disabled PBFB subunits
      drm/nvc0: enable acceleration on 0xc8 by default
      drm/nvc0/gr: fix some bugs in grctx generation
      drm/nvc1: hacky workaround to fix accel issues
      drm/nvc0/gr: fixup the mmio list register writes for 0xc1
      drm/nvc0: enable acceleration for nvc1 by default

Carlos Maiolino (1):
      xfs: Fix possible memory corruption in xfs_readlink

Chris Dunlop (1):
      sata_sis.c: trivial spelling fix

Chris Mason (2):
      Btrfs: fix oops on NULL trans handle in btrfs_truncate
      Btrfs: tweak the delayed inode reservations again

Christoph Bumiller (1):
      drm/nvc0/vram: storage type 0xc3 is not compressed

Christoph Hellwig (2):
      xfs: constify xfs_item_ops
      xfs: fix force shutdown handling in xfs_end_io

Dan Carpenter (4):
      drm/i915: fix if statement (bogus semi-colon)
      drm/nouveau: testing the wrong variable
      drm/radeon/benchmark: signedness bug in radeon_benchmark_move()
      hfs: add sanity check for file name length

Dan Williams (1):
      md/raid5: STRIPE_ACTIVE has lock semantics, add barriers

David Daney (1):
      kbuild: Fix missing system calls check on mips.

David Henningsson (1):
      ALSA: HDA: Remove quirk for Toshiba T110

David S. Miller (1):
      sparc: Hook up process_vm_{readv,writev} syscalls.

David Sterba (1):
      btrfs: rename the option to nospace_cache

Denis V. Lunev (1):
      ALSA: intel8x0: Improve comments for VM optimization

Dipankar Sarma (1):
      powerpc/numa: NUMA topology support for PowerNV

Dirk Behme (1):
      ARM: mxc: Remove test_for_ltirq

Dominik Brodowski (1):
      PM / QoS: Set cpu_dma_pm_qos->name

Eric Anholt (1):
      drm/i915: Fix object refcount leak on mmappable size limit error path.

Feng Tang (1):
      vrtc: change its year offset from 1960 to 1972

Finn Thain (1):
      m68k/mac: Remove mac_irq_{en,dis}able() wrappers

Francisco Jerez (1):
      drm/nv10: Change the BO size threshold determining the memory
placement range.

Geert Uytterhoeven (28):
      m68k: Revive lost ARAnyM config options
      m68k: Revive lost DIO bus config option
      ide-{cd,floppy,tape}: Do not include <linux/irq.h>
      m68k/irq: Rename irq_controller to irq_chip
      m68k/irq: Kill irq_node_t typedef, always use struct irq_node
      m68k/irq: Rename irq_node to irq_data
      m68k/irq: Switch irq_chip methods to "struct irq_data *data"
      m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
      m68k/irq: Extract irq_set_chip()
      m68k/irq: Add m68k_setup_irq_controller()
      m68k/irq: Rename {,__}m68k_handle_int()
      m68k/irq: Remove obsolete IRQ_FLG_* users
      m68k/irq: Add genirq support
      m68k/atari: Convert Atari to genirq
      m68k/atari: Remove code and comments about different irq types
      m68k/amiga: Refactor amiints.c
      m68k/amiga: Convert Amiga to genirq
      m68k/amiga: Optimize interrupts using chain handlers
      m68k/mac: Convert Mac to genirq
      m68k/mac: Optimize interrupts using chain handlers
      m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
      m68k/vme: Convert VME to genirq
      m68k/apollo: Convert Apollo to genirq
      m68k/sun3: Use the kstat_irqs_cpu() wrapper
      m68k/sun3: Convert Sun3/3x to genirq
      m68k/q40: Convert Q40/Q60 to genirq
      m68k/irq: Remove obsolete m68k irq framework
      m68k/irq: Remove obsolete support for user vector interrupt fixups

Geoff Levand (2):
      powerpc/ps3: Fix PS3 repository build warnings
      powerpc/ps3: Fix lv1_gpu_attribute hcall

Gwendal Grignou (1):
      [libata] Issue SRST to Sil3726 PMP

Hans de Goede (5):
      [media] uvcvideo: GET_RES should only be checked for BITMAP type
menu controls
      [media] v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
      [media] v4l2-event: Remove pending events from fh event queue
when unsubscribing
      [media] v4l2-event: Don't set sev->fh to NULL on unsubscribe
      [media] v4l2-ctrl: Send change events to all fh for auto cluster
slave controls

Heiko Schocher (2):
      powerpc/5200: add support for charon board
      powerpc, tqm5200: update tqm5200_defconfig to fit for charon board.

Herbert Xu (1):
      crypto: algapi - Fix build problem with NET disabled

Ilija Hadzic (2):
      drm: do not sleep on vblank while holding a mutex
      drm: add some comments to drm_wait_vblank and drm_queue_vblank_event

Ilya Dryomov (5):
      Btrfs: fix memory leak in btrfs_parse_early_options()
      Btrfs: fix subvol_name leak on error in btrfs_mount()
      Btrfs: avoid null dereference and leaks when bailing from open_ctree()
      Btrfs: close devices on all error paths in open_ctree()
      Btrfs: rework error handling in btrfs_mount()

Inki Dae (1):
      drm/exynos: added padding to be 64-bit align.

Jakob Bornecrantz (3):
      vmwgfx: Close screen object system
      vmwgfx: Initialize clip rect loop correctly in surface dirty
      vmwgfx: Only allow 64x64 cursors

Jamie Iles (1):
      ARM: picoxcell: add extra temp register to addruart

Jason Liu (2):
      ARM:i.MX: fix build error in tzic/avic.c
      ARM:i.MX: fix build error in clock-mx51-mx53.c

Jean-Christophe PLAGNIOL-VILLARD (4):
      ARM: at91: usart: drop static map regs for dbgu
      at91: vmalloc fix missing AT91_VIRT_BASE define
      at91/yl-9200: Fix section mismatch
      atmel/spi: fix missing probe

Jeongtae Park (1):
      [media] MAINTAINERS: add a maintainer for s5p-mfc driver

Jesse Barnes (1):
      drm: try to restore previous CRTC config if mode set fails

JiSheng Zhang (1):
      ahci_platform: use dev_get_platdata()

Jochen Friedrich (1):
      ARM: at91: Fix USBA gadget registration

Jonas Gorski (1):
      MTD: MAPS: bcm963xx-flash.c: explicitly include module.h

Jonathan Corbet (2):
      crypto: user - Fix rwsem leak in crypto_user
      PM / devfreq: fix private_data

Josef Bacik (2):
      Btrfs: fix our reservations for updating an inode when completing io
      Btrfs: only map pages if we know we need them when reading the space cache

Julian Wollrath (1):
      ALSA: hda - fix internal mic on Dell Vostro 3500 laptop

Kamil Debski (1):
      [media] v4l: s5p-mfc: fix reported capabilities

Keith Packard (1):
      agp: iommu_gfx_mapped only available if CONFIG_INTEL_IOMMU is set

Keng-Yu Lin (1):
      [libata] ahci: Add ASMedia ASM1061 support

Kevin Hilman (1):
      gpio/omap: replace MOD_REG_BIT macro with static inline

Konstantin Ozerkov (2):
      ALSA: intel8x0: move virtual environment detection code into one place
      ALSA: intel8x0: improve virtual environment detection

Kuninori Morimoto (9):
      sh: clkfwk: add clk_rate_mult_range_round()
      mailmap: Fix up some renesas attributions
      ARM: mach-shmobile: sh73a0: add MMC data pin pull-up
      ARM: mach-shmobile: kota2: add comment out separator
      ARM: mach-shmobile: clock-sh7372: remove un-necessary index
      ARM: mach-shmobile: ap4evb: remove white space from end of line
      ARM: mach-shmobile: move helper macro PORT_DATA_xx to sh_pfc.h
      ARM: mach-shmobile: move helper macro PORT_xx to sh_pfc.h
      ARM: mach-shmobile: move helper macro PORTCR to sh_pfc.h

Kyungmin Park (1):
      MAINTAINERS: exynos: Add EXYNOS DRM maintainer entry

Lars-Peter Clausen (1):
      blackfin: Fixup export.h includes

Linus Torvalds (4):
      x86 platform drivers: make Dell laptop driver select needed LED support
      x86 platform drivers: add POWER_SUPPLY to selected drivers for Dell
      Revert "proc: fix races against execve() of /proc/PID/fd**"
      Linux 3.2-rc2

Linus Walleij (1):
      pinctrl: hide subsystem from the populace

Liu Gang (1):
      fsl-rio: fix compile error

Magnus Damm (1):
      ARM: mach-shmobile: cpuidle single/global and last_state fixes

Marc Zyngier (2):
      ARM: mxc: fix local timer interrupt handling
      ARM: msm: fix compilation flags for MSM_SCM

Marcin Slusarz (3):
      drm/nouveau: initialize chan->fence.lock before use
      drm/nouveau: by default use low bpp framebuffer on low memory cards
      drm: serialize access to list of debugfs files

Marcos Paulo de Souza (1):
      [libata] libata-scsi.c: Add function parameter documentation

Marek Szyprowski (3):
      [media] media: vb2: add a check for uninitialized buffer
      [media] media: vb2: set buffer length correctly for all buffer types
      [media] media: vb2: reset queued list on REQBUFS(0) call

Mark Brown (4):
      ASoC: Update git repository URL
      ASoC: Don't use wm8994->control_data in wm8994_readable_register()
      ASoC: Don't use wm8994->control_data when requesting IRQs
      ASoC: Ensure we get an impedence reported for WM8958 jack detect

Maxim Levitsky (1):
      drm/nv50: fix stability issue on NV86.

Miao Xie (6):
      Btrfs: fix nocow when deleting the item
      Btrfs: fix no reserved space for writing out inode cache
      Btrfs: fix unreleased path in btrfs_orphan_cleanup()
      Btrfs: Abstract similar code for btrfs_block_rsv_add{, _noflush}
      Btrfs: fix orphan backref nodes
      Btrfs: fix deadlock caused by the race between relocation

Michael Krufky (4):
      [media] mxl111sf: fix return value of mxl111sf_idac_config
      [media] mxl111sf: check for errors after mxl111sf_write_reg in
mxl111sf_idac_config
      [media] mxl111sf: remove pointless if condition in mxl111sf_config_spi
      [media] mxl111sf: fix build warning

Michael Neuling (1):
      powerpc: Add KVM as module to defconfigs

Michael S. Tsirkin (1):
      virtio-pci: fix use after free

Michael Witten (45):
      DocBook/drm: Eradicate inappropriate uses of the future tense
      DocBook/drm: can -> may
      DocBook/drm: Clean up code comment
      DocBook/drm: Use a semicolon
      DocBook/drm: a -> an
      DocBook/drm: , -> .
      DocBook/drm: Move `should be set' to the beginning of the sentence
      DocBook/drm: Clean up `pre-memory management aware'
      DocBook/drm: Rearrange wording to make more sense
      DocBook/drm: Replace the paragraph's first sentence with its last sentence
      DocBook/drm: Better wording
      DocBook/drm: Clearer wording with `for consumption by'
      DocBook/drm: Insert missing `that'
      DocBook/drm: Insert missing `an'
      DocBook/drm: `setup' is the noun; `to set up' is the verb
      DocBook/drm: `at driver load time' -> `when the driver is loaded'
      DocBook/drm: Use the passive voice
      DocBook/drm: Offset modifiers with commas
      DocBook/drm: can -> could
      DocBook/drm: , -> :
      DocBook/drm: Insert missing comma
      DocBook/drm: Remove parentheses and unnecessary repetition
      DocBook/drm: Insert `()' after function name
      DocBook/drm: Streamline wording of GEM initialization
      DocBook/drm: basic -> core
      DocBook/drm: Use a singular subject for grammatical cleanliness
      DocBook/drm: The word `so-called'; I do not think it connotes
what you think it connotes
      DocBook/drm: Insert `it' for smooth reading
      DocBook/drm: Remove redundancy
      DocBook/drm: Clarify `final initialization' via better formatting
      DocBook/drm: Use a colon
      DocBook/drm: Remove extraneous commas
      DocBook/drm: Insert `the' for readability, and change `set' to `setting'
      DocBook/drm: Use an itemizedlist for what an encoder needs to provide
      DocBook/drm: Use a <variablelist> for vblank ioctls
      DocBook/drm: Insert a comma
      DocBook/drm: Use an <itemizelist> for fundamental GEM operations
      DocBook/drm: Improve flow of GPU/CPU coherence sentence
      DocBook/drm: Refer to the domain-setting function as a
device-specific ioctl
      DocBook/drm: Better flow with `, and then'
      DocBook/drm: Use `; otherwise,'
      DocBook/drm: Clean up the paragraph on framebuffer objects
      DocBook/drm: `(device|driver) specific' -> `(device|driver)-specific'
      DocBook/drm: `device aware' -> `device-aware'
      DocBook/drm: Clean up a todo-note

Michel Dänzer (1):
      drm/radeon: Make sure CS mutex is held across GPU reset.

Ming Lei (1):
      iommu: omap: Fix compile failure

NeilBrown (1):
      md/raid5: abort any pending parity operations when array fails.

Nishanth Aravamudan (1):
      powerpc/kvm: Fix build with older toolchains

Nobuhiro Iwamatsu (1):
      sh: Fix cached/uncaced address calculation in 29bit mode

Paul Bolle (1):
      drm: drop select of SLOW_WORK

Paul Gortmaker (2):
      mfd: fix build failures in recently added ab5500 code
      drivers/media: video/a5k6aa is a module and so needs module.h

Paul Mundt (4):
      sh: Wire up process_vm syscalls.
      drivers: sh: Generalize runtime PM platform stub.
      drivers: sh: Kill off dead pathname for runtime PM stub.
      sh: clkfwk: Kill off remaining debugfs cruft.

Phil Edworthy (1):
      serial: sh-sci: Fix up SH-2A SCIF support.

Rafael J. Wysocki (2):
      Documentation: Fix typo in freezer-subsystem.txt
      ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)

Randy Dunlap (1):
      drm: fix kconfig unmet dependency warning

Richard Zhao (1):
      ARM: mx51/53: set pwm clock parent to ipg_perclk

Shawn Guo (4):
      arm/mxs: fix mmc device adding for mach-mx28evk
      arm/imx: fix the references to ARCH_MX3
      arm/imx: fix AUTO_ZRELADDR selection
      arm/imx: fix imx6q mmc error when mounting rootfs

Sonic Zhang (1):
      Blackfin: add serial TX IRQ in individual platform resource

Stephen Boyd (1):
      msm: boards: Fix fallout from removal of machine_desc in fixup

Stephen Warren (2):
      arm/tegra: Don't create duplicate gpio and pinmux devices
      arm/dt: Fix ventana SDHCI power-gpios

Steven Rostedt (18):
      ktest: Add TEST_TYPE install option
      ktest: Fail when grub menu not found
      ktest: Add NO_INSTALL option to not install for a test
      ktest: Add option REBOOT_SUCCESS_LINE to stop waiting after a reboot
      ktest: Do not reboot on config or build issues
      ktest: Add IF and ELSE to config sections
      ktest: Let IF keyword take comparisons
      ktest: Add INCLUDE keyword to include other config files
      ktest: Consolidate TEST_TYPE and DEFAULT code
      ktest: Add OVERRIDE keyword to DEFAULTS section
      ktest: Add DEFINED keyword for IF statements
      ktest: Sort make_min_config configs by dependecies
      ktest: Fix parsing of config section lines
      ktest: Add processing of complex conditionals
      ktest: Do not opencode reboot in grub setting
      ktest: Add another monitor flush before installing kernel
      ktest: Add variable ${PWD}
      ktest: Evaluate variables entered on the command line

Takashi Iwai (5):
      ALSA: hda - Mute unused capture sources for Realtek codecs
      ALSA: usb-audio - Fix the missing volume quirks at delayed init
      ALSA: hda - Don't add elements of other codecs to vmaster slave
      ALSA: vmaster - Free slave-links when freeing the master element
      ALSA: hda - Re-enable the check NO_PRESENCE misc bit

Thomas Meyer (2):
      PM / OPP: Use ERR_CAST instead of ERR_PTR(PTR_ERR())
      ALSA: usb-audio: Use kmemdup rather than duplicating its implementation

Todd Poynor (1):
      gpio/omap: check return value from irq_alloc_generic_chip

Vinson Lee (1):
      drm: Ensure string is null terminated.

William Douglas (1):
      bma023: Add SFI translation for this device

Wolfram Sang (2):
      gpio: pca953x: remove unneeded check for chip type
      gpio: pca953x: propagate the errno from the chip_init functions

Yong Zhang (2):
      powerpc/irq: Remove IRQF_DISABLED
      powerpc/ps3: irq: Remove IRQF_DISABLED

Yufeng Shen (1):
      arm/tegra: enable headphone detection gpio on seaboard

Zhang Rui (1):
      ce4100: fix a build error

slyich@gmail.com (1):
      btrfs: fix double-free 'tree_root' in 'btrfs_mount()'
