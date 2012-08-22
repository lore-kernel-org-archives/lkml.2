Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab2HVU4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:56:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62060 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab2HVUzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:55:50 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Aug 2012 13:55:28 -0700
X-Google-Sender-Auth: t2ufNZGq2KxK1q3XoI7rm8Gqmt8
Message-ID: <CA+55aFz8dUQxybwYtSP55TFQj3ubQH+i85z=efmN66ZX6+128Q@mail.gmail.com>
Subject: Linux 3.6-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A mid-week -rc release to match the mid-week rc2 release. It's just
six days since rc2, but I'm not only making up for the longer -rc2,
I'm also on the airport for San Diego, spending a few days there
before the kernel summit.

Also, it's already pretty big, probably because some people held off
asking me to pull while I was away, resulting in some pent-up demand
for -rc3.

It's a bit over half drivers, with a quarter being arch updates, and
the rest being "random" - mostly networking and filesystems.

Shortlog appemded, there's nothing here that makes me go "OMG! Scary!"
or makes me want to particularly mention it separately. All just
random updates and fixes.

Go get it,

                 Linus

---

Aaro Koskinen (1):
      regulator: twl-regulator: fix up VINTANA1/VINTANA2

AceLan Kao (2):
      asus-wmi: record wlan status while controlled by userapp
      dell-laptop: Fixed typo in touchpad LED quirk

Ajay Kumar Gupta (3):
      usb: musb: Fix wrong config for am33xx and ti81xx
      usb: musb: am335x: fix pdev resource bug
      usb: musb: reorder runtime pm call

Al Viro (10):
      mqueue: lift mnt_want_write() outside ->i_mutex, clean up a bit
      alpha: take a bunch of syscalls into osf_sys.c
      alpha: take kernel_execve() out of entry.S
      vfs: missed source of ->f_pos races
      vfio: don't dereference after kfree...
      introduce kref_put_mutex()
      vfio: get rid of open-coding kref_put_mutex
      vfio: get rid of vfio_device_put()/vfio_group_get_device* races
      vfio: grab vfio_device reference *before* exposing the sucker
via fd_install()
      eventpoll: use-after-possible-free in epoll_create1()

Alan Cox (1):
      drm: stop vmgfx driver explosion

Albert Wang (1):
      [media] media: soc_camera: don't clear pix->sizeimage in JPEG mode

Alex Deucher (5):
      ACPI: export symbol acpi_get_table_with_size
      drm/radeon: convert radeon vfct code to use acpi_get_table_with_size
      drm/radeon: split ATRM support out from the ATPX handler (v3)
      Revert "drm/radeon: fix bo creation retry path"
      drm/radeon/ss: use num_crtc rather than hardcoded 6

Alex Gershgorin (1):
      [media] media: mx3_camera: buf_init() add buffer state check

Alex Shi (1):
      mm: correct page->pfmemalloc to fix deactivate_slab regression

Alexander Shiyan (1):
      serial: Change Kconfig entry for CLPS711X-target

Alexandre Bounine (2):
      rapidio/tsi721: fix inbound doorbell interrupt handling
      rapidio/tsi721: fix unused variable compiler warning

Alexey Khoroshilov (2):
      rndis_wlan: Fix potential memory leak in update_pmkid()
      iio/adjd_s311: Fix potential memory leak in adjd_s311_update_scan_mode()

Amerigo Wang (15):
      netpoll: use GFP_ATOMIC in slave_enable_netpoll() and __netpoll_setup()
      netpoll: make __netpoll_cleanup non-block
      netconsole: do not release spin_lock when calling __netpoll_cleanup
      netpoll: take rcu_read_lock_bh() in netpoll_rx()
      netpoll: use netpoll_rx_on() in netpoll_rx()
      netpoll: take rcu_read_lock_bh() in netpoll_send_skb_on_dev()
      bridge: add some comments for NETDEV_RELEASE
      bridge: use list_for_each_entry() in netpoll functions
      netpoll: check netpoll tx status on the right device
      netpoll: convert several functions to bool
      vlan: clean up some variable names
      vlan: clean up vlan_dev_hard_start_xmit()
      netpoll: handle vlan tags in netpoll tx and rx path
      netpoll: re-enable irq in poll_napi()
      netconsole: remove a redundant netconsole_target_put()

Andi Kleen (1):
      sections: Fix section conflicts in drivers/hwmon

Andreas Heider (1):
      apple-gmux: Add display mux support

Andrei Emeltchenko (1):
      Bluetooth: smp: Fix possible NULL dereference

Andrew Boie (1):
      x86, build: Globally set -fno-pic

Atsushi Nemoto (1):
      drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode

Axel Lin (8):
      regulator: palmas: Fix calculating selector in palmas_map_voltage_ldo
      regulator: palmas: Fix regmap offsets for PALMAS_REG_SMPS10 vsel_reg
      regulator: palmas: Call palmas_ldo_[read|write] in palmas_ldo_init
      regulator: palmas: Fix palmas_probe error handling
      regulator: anatop: Fix wrong mask used in anatop_get_voltage_sel
      extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one
      iio: lm3533-als: Fix build warnings
      pwm: Remove a redundant error message when devm_request_and_ioremap fails

Bart Van Assche (1):
      IB/srp: Fix a race condition

Ben Hutchings (4):
      llc2: Fix silent failure of llc_station_init()
      llc2: Call llc_station_exit() on llc2_init() failure path
      llc: Fix races between llc2 handler use and (un)registration
      ipv6: addrconf: Avoid calling netdevice notifiers with RCU read-side lock

Ben Widawsky (1):
      drm/i915/contexts: fix list corruption

Bjørn Mork (9):
      usb: usb_wwan: replace release and disconnect with a port_remove hook
      usb: serial: prevent suspend/resume from racing against probe/remove
      usb: usb_wwan: resume/suspend can be called after port is gone
      net: qmi_wwan: use fixed interface number matching
      net: qmi_wwan: add Sierra Wireless devices
      net: qmi_wwan: compress device_id list using macros
      net: sierra_net: replace whitelist with ifnumber match
      USB: option: add ZTE K5006-Z
      net: qmi_wwan: new devices: UML290 and K5006-Z

Boaz Harrosh (1):
      pnfs-obj: Better IO pattern in case of unaligned offset

Bob Copeland (1):
      ath5k: fix spin_lock_irqsave/spin_lock_bh nesting in mesh

Borislav Petkov (1):
      perf, x86: Fix uncore_types_exit section mismatch

Bruno Morelli (1):
      USB: isp1362-hcd.c: usb message always saved in case of underrun

Bryan Schumaker (2):
      NFS: Clear key construction data if the idmap upcall fails
      NFS: return -ENOKEY when the upcall fails to map the name

Carlos Alberto Lopez Perez (1):
      classmate-laptop: always call input_sync() after input_report_switch()

Chris Rattray (1):
      ASoC: wm8994: Add missing dapm routes for WM8958 rev A

Christian König (1):
      drm/radeon: init lockup timeout on ring init

Christoph Paasch (1):
      ipv4: Use newinet->inet_opt in inet_csk_route_child_sock()

Colin Cross (2):
      ARM: 7486/1: sched_clock: update epoch_cyc on resume
      cpuidle: coupled: fix sleeping while atomic in cpu notifier

Damien Lespiau (1):
      drm: Remove two unused fields from struct drm_display_mode

Dan Carpenter (3):
      ALSA: cs46xx - signedness bug in snd_cs46xx_codec_read()
      wireless: at76c50x: signedness bug in at76_dfu_get_state()
      sound: oss/sb_audio: prevent divide by zero bug

Dan Williams (1):
      USB: qcserial: fix port handling on Gobi 1K and 2K+

Daniel Mack (1):
      Documentation/pinctrl.txt: Fix some misspelled macros

Daniel Vetter (2):
      drm/i915: fix hsw uncached pte
      drm/i915: use hsw rps tuning values everywhere on gen6+

Dave Airlie (3):
      fbcon: fix race condition between console lock and cursor timer
      drm/udl: dpms off the crtc when disabled.
      fbcon: fix race condition between console lock and cursor timer (v1.1)

David Henningsson (5):
      ALSA: hda - Fix pop noise in headphones on S3 for Asus X55A, X55V
      ALSA: hda - Fix panned "Beep Playback Switch"
      ALSA: hda - Fix 'Beep Playback Switch' with no underlying mute switch
      ALSA: hda - Don't send invalid volume knob command on IDT 92hd75bxx
      ALSA: hda - don't create dysfunctional mixer controls for ca0132

David Lamparter (1):
      drm/radeon: implement ACPI VFCT vbios fetch (v3)

Denis Efremov (1):
      tcm_fc: rcu_deref outside rcu lock/unlock section

Dirk Gouders (1):
      netconsole.txt: revision of examples for the receiver of kernel messages

Eric Dumazet (5):
      task_work: add a scheduling point in task_work_run()
      tcp: fix possible socket refcount problem
      ipv4: fix ip header ident selection in __ip_make_skb()
      af_netlink: force credentials passing [CVE-2012-3520]
      task_work: add a scheduling point in task_work_run()

Eric Leblond (1):
      af_packet: don't emit packet on orig fanout group

Fabio Estevam (5):
      ASoC: mxs: Fix the name of the SoC family
      ASoC: imx-ssi: Remove mono support
      [media] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
      [media] video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepare
      [IA64] defconfig: Remove CONFIG_MISC_DEVICES

Felix Fietkau (1):
      ath9k: fix interrupt storms on queued hardware reset

Fengguang Wu (2):
      serial: ifx6x60: fix paging fault on spi_register_driver
      tcm_vhost: Fix incorrect IS_ERR() usage in vhost_scsi_map_iov_to_sgl

Gleb Natapov (1):
      perf/x86: disable PEBS on a guest entry.

Greg Kroah-Hartman (9):
      staging: csr: add INET dependancy
      USB: smsusb: remove __devinit* from the struct usb_device_id table
      USB: jl2005bcd: remove __devinit* from the struct usb_device_id table
      USB: spca506: remove __devinit* from the struct usb_device_id table
      USB: p54usb: remove __devinit* from the struct usb_device_id table
      USB: rtl8187: remove __devinit* from the struct usb_device_id table
      USB: vt6656: remove __devinit* from the struct usb_device_id table
      USB: winbond: remove __devinit* from the struct usb_device_id table
      USB: emi62: remove __devinit* from the struct usb_device_id table

Greg Ungerer (2):
      m68knommu: select CONFIG_HAVE_CLK for ColdFire CPU types
      m68k: select CONFIG_GENERIC_ATOMIC64 for all m68k CPU types

Guenter Roeck (6):
      [media] Add USB dependency for IguanaWorks USB IR Transceiver
      spi/bcm63xx: Ensure that memory is freed only after it is no longer used
      spi: spi-coldfire-qspi: Drop extra spi_master_put in device
remove function
      spi/coldfire-qspi: Drop extra calls to spi_master_get in
suspend/resume functions
      i2c: diolan-u2c: Fix master_xfer return code
      gpu/mfd/usb: Fix USB randconfig problems

Gustavo Padovan (1):
      Bluetooth: Fix possible deadlock in SCO code

H Hartley Sweeten (5):
      staging: comedi: remove pci_is_enabled() tests
      staging: comedi: daqboard2000: add back subsystem_device check
      staging: comedi: daqboard2000: ioremap'ed addresses are resource_size_t
      staging: comedi: dt3000: ioremap'ed addresses are resource_size_t
      staging: comedi: rtd520: ioremap'ed addresses are resource_size_t

H. Peter Anvin (1):
      Revert "x86-64/efi: Use EFI to deal with platform wall clock"

Hans Verkuil (5):
      [media] DocBook: Remove a spurious character
      [media] si470x: v4l2-compliance fixes
      [media] mem2mem_testdev: fix querycap regression
      [media] VIDIOC_ENUM_FREQ_BANDS fix
      [media] Add missing logging for rangelow/high of hwseek

Hans de Goede (4):
      [media] radio-shark*: Remove work-around for dangling pointer in
usb intfdata
      [media] radio-shark*: Call cancel_work_sync from disconnect
rather then release
      [media] radio-shark: Only compile led support when CONFIG_LED_CLASS is set
      [media] radio-shark2: Only compile led support when
CONFIG_LED_CLASS is set

Heiko Stübner (1):
      regulator: gpio-regulator: Split setting of voltages and currents

Huang Shijie (1):
      serial: mxs-auart: fix the wrong RTS hardware flow control

Hugh Dickins (1):
      mm: change nr_ptes BUG_ON to WARN_ON

Ian Abbott (1):
      staging: comedi: Fix reversed test in comedi_device_attach()

Ian Kent (1):
      autofs4 - fix expire check

Idan Kedar (2):
      pnfs: defer release of pages in layoutget
      pnfs: nfs4_proc_layoutget returns void

Igor Maravic (1):
      net: ipv6: proc: Fix error handling

Ilya Shchepetkov (1):
      drivers/rtc/rtc-pcf2123.c: initialize dynamic sysfs attributes

Jack Morgenstein (1):
      IB/mlx4: Fix possible deadlock on sm_lock spinlock

Jaganath Kanakkassery (1):
      Bluetooth: Fix socket not getting freed if l2cap channel create fails

James Ralston (1):
      ALSA: hda_intel: Add Device IDs for Intel Lynx Point-LP PCH

Jani Nikula (3):
      drm/i915: fix EDID memory leak in SDVO
      drm/i915: extract connector update from intel_ddc_get_modes() for reuse
      drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads

Jason Wang (1):
      act_mirred: do not drop packets when fails to mirror it

Jason Wessel (1):
      pmac_zilog,kdb: Fix console poll hook to return instead of loop

Javier Martin (1):
      [media] media: mx2_camera: Fix clock handling for i.MX27

Jayakrishnan Memana (1):
      [media] uvcvideo: Reset the bytesused field when recycling an
erroneous buffer

Jeff Layton (1):
      nfs: tear down caches in nfs_init_writepagecache when allocation fails

Jens Rottmann (1):
      cs5535-clockevt: typo, it's MFGPT, not MFPGT

Jerome Glisse (1):
      drm/radeon: avoid turning off spread spectrum for used pll

Jesper Juhl (1):
      caif: Do not dereference NULL in chnl_recv_cb()

Jim Cromie (1):
      drivers-core: make structured logging play nice with dynamic-debug

Jim Schutt (1):
      libceph: avoid truncation due to racing banners

Jingoo Han (1):
      pwm: samsung: add missing device pointer to struct pwm_chip

Joe Perches (1):
      checkpatch: add control statement test to SINGLE_STATEMENT_DO_WHILE_MACRO

Joerg Roedel (1):
      iommu/amd: Fix wrong check for ARRAY_SIZE()

John Fastabend (3):
      net: netprio: fix files lock and remove useless d_path bits
      net: netprio: fd passed in SCM_RIGHTS datagram not set correctly
      net: netprio: fix cgrp create and write priomap race

Jon Medhurst (Tixy) (1):
      cpuidle: Prevent null pointer dereference in cpuidle_coupled_cpu_notify

Julia Lawall (13):
      drivers/net/ethernet/ti/davinci_cpdma.c: Remove potential NULL dereference
      drivers/net/ethernet/freescale/fs_enet: fix error return code
      drivers/net/ethernet/mellanox/mlx4/mcg.c: fix error return code
      IB/qib: Fix error return code in qib_init_7322_variables()
      ALSA: sound/atmel/abdac.c: fix error return code
      ALSA: sound/atmel/ac97c.c: fix error return code
      ALSA: sound/pci/ctxfi/ctatc.c: fix error return code
      ALSA: sound/pci/sis7019.c: fix error return code
      ALSA: sound/pci/rme9652/hdspm.c: fix error return code
      ALSA: sound/ppc/snd_ps3.c: fix error return code
      drivers/net/wimax/i2400m/fw.c: fix error return code
      drivers/net/wan/dscc4.c: fix error return code
      drivers/net/irda: fix error return code

Kautuk Consul (1):
      alpha/mm/fault.c: Port OOM changes to do_page_fault

Kees Cook (1):
      Yama: access task_struct->comm directly

Kelvin Cheung (1):
      net/stmmac: fix issue of clk_get for Loongson1B.

Keshava Munegowda (1):
      OMAP: USB : Fix the EHCI enumeration and core retention issue

Kevin Hilman (1):
      I2C: OMAP: xfer: fix runtime PM get/put balance on error

Kleber Sacilotto de Souza (1):
      IB/mlx4: Check iboe netdev pointer before dereferencing it

Konrad Rzeszutek Wilk (1):
      intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.

Kuninori Morimoto (2):
      usb: renesas_usbhs: mod_host: add missing .bus_suspend/resume
      usb: renesas_usbhs: fixup resume method for autonomy mode

Lars-Peter Clausen (12):
      staging:iio:ad7793: Add missing break in switch statement
      staging:iio:ad7793: Mark channels as unsigned
      staging:iio:ad7793: Report channel offset
      staging:iio:ad7793: Fix temperature scale and offset
      staging:iio:ad7793: Follow new IIO naming spec
      staging:iio:ad7793: Fix internal reference value
      staging:iio:ad7192: Add missing break in switch statement
      staging:iio:ad7192: Fix setting ACX
      staging:iio:ad7192: Mark channels as unsigned
      staging:iio:ad7192: Report channel offset
      staging:iio:ad7192: Report offset and scale for temperature channel
      staging:iio:ad7780: Mark channels as unsigned

Laxman Dewangan (2):
      regulator: tps6586x: correct vin pin for sm0/sm1/sm2
      i2c: tegra: protect suspend/resume callbacks with CONFIG_PM_SLEEP

Lee Jones (1):
      i2c: nomadik: Add default configuration into the Nomadik I2C driver

Linus Torvalds (1):
      Linux 3.6-rc3

Linus Walleij (2):
      regulator: ab3100: add missing voltage table
      pinctrl/nomadik: fix null in irqdomain errorpath

Lorenzo Bianconi (1):
      ath9k: fix decrypt_error initialization in ath_rx_tasklet()

Manoj Iyer (2):
      Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0
      thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

Marc Kleine-Budde (1):
      usb: chipidea: fix and improve dependencies if usb host or
gadget support is built as module

Marek Olšák (2):
      drm/radeon: allow CMASK and FMASK in the CS checker on r600-r700
      drm/radeon: fix checking of MSAA renderbuffers on r600-r700

Marek Szyprowski (1):
      regulator: core: request only valid gpio pins for regulator enable

Mark Brown (10):
      regulator: twl: Remove references to the twl4030 regulator
      ASoC: wm8962: Don't duplicate bias level management in resume
      ASoC: core: Upgrade the severity of probe deferral errors to dev_err()
      MAINTAINERS: Add entries for Wolfson Arizona class devices
      ASoC: wm5102: Add missing input PGA routes
      ASoC: wm5110: Add missing input PGA routes
      ASoC: jack: Always notify full jack status
      ASoC: wm5102: Remove DRC2
      ASoC: wm9712: Fix microphone source selection
      ASoC: wm9712: Fix inverted capture volume

Mark Ferrell (2):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()
      USB: serial: Fix mos7840 timeout

Mark Rustad (1):
      tcm_fc: Avoid debug overhead when not debugging

Mark Salter (2):
      C6X: add Lx_CACHE_SHIFT defines
      C6X: select GENERIC_ATOMIC64

Markus Trippelsdorf (1):
      dyndbg: fix for SOH in logging messages

Masanari Iida (1):
      IB: Fix typos in infiniband drivers

Mathias Krause (14):
      atm: fix info leak in getsockopt(SO_ATMPVC)
      atm: fix info leak via getsockname()
      Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
      Bluetooth: HCI - Fix info leak via getsockname()
      Bluetooth: RFCOMM - Fix info leak in getsockopt(BT_SECURITY)
      Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)
      Bluetooth: RFCOMM - Fix info leak via getsockname()
      Bluetooth: L2CAP - Fix info leak via getsockname()
      l2tp: fix info leak via getsockname()
      llc: fix info leak via getsockname()
      dccp: check ccid before dereferencing
      dccp: fix info leak via getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)
      ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)
      net: fix info leak in compat dev_ifconf()

Matthew Garrett (3):
      gmux: Add generic write32 function
      apple_gmux: Add support for newer hardware
      apple_gmux: Fix ACPI video unregister

Matthias Kaehlcke (1):
      ti-st: Fix check for pdata->chip_awake function pointer

Maxim Mikityanskiy (3):
      ideapad: add Lenovo IdeaPad Z570 support (part 1)
      ideapad: add Lenovo IdeaPad Z570 support (part 2)
      ideapad: add Lenovo IdeaPad Z570 support (part 3)

Mel Gorman (3):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
      mm: have order > 0 compaction start near a pageblock with free pages
      mm: compaction: Abort async compaction if locks are contended or
taking too long

Mengdong Lin (1):
      ALSA : hda - bug fix on checking the supported power states of a codec

Michael Cree (4):
      alpha: Don't export SOCK_NONBLOCK to user space.
      alpha: Wire up cross memory attach syscalls
      alpha: Use new generic strncpy_from_user() and strnlen_user()
      alpha: Fix fall-out from disintegrating asm/system.h

Michael Grzeschik (1):
      usb: gadget: u_ether: fix kworker 100% CPU issue with still used
interfaces in eth_stop

Michael Hennerich (2):
      iio: staging: ad7298_ring: Fix maybe-uninitialized warning
      iio: frequency: ADF4350: Fix potential reference div factor overflow.

Michael S. Tsirkin (1):
      tcm_vhost: Fix vhost_scsi_target structure alignment

Michal Hocko (1):
      mm: hugetlbfs: correctly populate shared pmd

Michel JAOUEN (1):
      spi/pl022: fix spi-pl022 pm enable at probe

Mike Frysinger (2):
      x32: Use compat shims for {g,s}etsockopt
      alpha: fix fpu.h usage in userspace

Mike Galbraith (3):
      sched,cgroup: Fix up task_groups list
      sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled
      sched: Fix migration thread runtime bogosity

Miklos Szeredi (7):
      audit: don't free_chunk() after fsnotify_add_mark()
      audit: fix refcounting in audit-tree
      audit: clean up refcounting in audit-tree
      vfs: canonicalize create mode in build_open_flags()
      vfs: atomic_open(): fix create mode usage
      vfs: pass right create mode to may_o_create()
      fuse: check create mode in atomic open

Minchan Kim (1):
      mm/compaction.c: fix deferring compaction mistake

Namjae Jeon (1):
      Documentation: update mount option in filesystem/vfat.txt

Neal Cardwell (1):
      net: tcp: move sk_rx_dst_set call after tcp_create_openreq_child()

NeilBrown (2):
      md: Don't truncate size at 4TB for RAID0 and Linear
      md/raid10: fix problem with on-stack allocation of r10bio structure.

Nicholas Bellinger (4):
      tcm_vhost: Post-merge review changes requested by MST
      tcm_vhost: Change vhost_scsi_target->vhost_wwpn to char *
      target/pscsi: Fix bug with REPORT_LUNs handling for SCSI passthrough
      target: Fix regression bug with handling of zero-length data CDBs

Oliver Neukum (1):
      update MAINTAINERS for Oliver Neukum

Ondrej Zary (1):
      ALSA: snd-als100: fix suspend/resume

Ozan Çağlayan (1):
      USB: ftdi_sio: Add VID/PID for Kondo Serial USB

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: fix missing locking while changing
conntrack from nfqueue
      netfilter: nf_ct_expect: fix possible access to uninitialized timer

Patrice Chotard (1):
      pinctrl/nomadik: add kp_b_2 keyboard function group list

Patrick McHardy (4):
      netfilter: nf_ct_sip: fix helper name
      netfilter: nf_ct_sip: fix IPv6 address parsing
      netfilter: nf_nat_sip: fix via header translation with multiple parameters
      net: ipv6: fix oops in inet_putpeer()

Peng Chen (1):
      Bluetooth: add support for atheros 0489:e057

Peng Tao (1):
      NFS41: add pg_layout_private to nfs_pageio_descriptor

Peter Ujfalusi (1):
      ASoC: omap-mcbsp: Fix 6pin mux configuration

Peter Zijlstra (1):
      sched, cgroup: Reduce rq->lock hold times for large cgroup hierarchies

Phil Edworthy (1):
      net: sh_eth: Add eth support for R8A7779 device

Rafael J. Wysocki (5):
      PCI / PM: Fix D3/D3cold/D4 messages printed by acpi_pci_set_power_state()
      PCI: EHCI: Fix crash during hibernation on ASUS computers
      PM / Runtime: Fix rpm_resume() return value for power.no_callbacks set
      PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()
      PM / Runtime: Check device PM QoS setting before "no callbacks" check

Rajkumar Manoharan (1):
      ath9k: stop btcoex on device suspend

Ram Malovany (3):
      Bluetooth: Fix using NULL inquiry entry
      Bluetooth: Fix using a NULL inquiry cache entry
      Bluetooth: Set name_state to unknown when entry name is empty

Randy Dunlap (4):
      scripts/kernel-doc: fix fatal script error
      ALSA: fix pcm.h kernel-doc warning and notation
      net/core/dev.c: fix kernel-doc warning
      fs: fix fs/namei.c kernel-doc warnings

Raphael Assenat (1):
      1-Wire: Add support for the maxim ds1825 temperature sensor

Richard Genoud (2):
      pinctrl: header: trivial: declare struct device
      trivial: pinctrl core: remove extraneous code lines

Robin Holt (1):
      drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0
is out of IRQ resources

Roland Dreier (3):
      RDMA/ocrdma: Don't call vlan_dev_real_dev() for non-VLAN netdevs
      mlx4_core: Clean up buddy bitmap allocation
      target: Remove unused se_cmd.cmd_spdtl

Russell King (1):
      ARM: Bring back ARMv3 IO and user access code

Sachin Kamat (6):
      spi/s3c64xx: Add missing static storage class specifiers
      ASoC: Samsung: Fix build error
      pwm: Add missing static storage class specifiers in core.c file
      pwm: vt8500: Fix coding style issue
      pwm: core: Fix coding style issues
      drm: Add missing static storage class specifiers in drm_proc.c file

Sage Weil (4):
      vfs: fix propagation of atomic_open create error on negative dentry
      libceph: delay debugfs initialization until we learn global_id
      ceph: tolerate (and warn on) extraneous dentry from mds
      ceph: avoid divide by zero in __validate_layout()

Sarah Sharp (5):
      xhci: Increase reset timeout for Renesas 720201 host.
      xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.
      xhci: Rate-limit XHCI_TRUST_TX_LENGTH quirk warning.
      xhci: Fix bug after deq ptr set to link TRB.
      xhci: Switch PPT ports to EHCI on shutdown.

Scott Jiang (1):
      ASoC: bfin: fix memory leak in sport3 controller driver

Seth Forshee (4):
      irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU
      apple-gmux: Fix kconfig dependencies
      vga_switcheroo: Remove assumptions about
registration/unregistration ordering
      vga_switcheroo: Don't require handler init callback

Shawn Guo (1):
      pinctrl: imx51: fix .conf_reg of MX51_PAD_SD2_CMD__CSPI_MOSI

Shlomo Pongratz (2):
      IB/ipoib: Add missing locking when CM object is deleted
      IB/ipoib: Fix RCU pointer dereference of wrong object

Shubhrajyoti D (1):
      spi: omap2-mcspi: Fix the error handling in probe

Stanislaw Gruszka (1):
      sched: fix divide by zero at {thread_group,task}_times

Stephen Boyd (2):
      ARM: 7484/1: Don't enable GENERIC_LOCKBREAK with ticket spinlocks
      ARM: 7490/1: Drop duplicate select for GENERIC_IRQ_PROBE

Stephen Hemminger (1):
      bridge: fix rcu dereference outside of rcu_read_lock

Stephen M. Cameron (1):
      cciss: fix incorrect scsi status reporting

Steve Glendinning (1):
      smsc75xx: add missing entry to MAINTAINERS

Steve Hodgson (1):
      vmxnet3: Fix race between dev_open() and register_netdev()

Steven J. Hill (1):
      usb: host: mips: sead3: Update for EHCI register structure.

Suresh Siddha (2):
      x86, avx: don't use avx instructions with "noxsave" boot param
      x86, apic: fix broken legacy interrupts in the logical apic mode

Sven Schnelle (1):
      USB: CDC ACM: Fix NULL pointer dereference

Szymon Janc (1):
      Bluetooth: Fix legacy pairing with some devices

Takashi Iwai (8):
      ALSA: hda - Add codec->pcm_format_first flag
      ALSA: hda - Fix superfluous "-in" suffix from CA0132 capture items
      ALSA: hda - Use the standard PCM ops for CA0132
      ALSA: hda - Add missing SPDIF I/O setup for CA0132
      ALSA: platform: Check CONFIG_PM_SLEEP instead of CONFIG_PM
      ALSA: lx6464es: Add a missing error check
      ALSA: usb-audio: Fix scheduling-while-atomic bug in PCM capture stream
      ALSA: hda - Fix leftover codec->power_transition

Tatyana Nikolova (1):
      RDMA/ucma.c: Fix for events with wrong context on iWARP

Theodore Ts'o (5):
      ext4: make sure the journal sb is written in ext4_clear_journal_err()
      ext4: avoid kmemcheck complaint from reading uninitialized memory
      ext4: don't call ext4_error while block group is locked
      ext4: fix long mount times on very big file systems
      ext4: fix kernel BUG on large-scale rm -rf commands

Thierry Reding (1):
      pwm: Improve Kconfig help text

Tim Gardner (3):
      staging: comedi: usbduxsigma: Declare MODULE_FIRMWARE usage
      staging: comedi: usbdux: Declare MODULE_FIRMWARE usage
      staging: comedi: usbduxfast: Declare MODULE_FIRMWARE usage

Timur Tabi (2):
      dt: introduce for_each_available_child_of_node,
of_get_next_available_child
      netdev/phy: skip disabled mdio-mux nodes

Tomas Winkler (2):
      mei: fix device stall after wd is stopped
      mei: add mei_quirk_probe function

Trond Myklebust (6):
      NFSv4.1: Remove a bogus BUG_ON() in nfs4_layoutreturn_done
      NFSv4: Fix pointer arithmetic in decode_getacl
      NFSv4: Fix the acl cache size calculation
      NFSv4: Don't use private xdr_stream fields in decode_getacl
      NFSv4: Ensure that nfs4_alloc_client cleans up on error.
      NFSv3: Ensure that do_proc_get_root() reports errors correctly

Tvrtko Ursulin (1):
      drm/radeon/kms: extend the Fujitsu D3003-S2 board connector
quirk to cover later silicon stepping

Vaibhav Bedia (1):
      ASoC: Davinci: McASP: Flush the FIFO before enabling

Venkatraman Sathiyamoorthy (1):
      ARM: 7482/1: topology: fix section mismatch warning for init_cpu_topology

Venu Byravarasu (1):
      usb: host: tegra: fix warning messages in ehci_remove

WANG Cong (1):
      string: do not export memweight() to userspace

Wang Xingchao (1):
      ALSA: hda - fix Copyright debug message

Will Deacon (5):
      ARM: 7483/1: vfp: only advertise VFPv4 in hwcaps if CONFIG_VFPv3
is enabled
      ARM: 7487/1: mm: avoid setting nG bit for user mappings that
aren't present
      ARM: 7488/1: mm: use 5 bits for swapfile type encoding
      ARM: 7489/1: errata: fix workaround for erratum #720789 on UP systems
      mutex: Place lock in contended state after fastpath_lock failure

Yan, Zheng (3):
      perf/x86: Fixes for Nehalem-EX uncore driver
      perf/x86: Add Intel Westmere-EX uncore support
      ipv4: Cache local output routes

Yi Zou (1):
      target: fix NULL pointer dereference bug alloc_page() fails to get memory

Yishai Hadas (2):
      mlx4_core: Allow large mlx4_buddy bitmaps
      mlx4_core: Fix integer overflow issues around MTT table

Zhouping Liu (1):
      hugetlb: update hugetlbpage.txt

bjschuma@gmail.com (2):
      NFS: Fix a regression when loading the NFS v4 module
      NFS: Alias the nfs module to nfs4

fangxiaozhi (1):
      USB: support the new interfaces of Huawei Data Card devices in
option driver
