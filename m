Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1H2ExN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 00:53:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab1H2ExH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 00:53:07 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Aug 2011 21:52:43 -0700
Message-ID: <CA+55aFwwtfLpmNS+Wm4DXgJsipPS8siF6Dur4rMDum7Zs=KqKw@mail.gmail.com>
Subject: Linux 3.1-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're back on track on weekly -rc releases.

I don't know what to say about this one. -rc3 had fewer new commits
than -rc4 does, and I don't like that trend. I'm not happy about the
size of some of the changes (iscsi target, some other random drivers),
but at the same time I have to say that absolutely nothing here makes
me feel worried. Most of the changes are *really* trivial, and the
ones that are a bit bigger tend to be to pretty esoteric areas. For
example, sparc shows up in the dirstat as one of the bigger changes,
and that's just because there's a biggish signal handling change to
fix a rather obscure test. But for the life of me I can't really get
worried about it.

Or how about the wiimote driver changes? Or the iscsi target changes?

In other words, most people won't notice - and the remaining stuff is
really small one-liners spread out (mostly in drivers). If you look at
the old-style - non-rename-aware - patches, the XFS changes look big
and scary, but they're all just file renames.

Anyway, go wild and please do test. The appended shortlog gives a
reasonable idea of the changes, but they really aren't that big.

So I definitely *am* hoping that -rc5 will be smaller. But at the same
time, I continue to be pretty happy about the state of 3.1 so far. But
maybe it's just that my meds are finally working.

               Linus "I don't think I've really flamed
                              anybody this week" Torvalds

--
Al Cooper (1):
      8250: Fix race condition in serial8250_backup_timeout().

Alex Elder (1):
      xfs: don't expect xfs headers to be in subdirectories

Alexander Duyck (1):
      ixgbe: Fix FCOE memory leak for DDP packets

Alexandre Bounine (1):
      rapidio: fix use of non-compatible registers

Amerigo Wang (1):
      cpupower: avoid using symlinks

Andi Kleen (1):
      Add a personality to report 2.6.x version numbers

Andiry Xu (2):
      xHCI: fix port U3 status check condition
      xHCI: report USB2 port in resuming as suspend

Andrew Bird (3):
      USB option driver add PID of Huawei Vodafone K3806
      USB option driver add PID of Huawei Vodafone K4605
      USB option driver K3765/K4505 avoid CDC_DATA interface

Andrew Drake (1):
      Input: bcm5974 - Add support for newer MacBookPro8,2

Andy Lutomirski (1):
      x86-32: Fix boot with CONFIG_X86_INVD_BUG

Arend Van Spriel (1):
      staging: brcm80211: fix compile error on non-x86 archs since 3.0 kernel

Arnaud Lacombe (1):
      drivers/base/devtmpfs.c: correct annotation of `setup_done'

Axel Lin (17):
      Input: mma8450 - fix module device table type
      Input: mpu3050 - correct call to input_free_device
      Input: tegra-kbc - correct call to input_free_device
      usb: gadget: s3c2410_udc: fix unterminated platform_device_id table
      ASoC: soc-jack: Fix checking return value of request_any_context_irq
      ASoC: sta32x: Fix a memory leak if snd_soc_register_codec fails
      max8997_charger: Needs module.h
      Input: tnetv107x-ts - add missing include of linux/module.h
      Input: ep93xx_keypad - add missing include of linux/module.h
      ASoC: soc-core: use GFP_KERNEL flag for kmalloc in snd_soc_cnew
      tty: Add "spi:" prefix for spi modalias
      drivers/video/backlight/ep93xx_bl.c: add missing include of linux/module.h
      leds: add missing include of linux/module.h
      backlight: fix module alias prefix for adp8870_bl
      drivers/misc/fsa9480.c: fix a leak of the IRQ during init failure
      drivers/misc/ab8500-pwm.c: fix modalias
      drivers/leds/leds-bd2802.c: bd2802_unregister_led_classdev()
should unregister all registered leds

Ben Skeggs (2):
      drm/ttm: unbind ttm before destroying node in accel move cleanup
      drm/ttm: ensure ttm for new node is bound before calling move_notify()

Bjorn Helgaas (1):
      serial: 8250_pnp: add Intermec CV60 touchscreen device

Bob Liu (1):
      usb: musb: blackfin: include prefetch head file

Bruce Allan (3):
      e1000e: Spurious interrupts & dropped packets with 82577/8/9 in
half-duplex
      e1000e: workaround for packet drop on 82579 at 100Mbps
      e1000e: workaround invalid Tx/Rx tail descriptor register write

Chris Boot (2):
      iscsi-target: Implement iSCSI target IPv6 address printing.
      firewire: sbp2: fix panic after rmmod with slow targets

Christoph Hellwig (2):
      xfs: remove subdirectories
      xfs: fix tracing builds inside the source tree

Dan Bastone (1):
      HID: add support for new revision of Apple aluminum keyboard

Dan Carpenter (5):
      iscsi-target: remove duplicate return
      iscsi-target: forever loop bug in iscsit_attach_ooo_cmdsn()
      iscsi-target: Fix iscsit_allocate_se_cmd_for_tmr failure path bugs
      Staging: zcache: signedness bug in tmem_get()
      w1: fix for loop in w1_f29_remove_slave()

Daniel Baluta (1):
      ipv6: Fix ipv6_getsockopt for IPV6_2292PKTOPTIONS

Daniel Schwierzeck (1):
      atm: br2684: Fix oops due to skb->dev being NULL

Dave Jones (1):
      cpupower: fix Makefile typo

David Daney (1):
      staging: octeon-ethernet: Add missing #includes.

David Henningsson (1):
      ALSA: hda: Conexant: Allow different output types to share DAC

David Herrmann (5):
      HID: wiimote: Simplify synchronization
      HID: wiimote: Correctly call HID open/close callbacks
      HID: wiimote: Register led class devices
      HID: wiimote: Add drm request
      HID: wiimote: Add status and return request handlers

David S. Miller (1):
      sparc: Allow handling signals when stack is corrupted.

Deepak Saxena (1):
      Input: remove CLOCK_TICK_RATE from analog joystick driver

Dilan Lee (1):
      backlight: add a callback 'notify_after' for backlight control

Dmitry Torokhov (1):
      Input: ad714x - use DMA-safe buffers for spi_write()

Dominik Brodowski (2):
      cpupower: make NLS truly optional
      cpupower: use man(1) when calling "cpupower help subcommand"

Emmanuel Grumbach (2):
      Revert "iwlagn: sysfs couldn't find the priv pointer"
      iwlagn: sysfs couldn't find the priv pointer

Eric Dumazet (1):
      bridge: fix a possible net_device leak

Eric Smith (1):
      8250_pci: add support for Rosewill RC-305 4x serial port card

Evgeniy Polyakov (1):
      MAINTAINERS: Evgeniy has moved

Felipe Balbi (1):
      usb: musb: tusb6010: fix compilation

Gavin.zhu (1):
      USB: option: add YUGA device id to driver

Geoffrey Thomas (1):
      net: Documentation: RFC 2553bis is now RFC 3493

Gerard Braad (1):
      Input: wacom - add support for the Wacom Bamboo Pen (CTL-660/K)

Guenter Roeck (1):
      hwmon: (ntc_thermistor) Simplify if sequence

H Hartley Sweeten (1):
      base/devres.c: quiet sparse noise about context imbalance

H. Peter Anvin (1):
      x86-32, vdso: On system call restart after SYSENTER, use int $0x80

Heiko Carstens (3):
      pti: add missing CONFIG_PCI dependency
      [S390] nss,initrd: kernel image and initrd must be in different segments
      [S390] memory hotplug: only unassign assigned increments

Hui Zhu (1):
      checkpatch: add missing WARN argument for min_t and max_t tests

Ian Campbell (1):
      m68k: fix __page_to_pfn for a const struct page argument

Jack Steiner (1):
      x86, UV: Remove UV delay in starting slave cpus

Jamal Hadi Salim (1):
      net_sched: fix port mirror/redirect stats reporting

Jarkko Nikula (1):
      ASoC: omap: Fix build errors in ams-delta

Jay Estabrook (1):
      drm/radeon/alpha: Add Alpha support to Radeon DRM code

Jean Delvare (1):
      hwmon: (i5k_amb) Drop i5k_channel_pci_id

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add Calao reference board support

Jeremiah Matthey (1):
      HID: usbhid: Add support for SiGma Micro chip

Jesper Juhl (1):
      iscsi-target: Fix leak on failure in iscsi_copy_param_list()

Jesse Gross (1):
      vmxnet3: Don't enable vlan filters in promiscuous mode.

Jiejing Zhang (1):
      Input: max11801_ts - correct license statement

Jiri Pirko (4):
      gianfar: prevent buggy hw rx vlan tagging
      via-velocity: remove non-tagged packet filtering
      forcedeth: call vlan_mode only if hw supports vlans
      vlan: reset headers on accel emulation path

Jiri Slaby (2):
      TTY: pty, fix pty counting
      TTY: serial, document ignoring of uart->ops->startup error

Johannes Weiner (4):
      fuse: delete dead .write_begin and .write_end aops
      fuse: mark pages accessed when written to
      memcg: pin execution to current cpu while draining stock
      memcg: fix hierarchical oom locking

John Stultz (1):
      usb: musb: fix oops on musb_gadget_pullup

Joseph Pentland (1):
      ASoC: Add Springbank I/O card to Speyside Kconfig

Josh Boyer (2):
      usbnet/cdc_ncm: Don't use stack variables for DMA
      lockdep: Add helper function for dir vs file i_mutex annotation

Joshua V. Dillon (1):
      Input: bcm5974 - add support for touchpads found in MacBookAir4,2

Julia Lawall (9):
      drivers/net/wireless/wl12xx: add missing kfree
      drivers/net/can/sja1000/plx_pci.c: eliminate double free
      target: Convert target_core_rd.c to use use BUG_ON
      sound/soc/kirkwood/kirkwood-i2s.c: add missing kfree
      sound/soc/ep93xx/ep93xx-i2s.c: add missing kfree
      sound/soc/fsl/p1022_ds.c: add missing of_node_put
      sound/soc/fsl/mpc8610_hpcd.c: add missing of_node_put
      [S390] drivers/s390/block/dasd_ioctl.c: add missing kfree
      [S390] arch/s390/kernel/ipl.c: correct error detection check

Kamal Mostafa (1):
      i915: do not setup intel_backlight twice

Kevin Hilman (2):
      Revert "i2c-omap: fix static suspend vs. runtime suspend"
      OMAP: omap_device: only override _noirq methods, not normal suspend/resume

Kirill A. Shutemov (1):
      sfi: table irq 0xFF means 'no interrupt'

Kukjin Kim (1):
      serial: samsung: Fix build error

Kumar Gala (1):
      drivers/serial/ucc_uart.c: Fix compiler warning

Kuninori Morimoto (1):
      usb: gadget: renesas_usbhs: fix DMA build by including dma-mapping.h

Linus Torvalds (3):
      Revert "irq: Always set IRQF_ONESHOT if no primary handler is specified"
      firmware loader: allow builtin firmware load even if
usermodehelper is disabled
      Linux 3.1-rc4

Linus Walleij (1):
      i2c-nomadik: fix kerneldoc warning

Lionel Elie Mamane (1):
      sit tunnels: propagate IPv6 transport class to IPv4 Type of Service

Liu Gang-B34182 (1):
      arch/powerpc/sysdev/fsl_rio.c: correct IECSR register clear value

Magnus Damm (2):
      ARM: mach-shmobile: sh7372 LCDC1 suspend fix
      ARM: mach-shmobile: sh7372 LCDC1 suspend fix V2 (incremental)

Marcin Slusarz (1):
      drm/ttm: fix ttm_bo_add_ttm(user) failure path

Mark Brown (7):
      ASoC: Move WM8962 CLKREG_OVD earlier
      ASoC: WM8996 record paths need AIFCLK
      ASoC: Fix configuration of WM8996 input enables
      ASoC: Ensure we only run Speyside WM8962 bias level callbacks once
      ASoC: Clear any outstanding WM8962 FLL lock completions before waiting
      ASoC: Clear completions from late WM8996 FLL lock IRQs
      ASoC: Correct element count for WM8996 sidetone HPF

Michael Hennerich (3):
      Input: ad714xx-spi - force SPI bus into the default 8-bit mode
      Input: ad714x - fix endianness issues
      Input: ad714x - read the interrupt status registers in a row

Michael Holzheu (1):
      [S390] Change default action from reipl to stop for on_restart

Michel Dänzer (3):
      drm/radeon: Take IH ring into account for test size calculation.
      drm/radeon: Explicitly print GTT/VRAM offsets on test failure.
      drm/radeon: Make vramlimit parameter actually work.

Miklos Szeredi (2):
      fuse: fix flock
      fuse: check size of FUSE_NOTIFY_INVAL_ENTRY message

Ming Lei (1):
      usb: host: ehci-omap: fix .remove and failure handling path of .probe(v1)

MyungJoo Ham (2):
      drivers/rtc/rtc-s3c.c: correct debug messages
      drivers/rtc/rtc-s3c.c: allow multiple open / allow
no-ioctl-open'ed rtc to have irq.

NeilBrown (1):
      All Arch: remove linkage for sys_nfsservctl system call

Nicholas Bellinger (10):
      target: Change TCM_NON_EXISTENT_LUN response to ASC=LOGICAL UNIT
NOT SUPPORTED
      target: Make standard INQUIRY return 'not connected' for tpg_virt_lun0
      target: Fix write payload exception handling with ->new_cmd_map
      target: Add WRITE_SAME (10) parsing and refactor passthrough checks
      target: Fix WRITE_SAME usage with transport_get_size
      target: Remove duplicate task completions in transport_emulate_control_cdb
      target: Fix SYNCHRONIZE_CACHE zero LBA + range breakage
      target: Add missing DATA_SG_IO transport_cmd_get_valid_sectors check
      target: Fix task count > 1 handling breakage and use max_sector
page alignment
      target: Fix task SGL chaining breakage with transport_allocate_data_tasks

Nick Pelly (1):
      omap-serial: Allow IXON and IXOFF to be disabled.

Nishanth Aravamudan (1):
      kernel/printk: do not turn off bootconsole in printk_late_init()
if keep_bootcon

Nobuhiro Iwamatsu (1):
      net: sh_eth: Fix build by forgot including linux/interrupt.h

Omar Ramirez Luna (1):
      staging: tidspbridge: fix compilation on dsp clock functions

Paul Fox (1):
      x86, olpc: Wait for last byte of EC command to be accepted

Pavan Savoy (7):
      drivers:misc: ti-st: avoid a misleading dbg msg
      drivers:misc:ti-st: platform hooks for chip states
      drivers:misc: ti-st: reinit completion on ver read
      drivers:misc: ti-st: reinit completion before send
      drivers:misc: ti-st: wait for completion at fail
      drivers:misc: ti-st: free skb on firmware download
      drivers:misc: ti-st: fix unexpected UART close

Per Forlin (3):
      usb: musb: ux500: set dma config for both src and dst
      usb: musb: ux500: replace missing DBG with dev_dbg
      usb: musb: cppi: fix build errors due to DBG and missing musb variable

Peter Pan(潘卫平) (1):
      bonding:reset backup and inactive flag of slave

Pieter-Paul Giesberts (1):
      staging: brcm80211: SPARC build error fix

Ping Cheng (2):
      Input: wacom - add WAC_MSG_RETRIES define
      Input: wacom - report id 3 returns 4 bytes of data

Rabin Vincent (1):
      usb: musb: fix Kconfig

Rafael J. Wysocki (3):
      PM: Use spinlock instead of mutex in clock management functions
      sh-sci / PM: Use power.irq_safe
      PM / Runtime: Correct documentation of pm_runtime_irq_safe()

Ralf Thielow (1):
      scripts/get_maintainer.pl: update Linus's git repository

Randy Dunlap (4):
      fuse: fix non-ANSI void function notation
      firmware: fix google/gsmi.c build warning
      driver core: fix kernel-doc warning in platform.c
      max8998_charger: Needs module.h

Roland Dreier (4):
      target: Print subpage too for unhandled MODE SENSE pages
      tcm_fc: init/exit functions should not be protected by "#ifdef MODULE"
      target: Make locking in transport_deregister_session() IRQ safe
      target: Convert acl_node_lock to be IRQ-disabling

Sangbeom Kim (1):
      ASoC: Add samsung maintainer

Sarah Sharp (5):
      xhci: Fix memory leak during failed enqueue.
      xhci: Fix failed enqueue in the middle of isoch TD.
      xhci: Remove TDs from TD lists when URBs are canceled.
      USB: Avoid NULL pointer deref in usb_hcd_alloc_bandwidth.
      xhci: Handle zero-length isochronous packets.

Sascha Hauer (1):
      ASoC: Fix check for symmetric rate enforcement

Scott Jiang (5):
      ASoC: ad193x: fix registers definition
      ASoC: ad193x: fix dac word len setting
      ASoC: ad193x: fix system clock
      ASoC: Add spi hw read function for 16 addr 8 data mode for ad193x fix
      ASoC: ad193x: remove cache support

Sebastian Andrzej Siewior (4):
      usb: gadget: fusb300: remove #if 0 block
      usb: gadget: composite: fix bMaxPacketSize for SuperSpeed
      usb: gadget: f_phonet: unlock in error case
      usb: musb: gadget: fix error path

Sebastian Bauer (1):
      usb: gadget: hid: don't STALL when processing a HID Descriptor request

Sergei Trofimovich (3):
      usb: musb: tusb6010_omap: fix build failure: error: 'musb' undeclared
      drivers/misc/pti.c: add missing includes
      alpha: unbreak osf_setsysinfo(SSI_NVPAIRS, [SSIN_UACPROC, UAC_SIGBUS])

Seth Jennings (1):
      staging: zcache: fix crash on high memory swap

Shaohua Li (2):
      mm: fix a vmscan warning
      vmscan: clear ZONE_CONGESTED for zone with good watermark

Stanislaw Gruszka (3):
      rt2x00: fix crash in rt2800usb_write_tx_desc
      rt2x00: fix order of entry flags modification
      rt2x00: fix crash in rt2800usb_get_txwi

Stephen Warren (1):
      ASoC: Tegra: wm8903 machine driver: Drop Ventana support

Takashi Iwai (4):
      ALSA: hda - Fix output-path initialization for Realtek auto-parser
      ALSA: hda - Update jack-sense info even when no automute is set
      ALSA: hda - Fix double-headphone/speaker paths for Cxt auto-parser
      ALSA: hda/conexant - Enable ADC-switching for auto-mic mode, too

Tejun Heo (1):
      mtrr: fix UP breakage caused during switch to stop_machine

Thomas Jarosch (1):
      drm/i915: Fix wrong initializer for "locked" variable in
assert_panel_unlocked

Thomas Meyer (2):
      target: Use ERR_CAST inlined function
      drivers/char/msm_smd_pkt.c: don't use IS_ERR()

Thomas Reim (1):
      drm/radeon: Extended DDC Probing for Toshiba L300D Radeon
Mobility X1100 HDMI-A Connector

Thomas Renninger (4):
      cpupower: mperf monitor - Use TSC to calculate max frequency if possible
      cpupower: Do not show an empty Idle_Stats monitor if no idle
driver is available
      cpupower: Better detect offlined CPUs
      cpupower: Make monitor command -c/--cpu aware

Timur Tabi (1):
      sound/soc/fsl/fsl_dma.c: add missing of_node_put

Tomoya MORINAGA (2):
      pch_uart: Set PCIe bus number using probe parameter
      serial/8250_pci: delete duplicate data definition

Vasily Khoruzhick (3):
      ASoC: h1940: Fix compilation error due to missing header
      ASoC: rx1950: Fix compilation error due to missing header
      s3c-adc-battery: Fix compilation error due to missing header (module.h)

Vijay Badawadagi (1):
      drivers:misc: ti-st: fail-safe on wrong pkt type

Voss, Nikolaus (1):
      atmel_serial: fix atmel_default_console_device

WANG Cong (1):
      cris: add arch/cris/include/asm/serial.h

Wang Shaoyan (1):
      gianfar: reduce stack usage in gianfar_ethtool.c

Wang Zhi (1):
      USB: EHCI: Do not rely on PORT_SUSPEND to stop USB resuming in
ehci_bus_resume().

Wanlong Gao (1):
      MAINTAINERS: Paul Menage has moved

Willem de Bruijn (3):
      net: add missing entries to Documentation/networking/00-INDEX
      net: minor update to Documentation/networking/scaling.txt
      net: netdev-features.txt update to Documentation/networking/00-INDEX

Wu Fengguang (1):
      squeeze max-pause area and drop pass-good area

Yufeng Shen (1):
      Input: atmel_mxt_ts - report pressure information from the driver

Yulgon Kim (1):
      usb: s5p-ehci: fix a NULL pointer deference

srinidhi kasagar (1):
      i2c-nomadik: Do not use _interruptible_ variant call
