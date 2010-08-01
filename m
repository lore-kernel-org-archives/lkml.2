Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0HAXxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:53:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab0HAXxf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:53:35 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Aug 2010 16:52:42 -0700
Message-ID: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
Subject: Linux 2.6.35
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I said -rc6 would likely be the last -rc, and nothing happened to
change my mind. I'd always be happier if it had been an even quieter
week, but the appended Shortlog of changes since rc6 doesn't contain
anything earthshaking, and I don't think we'd have been any better off
by another rc, and waiting one more week. So 2.6.35 is out, go check
it out.

This may have been a fairly odd release cycle with my rather strict
-rc rules before -rc3, but on the whole I think I liked it, and it
seems to have worked out ok. I relaxed my extreme stance after getting
back from vacation, so the latter half of the rc series was more
normal. But even then I got the feeling that people were perhaps a bit
more aware of the whole "regression fixes only" model, which is all
good. It's a bit hard to judge, but there are some numbers to back it
up: in the 2.6.34 release, there were 3800 commits after -rc1, but in
the current 35 release cycle we had less than 2000.

Now, admittedly 34 was worse than average in that respect (3800
commits is a _lot_ of work after -rc1), but git history says that at
least going back to 2.6.24, we've never had less than 2000 commits
after -rc1 before now. They tend to be in the 2700-3200 commit range.
So I do think we really did have a lot less churn than usual
post-merge-window. And that's good.

So I'd like to try to repeat the experiment for the next release
cycle, and be pretty hardnosed about taking patches and git pull
requests after the merge window closes.

Talking about the next merge window: Andrew Morton was pretty unhappy
with the stability of linux-next at least a couple of weeks ago. It's
what he bases his -mm trees on, and so an unstable linux-next makes it
hard for Andrew to get his work done. It also makes me worried,
because a lot of people seem to think that "it's been in linux-next
for several months" means that something can and should be merged. And
if linux-next ends up being really flaky, that clearly cannot be the
case.

So guys - please don't treat linux-next as a dumping ground. Things
that go in there should be more or less ready for merging (with an
emphasis on "more"), and we need to keep that tree in working order.
If you're nervous about the stability of your work, you should just
admit that it's not ready to be merged, shouldn't go in the next
release cycle, and shouldn't be in linux-next yet and make life harder
for people like Andrew - or for the other more careful linux-next
submitters.

On a slightly happier note: one thing I do hope we can merge in the
upcoming merge window is Nick Piggin's cool VFS scalability series.
I've been using it on my own machine, and gone through all the commits
(not that I shouldn't go through some of them some more), and am
personally really excited about it. It's seldom we see major
performance improvements in core code that are quite that noticeable,
and Nick's whole RCU pathname lookup in particular just tickles me
pink.

Anything else? I'm sure there's tons of things I should say about what
went into 2.6.35, but as usual there are already better writeups about
what has changed. Things like the kernelnewbies pages etc. So head off
to

  http://kernelnewbies.org/Linux_2_6_35

for some overviews of the things that changed this time around. Or
just download the kernel from the regular places, and give it a test.

                       Linus

---
Adam Jackson (2):
      drm/i915: Make G4X-style PLL search more permissive
      drm/edid: Fix the HDTV hack sync adjustment

Adam Lackorzynski (1):
      x86, i8259: Only register sysdev if we have a real 8259 PIC

Alex Chiang (1):
      ACPI: processor: fix processor_physically_present on UP

Alexey Shvetsov (1):
      wimax/i2400m: Add PID & VID for Intel WiMAX 6250

Andre Osterhues (1):
      ecryptfs: Bugfix for error related to ecryptfs_hash_buckets

Andrea Shepard (1):
      net: Fix corruption of skb csum field in pskb_expand_head() of
net/core/skbuff.c

Andrej Gelenberg (1):
      [CPUFREQ] revert "[CPUFREQ] remove rwsem lock from
CPUFREQ_GOV_STOP call (second call site)"

Andrew Bird (1):
      USB: New PIDs for Qualcomm gobi 2000 (qcserial)

Andy Gospodarek (1):
      ixgbe/igb: catch invalid VF settings

Anton Blanchard (2):
      powerpc/mm: Handle hypervisor pte insert failure in __hash_page_huge
      [SCSI] ibmvscsi: Fix oops when an interrupt is pending during probe

Anton Vorontsov (1):
      edac: mpc85xx: fix coldplug/hotplug module autoloading

Anuj Aggarwal (1):
      regulator: tps6507x: allow driver to use DEFDCDC{2,3}_HIGH register

Arnaldo Carvalho de Melo (1):
      perf annotate: Fix handling of goto labels that are valid hex numbers

Avi Kivity (1):
      KVM: Use kmalloc() instead of vmalloc() for KVM_[GS]ET_MSR

Axel Lin (2):
      ab3100: fix off-by-one value range checking for voltage selector
      wm8350-regulator: fix wm8350_register_regulator error handling

Ben Greear (1):
      net: dev_forward_skb should call nf_reset

Ben Hutchings (1):
      MIPS: Set io_map_base for several PCI bridges lacking it

Benjamin Herrenschmidt (4):
      powerpc/mm: Move around testing of _PAGE_PRESENT in hash code
      powerpc/mm: Fix bugs in huge page hashing
      powerpc/mm: Add some debug output when hash insertion fails
      powerpc: Fix erroneous lmb->memblock conversions

Bob Copeland (1):
      USB: usb-storage: fix initializations of urb fields

Borislav Petkov (1):
      [CPUFREQ] powernow-k8: Limit Pstate transition latency check

Breno Leitao (1):
      s2io: fixing DBG_PRINT() macro

Brian Haley (1):
      ipv6: Don't add routes to ipv6 disabled interfaces.

Bruno Randolf (1):
      MIPS: MTX-1: Fix PCI on the MeshCube and related boards

Catalin Marinas (3):
      ARM: 6271/1: Introduce *_relaxed() I/O accessors
      ARM: 6272/1: Convert L2x0 to use the IO relaxed operations
      ARM: 6273/1: Add barriers to the I/O accessors if ARM_DMA_MEM_BUFFERABLE

Chris Wilson (4):
      drm/i915: Explosion following OOM in do_execbuffer.
      drm/i915: Clear any existing dither mode prior to enabling
spatial dithering
      drm/i915: Use the correct scanout alignment for fbcon.
      drm/i915: Fix panel fitting regression since 734b4157

Christof Schmitt (2):
      [SCSI] zfcp: Do not wait for SBALs on stopped queue
      [SCSI] zfcp: Update status read mempool

Colin Leitner (1):
      USB: ftdi_sio: support for Signalyzer tools based on FTDI chips

Conny Seidel (1):
      perf tools: Fix fallback to cplus_demangle() when bfd_demangle()
is not available

Corey Minyard (1):
      USB: FTDI: Add support for the RT System VX-7 radio programming cable

Dan Carpenter (1):
      nfs: include space for the NUL in root path

Daniel J Blueman (3):
      quiesce EDAC initialisation on desktop/mobile i7
      [CPUFREQ] fix double freeing in error path of pcc-cpufreq
      drm/radeon/kms: fix radeon mid power profile reporting

David Daney (3):
      MIPS: "Fix" useless 'init_vdso successfully' message.
      MIPS: Make init_vdso a subsys_initcall.
      MIPS: Quit using undefined behavior of ADDU in 64-bit atomic operations.

David Howells (3):
      CRED: Fix get_task_cred() and task_state() to not resurrect dead
credentials
      CRED: Fix __task_cred()'s lockdep check and banner comment
      CIFS: Remove __exit mark from cifs_exit_dns_resolver()

David S. Miller (1):
      net: Fix skb_copy_expand() handling of ->csum_start

David VomLehn (1):
      MIPS: PowerTV: Move register setup to before reading registers.

Dennis Jansen (1):
      USB: option: Add support for AMOI Skypephone S2

Dmitry Torokhov (1):
      Input: RX51 keymap - fix recent compile breakage

Eric Miao (3):
      [ARM] pxa/corgi: fix MMC/SD card detection failure
      [ARM] pxa: fix incorrect order of AC97 reset pin configs
      [ARM] pxa: fix incorrect CONFIG_CPU_PXA27x to CONFIG_PXA27x

Eric W. Biederman (4):
      Driver-core: Always create class directories for classses that
support namespaces.
      sysfs: Don't allow the creation of symlinks we can't remove
      sysfs: sysfs_delete_link handle symlinks from untagged to tagged
directories.
      sysfs: allow creating symlinks from untagged to tagged directories

Felipe Balbi (1):
      USB: musb: tusb6010: fix compile error with n8x0_defconfig

Florian Fainelli (1):
      MIPS: BCM63xx: Prevent second enet registration on BCM6338

Frederic Weisbecker (1):
      perf: Fix various display bugs with parent filtering

Gary King (1):
      ARM: 6279/1: highmem: fix SMP preemption bug in kmap_high_l1_vipt

Greg Edwards (1):
      bonding: set device in RLB ARP packet handler

Gui Jianfeng (1):
      perf symbols: Fix directory descriptor leaking

Heiko Carstens (1):
      [S390] Fix IRQ tracing in case of PER

Herbert Xu (1):
      macvtap: Limit packet queue length

Hugh Dickins (1):
      mm: fix ia64 crash when gcore reads gate area

Jason Baron (1):
      dynamic debug: move ddebug_remove_module() down into free_module()

Jason Wessel (1):
      x86,kgdb: Fix hw breakpoint regression

Jeremy Kerr (5):
      ARM: 6258/1: arm/h720x: fix debug macro compilation failure
      ARM: 6259/1: arm/ns9xxx: fix debug macro compilation failure
      ARM: 6260/1: arm/plat-spear: fix debug macro compilation failure
      ARM: 6261/1: arm/shark: fix debug macro compilation failure
      ARM: 6262/1: arm/clps711x: fix debug macro compilation failure

Jesse Barnes (8):
      drm/i915: handle shared framebuffers when flipping
      drm/i915: add PANEL_UNLOCK_REGS definition
      drm/i915: make sure eDP panel is turned on
      drm/i915: disable FBC when more than one pipe is active
      drm/i915: don't free non-existent compressed llb on ILK+
      drm/i915: fix deadlock in fb teardown
      drm/i915: add pipe A force quirks to i915 driver
      drm/i915: make sure we shut off the panel in eDP configs

John W. Linville (1):
      wireless: use netif_rx_ni in ieee80211_send_layer2_update

Jon Povey (1):
      gpio: fix spurious printk when freeing a gpio

Julia Lawall (1):
      SA1111: Eliminate use after free

KOSAKI Motohiro (1):
      ACPI: fix unused function warning

Kumar Gala (1):
      powerpc/kexec: Fix boundary case for book-e kexec memory limits

Latchesar Ionkov (1):
      9p: Pass the correct end of buffer to p9stat_read

Len Brown (3):
      ACPI: handle systems which asynchoronously enable ACPI mode
      ACPI: skip checking BM_STS if the BIOS doesn't ask for it
      ACPI: create "processor.bm_check_disable" boot param

Linus Torvalds (1):
      Linux 2.6.35

Magnus Damm (1):
      ARM: 6270/1: clean files in arch/arm/boot/compressed/

Marek Vasut (2):
      [ARM] pxa: cpufreq-pxa2xx: fix DRI recomputation routine
      [ARM] pxa: fix frequency scaling for pcmcia/pxa2xx_base

Martin Schwidefsky (1):
      [S390] etr: fix clock synchronization race

Matthew Garrett (2):
      [CPUFREQ] pcc driver should check for pcch method before calling _OSC
      [CPUFREQ] Fix PCC driver error path

Michael S. Tsirkin (2):
      tun: avoid BUG, dump packet on GSO errors
      virtio: fix oops on OOM

Michal Marek (1):
      kbuild: Fix make rpm

Michał Górny (1):
      kbuild: Make the setlocalversion script POSIX-compliant

Ming Lei (1):
      ath9k: fix dma direction for map/unmap in ath_rx_tasklet

Nik A. Melchior (1):
      ACPI video: fix string mismatch for Sony SR290 laptop

Oliver Neukum (2):
      USB: sisusbvga: Fix for USB 3.0
      USB: add quirk for Broadcom BT dongle

Ondrej Zary (2):
      cyber2000fb: fix machine hang on module load
      cyber2000fb: fix console in truecolor modes

Paul Mortier (1):
      USB: adds Artisman USB dongle to list of quirky devices

Peter Huewe (2):
      ds2782_battery: Rename get_current to fix build failure / name conflict
      serial: fix rs485 for atmel_serial on avr32

Peter Zijlstra (1):
      perf, powerpc: Use perf_sample_data_init() for the FSL code

Przemo Firszt (1):
      USB: Expose vendor-specific ACM channel on Nokia 5230

Rabin Vincent (1):
      ARM: 6275/1: ux500: don't use writeb() in uncompress.h

Rafael J. Wysocki (1):
      ACPI / Sleep: Allow the NVS saving to be skipped during suspend to RAM

Rajiv Andrade (1):
      tpm_tis: fix subsequent suspend failures

Ralf Baechle (7):
      VIDEO. gbefb: Fix section mismatches.
      NET: declance: Fix section mismatches
      VIDEO: PMAG-BA: Fix section mismatch
      VIDEO: PMAGB-B: Fix section mismatch
      VIDEO: Au1100fb: Fix section mismatch
      SOUND: Au1000: Fix section mismatch
      MIPS: N32: Define getdents64.

Robert P. J. Day (1):
      ceph: Correct obvious typo of Kconfig variable "CRYPTO_AES"

Rudolf Marek (1):
      drivers/rtc/rtc-rx8581.c: fix setdatetime

Russell King (3):
      ARM: Fix csum_partial_copy_from_user()
      ARM: Add barriers to io{read,write}{8,16,32} accessors as well
      ARM: Fix Versatile/Realview/VExpress MMC card detection sense

Sage Weil (5):
      ceph: avoid dcache readdir for snapdir
      ceph: fix d_release dop for snapdir, snapped dentries
      ceph: fix pg_mapping leak on pg_temp updates
      ceph: fix leak of dentry in ceph_init_dentry() error path
      ceph: fix dentry lease release

Sam Ravnborg (2):
      tracing: Properly align linker defined symbols
      vmlinux.lds: fix .data..init_task output section (fix popwerpc boot)

Sarah Sharp (4):
      USB: xHCI: Fix another bug in link TRB activation change.
      USB: Fix USB3.0 Port Speed Downgrade after port reset
      USB: xhci: Set EP0 dequeue ptr after reset of configured device.
      USB: xhci: Set Mult field in endpoint context correctly.

Sekhar Nori (1):
      davinci: da850/omap-l138 evm: account for DEFDCDC{2,3} being tied high

Stefano Stabellini (1):
      x86: Do not try to disable hpet if it hasn't been initialized before

Stephen Boyd (1):
      nconfig: Fix segfault when help contains special characters

Steven Whitehouse (1):
      GFS2: Use kmalloc when possible for ->readdir()

Swen Schillig (1):
      [SCSI] zfcp: Fix check whether unchained ct_els is possible

Takashi Iwai (4):
      ALSA: hda - Fix pin-detection of Nvidia HDMI
      ALSA: hda - Don't register beep input device when no beep is available
      ALSA: hda - Assume PC-beep as default for Realtek
      ALSA: hda - Add a PC-beep workaround for ASUS P5-V

Thomas Bächler (1):
      gpu/drm/i915: Add a blacklist to omit modeset on LID open

Tim Gardner (1):
      agp/intel: Use the correct mask to detect i830 aperture size.

Trond Myklebust (3):
      NFS: kswapd must not block in nfs_release_page
      NFS: Ensure that writepage respects the nonblock flag
      NFS: Fix a typo in include/linux/nfs_fs.h

Uwe Kleine-König (2):
      ARM: 6263/1: ns9xxx: fix FTBFS for zImage
      ARM: 6265/1: kirkwood: move qnap_tsx1x_register_flash() to .init.text

Vladimir Zapolskiy (1):
      USB: s3c2410_udc: be aware of connected gadget driver

Vladislav Zolotarov (3):
      bnx2x: Protect a SM state change
      bnx2x: Protect statistics ramrod and sequence number
      bnx2x: Advance a module version

Wayne Boyer (1):
      [SCSI] ipr: fix resource path display and formatting

Wim Van Sebroeck (1):
      watchdog: update MAINTAINERS entry

Wolfgang Grandegger (1):
      MIPS: Alchemy: Define eth platform devices in the correct order

Xiao Guangrong (1):
      KVM: MMU: fix conflict access permissions in direct sp

Xiaotian Feng (1):
      [CPUFREQ] fix memory leak in cpufreq_add_dev

Yehuda Sadeh (1):
      ceph: use complete_all and wake_up_all

Zhang Rui (1):
      ACPI battery: don't invoke power_supply_changed twice when
battery is hot-added

august huber (1):
      USB: Add PID for Sierra 250U to drivers/usb/serial/sierra.c

pieterg (1):
      [ARM] pxa/colibri-pxa300: fix AC97 init

stephen hemminger (1):
      net sched: fix race in mirred device removal

wanzongshun (2):
      ARM: 6230/1: fix nuc900 touchscreen clk definition bug
      ARM: 6233/1: Delete a wrong redundant right parenthesis

Ömer Sezgin Ugurlu (1):
      USB: option: add support for 1da5:4518
