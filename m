Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0EJB4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 21:56:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774Ab0EJB4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 21:56:45 -0400
Date: Sun, 9 May 2010 18:54:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.34-rc7
Message-ID: <alpine.LFD.2.00.1005091849390.3711@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think this is the last -rc - things have been pretty quiet on the patch 
front, although there's been some rather spirited discussions.

Random fixes all around, some of them RCU related (people fixing various 
RCU sanity check warnings), but most of them just random driver fixes. And 
there's some MIPS, microblaze and ARM updates, and ocfs2 and ceph fixes.

The shortlog is about as informative as anything else - nothing there 
stands out in my mind, it's just a lot of small random stuff.

		Linus


---
Ajay Kumar Gupta (2):
      musb: fix power field to hold all possible values
      musb: save and restore missing bus control register

Alan Cox (1):
      tty: Fix regressions in the char driver conversion

Alan Stern (2):
      USB: don't choose configs with no interfaces
      USB: OHCI: don't look at the root hub to get the number of ports

Alex Chiang (1):
      ACPI: DMI init_set_sci_en_on_resume for multiple Lenovo ThinkPads

Alex Deucher (2):
      drm/radeon/kms: fix panel scaling adjusted mode setup
      drm/radeon/kms/legacy: only enable load detection property on DVI-I

Anand Gadiyar (1):
      USB: fix build on OMAPs if CONFIG_PM_RUNTIME is not set

Andrew Morton (2):
      Staging: iio: fix up the iio_get_new_idr_val comment
      arch/arm/include/asm/elf.h: forward-declare the task-struct

Anisse Astier (1):
      ALSA: hda - Add quirk for Dell Inspiron 19T using a Conexant CX20582

Anton Blanchard (1):
      e1000e: Fix oops caused by ASPM patch.

Arjan van de Ven (1):
      cpuidle: Fix incorrect optimization

Arnaud Patard (3):
      MIPS: Loongson: Fix typo in gdium mach type string.
      MIPS: Loongson: Fix phys_mem_access_prot() check
      MIPS: Loongson: Fix LOONGSON_ADDRWIN_CFG macro.

Benjamin Herrenschmidt (1):
      mutex: Don't spin when the owner CPU is offline or other weird cases

Bjorn Helgaas (2):
      PNPACPI: compute Address Space length rather than using _LEN
      PNP: don't check for conflicts with bridge windows

Bjørn Mork (1):
      V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer 	dereference"

Borislav Petkov (1):
      edac, mce: Fix wrong mask and macro usage

Brian J. Tarricone (1):
      ALSA: hda - fix array indexing while creating inputs for Cirrus codecs

Catalin Marinas (1):
      ARM: 6093/1: Fix kernel memory printing for sparsemem

Chris Largret (1):
      Staging: rt2860: add Belkin F5D8055 Wireless-N USB Dongle device id

Christoph Fritz (1):
      Input: joydev - allow binding to button-only devices

Coly Li (1):
      ocfs2: one more warning fix in ocfs2_file_aio_write(), v2

Cyrill Gorcunov (1):
      Staging: hv: Fix up memory leak on HvCleanup

Dan Carpenter (18):
      ocfs2: potential ERR_PTR dereference on error paths
      ACPI: silence kmemcheck false positive
      gpio: potential null dereference
      of: check for IS_ERR()
      drivers/gpu/drm/via/via_video.c: fix off by one issue
      drivers/gpu/drm/drm_memory.c: fix check for end of loop
      drivers/gpu/drm/radeon/radeon_atombios.c: range check issues
      drivers/gpu/drm/drm_sysfs.c: sysfs files error handling
      musb: potential use after free
      USB: fix testing the wrong variable in fs_create_by_name()
      USB: oxu210hp: release spinlock on error path
      Staging: iio: test for failed allocation
      ALSA: take tu->qlock with irqs disabled
      acpi_pad: "processor_aggregator" name too long
      power_meter: acpi_device_class "power_meter_resource" too long
      sbshc: acpi_device_class "smbus_host_controller" too long
      V4L/DVB: omap24xxcam: potential buffer overflow
      V4L/DVB: video: testing unsigned for less than 0

Dan Williams (1):
      raid6: fix recovery performance regression

Daniel Mack (3):
      Input: eeti_ts - cancel pending work when going to suspend
      USB: rename usb_buffer_alloc() and usb_buffer_free()
      [ARM] pxa/raumfeld: fix button name

Daniel T Chen (3):
      ALSA: hda: Use olpc-xo-1_5 quirk for Toshiba Satellite Pro T130-15F
      ALSA: hda: Use olpc-xo-1_5 quirk for Toshiba Satellite P500-PSPGSC-01800T
      ALSA: hda: Fix 0 dB for Packard Bell models using Conexant CX20549 (Venice)

David Daney (7):
      MIPS: Don't vmap things at address zero.
      MIPS: Add uasm_i_dsrl_safe() and uasm_i_dsll_safe() to uasm.
      MIPS: Use uasm_i_ds{r,l}l_safe() instead of uasm_i_ds{r,l}l() in tlbex.c
      MIPS: Check for accesses beyond the end of the PGD.
      I2C: Fix section mismatch errors in i2c-octeon.c
      NET: mdio-octeon: Enable the hardware before using it.
      STAGING: octeon-ethernet: Use proper phy addresses for Movidis hardware.

David Howells (8):
      NFS: Fix RCU issues in the NFSv4 delegation code
      KEYS: Fix an RCU warning
      KEYS: Fix an RCU warning in the reading of user keys
      Fix the x86_64 implementation of call_rwsem_wait()
      KEYS: Fix an RCU warning in the reading of user keys
      KEYS: Fix RCU handling in key_gc_keyring()
      KEYS: Use RCU dereference wrappers in keyring key type code
      KEYS: call_sbin_request_key() must write lock keyrings before modifying them

David J. Choi (1):
      drivers/net/phy: micrel phy driver

David S. Miller (2):
      net: ep93xx_eth stops receiving packets
      ipv6: Fix default multicast hops setting.

Dinh Nguyen (1):
      mx5: Fix build error for mx51_defconfig

Dmitry Artamonow (2):
      ARM: 6075/1: SA1100: fix wrong CPU type for h3100 and h3600
      ARM: 6076/1: SA1100: add processor check to sa1110-cpufreq driver

Dmitry Torokhov (2):
      Input: psmouse - ignore parity error for basic protocols
      Revert "Input: ALPS - add signature for HP Pavilion dm3 laptops"

Dominik Brodowski (3):
      USB: option: add ID for ZTE MF 330
      pcmcia: avoid pccard_validate_cis failure in resume callpath
      pcmcia: order userspace suspend and resume requests

Douglas Gilbert (1):
      [SCSI] scsi_debug: virtual_gb ignores sector_size

Elina Pasheva (2):
      net/usb: remove default in Kconfig for sierra_net driver
      net/usb: initiate sync sequence in sierra_net.c driver

Eric Dumazet (1):
      r8169: Fix rtl8169_rx_interrupt()

Eric Lescouet (1):
      staging: usbip: Fix deadlock

Erik Andrén (1):
      V4L/DVB: gspca - stv06xx: Remove the 046d:08da from the stv06xx driver

Florian Fainelli (2):
      MIPS: BCM63xx: Update defconfig
      MIPS: Kconfig: Make Broadcom SoC support naming consistent

Florian Ragwitz (3):
      Input: elantech - fix firmware version check
      Input: elantech - allow forcing Elantech protocol
      Input: elantech - ignore high bits in the position coordinates

Gabriele A. Trombetti (1):
      md/raid6: Fix raid-6 read-error correction in degraded state

Geert Uytterhoeven (1):
      MIPS: TXx9: Add missing MODULE_ALIAS definitions for TXx9 platform devices

Greg Kroah-Hartman (1):
      USB: serial: option: add cinterion device id

Guennadi Liakhovetski (3):
      SH: fix TS field shift calculation for DMA drivers
      SH: fix error paths in DMA driver
      sh: fix a number of Oopses and leaks in SH framebuffer driver

H Hartley Sweeten (1):
      Staging: dt3155: fix 50Hz configuration

Haiyang Zhang (1):
      Staging: hv: Fix a bug affecting IPv6

Hannes Reinecke (1):
      [SCSI] Enable retries for SYNCRONIZE_CACHE commands to fix I/O error

Hans Verkuil (3):
      V4L/DVB: feature-removal: announce videotext.h removal
      V4L/DVB: v4l: fix config dependencies: mxb and saa7191 are V4L2 drivers, not V4L1
      V4L/DVB: saa7146: fix regression of the av7110/budget-av driver

Hans de Goede (1):
      p54pci: fix bugs in p54p_check_tx_ring

Haojian Zhuang (2):
      [ARM] pxa: update cpuid pattern for pxa9xx in head.S
      [ARM] pxa: fix the incorrect cpu_is_pxa950()

Hector Palacios (1):
      spi: spidev_test gives error upon 1-byte transfer

Herton Ronaldo Krzesinski (1):
      [SCSI] advansys: fix narrow board error path

Igor Grinberg (1):
      [ARM] pxa: add missing new line to regs-u2d.h

Ingo Molnar (1):
      x86: Fix parse_reservetop() build failure on certain configs

Jakob Viketoft (1):
      [ARM] pxa/colibri: fix missing #include <mach/mfp.h> in colibri.h

James Bottomley (1):
      [SCSI] Retry commands with UNIT_ATTENTION sense codes to fix ext3/ext4 I/O error

Jan Engelhardt (1):
      net: fix compile error due to double return type in SOCK_DEBUG

Jarod Wilson (1):
      Input: ati_remote - add some missing devices from lirc_atiusb

Jean Delvare (2):
      i2c: Fix probing of FSC hardware monitoring chips
      i2c-core: Use per-adapter userspace device lists

Jeff Garzik (1):
      [MTD] Remove zero-length files mtdbdi.c and internal.ho

Jerome Glisse (1):
      drm/radeon: async event synchronization for drmWaitVblank

Jiri Slaby (1):
      gpu: vga_switcheroo, fix lock imbalance

Joel Becker (3):
      ocfs2: Compute metaecc for superblocks during online resize.
      ocfs2_dlmfs: Fix math error when reading LVB.
      ocfs2: Avoid a gcc warning in ocfs2_wipe_inode().

John Ellson (1):
      V4L/DVB: gspca: make usb id 0461:0815 get handled by the right driver

Jonathan Cameron (2):
      staging: iio: lis3l02dq - incorrect ws used in container of call.
      staging: iio: ring_sw: Fix incorrect test on successful read of last value, causes infinite loop

Julia Lawall (3):
      serial: drivers/serial/pmac_zilog.c: add missing unlock
      USB: gadget: s3c-hsotg: Add missing unlock
      arch/arm/plat-pxa/dma.c: correct NULL test

Kamal Mostafa (1):
      ACPI: sleep: init_set_sci_en_on_resume for Dell Studio 155x

Kristoffer Ericson (1):
      pata_pcmcia / ide-cs: Fix bad hashes for Transcend and kingston IDs

Krzysztof Helt (1):
      ALSA: es968: fix wrong PnP dma index

Lars Ellenberg (1):
      drbd: don't expose failed local READ to upper layers

Li Dongyang (4):
      ocfs2: add OCFS2_INODE_SKIP_ORPHAN_DIR flag and honor it in the inode wipe code
      ocfs2: use OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_symlink error path
      ocfs2: use OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_mknod error path
      ocfs2: Avoid direct write if we fall back to buffered I/O

Li Zefan (5):
      cgroup: Fix an RCU warning in cgroup_path()
      cgroup: Fix an RCU warning in alloc_css_id()
      sched: Fix an RCU warning in print_task()
      cgroup: Check task_lock in task_subsys_state()
      blk-cgroup: Fix an RCU warning in blkiocg_create()

Liang Li (1):
      x86: Fix 'reservetop=' functionality

Linus Torvalds (1):
      Linux 2.6.34-rc7

Magnus Damm (2):
      sh: Fix maximum number of SCIF ports in R2D defconfigs
      sh: sh7751 pci controller io port fix

Mahesh Kuruganti (1):
      USB: serial: option: ZTEAC8710 Support with Device ID 0xffff

Manuel Lauss (1):
      MIPS: DB1200: PCMCIA card detection must not be auto-enabled.

Marc Zyngier (1):
      pcmcia: fix compilation after 16bit state locking changes

Marek Ol¨ák (1):
      drm/radeon/kms: r300 fix CS checker to allow zbuffer-only fastfill

Mark Fasheh (1):
      ocfs2: Add directory entry later in ocfs2_symlink() and ocfs2_mknod()

Mark Langsdorf (1):
      powernow-k8: Fix frequency reporting

Martyn Welch (1):
      Staging: vme: Re-introduce necessary brackets

Mattias Walström (1):
      FEC: Fix kernel panic in fec_set_mac_address.

Michael Hennerich (1):
      USB: sl811-hcd: Fix device disconnect

Michael Hunold (1):
      V4L/DVB: saa7146: fix up bytesperline if it is an impossible value

Michal Simek (16):
      microblaze: PCI: add pci_bus_for_each_resource(), remove direct bus->resource[] refs
      microblaze: resource/PCI: align functions now return start of resource
      microblaze: Quiet section mismatch warnings for MMU version
      microblaze: Remove ancient code
      microblaze: Add isa_dma_bridge_buggy to dma.h
      microblaze: Remove "cache" optimized copy_page function
      microblaze: page.h: Remove get_user_page and free_user_page
      microblaze: pci-dma: use include/linux/dma-mapping.h
      microblaze: Fix consistent code
      microblaze: Fix typo fault in cache code
      microblaze: Fix kmalloc alignment on non-coherent DMA platforms
      microblaze: cpuinfo shows cache line length
      microblaze: Define correct L1_CACHE_SHIFT value
      microblaze: Fix consistent-sync code
      microblaze: Optimize CACHE_LOOP_LIMITS and CACHE_RANGE_LOOP macros
      microblaze: Defconfig update

Mike Christie (1):
      [SCSI] libiscsi: regression: fix header digest errors

Murali Karicheri (1):
      V4L/DVB: V4L: vpfe_capture - free ccdc_lock when memory allocation fails

Muralidharan Karicheri (1):
      V4L/DVB: V4L - vpfe capture - fix for kernel crash

Neil Horman (1):
      sctp: Fix skb_over_panic resulting from multiple invalid parameter errors (CVE-2010-1173) (v4)

NeilBrown (1):
      md: restore ability of spare drives to spin down.

Nick Piggin (1):
      microblaze: invoke oom-killer from page fault

Oleg Nesterov (1):
      workqueue: flush_delayed_work: keep the original workqueue for re-queueing

Oliver Endriss (1):
      V4L/DVB: ngene: Workaround for stuck DiSEqC pin

Patrice Vilchez (1):
      USB: ohci-at91: fix power management hanging

Paul E. McKenney (3):
      rcu: Fix RCU lockdep splat on freezer_fork path
      memcg: css_id() must be called under rcu_read_lock()
      rcu: create rcu_my_thread_group_empty() wrapper

Pavel Machek (1):
      [ARM] pxa/spitz: fix On/off key name to fix warning during boot

Pavel Roskin (1):
      Staging: rtl8192su: add USB ID for 0bda:8171

Peter Korsgaard (1):
      dm9601: fix phy/eeprom write routine

Peter Zijlstra (1):
      rcu: Fix RCU lockdep splat in set_task_cpu on fork path

Ping Cheng (1):
      serial: 8250_pnp - add Fujitsu Wacom device

Prarit Bhargava (1):
      x86: Fix NULL pointer access in irq_force_complete_move() for Xen guests

Ralf Baechle (3):
      Inotify: Fix build failure in inotify user support
      MIPS: PNX8550: Fix build error, broken by:
      MIPS: cmpxchg.h: Fix excessive indentation.

Randy Dunlap (2):
      USB: ti_usb: fix printk format warning
      microblaze: fix divide by zero exception message

Richard Airlie (1):
      staging: rtl8192su: add Support for Belkin F5D8053 v6

Richard LIU (1):
      MIPS: Loongson: Fix find_vga_mem_init()

Robert Fitzsimons (1):
      drm/radeon/kms/agp The wrong AGP chipset can cause a NULL pointer dereference

Rodrigo Linfati (1):
      Staging: add Add Sitecom WL-349 to rtl8192su

Roman Tereshonkov (4):
      spi: release device claimed by bus_find_device_by_name
      spi: spi_device memory should be released instead of device.
      omap2_mcspi: Flush posted writes
      omap2_mcspi: small fixes of output data format

Russ Nelson (1):
      USB: cdc-acm: add another device quirk

Russell King (1):
      ARM: Update mach-types

Ryusuke Konishi (1):
      nilfs2: fix sync silent failure

Sage Weil (11):
      ceph: clear dir complete on d_move
      ceph: fix snap realm splits
      ceph: print more useful version info on module load
      ceph: fix leaked spinlock during mds reconnect
      ceph: add missing #includes
      ceph: fix seq counting for skipped messages
      ceph: discard incoming messages with bad seq #
      ceph: fix direct io truncate offset
      ceph: clear dir complete, invalidate dentry on replayed rename
      ceph: fix lockless caps check
      ceph: remove bad auth_x kmem_cache

Santosh Shilimkar (2):
      ARM: 6068/1: Fix build break with KPROBES enabled
      ARM: 6066/1: Fix "BUG: scheduling while atomic: swapper/0/0x00000002

Sarah Sharp (2):
      USB: xhci: properly set the "Mult" field of the endpoint context.
      USB: xhci: properly set endpoint context fields for periodic eps.

Sebastian Andrzej Siewior (4):
      MIPS: Fixup screen_info struct initializations
      MIPS: SB1250: Include correct header and fix a warning
      MIPS: Swarm, Littlesur: Enable PATA platform driver.
      MIPS: Use CKSEG1ADDR for uncached handler

Sebastian Siewior (1):
      net/sb1250: register mdio bus in probe

Sergei Shtylyov (9):
      MUSB: Blackfin: don't fake blackfin_interrupt() result
      musb_core: don't touch 'musb->clock' in musb_free()
      musb_core: don't prevent disabling clock on driver unload
      MUSB: DaVinci: fix musb_platform_init() error cleanup path
      MUSB: OMAP: don't call clk_put()
      musb_core: don't call musb_platform_exit() twice
      MUSB: fix DaVinci glue layer dependency
      musb_core: fix musb_init_controller() error cleanup path
      libata: Fix several inaccuracies in developer's guide

Shaohua Li (1):
      ACPI: fix acpi_hest_firmware_first_pci() caused oops

Simon Arlott (2):
      ppp_generic: pull 2 bytes so that PPP_PROTO(skb) is valid
      ppp_generic: handle non-linear skbs when passing them to pppd

Simone Contini (1):
      USB: serial: pl2303: Hybrid reader Uniform HCR331

Sonic Zhang (1):
      staging: iio: Function iio_get_new_idr_val() return negative value if fails.

Stefan Herbrechtsmeier (1):
      V4L/DVB: pxa_camera: move fifo reset direct before dma start

Stefan Schmidt (1):
      [ARM] pxa/imote2: Fix iMote2 defconfig

Stephen Hemminger (1):
      Staging: hv: name network device ethX rather than sethX

Steven J. Magnani (2):
      microblaze: Fix IRQ entry/exit ftracing
      microblaze: Quiet section mismatch warnings

Stijn Tintel (1):
      virtio: initialize earlier

Takashi Iwai (1):
      Input: Add support of Synaptics Clickpad device

Tao Ma (3):
      ocfs2_dlmfs: User DLM_* when decoding file open flags.
      ocfs2: Reset status if we want to restart file extension.
      ocfs2: Update VFS inode's id info after reflink.

Tejun Heo (2):
      perf: Fix resource leak in failure path of perf_event_open()
      [SCSI] fix locking around blk_abort_request()

Thomas Hellstrom (2):
      drm/ttm: Remove some leftover debug messages.
      drm/ttm: Remove the ttm_bo_block_reservation() function.

Tony Lindgren (1):
      usb: Fix tusb6010 for DMA API

Toshiyuki Okajima (1):
      KEYS: find_keyring_by_name() can gain access to a freed keyring

Trond Myklebust (1):
      NFSv4: Fix the locking in nfs_inode_reclaim_delegation()

Uwe Kleine-König (1):
      V4L/DVB: mx1-camera: compile fix

Vaibhav Hiremath (1):
      V4L/DVB: V4L - Makfile:Removed duplicate entry of davinci

Vivek Goyal (1):
      blk-cgroup: Fix RCU correctness warning in cfq_init_queue()

Wengang Wang (1):
      ocfs2: Check the owner of a lockres inside the spinlock

Wim Van Sebroeck (1):
      watchdog: ep93xx_wdt.c fix default timout value in MODULE_PARM_DESC string.

Wolfram Sang (5):
      serial/mpc52xx_uart: Drop outdated comments
      Staging: iio: light: fix dangling pointers
      Staging: iio: adc: fix dangling pointers
      i2c-core: Erase pointer to clientdata on removal
      [ARM] pxa/viper: fix timeout usage for I2C

Wu Zhangjin (5):
      MIPS: oprofile: Fix breakage when CONFIG_OPROFILE=m
      MIPS: Loongson: Add CPU_LOONGSON2F_WORKAROUNDS
      MIPS: Loongson 2F: Enable fixups of the latest binutils
      MIPS: Loongson-2F: Use CONFIG_CPU_JUMP_WORKAROUNDS to control workarounds.
      MIPS: Loongson 2F: Fix of problems introduced by -mfix-loongson2f-jump

Yong Zhang (1):
      V4L/DVB: gspca - sn9c20x: Correct onstack wait_queue_head declaration

Yury Polyanskiy (1):
      MIPS: die() does not call die notifier chain

Zhang, Yanmin (1):
      slub: Fix bad boundary check in init_kmem_cache_nodes()
