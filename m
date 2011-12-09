Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1LIXyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:54:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63612 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab1LIXy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:54:29 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Dec 2011 15:54:07 -0800
X-Google-Sender-Auth: 5ADmcsjbvRRiSjLabLaxdvsuCog
Message-ID: <CA+55aFzE9GbgzXU84EWEUP5xBm1n59z6GhRpjEmmOCENuVJRgA@mail.gmail.com>
Subject: Linux 3.2-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a bit over a week, and I'm sad to report that -rc5 is bigger
(at least in number of commits - most of the commits are pretty small,
so it's possible that the *diff* ends up being smaller, but I didn't
check) than both -rc2 and -rc4 were.

So much for "calming down".

Yeah, part of it is probably that Ingo is back, and had a backlog
(mainly x86 and perf). But quite frankly, that isn't enough to explain
it all - we have xfs and btrfs changes, we have network updates, and
we have the usual 50% random driver updates (sound, target and gpu
drivers stand out, but there's some network amd MD driver noise too).

That said, there's nothing really scary there and it all tends to be
pretty small, and many of them are solid regression fixes.

So I'm going to continue to push back a bit on people sending me
stuff, but I'm also just going to hope that this was some one-time
thing and we really will be calming down now.

Ok? Because we all want a quiet holiday season, don't we? And Santa
doesn't like it when I curse a lot in email.

                     Linus

---
Adam Kwolek (1):
      md: raid5 crash during degradation

Ajaykumar Hotchandani (1):
      x86/mtrr: Resolve inconsistency with Intel processor manual

Al Viro (1):
      fix apparmor dereferencing potentially freed dentry, sanitize
__d_path() API

Alan Cox (2):
      x86/intel_mid: Fix the Kconfig for MID selection
      x86/intel_mid: Kconfig select fix

Alan Stern (1):
      PM / Driver core: leave runtime PM enabled during system shutdown

Alex Deucher (5):
      drm/radeon/kms: add some loop timeouts in pageflip code
      drm/radeon/kms: add some new pci ids
      drm/radeon/kms: fix scanout of 2D tiled buffers on EG/CM
      drm/radeon/kms: fix 2D tiling CS support on EG/CM
      drm/radeon/kms: fix return type for
radeon_encoder_get_dp_bridge_encoder_id

Alexandre Bounine (3):
      rapidio/tsi721: switch to dma_zalloc_coherent
      rapidio/tsi721: fix mailbox resource reporting
      rapidio/tsi721: modify PCIe capability settings

Alexandre Oliva (2):
      Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE
      Btrfs: try cluster but don't advance in search list

Alexey Moiseytsev (1):
      AF_UNIX: Fix poll blocking problem when reading from a stream socket

Anders Darander (1):
      ARM: at91: Fix USB AT91 gadget registration

Andiry Xu (2):
      xHCI: reset-on-resume quirk for NEC uPD720200
      xHCI: fix bug in xhci_clear_command_ring()

Andrea Arcangeli (1):
      thp: reduce khugepaged freezing latency

Andreas Herrmann (1):
      x86, amd: Fix up numa_node information for AMD CPU family 15h
model 0-0fh northbridge functions

Andrew Vagin (1):
      perf header: Use event_name() to get an event name

Andy Grover (1):
      target: Don't return an error if disabling unsupported features

Anton Blanchard (4):
      ehea: Reduce memory usage in buffer pools
      ehea: Use round_jiffies_relative to align workqueue
      net: Fix corruption in /proc/*/net/dev_mcast
      perf stat: Failure with "Operation not supported"

Anton Vorontsov (1):
      of/irq: Get rid of NO_IRQ usage

Aries Lee (1):
      jme: PHY configuration for compatible issue

Arnaldo Carvalho de Melo (1):
      perf python: Fix undefined symbol problem

Arve Hjønnevåg (1):
      rtc: Fix some bugs that allowed accumulating time drift in suspend/resume

Axel Lin (8):
      ASoC: Fix wrong define for AD1836_ADC_WORD_OFFSET
      ASoC: max9877: Update register if either val or val2 is changed
      ASoC: cs42l51: Fix off-by-one for reg_cache_size
      ASoC: kirkwood: Make SND_KIRKWOOD_SOC_OPENRD and
SND_KIRKWOOD_SOC_T5325 depend on I2C
      ASoC: uda1380: Return proper error in uda1380_modinit failure path
      ASoC: Fix dependency for SND_SOC_RAUMFELD and SND_PXA2XX_SOC_HX4700
      ASoC: Make SND_SOC_MX27VIS_AIC32X4 depend on I2C
      spi/nuc900: Include linux/module.h

Barry Song (2):
      ARM: CSR: fix build error due to new mdesc->dma_zone_size
      ARM: CSR: PM: fix build error due to undeclared 'THIS_MODULE'

Bart Van Assche (2):
      target: Improve system responsivity during I/O
      target: Avoid compiler warnings about signed one-bit bitfields

Bart Westgeest (1):
      staging: usbip: bugfix for deadlock

Ben Greear (1):
      mac80211: Fix AMSDU rate printout in debugfs.

Ben Hutchings (2):
      net: Revert ARCNET and PHYLIB to tristate options
      pasemi_mac: Fix building as module

Ben Skeggs (4):
      drm/nouveau: add dumb ioctl support
      drm/nvd0/disp: fix sor dpms typo, preventing dpms on in some situations
      drm/nouveau: fix oopses caused by clear being called on unpopulated ttms
      drm/nv50/disp: silence compiler warning

Benjamin Tissoires (1):
      HID: Correct General touch PID

Bernd Porr (2):
      staging: comedi: usbduxsigma: Fixed wrong range for the analogue channel.
      staging: comedi: fix oops for USB DAQ devices.

Bjorn Helgaas (1):
      x86/mpparse: Account for bus types other than ISA and PCI

Boojin Kim (1):
      ASoC: SAMSUNG: Fix build error

Borislav Petkov (2):
      x86: Document rdmsr_safe restrictions
      x86, AMD: Correct align_va_addr documentation

Carsten Emde (1):
      sched: Set the command name of the idle tasks in SMP kernels

Carsten Otte (1):
      [S390] fix page change underindication in pgste_update_all

Charles Chin (1):
      ALSA: hda - Fix S3/S4 problem on machines with VREF-pin mute-LED

Chris Metcalf (5):
      arch/tile: add a few #includes and an EXPORT to catch up with
kernel changes.
      arch/tile: fix double-free bug in homecache_free_pages()
      asm-generic/unistd.h: support new process_vm_{readv,write} syscalls
      drivers/net/ethernet/tile: use skb_frag_page() API
      arch/tile: use new generic {enable,disable}_percpu_irq() routines

Chris Wilson (1):
      drm: Fix lack of CRTC disable for drm_crtc_helper_set_config(.fb=NULL)

Christian Hitz (1):
      ARM: at91: fix NAND bus width decoding from system_rev

Christoph Bumiller (1):
      drm/nvc0/gr: fix TP init for transform feedback offset queries

Christoph Hellwig (11):
      xfs: validate acl count
      xfs: force buffer writeback before blocking on the ilock in inode reclaim
      xfs: fix attr2 vs large data fork assert
      target: remove the se_obj_ptr and se_orig_obj_ptr se_cmd fields
      target: remove the se_ordered_node se_cmd field
      target: remove the t_tasks_fua se_cmd field
      target: remove the t_tasks_bidi se_cmd field
      target: remove the unused t_task_pt_sgl and t_task_pt_sgl_num
se_cmd fields
      target: remove the unused se_dev_list
      xfs: fix nfs export of 64-bit inodes numbers on 32-bit kernels
      xfs: fix the logspace waiting algorithm

Claudio Scordino (1):
      fs/proc/meminfo.c: fix compilation error

Dan Carpenter (7):
      prism54: potential memory corruption in prism54_get_essid()
      caif: fix endian conversion in cffrml_transmit()
      net/netlabel: copy and paste bug in netlbl_cfg_unlbl_map_add()
      Staging: comedi: integer overflow in do_insnlist_ioctl()
      USB: whci-hcd: fix endian conversion in qset_clear()
      isdn: make sure strings are null terminated
      isdn: avoid copying too long drvid

Daniel Mack (1):
      ASoC: cs4720: use snd_soc_cache_sync()

Daniel Vetter (1):
      drm/i915: fix infinite recursion on unbind due to ilk vt-d w/a

Dave Chinner (1):
      xfs: fix allocation length overflow in xfs_bmapi_write()

David Ahern (1):
      perf session: Fix crash with invalid CPU list

David Dillow (1):
      ALSA: sis7019 - give slow codecs more time to reset

David S. Miller (5):
      netfilter: Remove NOTRACK/RAW dependency on NETFILTER_ADVANCED.
      ipv4: Perform peer validation on cached route lookup.
      Revert "udp: remove redundant variable"
      netfilter: Remove ADVANCED dependency from NF_CONNTRACK_NETBIOS_NS
      ipv4: Fix peer validation on cached lookup.

Dirk Nehring (1):
      usb: option: add Huawei E353 controlling interfaces

Dong Aisheng (1):
      ARM: mxs/tx28: add __initconst for fec pdata

Eliad Peller (1):
      nl80211: fix MAC address validation

Emmanuel Grumbach (1):
      mac80211: fix race between the AGG SM and the Tx data path

Eric Dumazet (8):
      ipv6: tcp: fix panic in SYN processing
      ipv6: tcp: fix tcp_v6_conn_request()
      decnet: proper socket refcounting
      inet: add a redirect generation id in inetpeer
      sch_teql: fix lockdep splat
      ipv4: fix lockdep splat in rt_cache_seq_show
      sch_red: fix red_calc_qavg_from_idle_time
      sch_red: fix red_change

Eric Miao (1):
      ASoC: skip resume of soc-audio devices without codecs

Fabio Estevam (3):
      usb: fsl_mxc_udc.c: Fix build issue by including missing header file
      usb: fsl_mxc_udc.c: Remove compile-time dependency of MX35 SoC type
      net: fec: Select the FEC driver by default for i.MX SoCs

Federico Vaga (2):
      Staging: comedi: fix mmap_count
      Staging: comedi: fix signal handling in read and write

Feng King (1):
      net: correct comments of skb_shift

Feng Tang (1):
      x86, mrst: Change the pmic_gpio device type to IPC

Florian Westphal (1):
      l2tp: ensure sk->dst is still valid

Gabor Juhos (1):
      spi/ath79: fix compile error due to missing include

Geert Uytterhoeven (1):
      m68k: Wire up process_vm_{read,write}v

Gertjan van Wingerde (1):
      rt2x00: Fix efuse EEPROM reading on PPC32.

Giuseppe CAVALLARO (1):
      stmmac: mask mmc interrupts

Gleb Natapov (3):
      perf: Do not set task_ctx pointer in cpuctx if there are no
events in the context
      jump_label: jump_label_inc may return before the code is patched
      perf: Do no try to schedule task events if there are none

Greg Kroah-Hartman (1):
      Revert "Staging: comedi: integer overflow in do_insnlist_ioctl()"

Hans Verkuil (1):
      ARM: davinci: dm646x evm: wrong register used in
setup_vpif_input_channel_mode

Heiko Stuebner (1):
      MAINTAINERS: Consolidate Samsung MAINTAINERS

Helmut Schaa (1):
      mac80211: Fix endian bug in radiotap header generation

Henrik Saavedra Persson (1):
      bonding: only use primary address for ARP

Hillf Danton (1):
      mm/migrate.c: pair unlock_page() and lock_page() when migrating huge pages

Holger Dengler (1):
      [S390] ap: Setup timer for sending messages after reset.

Hui Kang (1):
      sched_fair: Fix a typo in the comment describing update_sd_lb_stats

Ido Yariv (1):
      genirq: Fix race condition when stopping the irq thread

Ilya Dryomov (1):
      tracing: fix event_subsystem ref counting

J. Bruce Fields (1):
      sched: Document wait_for_completion_*() return values

Jack Steiner (1):
      x86, UV: Fix UV2 hub part number

Jacob Pan (1):
      x86,mrst: Power control commands update

Jan Beulich (1):
      xen-netback: use correct index for invalidation in
xen_netbk_tx_check_gop()

Janusz Krzysztofik (3):
      ARM: OMAP1: Remove unsafe clock values from omap1_defconfig
      ARM: OMAP1: Fix ckctl value used for dpll1 defualt rate
      ARM: OMAP1: recalculate loops per jiffy after dpll1 reprogram

Jean Delvare (2):
      drm/radeon/kms: Hide debugging message
      drm/radeon/kms: Skip ACPI call to ATIF when possible

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix clock conid for atmel_tcb.1 on 9260/9g20

Jeff Layton (2):
      cifs: attempt to freeze while looping on a receive attempt
      cifs: check for NULL last_entry before calling cifs_save_resume_key

Jekyll Lai (1):
      mrst: Added some platform data for the SFI translations

Jesper Juhl (1):
      net, sja1000: Don't include version.h in peak_pci.c when not needed

Jett.Zhou (1):
      ARM: sa1100: fix build error

Jiri Slaby (1):
      spi/fsl-espi: disable CONFIG_SPI_FSL_ESPI=m build

Joe Perches (1):
      MAINTAINERS: Update amd-iommu F: patterns

Joerg Roedel (1):
      iommu/msm: Fix compile error in mach-msm/devices-iommu.c

Johannes Berg (3):
      cfg80211: fix regulatory NULL dereference
      mac80211: don't stop a single aggregation session twice
      iwlagn: fix HW crypto for TX-only keys

John F Leach (1):
      ALSA: usb-audio - Support for Roland GAIA SH-01 Synthesizer

John W. Linville (3):
      Revert "rt2x00: handle spurious pci interrupts"
      Revert "rt2800pci: handle spurious interrupts"
      Revert "mac80211: clear sta.drv_priv on reconfiguration"

Jonghwan Choi (1):
      drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance issues

Jorge Boncompte [DTI2] (1):
      netns: fix proxy ARP entries listing on a netns

Jozsef Kadlecsik (1):
      netfilter: ipset: suppress compile-time warnings in ip_set_hash_ipport*.c

Julian Anastasov (1):
      ipv4: make sure RTO_ONLINK is saved in routing cache

Jun Zhao (1):
      ipv4 : igmp : fix error handle in ip_mc_add_src()

Jörn Engel (1):
      target: remove unused struct fields

KAMEZAWA Hiroyuki (1):
      memcg: update maintainers

Kees Cook (1):
      CREDITS: update Kees's expired fingerprint and fix details

Kevin Hilman (1):
      usb: musb: PM: fix context save/restore in suspend/resume path

Klaus Schwarzkopf (1):
      USB: linux-cdc-acm.inf: add support for the acm_ms gadget

Konrad Rzeszutek Wilk (2):
      xen/pm_idle: Make pm_idle be default_idle under Xen.
      x86/paravirt: PTE updates in k(un)map_atomic need to be
synchronous, regardless of lazy_mmu mode

Konstantin Khlebnikov (2):
      vmscan: fix initial shrinker size handling
      vmscan: use atomic-long for shrinker batching

Kuninori Morimoto (4):
      usb: renesas_usbhs: fixup device_register timing
      usb: renesas_usbhs: fixup signal the driver that cable was disconnected
      usb: renesas_usbhs: fixup gadget.dev.driver when udc_stop.
      usb: renesas_usbhs: fixup driver speed

Lars-Peter Clausen (3):
      firmware: Sigma: Prevent out of bounds memory access
      firmware: Sigma: Skip header during CRC generation
      firmware: Sigma: Fix endianess issues

Lauri Hintsala (1):
      ARM: mxs: fix machines' initializers order

Li Wei (3):
      ipv6: fix a bug in ndisc_send_redirect
      ipv4: Save nexthop address of LSRR/SSRR option to IPCB.
      ipv6: Set mcast_hops to IPV6_DEFAULT_MCASTHOPS when -1 was given.

Li Yang (1):
      usb: gadget: fsl_udc: fix dequeuing a request in progress

Li Zefan (2):
      tracing: Restore system filter behavior
      Btrfs: check if the to-be-added device is writable

Linus Torvalds (2):
      x86: Fix boot failures on older AMD CPU's
      Linux 3.2-rc5

Linus Walleij (1):
      gpio: fix a build failure on KS8695 GPIO

Liu Bo (1):
      Btrfs: drop spin lock when memory alloc fails

Luis R. Rodriguez (2):
      cfg80211: fix race on init and driver registration
      cfg80211: amend regulatory NULL dereference fix

Maciej Żenczykowski (1):
      net-netlink: fix diag to export IPv4 tos for dual-stack IPv6 sockets

Major Lee (1):
      x86/mrst: Battery fixes

Mandeep Singh Baines (1):
      sys_getppid: add missing rcu_dereference

Manjunathappa, Prakash (1):
      ARM: davinci: da850 evm: change audio edma event queue to EVENTQ_0

Manuel Lauss (1):
      spi/gpio: fix section mismatch warning

Marc Vertes (1):
      ALSA: hda_intel - revert a quirk that affect VIA chipsets

Marcin Kościelnicki (1):
      usb: ftdi_sio: add PID for Propox ISPcable III

Mark Brown (12):
      dm9000: Fix check for disabled wake on LAN
      ASoC: Correct name of Speyside Main Speaker widget
      ASoC: Error out if we can't generate a LRCLK at all for WM8994
      ASoC: Supply dcs_codes for newer WM1811 revisions
      MAINTAINERS: Add linux-samsung-soc mailing list for Samsung
      MAINTAINERS: Extend Samsung patterns to cover SPI and ASoC drivers
      ARM: S3C64XX: Remove extern from definition of framebuffer setup call
      ARM: S3C64XX: Add linux/export.h to dev-spi.c
      ARM: S3C64XX: Staticise s3c6400_sysclass
      ASoC: Mark WM8994 ADC muxes as virtual
      ASoC: Remove references to corgi and spitz from machine driver document
      ASoC: Provide a more complete DMA driver stub

Mark Langsdorf (1):
      x86, hpet: Immediately disable HPET timer 1 if rtc irq is masked

Martin Schwidefsky (3):
      [S390] ptrace inferior call interactions with TIF_SYSCALL
      [S390] add missing .set function for NT_S390_LAST_BREAK regset
      [S390] remove reset of system call restart on psw changes

Mathias Nyman (1):
      x86/rtc, mrst: Don't register a platform RTC device for for
Intel MID platforms

Matt Fleming (1):
      x86, efi: Calling __pa() with an ioremap()ed address is invalid

Matthieu CASTET (1):
      EHCI : Fix a regression in the ISO scheduler

Mel Gorman (1):
      mm: vmalloc: check for page allocation failure before vmlist insertion

Michael Buesch (2):
      p54spi: Add missing spin_lock_init
      p54spi: Fix workqueue deadlock

Michael Holzheu (1):
      [S390] kdump: Replace is_kdump_kernel() with OLDMEM_BASE check

Michal Hocko (2):
      mm: Ensure that pfn_valid() is called once per pageblock when
reserving pageblocks
      procfs: do not overflow get_{idle,iowait}_time for nohz

Michal Nazarewicz (1):
      usb: udc: Fix gadget driver's speed check in various UDC drivers

Mitsuo Hayasaka (1):
      x86: Add user_mode_vm check in stack_overflow_check

Murali Karicheri (2):
      ARM: davinci: psc: fix incorrect mask
      ARM: davinci: psc: fix incorrect offsets

NeilBrown (6):
      md/lock: ensure updates to page_attrs are properly locked.
      md: refine interpretation of "hold_active == UNTIL_IOCTL".
      md: take a reference to mddev during sysfs access.
      md: bad blocks shouldn't cause a Blocked status on a Faulty device.
      md: ensure new badblocks are handled promptly.
      md/raid5: never wait for bad-block acks on failed device.

Nicholas Bellinger (7):
      target: Address legacy PYX_TRANSPORT_* return code breakage
      iscsi-target: Fix sess allocation leak in iscsi_login_zero_tsih_s1
      target: Drop config_item_name usage in fabric TFO->free_wwn()
      target: Reject SCSI data overflow for fabrics using
transport_generic_map_mem_to_cmd
      iscsi-target: Fix residual count hanlding + remove
iscsi_cmd->residual_count
      iscsi-target: Add missing F_BIT for iscsi_tm_rsp
      iscsi-target: Fix hex2bin warn_unused compile message

Nikolay Martynov (1):
      mac80211: fix race condition caused by late addBA response

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: make event callback registration per-netns

Paul Bolle (1):
      ASoC: drop support for PlayPaq with WM8510

Paul Guo (1):
      netfilter: possible unaligned packet header in ip_route_me_harder

Paul Moore (1):
      netlabel: Fix build problems when IPv6 is not enabled

Paul Turner (1):
      sched: Fix buglet in return_cfs_rq_runtime()

Pavel Shilovsky (1):
      CIFS: Add descriptions to the brlock cache functions

Peter Chen (1):
      USB: fsl_udc_core: use usb_endpoint_xfer_isoc to judge ISO XFER

Peter Chubb (1):
      x86: Fix "Acer Aspire 1" reboot hang

Peter Pan(潘卫平) (2):
      ipv4: flush route cache after change accept_local
      ipv4:correct description for tcp_max_syn_backlog

Peter Rusko (1):
      ARM: mx28: LRADC macro rename

Peter Zijlstra (10):
      sched: Add a comment to effective_load() since it's a pain
      sched, rt: Provide means of disabling cross-cpu bandwidth sharing
      perf/x86: Fix PEBS instruction unwind
      perf: Don't use -ENOSPC for out of PMU resources
      perf/x86: Enable raw event access to Intel offcore events
      sched: Avoid SMT siblings in select_idle_sibling() if possible
      perf, x86: Disable PEBS on SandyBridge chips
      perf: Fix loss of notification with multi-event
      slab, lockdep: Fix silly bug
      printk: avoid double lock acquire

Prarit Bhargava (1):
      Add TAINT_FIRMWARE_WORKAROUND on MTRR fixup

Qinglin Ye (1):
      USB: usb-storage: unusual_devs entry for Kingston DT 101 G2

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware

Rafael J. Wysocki (2):
      ath9k: Revert change that broke AR928X on Acer Ferrari One
      x86/reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot

Robert Jarzmik (1):
      usb: gadget: fix g_serial regression

Robert Richter (3):
      oprofile: Fix crash when unloading module (hr timer mode)
      oprofile, x86: Fix crash when unloading module (nmi timer mode)
      perf, x86: Force IBS LVT offset assignment for family 10h

Roland Dreier (4):
      target: Get rid of unused se_cmd_cache
      target: Don't return an error status for 0-length READ and WRITE
      target: Handle 0 correctly in transport_get_sectors_6()
      target: Fix page length in emulated INQUIRY VPD page 86h

RongQing.Li (2):
      dccp: fix error propagation in dccp_v4_connect
      net/core: fix rollback handler in register_netdevice_notifier

Salman Qazi (1):
      sched, x86: Avoid unnecessary overflow in sched_clock

Sarah Sharp (1):
      Revert "xHCI: reset-on-resume quirk for NEC uPD720200"

Sebastian Andrzej Siewior (3):
      target/file: walk properly over sg list
      target/rd: simplify the page/offset computation
      target/rd: fix or rewrite the copy routine

Sebastian Ott (4):
      [S390] hibernate: directly trigger subchannel evaluation
      [S390] cio: disallow driver io for known to be broken paths
      [S390] cio: provide fake irb for transport mode IO
      [S390] cio: fix chsc_chp_vary

Sedat Dilek (1):
      iommu/amd: Fix typo in kernel-parameters.txt

Sekhar Nori (1):
      ARM: davinci: dm646x does not have a DSP domain

Sergey Senozhatsky (2):
      intel-iommu: Fix section mismatch in dmar_parse_rmrr_atsr_dev()
      intr_remapping: Fix section mismatch in ir_dev_scope_init()

Seth Forshee (1):
      toshiba_acpi: Fix machines that don't support HCI_SYSTEM_EVENT

Shankarmurthy,Akshay (1):
      ARM: davinci: dm365 evm: align nand partition table to u-boot

Shawn Guo (2):
      arm/imx: fix return type of callback passed to of_irq_init()
      arm/imx: fix irq_base for gpio

Simon Wunderlich (1):
      mac80211: fill rate filter for internal scan requests

Srivatsa S. Bhat (1):
      x86, microcode: Fix the failure path of microcode update driver init code

Stanislaw Gruszka (3):
      rt2800pci: handle spurious interrupts
      rt2x00: handle spurious pci interrupts
      rtlwifi: fix lps_lock deadlock

Steffen Klassert (5):
      route: Use the device mtu as the default for blackhole routes
      net: Rename the dst_opt default_mtu method to mtu
      net: Move mtu handling down to the protocol depended handlers
      route: struct rtable can be const in rt_is_input_route and
rt_is_output_route
      ipv4: Don't use the cached pmtu informations for input routes

Stephen Boyd (1):
      net: Silence seq_scale() unused warning

Steve French (1):
      cifs: Fix sparse warning when calling cifs_strtoUCS

Steven Rostedt (3):
      ftrace: Remove force undef config value left for testing
      perf: Fix parsing of __print_flags() in TP_printk()
      ftrace: Fix hash record accounting bug

Takashi Iwai (7):
      ALSA: hda - Avoid touching mute-VREF pin for IDT codecs
      ALSA: hda/realtek - Fix Oops in alc_mux_select()
      ALSA: hda - Fix GPIO LED setup for IDT 92HD75 codecs
      ALSA: hda - Fix remaining VREF mute-LED NID check in post-3.1 changes
      ALSA: hda/realtek - Don't create extra controls with channel suffix
      ALSA: hda/realtek - Create "Bass Speaker" for two speaker pins
      ALSA: hda/realtek - Fix lost speaker volume controls

Tejun Heo (1):
      trace_events_filter: Use rcu_assign_pointer() when setting
ftrace_event_call->filter

Tetsuo Handa (1):
      TOMOYO: Fix pathname handling of disconnected paths.

Thadeu Lima de Souza Cascardo (1):
      qlge: fix size of external list for TX address descriptors

Thomas Gleixner (4):
      tick-broadcast: Stop active broadcast device when replacing it
      clockevents: Set noop handler in clockevents_exchange_device()
      ptp: Fix clock_getres() implementation
      alarmtimers: Fix time comparison

Thomas Jarosch (2):
      Fix comparison using wrong pointer variable in dma debug code
      iseries_veth: Fix wrong parameter given to sizeof call

Thomas Meyer (2):
      iscsi-target: Use kmemdup rather than duplicating its implementation
      vmwgfx: Use kcalloc instead of kzalloc to allocate array

Timur Tabi (1):
      ASoC: mpc8610: tell the CS4270 codec that it's the master

Tony Lindgren (1):
      ARM: OMAP1: Fix reprogramming of DPLL1 for systems that boot at
rates below 60MHz

Veli-Pekka Peltola (1):
      usb: option: add SIMCom SIM5218

Vitalii Demianets (1):
      bridge: master device stuck in no-carrier state forever when in
user-stp mode

Wei Liu (1):
      netback: Fix alert message.

Wey-Yi Guy (2):
      iwlwifi: do not re-configure HT40 after associated
      iwlwifi: change the default behavior of watchdog timer

Wolfram Sang (1):
      arm: mx23: recognise stmp378x as mx23

Xander Hover (1):
      b44: Use dev_kfree_skb_irq() in b44_tx()

Xi Wang (4):
      Staging: comedi: fix integer overflow in do_insnlist_ioctl()
      sctp: integer overflow in sctp_auth_create_key()
      sctp: better integer overflow check in sctp_auth_create_key()
      vmwgfx: integer overflow in vmw_kms_update_layout_ioctl()

Yang Honggang (Joseph) (1):
      clocksource: Fix bug with max_deferment margin calculation

Yaniv Rosner (1):
      bnx2x: Fix 5461x LED

Yong Zhang (1):
      lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()

Younes Manton (1):
      drm/nouveau: Keep RAMIN heap within the channel.

Youquan Song (2):
      thp: add compound tail page _mapcount when mapped
      thp: set compound tail page _count to zero

françois romieu (2):
      r8169: Rx FIFO overflow fixes.
      r8169: fix Rx index race between FIFO overflow recovery and NAPI handler.

stephen hemminger (1):
      tc: comment spelling fixes

wwang (1):
      staging:rts_pstor:Complete scanning_done variable
