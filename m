Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0GLXhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:37:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232Ab0GLXhT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:37:19 -0400
MIME-Version: 1.0
Date: Mon, 12 Jul 2010 16:37:09 -0700
Message-ID: <AANLkTikro3L1Hy3BYmY-KE8-KviZIrWOCAb54FkF7eX-@mail.gmail.com>
Subject: Linux 2.6.35-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

Ok, so it's actually eight days, but whatever. It's all the better for
it, as I got to merge some additional regression fixes today (some
sound resume issues, and a couple of v4l regression fixes).

And I merged the ARM defconfig minimization thing, which isn't the
final word on the whole defconfig issue, but since it removes almost
200 _thousand_ lines of ARM defconfig noise, it's a pretty big deal.
I'm hoping that going forward, we'll have much less defconfig noise in
our diffs as a result of this and hopefully future cleanups. Of
course, in the short term
future we'll hopefully see similar shrinkage in the powerpc defconfigs.

Other than that? It's pretty boring. Some MIPS and Ceph updates, and a
lot of small fixes. The ShortLog (appended) gives some idea of the
thing.

                    Linus

---

Alan Ott (1):
      HID: Send Report ID when numbered reports are sent over the
control endpoint.

Alex Deucher (1):
      drm/radeon/kms: fix shared ddc handling

Alexey Fisher (1):
      ALSA: usb-audio - Add volume resolution quirk for some Logitech webcams

Andreas Herrmann (1):
      hwmon: (k8temp) Fix temperature reporting for ASB1 processor revisions

Andreas Steffen (1):
      xfrm: fix XFRMA_MARK extraction in xfrm_mark_get

Andy Gospodarek (2):
      bonding: prevent netpoll over bonded interfaces
      ixgbe: fix panic when shutting down system with WoL enabled

Andy Walls (3):
      V4L/DVB: tuner: Add a definition for the Philips FQ1236 MK5 NTSC tuner
      V4L/DVB: tveeprom: Add an entry for tuner code 168: a TCL
M30WTP-4N-E tuner
      V4L/DVB: Documentation: Add the Philips FQ1236 MK5 to
video4linux/CARDLIST.tuner

Anton Blanchard (1):
      powerpc: Linux cannot run with 0 cores

Arnaud Patard (1):
      MIPS: Loongson: Define rtc device on MC146818-equipped systems

Artem Bityutskiy (1):
      VFS: introduce s_dirty accessors

Ben Hutchings (6):
      ethtool: Fix potential kernel buffer overflow in ETHTOOL_GRXCLSRLALL
      ethtool: Fix potential user buffer overflow for ETHTOOL_{G, S}RXFH
      net: Revert "rndis_host: Poll status channel before control channel"
      usbnet: Set parent device early for netdev_printk()
      net: Fix definition of netif_vdbg() when VERBOSE_DEBUG is defined
      IB/qib: Use request_firmware() to load SD7220 firmware

Boojin Kim (1):
      ARM: S5P: Bug fix on external interrupt for S5P SoCs

Breno Leitao (2):
      qlge: Replacing add_timer() to mod_timer()
      qlge: fix a eeh handler to not add a pending timer

Changli Gao (2):
      splice: direct_splice_actor() should not use pos in sd
      splice: check f_mode for seekable file

Chris Dearman (1):
      MIPS: Restore signalling NaN behaviour for abs.[sd]

Christoph Hellwig (3):
      writeback: remove writeback_inodes_wbc
      writeback: split writeback_inodes_wb
      writeback: simplify the write back thread queue

Cody Rester (1):
      drivers: bluetooth: bluecard_cs.c: Fixed include error, changed
to linux/io.h

Darrick J. Wong (1):
      x86, Calgary: Limit the max PHB number to 256

Dave Olson (1):
      IB/qib: Don't mark VL15 bufs as WC to avoid a rare 7322 chip problem

David Howells (1):
      Bluetooth: Fix abuse of the preincrement operator

Denis Kirjanov (2):
      ll_temac: Fix missing iounmaps
      powerpc/iseries: Fix possible null pointer dereference in
iSeries_pcibios_fixup_resources

Dominik Brodowski (1):
      pcmcia: do not initialize the present flag too late.

Eric Dumazet (1):
      netfilter: ip6t_REJECT: fix a dst leak in ipv6 REJECT

FUJITA Tomonori (1):
      RDMA/cxgb4: Use the DMA state API instead of the pci equivalents

Flavio Leitner (1):
      bonding: check if clients MAC addr has changed

Florian Fainelli (2):
      MIPS: AR7: Use correct UART port type
      MIPS: AR7: Fix typo in ar7.h

Francisco Jerez (1):
      drm/ttm: Allocate the page pool manager in the heap.

Guenter Roeck (1):
      i2c/mips: Fix error return codes from Sibyte i2c bus driver

Guillaume Gaudonville (1):
      ixgbe: skip non IPv4 packets in ATR filter

Herbert Xu (2):
      bridge br_multicast: BUG: unable to handle kernel NULL pointer dereference
      bridge: Clear IPCB before possible entry into IP stack

Hyuk Lee (1):
      ARM: SAMSUNG: Fix on wrong function name for S5PV210 sdhci0

Ian Armstrong (1):
      V4L/DVB: ivtv: Add delay to ensure the decoder always restarts
with a blank screen

Jean Delvare (5):
      hwmon: (it87) Fix in7 on IT8720F
      hwmon: (coretemp) Skip duplicate CPU entries
      hwmon: (coretemp) Properly label the sensors
      hwmon: Fix autoloading of fschmd on recent Fujitsu machines
      i2c: Fix probability check

Jesper Nilsson (1):
      MIPS: Return after handling coprocessor 2 exception

Jesse Barnes (1):
      drm: correctly update connector DPMS status in drm_fb_helper

Jindrich Makovicka (1):
      HID: check for HID_QUIRK_IGNORE during probing

Joe Perches (1):
      MAINTAINERS: fix EDAC-I7CORE file patterns

Johannes Berg (2):
      iwlwifi: fix multicast
      powerpc: Fix logic error in fixup_irqs

John Fastabend (3):
      ixgbe: disable tx engine before disabling tx laser
      sched: qdisc_reset_all_tx is calling qdisc_reset without qdisc_lock
      net: decreasing real_num_tx_queues needs to flush qdisc

Jon Mason (1):
      s2io: resolve statistics issues

Jonathan Rockway (1):
      HID: add support for CH Eclipse yoke

Julia Lawall (1):
      HID: eliminate a double lock in debug code

Kulikov Vasiliy (1):
      net/ne: fix memory leak in ne_drv_probe()

Laurent Pinchart (2):
      V4L/DVB: uvcvideo: Power line frequency control doesn't support
GET_MIN/MAX/RES
      V4L/DVB: uvc: Fix multiple symbols definitions with UVC gadget
and host drivers

Linus Torvalds (1):
      Linux 2.6.35-rc5

Luke Yelavich (1):
      ALSA: hda - Add Macbook 5,2 quirk

Manuel Lauss (1):
      MIPS: Alchemy: sleepcode without compile-time cputype dependencies

Marek Szyprowski (1):
      ARM: SAMSUNG: Fix build without SDHCI controllers for S3C64XX

Matt Evans (1):
      powerpc/perf_event: Fix for power_pmu_disable()

Michael S. Tsirkin (3):
      vhost: break out of polling loop on error
      vhost: add unlikely annotations to error path
      virtio_net: do not reschedule rx refill forever

Michal Marek (1):
      kbuild: Fix path to scripts/setlocalversion

MyungJoo Ham (1):
      ARM: S5PV210: Correct clock register properties

Or Gerlitz (1):
      IPoIB: Fix world-writable child interface control sysfs attributes

Paul E. McKenney (1):
      powerpc: Fix default_machine_crash_shutdown #ifdef botch

Pawel Osciak (1):
      V4L/DVB: v4l: mem2mem_testdev: fix g_fmt NULL pointer dereference

Peter Edwards (1):
      HID: Enable HID_QUIRK_MULTI_INPUT for Retro Adaptor

Peter Kosyh (1):
      xfrm: fix xfrm by MARK logic

Peter Zijlstra (1):
      rbtree: Undo augmented trees performance damage and regression

Ralf Baechle (2):
      MIPS: MT: Fix FPU affinity.
      NET: SB1250: Initialize .owner

Ralph Campbell (6):
      IB/qib: Mask hardware error during link reset
      IB/qib: Clear eager buffer memory for each new process
      IB/qib: Clear 6120 hardware error register
      IB/qib: Update 7322 serdes tables
      IB/qib: Completion queue callback needs to be single threaded
      IB/qib: Clean up properly if qib_init() fails

Randy Dunlap (3):
      HID: roccat: fix modules interdependencies
      fs-writeback: fix kernel-doc warnings
      linux/net.h: fix kernel-doc warnings

Rusty Russell (1):
      virtio_net: fix oom handling on tx

Saeed Bishara (1):
      mv643xx_eth: use sw csum for big packets

Sage Weil (10):
      ceph: fix map handler error path
      ceph: fix message memory leak, uninitialized variable
      ceph: fix crush map update decoding
      ceph: handle splice_dentry/d_materialize_unique error in
readdir_prepopulate
      ceph: delay umount until all mds requests drop inode+dentry refs
      ceph: fix crush recursion
      ceph: fix crush CHOOSE_LEAF when type is already a leaf
      ceph: only release clean, unused caps with mds requests
      ceph: fix caps usage accounting for import (non-reserved) case
      ceph: fix crush device 'out' threshold to 1.0, not 0.1

Sam Ravnborg (1):
      powerpc: Fix userspace build of ptrace.h

Stephen Rothwell (3):
      powerpc: Fix module building for gcc 4.5 and 64 bit
      powerpc: Fix compile errors in prom_init_check for gcc 4.5
      powerpc: Fix feature-fixup tests for gcc 4.5

Steve Wise (3):
      RDMA/cxgb4: Don't call abort_connection() for active connect failures
      RDMA/cxgb4: Avoid false GTS CIDX_INC overflows
      RDMA/cxgb4: Derive smac_idx from port viid

Takashi Iwai (3):
      ALSA: hda - Fix uninitialized variable
      ALSA: hda - Enable beep on Realtek codecs with PCI SSID override
      ALSA: hda - Restore cleared pin controls on resume

Thomas Abraham (1):
      ARM: S5P6442: Fix PLL setting announce message.

Uwe Kleine-König (1):
      ARM: reduce defconfigs

Vaibhav Hiremath (3):
      V4L/DVB: OMAP_VOUT:Build FIX: Rebased against latest DSS2 changes
      V4L/DVB: OMAP_VOUT: fix: Replaced dma-sg with dma-contig
      V4L/DVB: OMAP_VOUT: fix: Module params were not working through bootargs

Vasanthakumar Thiagarajan (1):
      ath9k: Fix bug in starting ani

Waldemar Brodkorb (1):
      MIPS: BCM47xx: Add NVRAM support devices

Wey-Yi Guy (1):
      iwlwifi: set TX_CMD_FLAG_PROT_REQUIRE_MSK in tx_flag

Wu Fengguang (1):
      vxge: show startup message with KERN_INFO

Wu Zhangjin (13):
      MIPS: Loongson: CS5536: Add missing RDMSRs for IDE and USB
      MIPS: Loongson: Add a missing break statement in CS5536 IDE code
      MIPS: Loongson: CS5536: Fix ISA support
      MIPS: Tracing: Merge adjacent #ifdefs with same condition.
      MIPS: Tracing: Cleanup the arguments passing of prepare_ftrace_return
      MIPS: Tracing: Cleanup comments
      MIPS: Tracing: Fix argument passing of the 32bit support with gcc 4.5
      MIPS: Tracing: Fix 32-bit support with -mmcount-ra-address
      MIPS: Tracing: Cleanup of instructions used
      MIPS: Tracing: Reduce the overhead of dynamic Function Tracer
      MIPS: Tracing: Cleanup of function graph tracer
      MIPS: Tracing: Cleanup of address space checking
      MIPS: Oprofile: Fixup of loongson2_exit()

Yang Li (1):
      powerpc: Disable SPARSE_IRQ by default

Yehuda Sadeh (2):
      ceph: some endianity fixes
      ceph: fix caps debugfs entry

Yoichi Yuasa (1):
      MIPS: AR7, BCM63xx: fix gpio_to_irq() return value

micki (1):
      HID: ntrig: add support for new firwmare versions
