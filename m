Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab3AJDVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 22:21:46 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:43476 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3AJDVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 22:21:44 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Jan 2013 19:21:23 -0800
X-Google-Sender-Auth: D8hTLjcxQqtrCtF3FzX0rgyDdeA
Message-ID: <CA+55aFxVaXtmOj3qVs6gwegz6_MH7BJke58UsF544bN2R9Nw7Q@mail.gmail.com>
Subject: Linux 3.8-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The holidays are over, and things are starting to get back to normal.
Except for Greg, I suspect, who is probably still digging his way out
of his email hole.

Anyway, another week, another -rc. A fairly normal-sized one. Most of
the changes are in drivers, with the bulk of them being one-liners all
over that just remove the last traces of __dev[init|exit].

But apart from that, there are real updates (GPU drivers stand out -
mainly radeon and exynos), and some architecture work (arm, powerpc,
mips, microblaze), filesystems (f2fs, gfs, cifs, nfs) and networking
(netfilter and sunrpc).

And I really hope things calm down. I realize there was some pent-up
patches from the holidays, but let's make sure -rc4 really is smaller.
Ok?

                   Linus

---

Aaro Koskinen (2):
      ARM: OMAP1: fix USB configuration use-after-release
      drm/nouveau: fix init with agpgart-uninorth

Abhijith Das (1):
      GFS2: Fix race in gfs2_rs_alloc

Adrian Huang (1):
      ACPI / APEI: Fix the returned value in erst_dbg_read

Alex Deucher (10):
      drm/radeon: add connector table for Mac G4 Silver
      drm/radeon/r6xx: fix DMA engine for ttm bo transfers
      drm/radeon: fix typo in evergreen dma fence
      drm/radeon: add GPU reset flags
      drm/radeon: switch to a finer grained reset for r6xx/7xx
      drm/radeon: switch to a finer grained reset for evergreen
      drm/radeon: switch to a finer grained reset for cayman/TN
      drm/radeon: switch to a finer grained reset for SI (v2)
      drm/radeon: split r6xx and r7xx copy_dma functions
      drm/radeon: fix DMA CS parser for r6xx linear copy packet

Alex Elder (1):
      sctp: fix Kconfig bug in default cookie hmac selection

Alexander Aring (1):
      mac802154: fix NOHZ local_softirq_pending 08 warning

Alexander Schremmer (1):
      ALSA: usb-audio: Add support for Creative BT-D1 via usb sound quirks

Andrew Collins (1):
      netfilter: nf_nat: Also handle non-ESTABLISHED routing changes
in MASQUERADE

Andrew Lunn (5):
      ARM: Kirkwood: Fix missing clk for USB device.
      Power: gpio-poweroff: Fix documentation and gpio_is_valid
      ARM: Kirkwood: Fix missing sdio clock
      ARM: Kirkwood: Use fixed-regulator instead of board gpio call
      arm: mvebu: Add missing ; for cpu node.

Arend van Spriel (1):
      brcmsmac: add copyright information for Canonical

Asim Kadav (1):
      sound: oss/pas2: Fix possible access out of array

Barry Song (2):
      pinctrl: sirf: add missing DT-binding document
      pinctrl: sirf: enable GPIO pullup/down configuration from dts

Bartlomiej Zolnierkiewicz (1):
      mm: fix zone_watermark_ok_safe() accounting of isolated pages

Bjørn Mork (1):
      net: qmi_wwan: add Telekom Speedstick LTE II

Bob Hockney (1):
      netfilter: nfnetlink_log: fix mac address for 6in4 tunnels

Bob Peterson (2):
      GFS2: Stop looking for free blocks at end of rgrp
      GFS2: Reset rd_last_alloc when it reaches the end of the rgrp

Borislav Petkov (1):
      EDAC: Fix EDAC Kconfig menu

Carlos Alberto Lopez Perez (1):
      Documentation/sysctl/kernel.txt: document /proc/sys/shmall

Catalin Marinas (3):
      arm64: Include linux/ptrace.h in asm/compat.h
      arm64: Keep the ARM64 Kconfig selects sorted
      arm64: Always select ARM_AMBA and GENERIC_GPIO

Cesar Eduardo Barros (18):
      MAINTAINERS: remove drivers/platform/msm/
      MAINTAINERS: remove arch/arm/common/time-acorn.c
      MAINTAINERS: remove arch/arm/plat-s5p/
      MAINTAINERS: fix drivers/rtc/rtc-vt8500.c
      MAINTAINERS: fix arch/arm/mach-at91/include/mach/at_hdmac.h
      MAINTAINERS: fix drivers/media/platform/atmel-isi.c
      MAINTAINERS: adjust for UAPI
      MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*
      MAINTAINERS: remove drivers/video/epson1355fb.c
      MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
      MAINTAINERS: fix drivers/ieee802154/
      MAINTAINERS: remove firmware/isci/
      MAINTAINERS: remove arch/x86/platform/mrst/pmu.*
      MAINTAINERS: fix Documentation/mei/
      MAINTAINERS: remove drivers/mmc/host/imxmmc.*
      MAINTAINERS: remove arch/*/lib/perf_event*.c
      MAINTAINERS: remove include/linux/of_pwm.h
      MAINTAINERS: fix drivers/staging/sm7xx/

Christian Lamparter (2):
      carl9170: fix -EINVAL bailout during init with !CONFIG_MAC80211_MESH
      p54usb: add USBIDs for two more p54usb devices

Christophe TORDEUX (1):
      Input: sentelic - only report position of first finger as ST coordinates

Damien Zammit (1):
      ALSA: usb-audio: Fix kernel panic of Digidesign Mbox2 quirk

Daniel Lezcano (1):
      cpuidle: fix lock contention in the idle path

Daniel Vetter (1):
      drm/ttm: fix fence locking in ttm_buffer_object_transfer

David Henningsson (2):
      ALSA: hda - Switch "On" and "Off" for "Mute-LED Mode" kcontrol
      ALSA: hda - add mute LED for HP Pavilion 17 (Realtek codec)

Dmitry Torokhov (1):
      Input: gpio_keys - defer probing if GPIO probing is deferred

Eric Dumazet (2):
      netfilter: xt_recent: avoid high order page allocations
      tcp: fix MSG_SENDPAGE_NOTLAST logic

Eunchul Kim (6):
      drm/exynos: change member variable name.
      drm/exynos: remove needless error handling to property.
      drm/exynos: consider both case of vflip and hflip.
      drm/exynos: fix build warning.
      drm/exynos: correct some comments to abbreviation.
      drm/exynos: remove needless parenthesis.

Fabio Baltieri (2):
      pinctrl: nomadik: return if prcm_base is NULL
      ARM: ux500: add pinctrl address resources

Fabio Estevam (4):
      ARM: dts: imx23-olinuxino: Fix IOMUX settings
      clk: imx: Remove 'clock-output-names' from the examples
      ARM: dts: imx31-bug: Fix manufacturer compatible string
      ARM: 7612/1: imx: Do not select some errata that depends on
!ARCH_MULTIPLATFORM

Florent Fourcot (1):
      netfilter: nf_conntrack_ipv6: fix comment for packets without data

Gabor Juhos (2):
      Input: gpio_keys_polled - defer probing if GPIO probing is deferred
      powerpc: Add missing NULL terminator to avoid boot panic on PPC40x

Geert Uytterhoeven (3):
      f2fs: add missing #include <linux/prefetch.h>
      bcma: BCMA_DRIVER_GPIO should depend on GPIOLIB instead of selecting it
      ssb: SSB_DRIVER_GPIO should depend on GPIOLIB instead of selecting it

Greg Kroah-Hartman (54):
      Drivers: w1: remove last __devexit_p() instance
      Drivers: xen: remove __dev* attributes.
      Drivers: zorro: remove CONFIG_HOTPLUG usage
      Drivers: vlynq: remove __dev* attributes.
      Drivers: virtio: remove __dev* attributes.
      Drivers: video: remove __dev* attributes.
      Drivers: scsi: remove __dev* attributes.
      Drivers: rtc: remove __dev* attributes.
      Drivers: pinctrl: remove __dev* attributes.
      Drivers: isdn: remove __dev* attributes.
      Drivers: crypto: remove __dev* attributes.
      Drivers: usb: host: ehci-orion.c: remove __devinitdata marking
      Drivers: thermal: remove __dev* attributes.
      Drivers: amba: remove __dev* attributes.
      Drivers: media: remove __dev* attributes.
      Drivers: platform: x86: remove __dev* attributes.
      Drivers: mtd: remove __dev* attributes.
      Drivers: ata: remove __dev* attributes.
      Drivers: ide: remove __dev* attributes.
      Drivers: iio: remove __dev* attributes.
      Drivers: parport: remove __dev* attributes.
      Drivers: edac: remove __dev* attributes.
      Drivers: sbus: remove __dev* attributes.
      Drivers: atm: remove __dev* attributes.
      Drivers: regulator: remove __dev* attributes.
      ARM: drivers: remove __dev* attributes.
      X86: drivers: remove __dev* attributes.
      SPARC: drivers: remove __dev* attributes.
      POWERPC: drivers: remove __dev* attributes.
      MIPS: drivers: remove __dev* attributes.
      IA64: drivers: remove __dev* attributes.
      ALPHA: drivers: remove __dev* attributes.
      ARCH: drivers remove __dev* attributes.
      MM: vmscan: remove __devinit attribute.
      pstore: remove __dev* attributes.
      Drivers: mfd: remove __dev* attributes.
      Drivers: macintosh: remove __dev* attributes.
      Drivers: message: remove __dev* attributes.
      Drivers: power: remove __dev* attributes.
      Drivers: iommu: remove __dev* attributes.
      Drivers: mmc: remove __dev* attributes.
      Drivers: memory: remove __dev* attributes.
      Drivers: infinband: remove __dev* attributes.
      Drivers: gpu: remove __dev* attributes.
      Drivers: dma: remove __dev* attributes.
      Drivers: ssb: remove __dev* attributes.
      Drivers: clocksource: remove __dev* attributes.
      Drivers: char: remove __dev* attributes.
      Drivers: bcma: remove __dev* attributes.
      Drivers: block: remove __dev* attributes.
      Drivers: misc: remove __dev* attributes.
      Documentation: remove __dev* attributes.
      include: remove __dev* attributes.
      misc: remove __dev* attributes.

Gregory CLEMENT (3):
      arm: mvebu: Use dw-apb-uart instead of ns16650 as UART driver
      ARM: 7615/1: cache-l2x0: aurora: Invalidate during clean
operation with WT enable
      ARM: 7616/1: cache-l2x0: aurora: Use writel_relaxed instead of writel

Guenter Roeck (1):
      drm: nouveau: Fix build warning seen if HWMON is undefined

Guo Chao (2):
      ext4: release buffer in failed path in dx_probe()
      ext4: remove duplicate call to ext4_bread() in ext4_init_new_dir()

Haibo Xi (1):
      netfilter: nf_ct_reasm: fix conntrack reassembly expire code

Hannes Frederic Sowa (1):
      ipv6: document ndisc_notify in networking/ip-sysctl.txt

Hante Meuleman (1):
      brcmfmac: fix parsing rsn ie for ap mode.

Haojian Zhuang (1):
      ARM: 7614/1: mm: fix wrong branch from Cortex-A9 to PJ4b

Ian Campbell (1):
      xen/netfront: improve truesize tracking

Inki Dae (4):
      drm/exynos: consider no iommu support to console framebuffer
      drm/exynos: change file license to GPL
      drm/exynos: consider buffer allocation without iommu
      drm/exynos: fix gem buffer allocation type checking

Ivan Khoronzhuk (2):
      ARM: OMAP4: PRM: Correct reset source map
      ARM: OMAP4: PRM: Correct wrong instance usage for reading reset sources

Jaegeuk Kim (11):
      f2fs: remove set_page_dirty for atomic f2fs_end_io_write
      f2fs: fix wrong calculation on f_files in statfs
      f2fs: fix handling errors got by f2fs_write_inode
      f2fs: should recover orphan and fsync data
      f2fs: do f2fs_balance_fs in front of dir operations
      f2fs: invalidate the node page if allocation is failed
      f2fs: return a default value for non-void function
      f2fs: add MAINTAINERS entry
      f2fs: fix equation of has_not_enough_free_secs()
      f2fs: clean up the start_bidx_of_node function
      f2fs: clean up unused variables and return values

Jeff Layton (2):
      cifs: move check for NULL socket into smb_send_rqst
      cifs: adjust sequence number downward after signing NT_CANCEL request

Jerome Glisse (4):
      drm/radeon: add debugfs file for dma rings
      drm/radeon: improve ring debugfs printing
      drm/radeon: print dma status reg on lockup (v2)
      drm/radeon: reset dma engine on gpu reset (v2)

Jesper Juhl (2):
      netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect
      rtlwifi: Don't leak on error in _rtl_usb_receive()

Jinyoung Jeon (1):
      drm/exynos: fix incorrect interrupt induced by m2m operation.

Joe Perches (1):
      ACPI / glue: Update DBG macro to include KERN_DEBUG

Jon Hunter (1):
      ARM: OMAP3: clock data: Add missing enable/disable for EMU clock

JoongMock Shin (1):
      drm/exynos: remove color bar pattern operation.

Joseph Lo (1):
      drivers/rtc/rtc-tegra.c: convert to DT driver

Joshua Coombs (1):
      clk: mvebu: Remove inappropriate __init tagging

Joshua Kinard (1):
      MIPS: 64-bit: Fix build if !CONFIG_MODULES

Julia Lawall (1):
      drivers/pinctrl/pinctrl-at91.c: convert kfree to devm_kfree

Jussi Kivilinna (1):
      rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg

Konstantin Khlebnikov (2):
      cpufreq / stats: fix race between stats allocation and first usage
      EDAC: Fix kernel panic on module unloading

Kukjin Kim (5):
      ARM: SAMSUNG: fix the cpu id for EXYNOS5440
      ARM: dts: use uart port0 for console on exynos5440-ssdk5440
      ARM: dts: use uart port1 for console on exynos4210-smdkv310
      ARM: EXYNOS: enable PINCTRL for EXYNOS5440
      ARM: EXYNOS: skip the clock initialization for exynos5440

Lans Zhang (1):
      EDAC: Cleanup device deregistering path

Larry Finger (7):
      forcedeth: Fix WARNINGS that result when DMA mapping is not checked
      rtlwifi: Fix warning for unchecked pci_map_single() call
      rtlwifi: rtl8192ce: Fix warning for unchecked pci_map_single() call
      rtlwifi: rtl8192de: Fix warning for unchecked pci_map_single() call
      rtlwifi: rtl8192se: Fix warning for unchecked pci_map_single() call
      rtlwifi: rtl8723ae: Fix warning for unchecked pci_map_single() call
      cpufreq / governor: Fix problem with cpufreq_ondemand or
cpufreq_conservative

Laxman Dewangan (1):
      rtc: add RTC driver for TPS6586x

Leon Romanovsky (1):
      f2fs: unify string length declarations and usage

Linus Torvalds (2):
      mm: reinstante dropped pmd_trans_splitting() check
      Linux 3.8-rc3

Linus Walleij (5):
      pinctrl: fix comment mistake
      ARM: 7610/1: versatile: bump IRQ numbers
      ARM: 7611/1: VIC: fix bug in VIC irqdomain code
      ARM: nomadik: delete dangling include
      ARM: nomadik: bump the IRQ numbers again

Liu Jinsong (1):
      ACPI / memhotplug: remove redundant logic of acpi memory hotadd

Lothar Waßmann (1):
      video: mxsfb: fix crash when unblanking the display

Lv Zheng (1):
      ACPICA: Remove useless mini-C library.

Maarten Lankhorst (1):
      drm/radeon: add quirk for d3 delay during switcheroo poweron for
apple macbooks

Manuel Lauss (2):
      MIPS: Alchemy: Make 32kHz and r4k timer coexist peacefully
      MIPS: perf: Fix build failure in XLP perf support.

Marc Dionne (1):
      cred: Remove tgcred pointer from struct cred

Marek Vasut (1):
      ARM: mx5: Fix MX53 flexcan2 clock

Michal Hocko (1):
      mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Michal Simek (6):
      microblaze: Microblaze wants sys_fork for noMMU too
      microblaze: Change section flags for noMMU
      microblaze: Kill __kmap_atomic()
      microblaze: Add finit_module syscall
      microblaze: Fix pci compilation and sparse warnings
      microblaze: Update microblaze defconfigs

Mimi Zohar (1):
      ima: fallback to MODULE_SIG_ENFORCE for existing kernel module syscall

Mukund Jampala (1):
      netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP reset

Namjae Jeon (5):
      f2fs: fix up f2fs_get_parent issue to retrieve correct parent inode number
      f2fs: handle error from f2fs_iget_nowait
      f2fs: remove unneeded initialization of nr_dirty in dirty_seglist_info
      f2fs: fix fsync_inode list addition logic and avoid invalid
access to memory
      f2fs: remove unneeded variable from f2fs_sync_fs

Nathan Straz (1):
      GFS2: Initialize hex string to '0'

Nickolai Zeldovich (2):
      nfs: avoid dereferencing null pointer in initiate_bulk_draining
      ALSA: au88x0: fix incorrect left shift

Niels Ole Salscheider (2):
      brcmsmac: Use udelay instead of usleep_range
      drm/radeon: Properly handle DDC probe for DP bridges

Nishanth Menon (1):
      ARM: OMAP4: PRM: fix RSTTIME and RSTST offsets

Nobuhiro Iwamatsu (1):
      ARM: Kirkwood: Switch TWSI1 of 88f6282 to DT clock providers

Oleg Nesterov (2):
      signals: sys_ssetmask() uses uninitialized newmask
      signals: set_current_blocked() can use __set_current_blocked()

Olof Johansson (1):
      ARM: clps711x: Fix bad merge of clockevents setup

Pablo Neira Ayuso (5):
      netfilter: xt_CT: fix crash while destroy ct templates
      netfilter: nfnetlink_log: fix possible compilation issue due to
missing include
      netfilter: xt_CT: recover NOTRACK target support
      netfilter: xt_hashlimit: fix race that results in duplicated entries
      netfilter: fix missing dependencies for the NOTRACK target

Pantelis Antoniou (1):
      ARM: OMAP2+: am33xx-hwmod: Fix wrongly terminated
am33xx_usbss_mpu_irqs array

Paul Walmsley (4):
      ARM: OMAP: 32k counter: resolve sparse warnings
      ARM: OMAP AM33xx: hwmod data: resolve sparse warnings
      ARM: OMAP: SRAM: resolve sparse warnings
      ARM: OMAP2/3: PRM: fix bogus OMAP2xxx powerstate return values

Pavel Shilovsky (3):
      Revert "CIFS: Fix write after setting a read lock for read oplock files"
      CIFS: Fix write after setting a read lock for read oplock files
      CIFS: Don't let read only caching for mandatory byte-range locked files

Philipp Zabel (1):
      pinctrl: imx5: fix GPIO_8 pad CAN1_RXCAN configuration

Philippe De Muyter (1):
      net/ipv4/ipconfig: really display the BOOTP/DHCP server's address.

Prathyush K (1):
      drm/exynos: fimd: modify condition in fimd resume

Rafael J. Wysocki (5):
      ACPI / PM: Do not apply ACPI_SUCCESS() to acpi_bus_get_device() result
      ACPI / power: Remove useless message from device registering routine
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes
      PM / QoS: Rename local variable in dev_pm_qos_add_ancestor_request()
      PM: Move disabling/enabling runtime PM to late suspend/early resume

Rafał Bilski (1):
      cpufreq / Longhaul: Disable driver by default

Rafał Miłecki (1):
      bcma: correct M25P32 serial flash ID

Rahul Sharma (1):
      drm/exynos: move finish page flip to a common place

Ralf Baechle (8):
      Revert "MIPS: Optimise TLB handlers for MIPS32/64 R2 cores."
      MIPS: Fix comment.
      MIPS: Don't include <asm/page.h> unnecessarily.
      MIPS: Include PAGE_S{IZE,HIFT} in <asm/offset.h>.
      MIPS: Switch remaining assembler PAGE_SIZE users to <asm/asm-offsets.h>.
      MIPS: page.h: Remove now unnecessary #ifndef __ASSEMBLY__ wrapper.
      MIPS: Fix modpost error in modules attepting to use virt_addr_valid().
      MIPS: Wire up finit_module syscall.

Rami Rosen (1):
      bridge: add empty br_mdb_init() and br_mdb_uninit() definitions.

Rob Herring (8):
      ARM: 7608/1: l2x0: Only set .set_debug on PL310 r3p0 and earlier
      ARM: 7609/1: disable errata work-arounds which access secure registers
      ARM: dts: add device_type prop to cpu nodes on Calxeda platforms
      ARM: dts: fix highbank cpu mpidr values
      ARM: highbank: fix typos with hignbank in power request functions
      ARM: highbank: fix secondary boot and hotplug
      ARM: highbank: add a power request clear
      ARM: highbank: save and restore L2 cache and GIC on suspend

Roland Dreier (1):
      printk: fix incorrect length from print_time() when seconds > 99999

Sachin Kamat (10):
      drm/exynos: Use devm_kzalloc in exynos_drm_ipp.c
      drm/exynos: Remove explicit freeing using devm_* APIs in exynos_drm_fimc.c
      drm/exynos: Remove redundant NULL check
      drm/exynos: Use devm_clk_get in exynos_drm_fimc.c
      drm/exynos: Remove unnecessary devm_* freeing APIs in exynos_drm_rotator.c
      drm/exynos: Remove redundant NULL check in exynos_drm_rotator.c
      drm/exynos: Use devm_clk_get in exynos_drm_rotator.c
      drm/exynos: Remove explicit freeing using devm_* APIs in exynos_drm_gsc.c
      drm/exynos: Remove redundant NULL check in exynos_drm_gsc.c
      drm/exynos: Use devm_clk_get in exynos_drm_gsc.c

Sean Paul (1):
      ARM: EXYNOS: Revise HDMI resource size

Sebastian Hesselbarth (2):
      ARM: Dove: Add pinctrl clock to DT
      pinctrl: mvebu: make pdma clock on dove mandatory

Seung-Woo Kim (2):
      drm/exynos: fix flags in dma buf exporting
      drm/prime: drop reference on imported dma-buf come from gem

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Sivaram Nair (2):
      cpuidle: Fix finding state with min power_usage
      cpuidle / coupled: fix ready counter decrement

Stanislav Kinsbursky (9):
      ipc: remove forced assignment of selected message
      ipc: add sysctl to specify desired next object id
      ipc: message queue receive cleanup
      ipc: introduce message queue copy feature
      selftests: IPC message queue copy feature test
      ipc: simplify free_copy() call
      ipc: convert prepare_copy() from macro to function
      ipc: simplify message copying
      ipc: add more comments to message copying related code

Stephen Warren (1):
      namei.h: include errno.h

      ath9k: Fix compilation breakage
      ath9k_hw: Fix RX gain initvals for AR9485

Thomas Petazzoni (4):
      arm: mvebu: Armada XP MV78230 has two cores, not one
      arm: mvebu: Armada XP MV78230 has only three Ethernet interfaces
      dma: mv_xor: fix error handling of mv_xor_channel_add()
      dma: mv_xor: fix error handling for clocks

Tomasz Guszkowski (1):
      p54usb: add USB ID for T-Com Sinus 154 data II

Tony Luck (1):
      Wire up finit_module syscall

Tony Prisk (2):
      drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
      drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time

Trond Myklebust (3):
      SUNRPC: Ensure that we free the rpc_task after cleanups are done
      NFS: Ensure that we free the rpc_task after read and write
cleanups are done
      SUNRPC: Partial revert of commit 168e4b39d1afb79a7e3ea6c3bb246b4c82c6bdb9

Ulrich Weber (1):
      netfilter: ip6t_NPT: fix IPv6 NTP checksum calculation

Valerie Aurora (1):
      ext4: fix configuration dependencies for ext4 ACLs and security labels

Vitaly E. Lavrov (2):
      netfilter: xt_recent: fix namespace destroy path
      netfilter: xt_hashlimit: fix namespace destroy path

Vlad Yasevich (1):
      bridge: Correctly unregister MDB rtnetlink handlers

Vladimir Kondratiev (1):
      ath9k: Fix Kconfig for ATH9K_HTC

Weston Andros Adamson (1):
      NFS: Fix access to suid/sgid executables

Witold Szczeponik (2):
      PNP: Simplify setting of resources
      PNP: Handle IORESOURCE_BITS in resource allocation

Xi Wang (2):
      nfs: fix null checking in nfs_get_option_str()
      ipv4: fix NULL checking in devinet_ioctl()

Yanchuan Nian (1):
      pnfs: Increase the refcount when LAYOUTGET fails the first time

Youquan Song (1):
      intel_idle: pr_debug information need separated

stephen hemminger (2):
      vxlan: allow live mac address change
      ip-sysctl: fix spelling errors
