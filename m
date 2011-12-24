Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1LXGQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 01:16:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64870 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1LXGQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 01:16:28 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Dec 2011 22:16:06 -0800
X-Google-Sender-Auth: dUtH3FYH_-wdHeqOu4EFx2Jdw1Y
Message-ID: <CA+55aFxw1abaxwQbX=sQVF-J6drk8m5cKCd+rMqrpoS5vohmnA@mail.gmail.com>
Subject: Linux 3.2-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There it is, likely the last -rc in before final 3.2, so please do
check it out in between your holiday festivities.

Most of the changes are faily simple one-liners, but some qla4xxx
driver updates stand out and in fact account for about 40% of the diff
("qla4xxx: fix flash/ddb support"). That, together with a VMWare DRI
driver update and some dvb updates and the regular random driver fixes
means that 80+% of the changes are in drivers.

Some net updates, some SH updates, and then a (tiny) smattering of
other stuff. The appended shortlog gives the (fairly boring) details,

                    Linus

---
Ajay Kumar Gupta (1):
      usb: musb: fix reset issue with full speed device

Ajaykumar Hotchandani (1):
      PCI: Set device power state to PCI_D0 for device without native PM support

Al Viro (1):
      Btrfs: call d_instantiate after all ops are setup

Alex Juncu (1):
      llc: llc_cmsg_rcv was getting called after sk_eat_skb.

Andrew Vasquez (1):
      [SCSI] qla2xxx: Return the correct value for a mailbox command
if 82xx is in reset recovery.

Anssi Hannula (1):
      [media] ati_remote: switch to single-byte scancodes

Anton Blanchard (1):
      [SCSI] mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in
interrupt context

Antti Palosaari (3):
      [media] af9015: limit I2C access to keep FW happy
      [media] tda18218: fix 6 MHz default IF frequency
      [media] mxl5007t: fix reg read

Arun Easi (1):
      [SCSI] qla2xxx: Check for SCSI status on underruns.

Aurelien Jacobs (1):
      asix: new device id

Axel Lin (7):
      mfd: Add missed free_irq in da903x_remove
      mfd: Set adp5520 bits if new value is different from the old one
      mfd: Set da903x bits if new value is different from the old one
      mfd: Set tps6586x bits if new value is different from the old one
      mfd: include linux/module.h for ab5500-debugfs
      mfd: add #ifdef CONFIG_DEBUG_FS guard for ab8500_debug_resources
      mfd: Include linux/io.h to jz4740-adc

Ben Hutchings (1):
      firmware: Refer to the co-maintained linux-firmware.git repository

Bo Shen (1):
      ALSA: atmel/ac97c: using software reset instead hardware reset
if not available

Chad Dupuis (3):
      [SCSI] qla2xxx: Display IPE error message for ISP82xx.
      [SCSI] qla2xxx: Encapsulate prematurely completing mailbox
commands during ISP82xx firmware hang.
      [SCSI] qla2xxx: Update version number to 8.03.07.12-k.

Chris Bagwell (1):
      Input: wacom - add product id used by Samsung Slate 7

Chris Mason (1):
      Btrfs: fix worker lock misuse in find_worker

Clemens Ladisch (1):
      x86, dumpstack: Fix code bytes breakage due to missing KERN_CONT

Corey Minyard (1):
      ipmi_watchdog: restore settings when BMC reset

Dan Carpenter (2):
      [media] V4L: mt9t112: use after free in mt9t112_probe()
      nfc: signedness bug in __nci_request()

Dave Kleikamp (1):
      vfs: __read_cache_page should use gfp argument rather than GFP_KERNEL

David Howells (1):
      SELinux: Fix RCU deref check warning in sel_netport_insert()

David Miller (2):
      USB: Fix usb/isp1760 build on sparc
      pata_of_platform: Add missing CONFIG_OF_IRQ dependency.

David Rientjes (1):
      cpusets: stall when updating mems_allowed for mempolicy or
disjoint nodemask

David S. Miller (1):
      sparc64: Fix MSIQ HV call ordering in pci_sun4v_msiq_build_irq().

Dmitry Artamonow (1):
      [media] omap3isp: fix compilation of ispvideo.c

Dmitry Kasatkin (2):
      evm: key must be set once during initialization
      evm: prevent racing during tfm allocation

Dmitry Torokhov (1):
      Input: synaptics - fix touchpad not working after S2R on Vostro V13

Eddie Wai (1):
      [SCSI] bnx2i: Fixed kernel panic caused by unprotected
task->sc->request deref

Emmanuel Grumbach (1):
      iwlwifi: update SCD BC table for all SCD queues

Eric Dumazet (4):
      ipv4: reintroduce route cache garbage collector
      bridge: provide a mtu() method for fake_dst_ops
      net: introduce DST_NOPEER dst flag
      net: relax rcvbuf limits

Eugene Surovegin (1):
      percpu: fix per_cpu_ptr_to_phys() handling of non-page-aligned addresses

Felipe Balbi (2):
      usb: dwc3: core: fix cached revision on our structure
      usb: gadget: epautoconf: do not change number of streams

Feng Tang (1):
      i2c-eg20t: correct the driver init order of pch_i2c_probe()

Florian Westphal (1):
      netfilter: xt_connbytes: handle negation correctly

Frantisek Hrbata (1):
      oom: fix integer overflow of points in oom_badness

Gary Thomas (1):
      [media] omap_vout: Fix compile error in 3.1

Gerlando Falauto (1):
      net: have ipconfig not wait if no dev is available

Giridhar Malavali (6):
      [SCSI] qla2xxx: Revert back the request queue mapping to request queue 0.
      [SCSI] qla2xxx: Stop unconditional completion of mailbox
commands issued in interrupt mode during firmware hang.
      [SCSI] qla2xxx: Enable Minidump by default with default capture mask 0x1f.
      [SCSI] qla2xxx: Clear mailbox busy flag during premature mailbox
completion for ISP82xx.
      [SCSI] qla2xxx: Disable generating pause frames when firmware
hang detected for ISP82xx.
      [SCSI] qla2xxx: Submit all chained IOCBs for passthrough
commands on request queue 0.

Guennadi Liakhovetski (2):
      [media] V4L: soc-camera: fix compiler warnings on 64-bit platforms
      [media] V4L: mt9m111: fix uninitialised mutex

Gustavo F. Padovan (1):
      Revert "Bluetooth: Revert: Fix L2CAP connection establishment"

Haogang Chen (1):
      nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()

Hillf Danton (1):
      memcg: keep root group unchanged if creation fails

Ilya Yanok (3):
      mtd: plat_ram: call mtd_device_register only if partition data exists
      davinci-cpdma: fix locking issue in cpdma_chan_stop
      mfd: Fix twl-core oops while calling twl_i2c_* for unbound driver

Jakob Bornecrantz (7):
      vmwgfx: Remove dmabuf check in present ioctl
      vmwgfx: Refactor cursor update
      vmwgfx: Add helper function to get surface or dmabuf
      vmwgfx: Refactor kms code to use vmw_user_lookup_handle helper
      vmwgfx: Do better culling of presents
      vmwgfx: Resend the cursor after legacy modeset
      vmwgfx: Clip cliprects against screen boundaries in present and dirty

James Bottomley (1):
      PCI: fix ats compile failure

Janusz Krzysztofik (1):
      [media] V4L: omap1_camera: fix missing <linux/module.h> include

Joe Perches (1):
      [media] [trivial] omap24xxcam-dma: Fix logical test

Johannes Berg (1):
      iwlwifi: tx_sync only on PAN context

John Stultz (1):
      rtc: m41t80: Workaround broken alarm functionality

Jonathan Cameron (1):
      mtd: pxa2xx-flash.c: It used to fall back to provided table.

Kautuk Consul (1):
      mm/vmalloc.c: remove static declaration of va from __get_vm_area_node

Konrad Rzeszutek Wilk (1):
      Revert "xen/pv-on-hvm kexec: add xs_reset_watches to shutdown
watches from old kernel"

Kusanagi Kouichi (1):
      time/clocksource: Fix kernel-doc warnings

Laurent Pinchart (1):
      [media] omap3isp: Fix crash caused by subdevs now having a
pointer to devnodes

Linus Torvalds (1):
      Linux 3.2-rc7

Magnus Damm (5):
      ARM: mach-shmobile: Kota2 PINT fix
      ARM: mach-shmobile: Kota2 GIC Sparse IRQ fix
      ARM: mach-shmobile: Kota2 TPU LED platform data
      ARM: mach-shmobile: AG5EVM GIC Sparse IRQ fix
      ARM: mach-shmobile: SH73A0 external Ethernet fix

Mandeep Singh Baines (1):
      cgroups: fix a css_set not found bug in cgroup_attach_proc

Manuel Lauss (1):
      mmc: sdhci: remove "state" argument from sdhci_suspend_host

Marcus Folkesson (1):
      mfd: Handle tps65910 clear-mask correctly

Marek Szyprowski (1):
      [media] media: video: s5p-tv: fix build break

Mark Brown (2):
      i2c: i2c-s3c2410: Add a cpu_relax() to busy wait for bus idle
      mfd: Update wm8994 active device checks for WM1811

Markus Kötter (1):
      net: bpf_jit: fix an off-one bug in x86_64 cond jump target

Mat Martineau (2):
      Bluetooth: Prevent uninitialized data access in L2CAP configuration
      Bluetooth: Clear RFCOMM session timer when disconnecting last channel

Mauro Carvalho Chehab (2):
      MAINTAINERS: Update media entries
      Revert "[media] af9015: limit I2C access to keep FW happy"

Michael Krufky (3):
      [media] au0828: add missing USB ID 2040:7260
      [media] au0828: add missing USB ID 2040:7213
      [media] au0828: add missing models 72101, 72201 & 72261 to the
model matrix

Michel Lespinasse (1):
      binary_sysctl(): fix memory leak

Mike Christie (2):
      [SCSI] qla4xxx: fix flash/ddb support
      [SCSI] qla4xxx: check for failed conn setup

Mike Marciniszyn (1):
      IB/qib: Correct sense on freectxts increment and decrement

NeilBrown (7):
      rtc: Expire alarms after the time is set.
      mfd: Base interrupt for twl4030-irq must be one-shot
      mfd: Use request_threaded_irq for twl4030-irq instead of
irq_set_chained_handler
      md/linear: fix hot-add of devices to linear arrays.
      md/raid5: ensure correct assessment of drives during degraded reshape.
      md: don't give up looking for spares on first failure-to-add
      md/bitmap: It is OK to clear bits during recovery.

Ohad Ben-Cohen (1):
      Revert "mmc: enable runtime PM by default"

Paul Bolle (1):
      kconfig: adapt update-po-config to new UML layout

Peter Korsgaard (1):
      [media] s5p_mfc_enc: fix s/H264/H263/ typo

Peter Zijlstra (2):
      MAINTAINERS: Update tip.git related git trees
      sched: Fix select_idle_sibling() regression in selecting an idle
SMT sibling

Rafael J. Wysocki (1):
      PCI hotplug: Always allow acpiphp to handle non-PCIe bridges

Rajkumar Manoharan (1):
      ath9k: fix max phy rate at rate control init

Ram Pai (1):
      PCI: defer enablement of SRIOV BARS

Randy Dunlap (1):
      [media] media/staging: fix allyesconfig build error

Robert Richter (1):
      oprofile: Fix uninitialized memory access when writing to
writing to oprofilefs

Roland Dreier (1):
      IB/mlx4: Fix shutdown crash accessing a non-existent bitmap

Rusty Russell (1):
      mmc: vub300: fix type of firmware_rom_wait_states module parameter

Saurav Kashyap (3):
      [SCSI] qla2xxx: Remove qla2x00_wait_for_loop_ready function.
      [SCSI] qla2xxx: Don't call alloc_fw_dump for ISP82XX.
      [SCSI] qla2xxx: Correct fc_host port_state display.

Sean Hefty (1):
      RDMA/cma: Verify private data length

Shubhrajyoti D (1):
      I2C: OMAP: fix FIFO usage for OMAP4

Srivatsa S. Bhat (1):
      VFS: Fix race between CPU hotplug and lglocks

Steffen Klassert (1):
      net: Add a flow_cache_flush_deferred function

Steffen Maier (1):
      [SCSI] zfcp: return early from slave_destroy if slave_alloc returned early

Stephen Rothwell (1):
      ipv4: using prefetch requires including prefetch.h

Sylwester Nawrocki (10):
      [media] s5p-fimc: Fix wrong pointer dereference when unregistering sensors
      [media] s5p-fimc: Fix error in the capture subdev deinitialization
      [media] s5p-fimc: Fix initialization for proper system suspend support
      [media] s5p-fimc: Fix buffer dequeue order issue
      [media] s5p-fimc: Allow probe() to succeed with null platform data
      [media] s5p-fimc: Adjust pixel height alignments according to
the IP revision
      [media] s5p-fimc: Fail driver probing when sensor configuration is wrong
      [media] s5p-fimc: Use correct fourcc for RGB565 colour format
      [media] m5mols: Fix set_fmt to return proper pixel format code
      [media] s5p-fimc: Fix camera input configuration in subdev operations

Thomas Gleixner (1):
      [SCSI] fcoe: Fix preempt count leak in fcoe_filter_frames()

Thomas Graf (2):
      sctp: Do not account for sizeof(struct sk_buff) in estimated rwnd
      mqprio: Avoid panic if no options are provided

Thomas Hellstrom (1):
      vmwgfx: Use the revised fifo hw version register when present

Thomas Jarosch (1):
      [media] m5mols: Fix logic in sanity check

Thomas Meyer (1):
      nilfs2: unbreak compat ioctl

Tomas Henzl (1):
      [SCSI] qla4xxx: a small loop fix

Tomi Valkeinen (1):
      [media] omap_vout: fix crash if no driver for a display

Tony Breeds (1):
      mtd: ndfc: fix typo in structure dereference

Trond Myklebust (7):
      SUNRPC: Fix the execution time statistics in the face of RPC restarts
      SUNRPC: Ensure we always bump the backlog queue in xprt_free_slot
      NFSv4: Don't error if we handled it in nfs4_recovery_handle_error
      NFSv4.1: Ensure that we handle _all_ SEQUENCE status bits.
      NFSv4: Ensure correct locking when accessing the 'lock_states' list
      NFSv4: Do not accept delegated opens when a delegation recall is in effect
      NFS: Fix a regression in nfs_file_llseek()

Tushar Behera (1):
      i2c-s3c2410: Fix return code of s3c24xx_i2c_parse_dt_gpio

Wey-Yi Guy (2):
      iwlwifi: do not set the sequence control bit is not needed
      iwlwifi: allow to switch to HT40 if not associated

Will Deacon (1):
      perf events: Fix ring_buffer_wakeup() brown paperbag bug

Wolfram Sang (1):
      mtd: gpmi: add missing include 'module.h'

Wu Fengguang (1):
      writeback: show writeback reason with __print_symbolic

Xi Wang (3):
      Input: cma3000_d0x - fix signedness bug in cma3000_thread_irq()
      sctp: fix incorrect overflow check on autoclose
      rps: fix insufficient bounds checking in store_rps_dev_flow_table_cnt()

Yinghai Lu (1):
      pci: Fix hotplug of Express Module with pci bridges

Yogesh Ashok Powar (1):
      mwifiex: avoid double list_del in command cancel path

Yoshihiro Shimoda (1):
      sh: fix build warning in board-sh7757lcr

françois romieu (1):
      r8169: fix Config2 MSIEnable bit setting.

john fastabend (1):
      [SCSI] fcoe: fix fcoe in a DCB environment by adding DCB
notifiers to set skb priority
