Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab0IUAY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:24:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab0IUAY5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:24:57 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Sep 2010 17:24:29 -0700
Message-ID: <AANLkTinPnUmRsYZ7pxBP4Jv9FNpiei2YxZG=0JrBi=Ft@mail.gmail.com>
Subject: Linux 2.6.36-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should have done this yesterday, but got distracted. So here's -rc5,
one day late - so it got some extra updates from Greg thanks to my
procrastination.

Nothing really stands out. Except perhaps that Al has obviously been
looking at architecture sigreturn paths, and been finding problems,
and Dan Rosenberg has been finding places where we copy structures to
user space without having fully initialized them yet, leaking kernel
stack contents.  And we had that annoying x86-64 32-bit compat syscall
bug that needed fixing for the _second_ time.

Other than that? Random fixes - most of them one/few-liners - with a
few reverts thrown in to spice things up.

                 Linus

---
Akinobu Mita (1):
      watchdog: sb_wdog: release irq and reboot notifier in error path
and module_exit()

Al Viro (10):
      arm: fix really nasty sigreturn bug
      alpha: belated ERESTART_RESTARTBLOCK race fix
      alpha: unb0rk sigsuspend() and rt_sigsuspend()
      alpha: fix a 14 years old bug in sigreturn tracing
      alpha: deal with multiple simultaneously pending signals
      frv: restart_block.fn needs to be reset on sigreturn
      frv: fix address verification holes in setup_frame/setup_rt_frame
      frv: avoid infinite loop of SIGSEGV delivery
      frv: handling of restart into restart_syscall is fscked
      frv: double syscall restarts, syscall restart in sigreturn()

Alan Ott (1):
      HID: Set Report ID properly for Output reports on the Control endpoint.

Alek Du (1):
      USB: EHCI: Disable langwell/penwell LPM capability

Alex Deucher (7):
      drm/radeon/kms: fix regression in RMX code (v2)
      drm/radeon/kms: add connector table for Mac x800
      drm/radeon/kms: don't enable underscan with interlaced modes
      drm/radeon: add some missing copyright headers
      drm/radeon/kms/evergreen: fix backend setup
      drm/radeon/kms: force legacy pll algo for RV620 LVDS
      drm/radeon/kms: only warn on mipmap size checks in r600 cs checker (v2)

Alexey Kuznetsov (1):
      tcp: Prevent overzealous packetization by SWS logic.

Andy Gospodarek (1):
      bonding: correctly process non-linear skbs

Aneesh Kumar K.V (3):
      fs/9p: Fix error handling in v9fs_get_sb
      fs/9p: Use the correct dentry operations
      fs/9p: Don't use dotl version of mknod for dotu inode operations

Anisse Astier (1):
      ALSA: hda - Add quirk for Toshiba C650D using a Conexant CX20585

Anton Vorontsov (2):
      gpiolib: Add 'struct gpio_chip' forward declaration for !GPIOLIB case
      apm_power: Add missing break statement

Arnd Bergmann (1):
      alpha: kill big kernel lock

Axel Lin (15):
      regulator: ab3100 - fix the logic to remove already registered
regulators in error path
      regulator: ab8500 - fix the logic to remove already registered
regulators in error path
      regulator: max1586 - improve the logic of choosing selector
      regulator: tps6507x - remove incorrect comments
      regulator: max8998 - fix memory allocation size for max8998->rdev
      regulator: max8998 - set max8998->num_regulators
      regulator: tps6586x-regulator - fix value range checking for val
      regulator: tps6586x-regulator - fix bit_mask parameter for
tps6586x_set_bits()
      regulator: set max8998->dev to &pdev->dev.
      regulator: ad5398 - fix a memory leak
      regulator: isl6271a-regulator - fix regulator_desc parameter for
regulator_register()
      regulator: 88pm8607 - fix value range checking for accessing
info->vol_table
      regulator: ab8500 - fix off-by-one value range checking for selector
      regulator: wm831x-ldo - fix the logic to set REGULATOR_MODE_IDLE
and REGULATOR_MODE_STANDBY modes
      regulator: wm8350-regulator - fix the logic of checking
REGULATOR_MODE_STANDBY mode

Bian Naimeng (2):
      gss:krb5 miss returning error to caller when import security context
      gss:spkm3 miss returning error to caller when import security context

Bob Arendt (1):
      ipv4: force_igmp_version ignored when a IGMPv3 query received

Chris Metcalf (5):
      arch/tile: finish const-ifying sys_execve()
      arch/tile: Change struct sigcontext to be more useful
      arch/tile: Save and restore extra user state for tilegx
      arch/tile: fix memcpy_fromio()/memcpy_toio() signatures
      arch/tile: fix formatting bug in register dumps

Chris Snook (1):
      MAINTAINERS: move atlx discussions to netdev

Chris Wilson (4):
      drm: Fix regression in disable polling e58f637
      drm: Only decouple the old_fb from the crtc is we call mode_set*
      drm: Use a nondestructive mode for output detect when polling
      drm: Use a nondestructive mode for output detect when polling (v2)

Dan Carpenter (5):
      regulator/ab8500: move dereference below the check for NULL
      net/llc: make opt unsigned in llc_ui_setsockopt()
      ppp: potential NULL dereference in ppp_mp_explode()
      net/llc: storing negative error codes in unsigned short
      Staging: vt6655: fix buffer overflow

Dan Rosenberg (5):
      drivers/video/via/ioctl.c: prevent reading uninitialized stack memory
      drivers/net/usb/hso.c: prevent reading uninitialized memory
      drivers/net/eql.c: prevent reading uninitialized stack memory
      drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized stack memory
      USB: serial/mos*: prevent reading uninitialized stack memory

Darius Augulis (2):
      ARM: S3C64XX: Fix coding style errors on mach-real6410
      ARM: S3C64XX: Add IORESOURCE_IRQ_HIGHLEVEL flag to dm9000 on mach-real6410

Dave Airlie (1):
      drm: fix race between driver loading and userspace open.

David Gow (1):
      HID: Add support for chicony multitouch screens.

David Henningsson (1):
      ALSA: HDA: Enable internal speaker on Dell M101z

David Howells (1):
      MN10300: Fix up the IRQ names for the on-chip serial ports

David Lamparter (1):
      spi: free children in spi_unregister_master, not siblings

David S. Miller (2):
      sch_atm: Fix potential NULL deref.
      net: RPS needs to depend upon USE_GENERIC_SMP_HELPERS

Decio Fonini (1):
      HID: Kanvus Note A5 tablet needs HID_QUIRK_MULTI_INPUT

Denis Kirjanov (1):
      3c59x: Remove atomic context inside vortex_{set|get}_wol

Dominik Brodowski (3):
      pcmcia serial_cs.c: fix multifunction card handling
      pcmcia: per-device, not per-socket debug messages
      pcmcia pcnet_cs: try setting io_lines to 16 if card setup fails

Eric Dumazet (2):
      net: use rcu_barrier() in rollback_registered_many
      xfrm: dont assume rcu_read_lock in xfrm_output_one()

Fabio Olive Leite (1):
      Remove incorrect do_vfs_lock message

Felipe Balbi (1):
      USB: musb: MAINTAINERS: Fix my mail address

Feng Tang (2):
      spi/dw_spi: clean the cs_control code
      serial: mfd: fix bug in serial_hsu_remove()

Geert Uytterhoeven (1):
      m68k,m68knommu: Wire up fanotify_init, fanotify_mark, and prlimit64

Guenter Roeck (2):
      hwmon: (adm1031) Replace update_rate sysfs attribute with update_interval
      hwmon: (lm95241) Replace rate sysfs attribute with update_interval

Guillaume Chazarain (1):
      HID: fix hiddev's use of usb_find_interface

Guillem Jover (2):
      hwmon: (f75375s) Shift control mode to the correct bit position
      hwmon: (f75375s) Do not overwrite values read from registers

H. Peter Anvin (2):
      compat: Make compat_alloc_user_space() incorporate the access_ok()
      x86-64, compat: Test %rax for the syscall number, not %eax

Heikki Lindholm (1):
      firewire: ohci: activate cycle timer register quirk on Ricoh chips

Herbert Xu (1):
      netpoll: Disable IRQ around RCU dereference in netpoll_rx

Hugh Dickins (1):
      mm: further fix swapin race condition

Ingo Molnar (1):
      sched: Improve latencies under load by decreasing minimum
scheduling granularity

J. Bruce Fields (2):
      Fix null dereference in call_allocate
      SUNRPC: cleanup state-machine ordering

Jack Steiner (1):
      x86, UV: Fix initialization of max_pnode

Jan Harkes (1):
      Coda: mount hangs because of missed REQ_WRITE rename

Jassi Brar (2):
      spi/s3c64xx: Fix compilation warning
      spi/s3c64xx: Fix incorrect reuse of 'val' local variable.

Jean Delvare (1):
      hwmon: New subsystem maintainers

Jeff Layton (5):
      cifs: eliminate redundant xdev check in cifs_rename
      cifs: prevent cifsd from exiting prematurely
      cifs: eliminate some more premature cifsd exits
      cifs: prevent possible memory corruption in cifs_demultiplex_thread
      cifs: fix potential double put of TCP session reference

Jeff Moyer (1):
      aio: check for multiplication overflow in do_io_submit

Jiri Kosina (2):
      HID: add support for another BTC Emprex remote control
      HID: fixup blacklist entry for Asus T91MT

Joe Perches (2):
      sound: Remove pr_<level> uses of KERN_<level>
      alpha: Use static const char * const where possible

Johan Hovold (1):
      HID: add no-get quirk for eGalax touch controller

John Ogness (1):
      mxc_nand: Do not do byte accesses to the NFC buffer.

Jonas Jonsson (1):
      hwmon: (w83627ehf) Use proper exit sequence

Julia Lawall (1):
      powerpc/5200: mpc52xx_uart.c: Add of_node_put to avoid memory leak

Kevin Wells (1):
      watchdog: Enable NXP LPC32XX support in Kconfig (resend)

Kukjin Kim (2):
      ARM: SAMSUNG: Fix on drive strength value
      ARM: SAMSUNG: Fix on s5p_gpio_[get,set]_drvstr

Kuninori Morimoto (1):
      hwmon: (lis3lv02d) Prevent NULL pointer dereference

Kyungmin Park (3):
      mtd: OneNAND: Fix 2KiB pagesize handling at Samsung SoCs
      mtd: OneNAND: Fix loop hang when DMA error at Samsung SoCs
      ARM: S5PV210: Reduce the iodesc length of systimer

Latchesar Ionkov (1):
      fs/9p, net/9p: memory leak fixes

Linus Torvalds (1):
      Linux 2.6.36-rc5

Linus Walleij (2):
      spi/pl022: fix APB pclk power regression on U300
      spi/pl022: move probe call to subsys_initcall()

Marek Olšák (2):
      drm/radeon/kms: increase lockup detection interval to 10 sec for r100-r500
      drm/radeon/kms: fix the colorbuffer CS checker for r300-r500

Marek Szyprowski (2):
      ARM: S5P: Fix DMA coherent mask for FIMC
      ARM: S5PV210: Add FIMC clocks

Mark Brown (8):
      regulator: Update e-mail address for Liam Girdwood
      spi/spi_s3c64xx: Make probe more robust against missing board config
      spi/spi_s3c64xx: Staticise non-exported functions
      spi/spi_s3c64xx: Move to subsys_initcall()
      spi/spi_s3c64xx: Increase dead reckoning time in wait_for_xfer()
      spi/spi_s3c64xx: Warn if PIO transfers time out
      ARM: S3C64XX: Fix dev-spi build
      ARM: S3C64XX: Prototype SPI devices

Mark F. Brown (1):
      mtd: pxa3xx: fix build error when CONFIG_MTD_PARTITIONS is not defined

Mathias Nyman (1):
      usb: musb_debugfs: don't use the struct file private_data field
with seq_files

Matthew Garrett (1):
      r8169: Handle rxfifo errors on 8168 chips

Menyhart Zoltan (1):
      statfs() gives ESTALE error

Michael Cree (1):
      alpha: Shift perf event pending work earlier in timer interrupt

Michael Kerrisk (1):
      ipv4: enable getsockopt() for IP_NODEFRAG

Michal Simek (1):
      of: Fix missing includes - ll_temac

Mika Westerberg (2):
      watchdog: ts72xx_wdt: disable watchdog at probe
      serial: amba-pl010: fix set_ldisc

Mikael Pettersson (1):
      alpha: wire up fanotify and prlimit64 syscalls

Mike Frysinger (2):
      mtd: Blackfin NFC: fix build error after nand_scan_ident() change
      mtd: Blackfin NFC: fix invalid free in remove()

Ming Lei (1):
      USB: otg: twl4030: fix phy initialization(v1)

Miquel van Smoorenburg (1):
      sunrpc: increase MAX_HASHTABLE_BITS to 14

MyungJoo Ham (1):
      ARM: S5PV210: Update I2C-1 Clock Register Property.

NeilBrown (2):
      md: call md_update_sb even for 'external' metadata arrays.
      md: fix v1.x metadata update when a disk is missing.

Petr Tesarik (1):
      [IA64] Optimize ticket spinlocks in fsys_rt_sigprocmask

Roland Baum (1):
      HID: add device ID for new Asus Multitouch Controller

Roland McGrath (1):
      x86-64, compat: Retruncate rax after ia32 syscall entry tracing

Sascha Hauer (1):
      mtd: mxc_nand: configure pages per block for v2 controller

Seth Heasley (1):
      ALSA: hda_intel: ALSA HD Audio patch for Intel Patsburg DeviceIDs

Shaohua Li (1):
      dquot: do full inode dirty in allocating space

Shuduo Sang (1):
      intel_pmic_battery: Fix battery charging status on mrst

Simon Guinot (1):
      phylib: fix PAL state machine restart on resume

Sosnowski, Maciej (1):
      dca: disable dca on IOAT ver.3.0 multiple-IOH platforms

Stefan Richter (1):
      firewire: nosy: fix build when CONFIG_FIREWIRE=N

Stephen Warren (1):
      ALSA: patch_nvhdmi.c: Fix supported sample rate list.

Steve French (5):
      Revert "[CIFS] Eliminate unused variable warning"
      Revert "Eliminate sparse warning - bad constant expression"
      Revert "missing changes during ntlmv2/ntlmssp auth and sign"
      Revert "[CIFS] Fix ntlmv2 auth with ntlmssp"
      [CIFS] ntlmv2/ntlmssp remove-unused-function CalcNTLMv2_partial_mac_key

Steven Whitehouse (1):
      GFS2: gfs2_logd should be using interruptible waits

Sven Eckelmann (1):
      Revert: "Staging: batman-adv: Adding netfilter-bridge hooks"

Sylwester Nawrocki (1):
      ARM: S5P: Decrease IO Registers memory region size on FIMC

Takashi Iwai (2):
      ALSA: pcm - Fix unbalanced pm_qos_request
      ALSA: pcm - Fix race with proc files

Tejun Heo (2):
      workqueue: add documentation
      alpha: fix build breakage in asm/cacheflush.h

Tetsuo Handa (1):
      x86, cpufeature: Suppress compiler warning with gcc 3.x

Thierry Reding (1):
      HID: Add quirk for eGalax touch controler.

Thomas Gleixner (1):
      x86: hpet: Work around hardware stupidity

Tony Luck (1):
      [IA64] fix siglock

Trond Myklebust (4):
      SUNRPC: Fix race corrupting rpc upcall
      SUNRPC: Fix a race in rpc_info_open
      NFS: Fix a typo in nfs_sockaddr_match_ipaddr6
      SUNRPC: Fix the NFSv4 and RPCSEC_GSS Kconfig dependencies

Vlad Yasevich (1):
      sctp: Do not reset the packet during sctp_packet_config().

Wolfram Sang (1):
      ide: Fix ordering of procfs registry.

Yong Wang (2):
      spi/dw_spi: Allow interrupt sharing
      hwmon: (emc1403) Remove unnecessary hwmon_device_unregister

basile@opensource.dyc.edu (1):
      x86, build: Disable -fPIE when compiling with CONFIG_CC_STACKPROTECTOR=y

jvrao (1):
      9p: Check for NULL fid in v9fs_dir_release()

matt mooney (1):
      alpha: remove unnecessary cast from void* in assignment.
