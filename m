Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab2GUWQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 18:16:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63530 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2GUWQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 18:16:22 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Jul 2012 15:16:00 -0700
X-Google-Sender-Auth: gV740DHUXOMRSwm-HyNNOpVuEks
Message-ID: <CA+55aFwkH4k5vrHZzoSk7aZmKXkieZBh1UogBsH=YZRye0_4fQ@mail.gmail.com>
Subject: Linux 3.5 released
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, not a lot happened since -rc7.

There's a number of MIPS commits (for some reason MIPS has had a
horrible track record with the -rc time schedule, I suspect I should
just stop pulling late in the game), but most of the rest is pretty
small. A couple of dm/md fixes, some gma500 work, make kgdb 'dmesg'
command work again, some networking fixes, some xfs and cifs noise,
yadda yadda. About 50% of the patch is actually the SPEAr clock name
renaming that is just some search-and-replace.

The shortlog is appended if you're interested in the details.

And as usual, this obviously means that the merge window for 3.6 is
open, although I hope people will spend a little bit of time testing
and beating on 3.5 before pushing on with the merge window. And as
mentioned earlier, if you are a (probably European) maintainer, and
will be gone most of August, I'd rather you just delay the whole thing
until 3.7 rather than send me a merge request for 3.6 and then
effectively disappear for the next few weeks.

And if 3.6 ends up smaller as a result of vacation details like that,
it's fine.

                       Linus

---

Aaditya Kumar (1):
      mm: fix lost kswapd wakeup in kswapd_stop()

Aaro Koskinen (1):
      MIPS: cmpxchg.h: Add missing include

Al Viro (1):
      ext4: fix duplicated mnt_drop_write call in EXT4_IOC_MOVE_EXT

Alan Cox (5):
      sch_sfb: Fix missing NULL check
      gma500: Fix lid related crash
      gma500: move the ASLE enable
      gma500,cdv: Fix the brightness base
      ax25: Fix missing break

Alexander Duyck (2):
      ixgbe: DCB and SR-IOV can not co-exist and will cause hangs
      ixgbevf: Fix panic when loading driver

Amir Hanania (1):
      net: Fix memory leak - vlan_info struct

Anders Kaseorg (1):
      fifo: Do not restart open() if it already found a partner

Anirban Chakraborty (1):
      MAINTAINERS: Changes in qlcnic and qlge maintainers list

Anton Vorontsov (4):
      kdb: Revive dmesg command
      printk: Remove kdb_syslog_data
      printk: Implement some unlocked kmsg_dump functions
      kdb: Switch to nolock variants of kmsg_dump functions

Artem Bityutskiy (1):
      UBIFS: fix a bug in empty space fix-up

Benjamin Tissoires (1):
      HID: hid-multitouch: add support for Zytronic panels

Bing Zhao (1):
      mwifiex: fix Coverity SCAN CID 709078: Resource leak (RESOURCE_LEAK)

Bjørn Mork (1):
      net: qmi_wwan: add ZTE MF60

Boaz Harrosh (5):
      ore: Fix NFS crash by supporting any unaligned RAID IO
      ore: Remove support of partial IO request (NFS crash)
      ore: Unlock r4w pages in exact reverse order of locking
      pnfs-obj: don't leak objio_state if ore_write/read fails
      pnfs-obj: Fix __r4w_get_page when offset is beyond i_size

Bruce Allan (1):
      e1000e: fix test for PHY being accessible on 82577/8/9 and I217

Christoph Hellwig (2):
      xfs: prevent recursion in xfs_buf_iorequest
      xfs: do not call xfs_bdstrat_cb in xfs_buf_iodone_callbacks

Cloud Ren (1):
      atl1c: fix issue of transmit queue 0 timed out

Dan Carpenter (4):
      sony-laptop: fix sony_nc_sysfs_store()
      sony-laptop: fix a couple signedness bugs
      ideapad: uninitialized data in ideapad_acpi_add()
      rbd: endian bug in rbd_req_cb()

Daniel Nicoletti (1):
      HID: add battery quirk for Apple Wireless ANSI

Danny Kukawka (1):
      MIPS: BMIPS: Fix duplicate header inclusion.

Dave Chinner (2):
      xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near
      xfs: don't defer metadata allocation to the workqueue

David Daney (2):
      netdev/phy: Fixup lockdep warnings in mdio-mux.c
      MIPS: Properly align the .data..init_task section.

Deepak Sikri (2):
      stmmac: Fix for nfs hang on multiple reboot
      stmmac: Fix for higher mtu size handling

Dmitry Eremin-Solenikov (1):
      MAINTAINERS: reflect actual changes in IEEE 802.15.4 maintainership

Dong Aisheng (2):
      pinctrl: pinctrl-imx: only print debug message when DEBUG is defined
      pinctrl: pinctrl-imx6q: add missed mux function for USBOTG_ID

Douglas Leung (1):
      MIPS: Fix decoding of c0_config1 for MIPSxx caches with 32 ways per set.

Eliad Peller (1):
      mac80211: destroy assoc_data correctly if assoc fails

Emmanuel Grumbach (1):
      iwlegacy: don't mess up the SCD when removing a key

Eric Dumazet (6):
      net: dont use __netdev_alloc_skb for bounce buffer
      netem: add limitation to reordered packets
      net: cgroup: fix out of bounds accesses
      gianfar: fix potential sk_wmem_alloc imbalance
      IPoIB: fix skb truesize underestimatiom
      net: respect GFP_DMA in __netdev_alloc_skb()

Eric Paris (2):
      SELinux: include definition of new capabilities
      SELinux: do not check open perms if they are not known to policy

Eric W. Biederman (2):
      bonding: Manage /proc/net/bonding/ entries from the netdev events
      bonding: debugfs and network namespaces are incompatible

Ezequiel Garcia (1):
      cx25821: Remove bad strcpy to read-only char*

Federico Fuga (1):
      rpmsg: fix dependency on initialization order

Florian Fainelli (2):
      MIPS: perf: Fix build error caused by unused counters_per_cpu_to_total()
      MIPS: BCM63XX: Fix BCM6368 IPSec clock bit

Frank Kunz (1):
      HID: add Sennheiser BTD500USB device support

Ganesan Ramalingam (1):
      MIPS: Netlogic: MSI enable fix for XLS

Gao feng (2):
      cgroup: fix panic in netprio_cgroup
      net: cgroup: fix access the unallocated memory in netprio cgroup

Geert Uytterhoeven (7):
      mn10300: fix "pull clearing RESTORE_SIGMASK into block_sigmask()" fallout
      m32r: remove duplicate definition of PTRACE_O_TRACESYSGOOD
      m32r: fix pull clearing RESTORE_SIGMASK into block_sigmask() fallout
      m32r: fix 'fix breakage from "m32r: use generic ptrace_resume
code"' fallout
      m32r: consistently use "suffix-$(...)"
      m32r: add memcpy() for CONFIG_KERNEL_GZIP=y
      m32r: make memset() global for CONFIG_KERNEL_BZIP2=y

Hans Verkuil (1):
      v4l2-dev: forgot to add VIDIOC_DV_TIMINGS_CAP.

Jayachandran C (2):
      MIPS: Netlogic: Fix PCIX irq on XLR chips
      MIPS: Netlogic: Fix TLB size of boot CPU.

Jeff Layton (3):
      cifs: on CONFIG_HIGHMEM machines, limit the rsize/wsize to the kmap space
      cifs: when CONFIG_HIGHMEM is set, serialize the read/write kmaps
      cifs: always update the inode cache with the results from a FIND_*

John Stultz (1):
      ntp: Fix STA_INS/DEL clearing bug

Jozsef Kadlecsik (1):
      netfilter: ipset: timeout fixing bug broke SET target special
timeout value

Julia Lawall (3):
      drivers/isdn/mISDN/stack.c: remove invalid reference to list
iterator variable
      net/rxrpc/ar-peer.c: remove invalid reference to list iterator variable
      drivers/net/ethernet/broadcom/cnic.c: remove invalid reference
to list iterator variable

Julian Anastasov (1):
      ipvs: fix oops in ip_vs_dst_event on rmmod

Leonid Yegoshin (3):
      MIPS: Don't panic on 5KEc.
      MIPS: Fix race condition with FPU thread task flag during context switch.
      MIPS: Malta may also be equipped with MIPS64 R2 processors.

Lin Ming (1):
      ipvs: fix oops on NAT reply in br_nf context

Linus Torvalds (2):
      Make wait_for_device_probe() also do scsi_complete_async_scans()
      Linux 3.5

Marco Chiappero (1):
      sony-laptop: notify userspace of GFX switch position changes

Marek Szyprowski (1):
      mm: cma: fix condition check when setting global cma area

Mark Rustad (1):
      tcm_fc: Fix crash seen with aborts and large reads

Mattia Dongili (5):
      sony-laptop: use an enum for SNC event types
      sony-laptop: store battery care limits on batteries
      sony-laptop: add lid backlight support for handle 0x143
      sony-laptop: input initialization should be done before SNC
      sony-laptop: correct find_snc_handle failure checks

Michael Chan (2):
      cnic: Don't use netdev->base_addr
      bnx2: Fix bug in bnx2_free_tx_skbs().

Michael Kerrisk (1):
      PM: Rename CAP_EPOLLWAKEUP to CAP_BLOCK_SUSPEND

Mikulas Patocka (3):
      dm raid1: fix crash with mirror recovery and discard
      dm thin: do not send discards to shared blocks
      dm raid1: set discard_zeroes_data_unsupported

Narendra K (1):
      ixgbevf: Prevent RX/TX statistics getting reset to zero

Neil Horman (1):
      sctp: Fix list corruption resulting from freeing an association on a list

NeilBrown (3):
      md: fix bug in handling of new_data_offset
      md: avoid crash when stopping md array races with closing other open fds.
      md/raid1: close some possible races on write errors during resync

Olaf Hering (1):
      kexec: update URL of kexec homepage

Pablo Neira Ayuso (1):
      netfilter: nf_ct_ecache: fix crash with multiple containers, one
shutting down

Paul Moore (1):
      cipso: don't follow a NULL pointer when setsockopt() is called

Prathyush K (1):
      ARM: dma-mapping: modify condition check while freeing pages

Rabin Vincent (1):
      mm: cma: don't replace lowmem pages with highmem

Rafael J. Wysocki (1):
      Remove SYSTEM_SUSPEND_DISK system state

Ralf Baechle (5):
      MIPS: Provide a symbol for the legacy performance counter interrupt.
      MIPS: MT: Fix indentation damage.
      MIPS: SMTC: Spelling and grammar corrections.
      MIPS: Fix typo multipy -> multiply
      MIPS: Oprofile: Fix build as a module.

Roland Dreier (2):
      target: Clean up returning errors in PR handling code
      target: Fix range calculation in WRITE SAME emulation when num blocks == 0

Rustad, Mark D (1):
      net: Statically initialize init_net.dev_base_head

Sachin Prabhu (1):
      Initialise mid_q_entry before putting it on the pending queue

Sage Weil (1):
      libceph: fix messenger retry

Sasha Levin (2):
      ieee802154: verify packet size before trying to allocate it
      NFC: Prevent NULL deref when getting socket name

Sebastian Andrzej Siewior (1):
      MIPS: PCI: Move fixups from __init to __devinit.

Simon Wunderlich (1):
      batman-adv: check incoming packet type for bla

Sjur Brændeland (1):
      caif: Fix access to freed pernet memory

Stanislaw Gruszka (2):
      rt2x00usb: fix indexes ordering on RX queue kick
      iwlegacy: always monitor for stuck queues

Stefan Roese (1):
      ARM: SPEAr600: Fix timer interrupt definition in spear600.dtsi

Steven J. Hill (4):
      MIPS: Clean-up GIC and vectored interrupts.
      MIPS: Add support for the M14Kc core.
      MIPS: Refactor 'clear_page' and 'copy_page' functions.
      MIPS: Malta: Change start address to avoid conflicts.

Takashi Iwai (1):
      intel_ips: blacklist HP ProBook laptops

Thomas Gleixner (1):
      timekeeping: Add missing update call in timekeeping_resume()

Thomas Huehn (1):
      mac80211: correct size the argument to kzalloc in minstrel_ht

Tushar Dave (1):
      e1000e: Correct link check logic for 82571 serdes

Uwe Kleine-König (1):
      mips: mark const init data with __initconst instead of __initdata

Vincent Wen (1):
      MIPS: Fix Magic SysRq L kernel crash.

Vipul Kumar Samar (9):
      clk:spear1340:Fix: Rename clk ids within predefined limit
      clk:spear1310:Fix: Rename clk ids within predefined limit
      Clk:spear3xx:Fix: Rename clk ids within predefined limit
      Clk:spear6xx:Fix: Rename clk ids within predefined limit
      ARM: SPEAr13xx: Fix Interrupt bindings
      clk: SPEAr1340: Fix clk enable register for uart1 and i2c1.
      Clk: SPEAr1340: Update sys clock parent array
      ARM: dts: SPEAr320: Fix compatible string
      ARM: dts: SPEAr320: Boot the board in EXTENDED_MODE

Yan, Zheng (1):
      rbd: Fix ceph_snap_context size calculation

Yinghai Lu (1):
      bootmem: make ___alloc_bootmem_node_nopanic() really nopanic

Yoichi Yuasa (4):
      mips: fix bug.h build regression
      MIPS: BCM47xx: Fix BCMA_DRIVER_PCI_HOSTMODE config dependencies
      MIPS: Cavium: Fix duplicate ARCH_SPARSEMEM_ENABLE in kconfig.
      MIPS: Fix bug.h MIPS build regression

Yong Zhang (8):
      MIPS: Octeon: delay enable irq to ->smp_finish()
      MIPS: BMIPS: delay irq enable to ->smp_finish()
      MIPS: SMTC: delay irq enable to ->smp_finish()
      MIPS: Yosemite: delay irq enable to ->smp_finish()
      MIPS: call ->smp_finish() a little late
      MIPS: call set_cpu_online() on cpu being brought up with irq disabled
      MIPS: smp: Warn on too early irq enable
      MIPS: sync-r4k: remove redundant irq operation
