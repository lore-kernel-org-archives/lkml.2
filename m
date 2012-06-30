Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2F3Xzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 19:55:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35645 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2F3Xzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 19:55:36 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jun 2012 16:55:14 -0700
X-Google-Sender-Auth: wzX5n9h_QyedDSnepjK0FHcKlI4
Message-ID: <CA+55aFws_u8A7tm8abOmnDe_orUY7LnjWpJwYzgXndvjoXRW8w@mail.gmail.com>
Subject: Linux 3.5-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc. This one looks more normal than rc4, in
that drivers are back to the more usual 60+%. Probably because there's
a networking pull in here, which rc4 didn't have.

The diffstat also looks uglier, because while *most* of it is nice and
small, the printk fixes do stand out a bit. But it was a real
regression from 3.4, so it's not like it's questionable. UDF also got
more careful about corrupted filesystems at mount-time, and that also
shows in the diffstat, but that's at least partly because some of the
checks were cleaned up an dmoved to a helper function while making
them more complete. So the actual change is smaller than it looks.

So nothing really worrisome in here. Despite the networking merge
(which tends to be fairly big), -rc5 is a smaller patch than -rc4 was,
even if there are a couple more commits in there. So things seem to be
going in the right direction.

So: networking updates, media fixes, some small arch updates (x86,
arm, ppc), and some random noise.

Let me (and lkml) know if you have any pending regressions.

                        Linus

---
Ajay Kumar Gupta (1):
      usb: musb: host: release dma channels if no active io

Alan Cox (1):
      [media] smia: Fix compile failures

Alan Stern (3):
      SCSI & usb-storage: add try_rc_10_first flag
      usb-storage: revert commit afff07e61a52 (Add 090c:1000 to unusal-devs)
      printk: fix regression in SYSLOG_ACTION_CLEAR

Alexander Duyck (2):
      ixgbe: Fix memory leak in ixgbe when receiving traffic on DDP
enabled rings
      ixgbe: Do not pad FCoE frames as this can cause issues with FCoE DDP

Alexandre Pereira da Silva (2):
      usb: gadget: lpc32xx_udc: fix build error with debugfs enabled
      usb: phy: Fix Kconfig dependency for Phy drivers

Amerigo Wang (1):
      bonding: show all the link status of slaves

Andrei Emeltchenko (1):
      Bluetooth: btmrvl: Do not send vendor events to bluetooth stack

Andrzej Hajda (2):
      [media] v4l/s5p-mfc: corrected encoder v4l control definitions
      [media] v4l/s5p-mfc: added image size align in VIDIOC_TRY_FMT

Anton Blanchard (1):
      powerpc: check_and_cede_processor() never cedes

Antonio Ospite (1):
      [media] gspca_ov534: make AGC and AWB controls independent

Antonio Quartulli (2):
      batman-adv: fix skb->data assignment
      batman-adv: fix race condition in TT full-table replacement

Ashok Nagarajan (1):
      mac80211: add missing kernel-doc

Avinash Patil (2):
      mwifiex: fix incorrect privacy setting in beacon and probe response
      mwifiex: fix uAP TX packet timeout issue

Axel Lin (2):
      regulator: tps65023: Fix mask for LDOs output voltage select control
      regulator: tps6524x: Fix get_voltage_sel for fixed voltage

Ben Collins (1):
      usb: gadget: Complete fsl qe/udc driver conversion

Ben Skeggs (1):
      drm/nouveau/fbcon: using nv_two_heads is not a good idea

Bing Zhao (1):
      mwifiex: fix wrong return values in add_virtual_intf() error cases

Bjørn Mork (1):
      net: qmi_wwan: fix Gobi device probing

Bob Copeland (1):
      ath5k: remove _bh from inner locks

Brian Norris (2):
      UBIFS: correct usage of IS_ENABLED()
      UBI: correct usage of IS_ENABLED()

Carolyn Wyborny (2):
      igb: Fix incorrect RAR address entries for i210/i211 device.
      Kconfig: Fix Kconfig for Intel ixgbe and igb PTP support.

Clemens Ladisch (1):
      ALSA: usb-audio: add BOSS GT-100 support

Craig Shelley (1):
      USB: CP210x Add 10 Device IDs

Dan Carpenter (5):
      can: c_can: precedence error in c_can_chip_config()
      qlcnic: off by one in qlcnic_init_pci_info()
      UBIFS: fix assertion
      airo: copying wrong data in airo_get_aplist()
      9p: fix min_t() casting in p9pdu_vwritef()

Daniel Halperin (1):
      sctp: fix warning when compiling without IPv6

Daniel Vetter (2):
      drm/i915: rip out the PM_IIR WARN
      Revert "drm/i915: allow PCH PWM override on IVB"

Dave Airlie (2):
      drm/udl: Make sure to get correct endian keys from vendor descriptor
      drm/nouveau: add license header to prime.

Dave Jones (1):
      chmod +x scripts/gfp-translate

David Henningsson (2):
      ALSA: HDA: Add inverted internal mic quirk for Lenovo S205
      ALSA: hda - Add Realtek ALC280 codec support

David S. Miller (1):
      Revert "ipv6: Prevent access to uninitialized fib_table_hash via
/proc/net/ipv6_route"

David Spinadel (1):
      mac80211: stop polling in disassociation

Davide Gerhard (1):
      ipheth: add support for iPad

Deepthi Dharwar (1):
      PM / ACPI: Fix suspend/resume regression caused by cpuidle cleanup.

Dmitry Shmygov (1):
      USB: option: add id for Cellient MEN-200

Eliad Peller (2):
      cfg80211: fix potential deadlock in regulatory
      mac80211: check sdata_running on ieee80211_set_bitrate_mask

Eric Dumazet (5):
      bnx2x: fix panic when TX ring is full
      net: remove skb_orphan_try()
      ipv6: fib: fix fib dump restart
      net: l2tp_eth: fix l2tp_eth_dev_xmit race
      net: l2tp_eth: use LLTX to avoid LOCKDEP splats

Felix Fietkau (2):
      ath9k: fix a tx rate duration calculation bug
      ath9k: fix invalid pointer access in the tx path

Feng Tang (3):
      ACPI: Make acpi_skip_timer_override cover all source_irq==0 cases
      ACPI: Remove one board specific WARN when ignoring timer overriding
      ACPI: Add a quirk for "AMILO PRO V2030" to ignore the timer overriding

Forest Bond (1):
      USB: option: Add USB ID for Novatel Ovation MC551

Giancarlo Formicuccia (1):
      Bluetooth: add support for atheros 0930:0219

Graeme Gregory (1):
      regulator: palmas: fix regmap offsets for enable/disable

Grazvydas Ignotas (3):
      wl1251: fix TSF calculation
      wl1251: always report beacon loss to the stack
      wl1251: Fix memory leaks in SPI initialization

Greg Kroah-Hartman (1):
      Revert "printk: return -EINVAL if the message len is bigger than
the buf size"

Greg Ungerer (1):
      m68knommu: define a local devm_clk_get() function

Guennadi Liakhovetski (3):
      [media] Revert "[media] media: mx2_camera: Fix mbus format handling"
      ARM: mach-shmobile: add missing GPIO IRQ configuration on mackerel
      sh: kfr2r09: fix compile breakage

Guenter Roeck (1):
      hwmon: Update my e-mail address

H. Peter Anvin (3):
      x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM
      x86, cpufeature: Catch duplicate CPU feature strings
      x86, cpufeature: Remove stray %s, add -w to mkcapflags.pl

Hans Verkuil (15):
      [media] Fix vivi regression
      [media] Fix regression in ioctl numbering
      [media] Fix query/enum_dv_timings regression
      [media] V4L2 spec fix
      [media] saa7146_fops: remove unused variable
      [media] cx24110: fix compiler warning
      [media] vino: fix compiler warnings
      [media] v4l2-ioctl: set readbuffers to 2 in g_parm
      [media] v4l2-dev.c: fix g_parm regression in determine_valid_ioctls()
      [media] tuner-core: return the frequency range of the correct tuner
      [media] ivtv: fix support for big-endian systems
      [media] cx18: support big-endian systems
      [media] cx88: fix firmware load on big-endian systems
      [media] bw-qcam: driver and pixfmt documentation fixes
      [media]  Fix VIDIOC_DQEVENT docbook entry

Hans de Goede (10):
      [media] radio/si470x: Add support for the Axentia ALERT FM USB Receiver
      [media] snd_tea575x: Report correct frequency range for EU/US
versus JA models
      [media] snd_tea575x: Make the module using snd_tea575x the fops owner
      [media] snd_tea575x: set_freq: update cached freq to the actual
achieved frequency
      [media] bttv: Use btv->has_radio rather then the card info when
registering the tuner
      [media] bttv: Remove unused needs_tvaudio card variable
      [media] bttv: The Hauppauge 61334 needs the msp3410 to do radio
demodulation
      [media] gspca_pac7311: Correct number of controls
      [media] gscpa_sn9c20x: Move clustering of controls to after error checking
      [media] gspca-core: Fix buffers staying in queued state after a stream_off

Henrik Rydberg (1):
      HID: Fix the generic Kconfig options

Huang Ying (1):
      ACPI, APEI, Avoid too much error reporting in runtime

Hui Wang (1):
      can: flexcan: use be32_to_cpup to handle the value of dt entry

Ian Campbell (1):
      xen/netfront: teardown the device before unregistering it.

Jacob Keller (1):
      ixgbe: Fix PHC loophole allowing misconfiguration of increment register

Jan Beulich (2):
      syslog: fill buffer with more than a single message for SYSLOG_ACTION_READ
      watchdog: iTCO_wdt: add platform driver module alias

Jan Kara (3):
      udf: Use 'ret' instead of abusing 'i' in udf_load_logicalvol()
      udf: Avoid run away loop when partition table length is corrupted
      udf: Fortify loading of sparing table

Janne Huttunen (1):
      [media] cxd2820r: Fix an incorrect modulation type bitmask

Jaroslav Kysela (1):
      ASoC: wm8994: remove duplicate code

Jason Wang (1):
      phy/micrel: change phy_id_mask for KSZ9021 and KS8001

Jean-Francois Moine (2):
      [media] gspca - ov534/ov534_9: Fix sccd_read/write errors
      [media] gspca - sonixj: Fix bad values of webcam 0458:7025

Jens Freimann (1):
      vhost: use USER_DS in vhost_worker thread

Jesper Juhl (1):
      hwmon: (applesmc) correct email address for Jesper Juhl

Johan Hedberg (4):
      Bluetooth: Fix SMP pairing method selection
      Bluetooth: Fix deadlock and crash when SMP pairing times out
      Bluetooth: Fix SMP security elevation from medium to high
      Bluetooth: Add support for encryption key refresh

Johannes Berg (2):
      mac80211: add some missing kernel-doc
      iwlwifi: remove log_event debugfs file debugging is disabled

Jon Hunter (1):
      ARM: OMAP4470: Fix OMAP4470 boot failure

Jonghwan Choi (1):
      ARM: SAMSUNG: Should check for IS_ERR(clk) instead of NULL

Jose Miguel Goncalves (1):
      ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping

Jussi Kivilinna (1):
      rndis_wlan: fix matching bssid check in rndis_check_bssid_list()

Kamil Debski (3):
      [media] s5p-mfc: Bug fix of timestamp/timecode copy mechanism
      [media] s5p-mfc: Fix setting controls
      [media] s5p-fimc: Fix control creation function

Kay Sievers (1):
      printk: flush continuation lines immediately to console

Kevin Hilman (1):
      ARM: OMAP2+: nand: fix build error when CONFIG_MTD_ONENAND_OMAP2=n

Kuninori Morimoto (4):
      ARM: shmobile: sh73a0: bugfix: SY-DMAC number
      ARM: shmobile: sh7372: bugfix: chclr_offset base
      ARM: shmobile: kzm9g: use late init machine hook
      ARM: shmobile: kzm9d: use late init machine hook

Laurent Pinchart (1):
      ARM: mach-shmobile: armadillo800eva: Use late init machine hook

Li Zhong (1):
      powerpc: Fix Section mismatch warnings in prom_init.c

Linus Torvalds (1):
      Linux 3.5-rc5

Mandeep Singh Baines (1):
      PM / Sleep: Prevent waiting forever on asynchronous suspend after abort

Marc Dionne (1):
      HID: logitech: don't use stack based dj_report structures

Marc Kleine-Budde (1):
      clk: mxs: fix clock lookup after freeing init memory

Marek Lindner (1):
      batman-adv: only drop packets of known wifi clients

Marek Szyprowski (1):
      ARM: dma-mapping: fix buffer chunk allocation order

Marek Vasut (1):
      Bluetooth: Support AR3011 in Acer Iconia Tab W500

Martin Blumenstingl (2):
      [media] em28xx: Add remote control support for Terratec's
Cinergy HTC Stick HD
      [media] em28xx: Show a warning if the board does not support
remote controls

Mel Gorman (1):
      stable: Allow merging of backports for serious user-visible
performance issues

Michael Ellerman (1):
      powerpc: Fix BPF_JIT code to link with multiple TOCs

Michael Krufky (2):
      [media] lg2160: fix off-by-one error in lg216x_write_regs
      [media] smsusb: add autodetection support for USB ID 2040:f5a0

Michael Neuling (2):
      powerpc: Fix uninitialised error in numa.c
      powerpc/pseries: Fix software invalidate TCE

Michal Kazior (1):
      cfg80211: check iface combinations only when iface is running

Ming Lei (4):
      usbnet: clear OPEN flag in failure path
      usbnet: decrease suspend count if returning -EBUSY for runtime suspend
      usbnet: handle remote wakeup asap
      Revert "mmc: omap_hsmmc: Enable Auto CMD12"

Mingarelli, Thomas (1):
      watchdog: hpwdt: Unregister NMI events on exit.

Mohammed Shafi Shajakhan (4):
      ath9k: Fix a WARNING on suspend/resume with IBSS
      ath9k: remove incompatible IBSS interface check in change_iface
      ath9k: Fix softlockup in AR9485
      ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc

Moiz Sonasath (1):
      usb: otg: twl6030-usb: Fix twl writes

Neal Cardwell (1):
      tcp: heed result of security_inet_conn_request() in tcp_v6_conn_request()

Nobuhiro Iwamatsu (2):
      ARM: mach-shmobile: Fix build when SMP is enabled and EMEV2 is not enabled
      sh: Convert sh_clk_mstp32_register to sh_clk_mstp_register

Oleksij Rempel (2):
      ALSA: snd_usb_audio: ignore ctrl errors on QuickCam E3500
      ALSA: snd_usb_audio: ignore ctrl errors on QuickCam Pro for Notebooks

Paul E. McKenney (1):
      rcu: Stop rcu_do_batch() from multiplexing the "count" variable

Paul Mundt (1):
      bug.h: Fix up CONFIG_BUG=n implicit function declarations.

Pavel Vasilyev (1):
      ACPI sysfs.c strlen fix

Pawel Moll (1):
      clk: Check parent for NULL in clk_change_rate

Per Ellefsen (1):
      caif-hsi: Bugfix - Piggyback'ed embedded CAIF frame lost

Phil Edworthy (1):
      ARM: shmobile: r8a7779: Route all interrupts to ARM

Phil Sutter (1):
      usbnet: sanitise overlong driver information strings

Pratyush Anand (1):
      usb: dwc3: fix giveback of queued request in ep_dequeue

Rajendra Nayak (1):
      clk: Allow late cache allocation for clk->parents

Rajkumar Manoharan (1):
      ath9k_htc: configure bssid on ASSOC/IBSS change

Randy Dunlap (2):
      linux/irq.h: fix kernel-doc warning
      printk.c: fix kernel-doc warnings

Rémi Denis-Courmont (1):
      net: remove my future former mail address

Sachin Kamat (2):
      [media] s5p-mfc: Fix checkpatch error in s5p_mfc_shm.h file
      ARM: EXYNOS: Fix EXYNOS_DEV_DMA Kconfig entry

Sakari Ailus (1):
      [media] v4l: Correct create_bufs documentation

Sarveshwar Bandi (1):
      be2net: reduce gso_max_size setting to account for ethernet header.

Sasha Levin (1):
      [media] USB: Staging: media: lirc: initialize spinlocks before usage

Shawn Guo (2):
      clk: mxs: fix ref_io clock definition
      ARM: imx6q: fix suspend regression caused by common clk migration

Sjur Brændeland (2):
      caif: Clear shutdown mask to zero at reconnect.
      caif-hsi: Add missing return in error path

Stefan Roese (1):
      clk: SPEAr600: Fix ethernet clock name for DT based probing

Steven Rostedt (2):
      powerpc/ftrace: Do not trace restore_interrupts()
      printk: Optimize if statement logic where newline exists

Stuart Hayes (1):
      acpi_pad: fix power_saving thread deadlock

Subhash Jadavani (1):
      mmc: block: fix the data timeout issue with ACMD22

Suresh Siddha (1):
      x86, compat: Use test_thread_flag(TIF_IA32) in compat signal delivery

Szymon Janc (1):
      Bluetooth: Fix using uninitialized option in RFCMode

Takashi Iwai (7):
      ALSA: hda - Fix ALC272X codec detection
      drm/i915: Fix eDP blank screen after S3 resume on HP desktops
      ALSA: hda - Remove obsoleted CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS
      ALSA: hda - Fix memory leaks in Realtek & Conexant codec parsers
      ALSA: hda - Fix memory leaks at module unload
      ALSA: hda - Initialize caches at codec reconfiguration
      ALSA: hda - Fix power-map regression for HP dv6 & co

Thomas Graf (2):
      ipv6: Prevent access to uninitialized fib_table_hash via
/proc/net/ipv6_route
      ipv6: Move ipv6 proc file registration to end of init order

Tiejun Chen (1):
      ppc64: fix missing to check all bits of _TIF_USER_WORK_MASK in preempt

Tomasz Moń (1):
      [media] v4l: mem2mem_testdev: Fix race conditions in driver

Vasundhara Volam (2):
      be2net: Modify error message to incorporate subsystem
      be2net: Increase statistics structure size for skyhawk.

Vishal Agarwal (2):
      Bluetooth: Fix LE pairing completion on connection failure
      Bluetooth: Fix sending HCI_Disconnect only when connected

Wanpeng Li (1):
      x86: Fix kernel-doc warnings

Will Deacon (1):
      oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static array

Wim Van Sebroeck (1):
      watchdog: core: fix WDIOC_GETSTATUS return value

Yevgeny Petrilin (3):
      net/mlx4_en: Set correct port parameters during device initialization
      net/mlx4: Use single completion vector after NOP failure
      net/mlx4_en: Release QP range in free_resources

Yoshihiro Shimoda (1):
      net: sh_eth: fix the condition to fix the cur_tx/dirty_rx

Yufeng Shen (1):
      HID: magicmouse: Correct report range of major / minor axes

Yuval Mintz (2):
      bnx2x: fix I2C non-respondent issue
      bnx2x: fix link for BCM57711 with 84823 phy

Zhang Rui (2):
      ACPI, x86: fix Dell M6600 ACPI reboot regression via DMI
      ACPI video: Still use ACPI backlight control if _DOS doesn't exist

alex.bluesman.smirnov@gmail.com (1):
      mac802154: add missed braces

françois romieu (1):
      r8169: RxConfig hack for the 8168evl.

stephen hemminger (1):
      bridge: Assign rtnl_link_ops to bridge devices created via ioctl (v2)
