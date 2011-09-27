Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1I0XNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:13:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64927 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1I0XNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
Date: Tue, 27 Sep 2011 19:13:01 -0400
Message-ID: <CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e64c145ec3dde704adf46a09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64c145ec3dde704adf46a09
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 21, 2011 at 8:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I was supposed to do this on Monday, but it didn't seem to be hugely pres=
sing.
>
this -rc fails to build on my config (attached):

arch/x86/kernel/i387.c: In function 'restore_i387_xsave':
arch/x86/kernel/i387.c:726:1: warning: "/*" within comment
arch/x86/kernel/i387.c:733:1: error: a label can only be part of a
statement and a declaration is not a statement
arch/x86/kernel/i387.c:734:1: error: expected '=3D', ',', ';', 'asm' or
'__attribute__' before '{' token
arch/x86/kernel/i387.c:746:1: error: expected expression before 'extern'
arch/x86/kernel/i387.c:746:1: warning: ISO C90 forbids mixed
declarations and code
arch/x86/kernel/i387.c:746:1: error: expected declaration or statement
at end of input
arch/x86/kernel/i387.c: At top level:
arch/x86/kernel/i387.c:639:12: warning: 'restore_i387_xsave' defined
but not used

This still happen with -rc8. Let me commute home and I'll give you a bisect=
ion.

 - Arnaud

> Not only were there some patches under discussion, it is becoming
> clear that I might as well not release the final 3.1 until after my
> upcoming vacation early October - otherwise the next merge window
> would just be total chaos. A merge window with kernel.org being off
> just really wouldn't work, and doing a release only to then have some
> chaotic merge window followed by travel seems crazy.
>
> So here we are, two days late, but in no hurry.
>
> We've actually fixed a few core regressions - they may not be easy to
> hit (which is why it took so long), but we had a nasty dentry bug
> (fixed by the first commit in the shortlog below) that admittedly was
> only triggerable with NFS and some odd directory movement, but it was
> still interesting to see something like that at this stage. Some
> rather subtle dentry refcounting rules had resulted in an "obvious
> cleanup" having broken a subtle rule about dentry parent lifetimes
> etc.
>
> We had some other "core" stuff too (wasting time looping over swap
> page entries in find_get_pages), but as you can see from the shortlog,
> most of it ends up being pretty peripheral. Mostly random driver
> fixes, which is also backed up by the diffstat - 60% drivers, 8%
> networking, 7% arch (arm and UM), 7% filesystem, 5% mm, random small
> patches elsewhere.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Linu=
s
>
> ---
> Al Viro (7):
> =C2=A0 =C2=A0 =C2=A0restore pinning the victim dentry in vfs_rmdir()/vfs_=
rename_dir()
> =C2=A0 =C2=A0 =C2=A0um: fix oopsable race in line_close()
> =C2=A0 =C2=A0 =C2=A0um: winch_interrupt() can happen inside of free_winch=
()
> =C2=A0 =C2=A0 =C2=A0um: fix free_winch() mess
> =C2=A0 =C2=A0 =C2=A0um: PTRACE_[GS]ETFPXREGS had been wired on the wrong =
subarch
> =C2=A0 =C2=A0 =C2=A0um: clean arch_ptrace() up a bit
> =C2=A0 =C2=A0 =C2=A0um: fix strrchr() problems
>
> Alex Deucher (2):
> =C2=A0 =C2=A0 =C2=A0drm/radeon/kms: fix typo in r100_blit_copy
> =C2=A0 =C2=A0 =C2=A0drm/radeon/kms: Make GPU/CPU page size handling consi=
stent in
> blit code (v2)
>
> Alexander Sverdlin (1):
> =C2=A0 =C2=A0 =C2=A0init: carefully handle loglevel option on kernel cmdl=
ine.
>
> Anand Gadiyar (1):
> =C2=A0 =C2=A0 =C2=A0mfd: Make omap-usb-host TLL mode work again
>
> Andi Kleen (2):
> =C2=A0 =C2=A0 =C2=A0IRDA: Fix global type conflicts in net/irda/irsysctl.=
c v2
> =C2=A0 =C2=A0 =C2=A0watchdog: Initconst section fixes for watchdog
>
> Andiry Xu (1):
> =C2=A0 =C2=A0 =C2=A0USB: xHCI: prevent infinite loop when processing MSE =
event
>
> Andrew Vasquez (1):
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: Correct inadvertent loop state transi=
tions
> during port-update handling.
>
> Anton Blanchard (3):
> =C2=A0 =C2=A0 =C2=A0ibmveth: Fix issue with DMA mapping failure
> =C2=A0 =C2=A0 =C2=A0ibmveth: Checksum offload is always disabled
> =C2=A0 =C2=A0 =C2=A0ibmveth: Fix checksum offload failure handling
>
> Ariel Elior (1):
> =C2=A0 =C2=A0 =C2=A0bnx2x: Fix for a host coalescing bug which impared la=
tency.
>
> Arjan van de Ven (1):
> =C2=A0 =C2=A0 =C2=A0ALSA: pcm - fix race condition in wait_for_avail()
>
> Arnd Bergmann (1):
> =C2=A0 =C2=A0 =C2=A0ASoC: Fix trivial build regression in Kirkwood I2S
>
> Arun Easi (2):
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: T10 DIF - Handle uninitalized sectors=
.
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: T10 DIF - Fix incorrect error reporti=
ng.
>
> Axel Lin (3):
> =C2=A0 =C2=A0 =C2=A0Input: cm109 - fix checking return value of usb_contr=
ol_msg
> =C2=A0 =C2=A0 =C2=A0Input: adp5588-keys - remove incorrect modalias
> =C2=A0 =C2=A0 =C2=A0drivers/rtc/rtc-imxdi.c needs linux/sched.h
>
> Banajit Goswami (1):
> =C2=A0 =C2=A0 =C2=A0ARM: S3C64XX: Remove un-used code backlight code on S=
MDK6410
>
> Bart De Schuymer (1):
> =C2=A0 =C2=A0 =C2=A0netfilter: ebtables: fix ebtables build dependency
>
> Ben Hutchings (4):
> =C2=A0 =C2=A0 =C2=A0alpha, gpio: GENERIC_GPIO default must be n
> =C2=A0 =C2=A0 =C2=A0Revert "sfc: Use write-combining to reduce TX latency=
" and follow-ups
> =C2=A0 =C2=A0 =C2=A0sfc: Use 64-bit writes for TX push where possible
> =C2=A0 =C2=A0 =C2=A0gianfar: Fix overflow check and return value for gfar=
_get_cls_all()
>
> Ben Skeggs (1):
> =C2=A0 =C2=A0 =C2=A0drm/ttm: request zeroed system memory pages for new T=
T buffer objects
>
> Benjamin Herrenschmidt (1):
> =C2=A0 =C2=A0 =C2=A0pci: Don't crash when reading mpss from root complex
>
> Benny Halevy (1):
> =C2=A0 =C2=A0 =C2=A0MAINTAINERS: update e-mail address of Benny Halevy
>
> Bjorn Helgaas (1):
> =C2=A0 =C2=A0 =C2=A0PNP: update pnp.debug usage (needs value on command l=
ine)
>
> Brian King (1):
> =C2=A0 =C2=A0 =C2=A0ibmveth: Fix DMA unmap error
>
> Carsten Emde (1):
> =C2=A0 =C2=A0 =C2=A0floppy: use del_timer_sync() in init cleanup
>
> Caspar Zhang (1):
> =C2=A0 =C2=A0 =C2=A0mm/mempolicy.c: fix pgoff in mbind vma merge
>
> Chad Dupuis (3):
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: Fix qla24xx revision check while enab=
ling interrupts.
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: Double check for command completion i=
f abort
> mailbox command fails.
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: Update version number to 8.03.07.07-k=
.
>
> Changhwan Youn (1):
> =C2=A0 =C2=A0 =C2=A0ARM: EXYNOS4: restart clocksource while system resume=
s
>
> Chen Ganir (1):
> =C2=A0 =C2=A0 =C2=A0Bluetooth: Fixed BT ST Channel reg order
>
> Chen Gong (1):
> =C2=A0 =C2=A0 =C2=A0ACPI APEI: Add Kconfig option IRQ_WORK for GHES
>
> Chris Bagwell (1):
> =C2=A0 =C2=A0 =C2=A0Input: wacom - fix touch parsing on newer Bamboos
>
> Christoph Hellwig (5):
> =C2=A0 =C2=A0 =C2=A0block: remove READ_META and WRITE_META
> =C2=A0 =C2=A0 =C2=A0block: separate priority boosting from REQ_META
> =C2=A0 =C2=A0 =C2=A0xfs: fix a use after free in xfs_end_io_direct_write
> =C2=A0 =C2=A0 =C2=A0hfsplus: fix filesystem size checks
> =C2=A0 =C2=A0 =C2=A0tcm_fc: Work queue based approach instead of managing=
 own thread
> and event based mechanism
>
> Dan Williams (5):
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: fix sata response handling
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: fix 32-bit operation when CONFIG_HIGHMEM=
64G=3Dn
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: dynamic interrupt coalescing
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: fix event-get pointer increment
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: add version number
>
> Daniel Hellstrom (2):
> =C2=A0 =C2=A0 =C2=A0GRETH: RX/TX bytes were never increased
> =C2=A0 =C2=A0 =C2=A0GRETH: avoid overwrite IP-stack's IP-frags checksum
>
> Daniel Mack (1):
> =C2=A0 =C2=A0 =C2=A0can: ti_hecc: include linux/io.h
>
> Dave Hansen (3):
> =C2=A0 =C2=A0 =C2=A0make /proc/$pid/numa_maps gather_stats() take variabl=
e page size
> =C2=A0 =C2=A0 =C2=A0break out numa_maps gather_pte_stats() checks
> =C2=A0 =C2=A0 =C2=A0teach /proc/$pid/numa_maps about transparent hugepage=
s
>
> Dave Jiang (2):
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: Update MAINTAINERS entry for the isci dr=
iver
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: Adding documentation to API change and f=
ixup sysfs
> registration
>
> David Henningsson (2):
> =C2=A0 =C2=A0 =C2=A0ALSA: HDA: Cirrus - fix "Surround Speaker" volume con=
trol name
> =C2=A0 =C2=A0 =C2=A0ALSA: HDA: Add support for IDT 92HD93
>
> David Rientjes (1):
> =C2=A0 =C2=A0 =C2=A0numa: fix NUMA compile error when sysfs and procfs ar=
e disabled
>
> David Vrabel (2):
> =C2=A0 =C2=A0 =C2=A0xen/e820: if there is no dom0_mem=3D, don't tweak ext=
ra_pages.
> =C2=A0 =C2=A0 =C2=A0mm: sync vmalloc address space page tables in alloc_v=
m_area()
>
> David Ward (1):
> =C2=A0 =C2=A0 =C2=A0net: Align AF-specific flowi structs to long
>
> Dmitry Kravkov (6):
> =C2=A0 =C2=A0 =C2=A0bnx2x: fix BRB thresholds for dropless_fc mode
> =C2=A0 =C2=A0 =C2=A0bnx2x: decrease print level to debug
> =C2=A0 =C2=A0 =C2=A0bnx2x: fix MF for 4-port devices
> =C2=A0 =C2=A0 =C2=A0bnx2x: don't reset device while reading its configura=
tion.
> =C2=A0 =C2=A0 =C2=A0bnx2x: init fw_seq after undi_unload is done
> =C2=A0 =C2=A0 =C2=A0bnx2x: don't access removed registers on 57712 and ab=
ove
>
> Don Fry (1):
> =C2=A0 =C2=A0 =C2=A0iwlagn: workaround bug crashing some APs
>
> Donggeun Kim (1):
> =C2=A0 =C2=A0 =C2=A0drivers/rtc/rtc-s3c.c: fix no occurrence of alarm int=
errupt
>
> Eddie Wai (1):
> =C2=A0 =C2=A0 =C2=A0[SCSI] bnx2i: Fixed the endian on TTT for NOP out tra=
nsmission
>
> Eric Dumazet (5):
> =C2=A0 =C2=A0 =C2=A0netfilter: xt_rateest: fix xt_rateest_mt_checkentry()
> =C2=A0 =C2=A0 =C2=A0net: ipv4: relax AF_INET check in bind()
> =C2=A0 =C2=A0 =C2=A0tcp: Change possible SYN flooding messages
> =C2=A0 =C2=A0 =C2=A0caif: fix a potential NULL dereference
> =C2=A0 =C2=A0 =C2=A0tcp: fix build error if !CONFIG_SYN_COOKIES
>
> Eric Seppanen (1):
> =C2=A0 =C2=A0 =C2=A0block: Fix queue_flag update when rq_affinity goes fr=
om 2 to 1
>
> Fabio Estevam (1):
> =C2=A0 =C2=A0 =C2=A0ASoC: imx: Fix build warning of unused 'card' variabl=
e
>
> Felix Fietkau (1):
> =C2=A0 =C2=A0 =C2=A0ath9k_hw: fix calibration on 5 ghz
>
> Florian Westphal (1):
> =C2=A0 =C2=A0 =C2=A0netfilter: nf_queue: reject NF_STOLEN verdicts from u=
serspace
>
> Francois Romieu (2):
> =C2=A0 =C2=A0 =C2=A0r8169: remove erroneous processing of always set bit.
> =C2=A0 =C2=A0 =C2=A0r8169: do not enable the TBI for anything but the ori=
ginal 8169.
>
> Gao feng (1):
> =C2=A0 =C2=A0 =C2=A0fib:fix BUG_ON in fib_nl_newrule when add new fib rul=
e
>
> Geert Uytterhoeven (1):
> =C2=A0 =C2=A0 =C2=A0genirq: Make irq_shutdown() symmetric vs. irq_startup=
 again
>
> George (2):
> =C2=A0 =C2=A0 =C2=A0rtlwifi: rtl8192su: Fix problem connecting to HT-enab=
led AP
> =C2=A0 =C2=A0 =C2=A0rtlwifi: Fix problem when switching connections
>
> Greg Kroah-Hartman (1):
> =C2=A0 =C2=A0 =C2=A0USB: xhci: Set change bit when warm reset change is s=
et.
>
> Guenter Roeck (1):
> =C2=A0 =C2=A0 =C2=A0hwmon: (pmbus) Fix low limit temperature alarms
>
> H Hartley Sweeten (2):
> =C2=A0 =C2=A0 =C2=A0lib/sha1.c: quiet sparse noise about symbol not decla=
red
> =C2=A0 =C2=A0 =C2=A0watchdog: WatchDog Timer Driver Core - use passed wat=
chdog_device
>
> Hayes Wang (3):
> =C2=A0 =C2=A0 =C2=A0r8169: fix the reset setting for 8111evl
> =C2=A0 =C2=A0 =C2=A0r8169: add MODULE_FIRMWARE for the firmware of 8111ev=
l
> =C2=A0 =C2=A0 =C2=A0r8169: fix WOL setting for 8105 and 8111evl
>
> Henry Wong (1):
> =C2=A0 =C2=A0 =C2=A0ppp_generic: fix multilink fragment MTU calculation (=
again)
>
> Hidetoshi Seto (1):
> =C2=A0 =C2=A0 =C2=A0btrfs: fix d_off in the first dirent
>
> Ian Campbell (3):
> =C2=A0 =C2=A0 =C2=A0MAINTAINERS: Update ATLX driver maintainers
> =C2=A0 =C2=A0 =C2=A0MAINTAINERS: Update Cisco VIC driver maintainers
> =C2=A0 =C2=A0 =C2=A0MAINTAINERS: Update BNA 10G Maintainer
>
> Igor Maravi=C4=87 (1):
> =C2=A0 =C2=A0 =C2=A0pkt_sched: cls_rsvp.h was outdated
>
> Ingo van Lil (1):
> =C2=A0 =C2=A0 =C2=A0um: Save FPU registers between task switches
>
> Jan Beulich (1):
> =C2=A0 =C2=A0 =C2=A0xen/i386: follow-up to "replace order-based range che=
cking of
> M2P table by linear one"
>
> Jan Kara (2):
> =C2=A0 =C2=A0 =C2=A0mm: Cleanup clearing of BDI_pending bit in bdi_forker=
_thread()
> =C2=A0 =C2=A0 =C2=A0mm: Add comment explaining task state setting in bdi_=
forker_thread()
>
> Jason Gerecke (2):
> =C2=A0 =C2=A0 =C2=A0Input: wacom - advertise BTN_TOOL_PEN and BTN_STYLUS =
for PenPartner
> =C2=A0 =C2=A0 =C2=A0Input: wacom - add POINTER and DIRECT device properti=
es
>
> Jean Delvare (1):
> =C2=A0 =C2=A0 =C2=A0hwmon: (coretemp) Initialize tmin
>
> Jeff Kirsher (1):
> =C2=A0 =C2=A0 =C2=A0e1000: Fix driver to be used on PA RISC C8000 worksta=
tions
>
> Jeff Layton (1):
> =C2=A0 =C2=A0 =C2=A0cifs: fix possible memory corruption in CIFSFindNext
>
> Jeff Liu (1):
> =C2=A0 =C2=A0 =C2=A0BTRFS: Fix lseek return value for error
>
> Jeff Skirvin (1):
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: Leave requests alone if already terminat=
ing.
>
> Jeremy Fitzhardinge (1):
> =C2=A0 =C2=A0 =C2=A0xen: use non-tracing preempt in xen_clocksource_read(=
)
>
> Jesper Juhl (2):
> =C2=A0 =C2=A0 =C2=A0netfilter: ip_queue: Fix small leak in ipq_build_pack=
et_message()
> =C2=A0 =C2=A0 =C2=A0drivers/misc/pti.c: give 'comm' function scope in
> pti_control_frame_built_and_sent()
>
> Jesse Brandeburg (1):
> =C2=A0 =C2=A0 =C2=A0ixgbe: fix possible null buffer error
>
> Joe Jin (2):
> =C2=A0 =C2=A0 =C2=A0xen-blkback: Don't disconnect backend until state swi=
tched to
> XenbusStateClosed.
> =C2=A0 =C2=A0 =C2=A0xen-blkback: fixed indentation and comments
>
> Johan Hovold (2):
> =C2=A0 =C2=A0 =C2=A0mfd: Fix initialisation of tps65910 interrupts
> =C2=A0 =C2=A0 =C2=A0drivers/leds/ledtrig-timer.c: fix broken sysfs delay =
handling
>
> Johannes Berg (3):
> =C2=A0 =C2=A0 =C2=A0mac80211: fix missing sta_lock in __sta_info_destroy
> =C2=A0 =C2=A0 =C2=A0iwlagn: fix stack corruption
> =C2=A0 =C2=A0 =C2=A0iwlagn: fix command queue timeout
>
> Johannes Weiner (2):
> =C2=A0 =C2=A0 =C2=A0mm: vmscan: fix force-scanning small targets without =
swap
> =C2=A0 =C2=A0 =C2=A0memcg: Revert "memcg: add memory.vmscan_stat"
>
> John Crispin (1):
> =C2=A0 =C2=A0 =C2=A0watchdog: lantiq: fix watchdogs timeout handling
>
> Jonathan Neusch=C3=A4fer (1):
> =C2=A0 =C2=A0 =C2=A0um: drivers/xterm.c: fix a file descriptor leak
>
> Jonghwan Choi (1):
> =C2=A0 =C2=A0 =C2=A0ARM: EXYNOS4: Fix wrong pll type for vpll
>
> Josef Bacik (1):
> =C2=A0 =C2=A0 =C2=A0Btrfs: only clear the need lookup flag after the dent=
ry is setup
>
> Jozsef Kadlecsik (2):
> =C2=A0 =C2=A0 =C2=A0netfilter: nf_ct_tcp: fix incorrect handling of inval=
id TCP option
> =C2=A0 =C2=A0 =C2=A0netfilter: nf_ct_tcp: wrong multiplication of
> TCPOLEN_TSTAMP_ALIGNED in tcp_sack skips fastpath
>
> Jurgen Kramer (1):
> =C2=A0 =C2=A0 =C2=A0Bluetooth: add support for 2011 mac mini
>
> KAMEZAWA Hiroyuki (1):
> =C2=A0 =C2=A0 =C2=A0mm/mempolicy.c: make copy_from_user() provably correc=
t
>
> Kasper Pedersen (1):
> =C2=A0 =C2=A0 =C2=A0tg3: fix VLAN tagging regression
>
> Kavan Smith (1):
> =C2=A0 =C2=A0 =C2=A0ipheth: iPhone 4 Verizon CDMA USB Product ID add
>
> Kiran Patil (1):
> =C2=A0 =C2=A0 =C2=A0tcm_fc: Invalidation of DDP context for FCoE target i=
n error conditions
>
> Konrad Rzeszutek Wilk (1):
> =C2=A0 =C2=A0 =C2=A0xen/irq: Alter the locking to use a mutex instead of =
a spinlock.
>
> Kukjin Kim (3):
> =C2=A0 =C2=A0 =C2=A0ARM: EXYNOS4: Fix return type of local_timer_setup()
> =C2=A0 =C2=A0 =C2=A0ARM: EXYNOS4: Fix routing timer interrupt to offline =
CPU
> =C2=A0 =C2=A0 =C2=A0ARM: SAMSUNG: fix to prevent declaring duplicated
>
> Kyle Manna (2):
> =C2=A0 =C2=A0 =C2=A0mfd: Copy the device pointer to the twl4030-madc stru=
cture
> =C2=A0 =C2=A0 =C2=A0mfd: Check for twl4030-madc NULL pointer
>
> Larry Finger (2):
> =C2=A0 =C2=A0 =C2=A0rt2800pci: Fix compiler error on PowerPC
> =C2=A0 =C2=A0 =C2=A0rtl2800usb: Fix incorrect storage of MAC address on b=
ig-endian platforms
>
> Lars-Peter Clausen (3):
> =C2=A0 =C2=A0 =C2=A0ASoC: snd_soc_codec_{readable,writable}_register chan=
ge default to true
> =C2=A0 =C2=A0 =C2=A0ASoC: Fix register cache sync register_writable WARN_=
ONs
> =C2=A0 =C2=A0 =C2=A0ASoC: Blackfin: bf5xx-ad193x: Fix codec device name
>
> Lasse Collin (1):
> =C2=A0 =C2=A0 =C2=A0XZ: Fix incorrect XZ_BUF_ERROR
>
> Len Brown (1):
> =C2=A0 =C2=A0 =C2=A0acpica: ACPI_MAX_SLEEP should be 2 sec, not 20
>
> Li Zefan (3):
> =C2=A0 =C2=A0 =C2=A0Btrfs: fix pages truncation in btrfs_ioctl_clone()
> =C2=A0 =C2=A0 =C2=A0Btrfs: don't make a file partly checksummed through f=
ile clone
> =C2=A0 =C2=A0 =C2=A0Btrfs: don't change inode flag of the dest clone file
>
> Lin Ming (1):
> =C2=A0 =C2=A0 =C2=A0netconsole: switch init_netconsole() to late_initcall
>
> Linus Torvalds (4):
> =C2=A0 =C2=A0 =C2=A0asm alternatives: remove incorrect alignment notes
> =C2=A0 =C2=A0 =C2=A0Make TASKSTATS require root access
> =C2=A0 =C2=A0 =C2=A0Make taskstats round statistics down to nearest 1k by=
tes/events
> =C2=A0 =C2=A0 =C2=A0Linux 3.1-rc7
>
> Linus Walleij (1):
> =C2=A0 =C2=A0 =C2=A0mach-integrator: fix VGA base regression
>
> Maciej =C5=BBenczykowski (1):
> =C2=A0 =C2=A0 =C2=A0net: relax PKTINFO non local ipv6 udp xmit check
>
> Manual Munz (1):
> =C2=A0 =C2=A0 =C2=A0b43: Fix beacon problem in ad-hoc mode
>
> Marcin Tomczak (1):
> =C2=A0 =C2=A0 =C2=A0[SCSI] isci: change sas phy timeouts from 54us to 59u=
s
>
> Marcos Paulo de Souza (1):
> =C2=A0 =C2=A0 =C2=A0Documentation: networking: dmfe.txt: Remove the maint=
ainer of
> orphan networking driver
>
> Marek Szyprowski (1):
> =C2=A0 =C2=A0 =C2=A0ARM: SAMSUNG: fix watchdog reset issue with clk_get()
>
> Mark Brown (3):
> =C2=A0 =C2=A0 =C2=A0MAINTAINERS: Add some missed Wolfson files
> =C2=A0 =C2=A0 =C2=A0ASoC: Fix reporting of partial jack updates
> =C2=A0 =C2=A0 =C2=A0mfd: Fix value of WM8994_CONFIGURE_GPIO
>
> Matthew Garrett (1):
> =C2=A0 =C2=A0 =C2=A0APEI: Fix WHEA _OSC call
>
> Max Matveev (1):
> =C2=A0 =C2=A0 =C2=A0sctp: deal with multiple COOKIE_ECHO chunks
>
> Michael S. Tsirkin (1):
> =C2=A0 =C2=A0 =C2=A0net: copy userspace buffers on device forwarding
>
> Michel D=C3=A4nzer (2):
> =C2=A0 =C2=A0 =C2=A0drm/radeon: Don't read from CP ring write pointer reg=
isters.
> =C2=A0 =C2=A0 =C2=A0drm/radeon: Unreference GEM object outside of spinloc=
k in page
> flip error path.
>
> Ming Lei (2):
> =C2=A0 =C2=A0 =C2=A0mfd: Fix omap-usb-host build failure
> =C2=A0 =C2=A0 =C2=A0firewire: ohci: add no MSI quirk for O2Micro controll=
er
>
> Mohammed Shafi Shajakhan (1):
> =C2=A0 =C2=A0 =C2=A0ath9k: Fix kernel panic on unplugging the device
>
> MyungJoo Ham (1):
> =C2=A0 =C2=A0 =C2=A0mfd: Set MAX8997 irq pointer
>
> Naga Chumbalkar (2):
> =C2=A0 =C2=A0 =C2=A0drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer der=
eference
> =C2=A0 =C2=A0 =C2=A0watchdog: hpwdt: prevent multiple "NMI occurred" mess=
ages
>
> Nicholas Bellinger (3):
> =C2=A0 =C2=A0 =C2=A0target: Skip non hex characters for VPD=3D0x83 NAA IE=
EE Registered Extended
> =C2=A0 =C2=A0 =C2=A0iscsi-target: Disable markers + remove dangerous loca=
l scope array usage
> =C2=A0 =C2=A0 =C2=A0iscsi-target: Fix sendpage breakage with proper
> padding+DataDigest iovec offsets
>
> Nicolas Pitre (1):
> =C2=A0 =C2=A0 =C2=A0ARM: Dove: fix second SPI initialization call
>
> Oliver Neukum (1):
> =C2=A0 =C2=A0 =C2=A0Bluetooth: Fix timeout on scanning for the second tim=
e
>
> Patrick McHardy (1):
> =C2=A0 =C2=A0 =C2=A0netfilter: update netfilter git URL
>
> Pavel Shilovsky (1):
> =C2=A0 =C2=A0 =C2=A0CIFS: Fix ERR_PTR dereference in cifs_get_root
>
> Peter Ujfalusi (1):
> =C2=A0 =C2=A0 =C2=A0ASoC: soc-dapm: Fix parameter comment for snd_soc_dap=
m_free
>
> Pieter-Augustijn Van Malleghem (2):
> =C2=A0 =C2=A0 =C2=A0Input: bcm5974 - add MacBookAir4,1 trackpad support
> =C2=A0 =C2=A0 =C2=A0Bluetooth: Add MacBookAir4,1 support
>
> Ping Cheng (1):
> =C2=A0 =C2=A0 =C2=A0Input: wacom - remove pressure for touch devices
>
> Rajkumar Manoharan (3):
> =C2=A0 =C2=A0 =C2=A0ath9k_hw: Fix init mode register regression
> =C2=A0 =C2=A0 =C2=A0wireless: Reset beacon_found while updating regulator=
y
> =C2=A0 =C2=A0 =C2=A0wireless: Fix rate mask for scan request
>
> Randy Dunlap (1):
> =C2=A0 =C2=A0 =C2=A0staging: fix comedi build when ISA_DMA_API is enabled=
 but
> COMEDI_PCI is not enabled
>
> Robert Love (1):
> =C2=A0 =C2=A0 =C2=A0[SCSI] fcoe: Fix deadlock between fip's recv_work and=
 rtnl
>
> Roland Dreier (1):
> =C2=A0 =C2=A0 =C2=A0target: Fix race between multiple invocations of targ=
et_qf_do_work()
>
> Roy Li (1):
> =C2=A0 =C2=A0 =C2=A0ipv6: fix a possible double free
>
> Russell King (1):
> =C2=A0 =C2=A0 =C2=A0drivers/gpio/gpio-generic.c: fix build errors
>
> Sachin Prabhu (1):
> =C2=A0 =C2=A0 =C2=A0nfs: Do not allow multiple mounts on same mountpoint =
when using -o noac
>
> Sage Weil (1):
> =C2=A0 =C2=A0 =C2=A0Btrfs: reserve sufficient space for ioctl clone
>
> Sanket Shah (1):
> =C2=A0 =C2=A0 =C2=A0netfilter: nf_ct_pptp: fix DNATed PPTP connection add=
ress translation
>
> Sascha Hauer (1):
> =C2=A0 =C2=A0 =C2=A0mfd: Rename wm8350 static gpio_set_debounce()
>
> Saurav Kashyap (3):
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: Acquire hardware lock while manipulat=
ing dsd list.
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: Save and restore irq in the response =
queue
> interrupt handler.
> =C2=A0 =C2=A0 =C2=A0[SCSI] qla2xxx: Set the task attributes after memsett=
ing fcp cmnd.
>
> Seth Forshee (1):
> =C2=A0 =C2=A0 =C2=A0hfsplus: Fix kfree of wrong pointers in hfsplus_fill_=
super() error path
>
> Seth Jennings (1):
> =C2=A0 =C2=A0 =C2=A0staging: zcache: fix cleancache crash
>
> Shaohua Li (4):
> =C2=A0 =C2=A0 =C2=A0block: change force plug flush call order
> =C2=A0 =C2=A0 =C2=A0block: simplify force plug flush code a little bit
> =C2=A0 =C2=A0 =C2=A0slub: add slab with one free object to partial list t=
ail
> =C2=A0 =C2=A0 =C2=A0mm: account skipped entries to avoid looping in find_=
get_pages
>
> Shirish Pargaonkar (1):
> =C2=A0 =C2=A0 =C2=A0cifs: Fix broken sec=3Dntlmv2/i sec option (try #2)
>
> Stanislaw Gruszka (2):
> =C2=A0 =C2=A0 =C2=A0iwlegacy: fix BUG_ON(info->control.rates[0].idx < 0)
> =C2=A0 =C2=A0 =C2=A0ipw2x00: fix rtnl mutex deadlock
>
> Stefano Stabellini (1):
> =C2=A0 =C2=A0 =C2=A0xen: disable PV spinlocks on HVM
>
> Steffen Klassert (1):
> =C2=A0 =C2=A0 =C2=A0xfrm: Perform a replay check after return from async =
codepaths
>
> Stephen M. Cameron (2):
> =C2=A0 =C2=A0 =C2=A0[SCSI] hpsa: fix problem that OBDR devices are not de=
tected
> =C2=A0 =C2=A0 =C2=A0[SCSI] hpsa: fix physical device lun and target numbe=
ring problem
>
> Stephen Warren (1):
> =C2=A0 =C2=A0 =C2=A0arm/dt: Tegra: Update SDHCI nodes to match bindings
>
> Steve French (1):
> =C2=A0 =C2=A0 =C2=A0Fix the conflict between rwpidforward and rw mount op=
tions
>
> Takashi Iwai (2):
> =C2=A0 =C2=A0 =C2=A0ALSA: hda - Terminate the recursive connection search=
 properly
> =C2=A0 =C2=A0 =C2=A0ALSA: hda/realtek - Fix auto-mute with HP+LO configur=
ation
>
> Tanmay Upadhyay (1):
> =C2=A0 =C2=A0 =C2=A0net: pxa168: Fix build errors by including interrupt.=
h
>
> Tao Ma (1):
> =C2=A0 =C2=A0 =C2=A0block: Don't check QUEUE_FLAG_SAME_COMP in __blk_comp=
lete_request
>
> Thadeu Lima de Souza Cascardo (1):
> =C2=A0 =C2=A0 =C2=A0um: disable CMPXCHG_DOUBLE as it breaks UML build
>
> Thomas Abraham (1):
> =C2=A0 =C2=A0 =C2=A0ARM: EXYNOS4: fix incorrect pad configuration for key=
pad row lines
>
> Thomas Gleixner (1):
> =C2=A0 =C2=A0 =C2=A0x86, iommu: Mark DMAR IRQ as non-threaded
>
> Thomas Tuttle (1):
> =C2=A0 =C2=A0 =C2=A0workqueue: lock cwq access in drain_workqueue
>
> Timur Tabi (1):
> =C2=A0 =C2=A0 =C2=A0ASoC: MPC5200: replace of_device with platform_device
>
> Toshiharu Okada (3):
> =C2=A0 =C2=A0 =C2=A0pch_gbe: fixed the issue which receives an unnecessar=
y packet.
> =C2=A0 =C2=A0 =C2=A0pch_gbe: added the process of FIFO over run error
> =C2=A0 =C2=A0 =C2=A0pch_gbe: support ML7831 IOH
>
> Trond Myklebust (5):
> =C2=A0 =C2=A0 =C2=A0NFSv4: nfs4_proc_async_renew should use a GFP_NOFS al=
location
> =C2=A0 =C2=A0 =C2=A0NFSv4: nfs4_proc_renew should be declared static
> =C2=A0 =C2=A0 =C2=A0NFSv4: The NFSv4.0 client must send RENEW calls if it=
 holds a delegation
> =C2=A0 =C2=A0 =C2=A0NFSv4: renewd needs to be able to handle the NFS4ERR_=
CB_PATH_DOWN error
> =C2=A0 =C2=A0 =C2=A0NFS: Fix a typo in nfs_flush_multi
>
> Vasu Dev (2):
> =C2=A0 =C2=A0 =C2=A0[SCSI] libfc: fix fc_eh_host_reset
> =C2=A0 =C2=A0 =C2=A0[SCSI] libfc: block SCSI eh thread for blocked rports
>
> Vladislav Zolotarov (1):
> =C2=A0 =C2=A0 =C2=A0bnx2x: fix rx ring size report
>
> WANG Cong (1):
> =C2=A0 =C2=A0 =C2=A0cris: fix a build error in drivers/tty/serial/crisv10=
.c
>
> Wanlong Gao (1):
> =C2=A0 =C2=A0 =C2=A0blk-cgroup: be able to remove the record of unplugged=
 device
>
> Yan, Zheng (2):
> =C2=A0 =C2=A0 =C2=A0ipv4: Fix fib_info->fib_metrics leak
> =C2=A0 =C2=A0 =C2=A0ipv6: don't use inetpeer to store metrics for routes.
>
> Yaniv Rosner (6):
> =C2=A0 =C2=A0 =C2=A0bnx2x: Fix ETS bandwidth
> =C2=A0 =C2=A0 =C2=A0bnx2x: Enable FEC for 57810-KR
> =C2=A0 =C2=A0 =C2=A0bnx2x: Remove fiber remote fault detection
> =C2=A0 =C2=A0 =C2=A0bnx2x: Fix XMAC loopback test
> =C2=A0 =C2=A0 =C2=A0bnx2x: Fix 578xx link LED
> =C2=A0 =C2=A0 =C2=A0bnx2x: Fix ethtool advertisement
>
> Yi Zou (1):
> =C2=A0 =C2=A0 =C2=A0[SCSI] libfc: fix referencing to fc_fcp_pkt from the =
frame
> pointer via fr_fsp()
>
> Zheng Yan (1):
> =C2=A0 =C2=A0 =C2=A0tcp: fix validation of D-SACK
>
> dpward (2):
> =C2=A0 =C2=A0 =C2=A0net: Make flow cache namespace-aware
> =C2=A0 =C2=A0 =C2=A0net: Handle different key sizes between address famil=
ies in flow cache
>
> nhorman (1):
> =C2=A0 =C2=A0 =C2=A0net: don't clear IFF_XMIT_DST_RELEASE in ether_setup
>
> rajan.aggarwal85@gmail.com (1):
> =C2=A0 =C2=A0 =C2=A0net/can/af_can.c: Change del_timer to del_timer_sync
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>

--0016e64c145ec3dde704adf46a09
Content-Type: application/octet-stream; name=dot-config
Content-Disposition: attachment; filename=dot-config
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt3htwsx0

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4L2kz
ODYgMy4xLjAtcmMzIEtlcm5lbCBDb25maWd1cmF0aW9uCiMKIyBDT05GSUdfNjRCSVQgaXMgbm90
IHNldApDT05GSUdfWDg2XzMyPXkKIyBDT05GSUdfWDg2XzY0IGlzIG5vdCBzZXQKQ09ORklHX1g4
Nj15CkNPTkZJR19JTlNUUlVDVElPTl9ERUNPREVSPXkKQ09ORklHX09VVFBVVF9GT1JNQVQ9ImVs
ZjMyLWkzODYiCkNPTkZJR19BUkNIX0RFRkNPTkZJRz0iYXJjaC94ODYvY29uZmlncy9pMzg2X2Rl
ZmNvbmZpZyIKQ09ORklHX0dFTkVSSUNfQ01PU19VUERBVEU9eQpDT05GSUdfQ0xPQ0tTT1VSQ0Vf
V0FUQ0hET0c9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNPTkZJR19MT0NLREVQX1NV
UFBPUlQ9eQpDT05GSUdfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfTEFURU5DWVRP
UF9TVVBQT1JUPXkKQ09ORklHX01NVT15CkNPTkZJR19aT05FX0RNQT15CiMgQ09ORklHX05FRURf
RE1BX01BUF9TVEFURSBpcyBub3Qgc2V0CkNPTkZJR19ORUVEX1NHX0RNQV9MRU5HVEg9eQpDT05G
SUdfR0VORVJJQ19JU0FfRE1BPXkKQ09ORklHX0dFTkVSSUNfSU9NQVA9eQpDT05GSUdfR0VORVJJ
Q19CVUc9eQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkKQ09ORklHX0FSQ0hfTUFZX0hBVkVfUENf
RkRDPXkKIyBDT05GSUdfUldTRU1fR0VORVJJQ19TUElOTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19S
V1NFTV9YQ0hHQUREX0FMR09SSVRITT15CkNPTkZJR19BUkNIX0hBU19DUFVfSURMRV9XQUlUPXkK
Q09ORklHX0dFTkVSSUNfQ0FMSUJSQVRFX0RFTEFZPXkKIyBDT05GSUdfR0VORVJJQ19USU1FX1ZT
WVNDQUxMIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSEFTX0NQVV9SRUxBWD15CkNPTkZJR19BUkNI
X0hBU19ERUZBVUxUX0lETEU9eQpDT05GSUdfQVJDSF9IQVNfQ0FDSEVfTElORV9TSVpFPXkKQ09O
RklHX0hBVkVfU0VUVVBfUEVSX0NQVV9BUkVBPXkKQ09ORklHX05FRURfUEVSX0NQVV9FTUJFRF9G
SVJTVF9DSFVOSz15CkNPTkZJR19ORUVEX1BFUl9DUFVfUEFHRV9GSVJTVF9DSFVOSz15CiMgQ09O
RklHX0hBVkVfQ1BVTUFTS19PRl9DUFVfTUFQIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSElCRVJO
QVRJT05fUE9TU0lCTEU9eQpDT05GSUdfQVJDSF9TVVNQRU5EX1BPU1NJQkxFPXkKIyBDT05GSUdf
Wk9ORV9ETUEzMiBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX1BPUFVMQVRFU19OT0RFX01BUD15CiMg
Q09ORklHX0FVRElUX0FSQ0ggaXMgbm90IHNldApDT05GSUdfQVJDSF9TVVBQT1JUU19PUFRJTUla
RURfSU5MSU5JTkc9eQpDT05GSUdfQVJDSF9TVVBQT1JUU19ERUJVR19QQUdFQUxMT0M9eQpDT05G
SUdfWDg2XzMyX0xBWllfR1M9eQpDT05GSUdfQVJDSF9IV0VJR0hUX0NGTEFHUz0iLWZjYWxsLXNh
dmVkLWVjeCAtZmNhbGwtc2F2ZWQtZWR4IgpDT05GSUdfS1RJTUVfU0NBTEFSPXkKQ09ORklHX0RF
RkNPTkZJR19MSVNUPSIvbGliL21vZHVsZXMvJFVOQU1FX1JFTEVBU0UvLmNvbmZpZyIKQ09ORklH
X0hBVkVfSVJRX1dPUks9eQpDT05GSUdfSVJRX1dPUks9eQoKIwojIEdlbmVyYWwgc2V0dXAKIwpD
T05GSUdfRVhQRVJJTUVOVEFMPXkKQ09ORklHX0JST0tFTl9PTl9TTVA9eQpDT05GSUdfSU5JVF9F
TlZfQVJHX0xJTUlUPTMyCkNPTkZJR19DUk9TU19DT01QSUxFPSIiCkNPTkZJR19MT0NBTFZFUlNJ
T049IiIKIyBDT05GSUdfTE9DQUxWRVJTSU9OX0FVVE8gaXMgbm90IHNldApDT05GSUdfSEFWRV9L
RVJORUxfR1pJUD15CkNPTkZJR19IQVZFX0tFUk5FTF9CWklQMj15CkNPTkZJR19IQVZFX0tFUk5F
TF9MWk1BPXkKQ09ORklHX0hBVkVfS0VSTkVMX1haPXkKQ09ORklHX0hBVkVfS0VSTkVMX0xaTz15
CkNPTkZJR19LRVJORUxfR1pJUD15CiMgQ09ORklHX0tFUk5FTF9CWklQMiBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFUk5FTF9MWk1BIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VSTkVMX1haIGlzIG5vdCBz
ZXQKIyBDT05GSUdfS0VSTkVMX0xaTyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0hPU1ROQU1F
PSIobm9uZSkiCiMgQ09ORklHX1NXQVAgaXMgbm90IHNldAojIENPTkZJR19TWVNWSVBDIGlzIG5v
dCBzZXQKIyBDT05GSUdfUE9TSVhfTVFVRVVFIGlzIG5vdCBzZXQKIyBDT05GSUdfQlNEX1BST0NF
U1NfQUNDVCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZIQU5ETEUgaXMgbm90IHNldAojIENPTkZJR19U
QVNLU1RBVFMgaXMgbm90IHNldAojIENPTkZJR19BVURJVCBpcyBub3Qgc2V0CkNPTkZJR19IQVZF
X0dFTkVSSUNfSEFSRElSUVM9eQoKIwojIElSUSBzdWJzeXN0ZW0KIwpDT05GSUdfR0VORVJJQ19I
QVJESVJRUz15CkNPTkZJR19IQVZFX1NQQVJTRV9JUlE9eQpDT05GSUdfR0VORVJJQ19JUlFfUFJP
QkU9eQpDT05GSUdfR0VORVJJQ19JUlFfU0hPVz15CkNPTkZJR19JUlFfRk9SQ0VEX1RIUkVBRElO
Rz15CiMgQ09ORklHX1NQQVJTRV9JUlEgaXMgbm90IHNldAoKIwojIFJDVSBTdWJzeXN0ZW0KIwpD
T05GSUdfVElOWV9SQ1U9eQojIENPTkZJR19QUkVFTVBUX1JDVSBpcyBub3Qgc2V0CiMgQ09ORklH
X1JDVV9UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RSRUVfUkNVX1RSQUNFIGlzIG5vdCBzZXQK
Q09ORklHX0lLQ09ORklHPXkKQ09ORklHX0lLQ09ORklHX1BST0M9eQpDT05GSUdfTE9HX0JVRl9T
SElGVD0xOApDT05GSUdfSEFWRV9VTlNUQUJMRV9TQ0hFRF9DTE9DSz15CiMgQ09ORklHX0NHUk9V
UFMgaXMgbm90IHNldApDT05GSUdfTkFNRVNQQUNFUz15CiMgQ09ORklHX1VUU19OUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTRVJfTlMgaXMgbm90IHNldAojIENPTkZJR19QSURfTlMgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfTlMgaXMgbm90IHNldAojIENPTkZJR19TQ0hFRF9BVVRPR1JPVVAgaXMg
bm90IHNldAojIENPTkZJR19TWVNGU19ERVBSRUNBVEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVM
QVkgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9JTklUUkQ9eQpDT05GSUdfSU5JVFJBTUZTX1NP
VVJDRT0iIgpDT05GSUdfUkRfR1pJUD15CiMgQ09ORklHX1JEX0JaSVAyIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkRfTFpNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1JEX1haIGlzIG5vdCBzZXQKIyBDT05G
SUdfUkRfTFpPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0NfT1BUSU1JWkVfRk9SX1NJWkUgaXMgbm90
IHNldApDT05GSUdfU1lTQ1RMPXkKQ09ORklHX0FOT05fSU5PREVTPXkKQ09ORklHX0VYUEVSVD15
CkNPTkZJR19VSUQxNj15CkNPTkZJR19TWVNDVExfU1lTQ0FMTD15CkNPTkZJR19LQUxMU1lNUz15
CkNPTkZJR19LQUxMU1lNU19BTEw9eQpDT05GSUdfSE9UUExVRz15CkNPTkZJR19QUklOVEs9eQpD
T05GSUdfQlVHPXkKQ09ORklHX0VMRl9DT1JFPXkKQ09ORklHX1BDU1BLUl9QTEFURk9STT15CkNP
TkZJR19IQVZFX1BDU1BLUl9QTEFURk9STT15CkNPTkZJR19CQVNFX0ZVTEw9eQpDT05GSUdfRlVU
RVg9eQpDT05GSUdfRVBPTEw9eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfVElNRVJGRD15CkNP
TkZJR19FVkVOVEZEPXkKQ09ORklHX1NITUVNPXkKQ09ORklHX0FJTz15CkNPTkZJR19FTUJFRERF
RD15CkNPTkZJR19IQVZFX1BFUkZfRVZFTlRTPXkKCiMKIyBLZXJuZWwgUGVyZm9ybWFuY2UgRXZl
bnRzIEFuZCBDb3VudGVycwojCkNPTkZJR19QRVJGX0VWRU5UUz15CiMgQ09ORklHX1BFUkZfQ09V
TlRFUlMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19QRVJGX1VTRV9WTUFMTE9DIGlzIG5vdCBz
ZXQKQ09ORklHX1ZNX0VWRU5UX0NPVU5URVJTPXkKQ09ORklHX1BDSV9RVUlSS1M9eQojIENPTkZJ
R19TTFVCX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NUEFUX0JSSyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NMQUIgaXMgbm90IHNldApDT05GSUdfU0xVQj15CiMgQ09ORklHX1NMT0IgaXMgbm90
IHNldAojIENPTkZJR19QUk9GSUxJTkcgaXMgbm90IHNldApDT05GSUdfSEFWRV9PUFJPRklMRT15
CiMgQ09ORklHX0pVTVBfTEFCRUwgaXMgbm90IHNldApDT05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5B
TElHTkVEX0FDQ0VTUz15CkNPTkZJR19IQVZFX0lPUkVNQVBfUFJPVD15CkNPTkZJR19IQVZFX0tQ
Uk9CRVM9eQpDT05GSUdfSEFWRV9LUkVUUFJPQkVTPXkKQ09ORklHX0hBVkVfT1BUUFJPQkVTPXkK
Q09ORklHX0hBVkVfQVJDSF9UUkFDRUhPT0s9eQpDT05GSUdfSEFWRV9ETUFfQVRUUlM9eQpDT05G
SUdfSEFWRV9SRUdTX0FORF9TVEFDS19BQ0NFU1NfQVBJPXkKQ09ORklHX0hBVkVfRE1BX0FQSV9E
RUJVRz15CkNPTkZJR19IQVZFX0hXX0JSRUFLUE9JTlQ9eQpDT05GSUdfSEFWRV9NSVhFRF9CUkVB
S1BPSU5UU19SRUdTPXkKQ09ORklHX0hBVkVfVVNFUl9SRVRVUk5fTk9USUZJRVI9eQpDT05GSUdf
SEFWRV9QRVJGX0VWRU5UU19OTUk9eQpDT05GSUdfSEFWRV9BUkNIX0pVTVBfTEFCRUw9eQpDT05G
SUdfQVJDSF9IQVZFX05NSV9TQUZFX0NNUFhDSEc9eQoKIwojIEdDT1YtYmFzZWQga2VybmVsIHBy
b2ZpbGluZwojCkNPTkZJR19IQVZFX0dFTkVSSUNfRE1BX0NPSEVSRU5UPXkKQ09ORklHX1JUX01V
VEVYRVM9eQpDT05GSUdfQkFTRV9TTUFMTD0wCiMgQ09ORklHX01PRFVMRVMgaXMgbm90IHNldApD
T05GSUdfQkxPQ0s9eQojIENPTkZJR19MQkRBRiBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZf
QlNHIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9CU0dMSUIgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX0lOVEVHUklUWSBpcyBub3Qgc2V0CgojCiMgSU8gU2NoZWR1bGVycwojCkNPTkZJ
R19JT1NDSEVEX05PT1A9eQojIENPTkZJR19JT1NDSEVEX0RFQURMSU5FIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU9TQ0hFRF9DRlEgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9OT09QPXkKQ09ORklH
X0RFRkFVTFRfSU9TQ0hFRD0ibm9vcCIKIyBDT05GSUdfSU5MSU5FX1NQSU5fVFJZTE9DSyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX1RSWUxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJ
R19JTkxJTkVfU1BJTl9MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DS19C
SCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5MSU5FX1NQSU5fTE9DS19JUlFTQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5F
X1NQSU5fVU5MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLX0JIIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOTElORV9TUElOX1VOTE9DS19JUlFSRVNUT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5M
SU5FX1JFQURfVFJZTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX0xPQ0sgaXMg
bm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5MSU5FX1JFQURfTE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9MT0NL
X0lSUVNBVkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9VTkxPQ0sgaXMgbm90IHNl
dAojIENPTkZJR19JTkxJTkVfUkVBRF9VTkxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJ
TkVfUkVBRF9VTkxPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NL
X0lSUVJFU1RPUkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfVFJZTE9DSyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5M
SU5FX1dSSVRFX0xPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9DS19J
UlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9DS19JUlFTQVZFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElO
RV9XUklURV9VTkxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfVU5MT0NL
X0lSUSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9VTkxPQ0tfSVJRUkVTVE9SRSBp
cyBub3Qgc2V0CiMgQ09ORklHX01VVEVYX1NQSU5fT05fT1dORVIgaXMgbm90IHNldAojIENPTkZJ
R19GUkVFWkVSIGlzIG5vdCBzZXQKCiMKIyBQcm9jZXNzb3IgdHlwZSBhbmQgZmVhdHVyZXMKIwpD
T05GSUdfVElDS19PTkVTSE9UPXkKQ09ORklHX05PX0haPXkKQ09ORklHX0hJR0hfUkVTX1RJTUVS
Uz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTX0JVSUxEPXkKIyBDT05GSUdfU01QIGlzIG5v
dCBzZXQKQ09ORklHX1g4Nl9FWFRFTkRFRF9QTEFURk9STT15CiMgQ09ORklHX1g4Nl9JTlRFTF9N
SUQgaXMgbm90IHNldAojIENPTkZJR19YODZfUkRDMzIxWCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4
Nl8zMl9JUklTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NIRURfT01JVF9GUkFNRV9QT0lOVEVSIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFSQVZJUlRfR1VFU1QgaXMgbm90IHNldApDT05GSUdfTk9fQk9P
VE1FTT15CiMgQ09ORklHX01FTVRFU1QgaXMgbm90IHNldAojIENPTkZJR19NMzg2IGlzIG5vdCBz
ZXQKQ09ORklHX000ODY9eQojIENPTkZJR19NNTg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTTU4NlRT
QyBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZNTVggaXMgbm90IHNldAojIENPTkZJR19NNjg2IGlz
IG5vdCBzZXQKIyBDT05GSUdfTVBFTlRJVU1JSSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVN
SUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfTVBFTlRJVU1NIGlzIG5vdCBzZXQKIyBDT05GSUdfTVBF
TlRJVU00IGlzIG5vdCBzZXQKIyBDT05GSUdfTUs2IGlzIG5vdCBzZXQKIyBDT05GSUdfTUs3IGlz
IG5vdCBzZXQKIyBDT05GSUdfTUs4IGlzIG5vdCBzZXQKIyBDT05GSUdfTUNSVVNPRSBpcyBub3Qg
c2V0CiMgQ09ORklHX01FRkZJQ0VPTiBpcyBub3Qgc2V0CiMgQ09ORklHX01XSU5DSElQQzYgaXMg
bm90IHNldAojIENPTkZJR19NV0lOQ0hJUDNEIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVMQU4gaXMg
bm90IHNldAojIENPTkZJR19NR0VPREVHWDEgaXMgbm90IHNldAojIENPTkZJR19NR0VPREVfTFgg
aXMgbm90IHNldAojIENPTkZJR19NQ1lSSVhJSUkgaXMgbm90IHNldAojIENPTkZJR19NVklBQzNf
MiBpcyBub3Qgc2V0CiMgQ09ORklHX01WSUFDNyBpcyBub3Qgc2V0CiMgQ09ORklHX01DT1JFMiBp
cyBub3Qgc2V0CiMgQ09ORklHX01BVE9NIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9HRU5FUklDPXkK
Q09ORklHX1g4Nl9JTlRFUk5PREVfQ0FDSEVfU0hJRlQ9NgpDT05GSUdfWDg2X0NNUFhDSEc9eQpD
T05GSUdfQ01QWENIR19MT0NBTD15CkNPTkZJR19DTVBYQ0hHX0RPVUJMRT15CkNPTkZJR19YODZf
TDFfQ0FDSEVfU0hJRlQ9NgpDT05GSUdfWDg2X1hBREQ9eQojIENPTkZJR19YODZfUFBST19GRU5D
RSBpcyBub3Qgc2V0CkNPTkZJR19YODZfRjAwRl9CVUc9eQpDT05GSUdfWDg2X0lOVkRfQlVHPXkK
Q09ORklHX1g4Nl9XUF9XT1JLU19PSz15CkNPTkZJR19YODZfSU5WTFBHPXkKQ09ORklHX1g4Nl9C
U1dBUD15CkNPTkZJR19YODZfUE9QQURfT0s9eQpDT05GSUdfWDg2X0FMSUdOTUVOVF8xNj15CkNP
TkZJR19YODZfSU5URUxfVVNFUkNPUFk9eQpDT05GSUdfWDg2X01JTklNVU1fQ1BVX0ZBTUlMWT00
CiMgQ09ORklHX1BST0NFU1NPUl9TRUxFQ1QgaXMgbm90IHNldApDT05GSUdfQ1BVX1NVUF9JTlRF
TD15CkNPTkZJR19DUFVfU1VQX0NZUklYXzMyPXkKQ09ORklHX0NQVV9TVVBfQU1EPXkKQ09ORklH
X0NQVV9TVVBfQ0VOVEFVUj15CkNPTkZJR19DUFVfU1VQX1RSQU5TTUVUQV8zMj15CkNPTkZJR19D
UFVfU1VQX1VNQ18zMj15CkNPTkZJR19IUEVUX1RJTUVSPXkKQ09ORklHX0RNST15CiMgQ09ORklH
X0lPTU1VX0hFTFBFUiBpcyBub3Qgc2V0CkNPTkZJR19OUl9DUFVTPTEKIyBDT05GSUdfSVJRX1RJ
TUVfQUNDT1VOVElORyBpcyBub3Qgc2V0CiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0
CkNPTkZJR19QUkVFTVBUX1ZPTFVOVEFSWT15CiMgQ09ORklHX1BSRUVNUFQgaXMgbm90IHNldAoj
IENPTkZJR19YODZfVVBfQVBJQyBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9NQ0UgaXMgbm90IHNl
dAojIENPTkZJR19WTTg2IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9TSElCQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0k4SyBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9SRUJPT1RGSVhVUFMgaXMgbm90IHNl
dAojIENPTkZJR19NSUNST0NPREUgaXMgbm90IHNldAojIENPTkZJR19YODZfTVNSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfWDg2X0NQVUlEIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9ISUdITUVNIGlzIG5v
dCBzZXQKQ09ORklHX0hJR0hNRU00Rz15CkNPTkZJR19WTVNQTElUXzNHPXkKIyBDT05GSUdfVk1T
UExJVF8zR19PUFQgaXMgbm90IHNldAojIENPTkZJR19WTVNQTElUXzJHIGlzIG5vdCBzZXQKIyBD
T05GSUdfVk1TUExJVF8yR19PUFQgaXMgbm90IHNldAojIENPTkZJR19WTVNQTElUXzFHIGlzIG5v
dCBzZXQKQ09ORklHX1BBR0VfT0ZGU0VUPTB4QzAwMDAwMDAKQ09ORklHX0hJR0hNRU09eQojIENP
TkZJR19BUkNIX1BIWVNfQUREUl9UXzY0QklUIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9ETUFf
QUREUl9UXzY0QklUIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfRkxBVE1FTV9FTkFCTEU9eQpDT05G
SUdfQVJDSF9TUEFSU0VNRU1fRU5BQkxFPXkKQ09ORklHX0FSQ0hfU0VMRUNUX01FTU9SWV9NT0RF
TD15CkNPTkZJR19JTExFR0FMX1BPSU5URVJfVkFMVUU9MApDT05GSUdfU0VMRUNUX01FTU9SWV9N
T0RFTD15CkNPTkZJR19GTEFUTUVNX01BTlVBTD15CiMgQ09ORklHX1NQQVJTRU1FTV9NQU5VQUwg
aXMgbm90IHNldApDT05GSUdfRkxBVE1FTT15CkNPTkZJR19GTEFUX05PREVfTUVNX01BUD15CkNP
TkZJR19TUEFSU0VNRU1fU1RBVElDPXkKQ09ORklHX0hBVkVfTUVNQkxPQ0s9eQpDT05GSUdfUEFH
RUZMQUdTX0VYVEVOREVEPXkKQ09ORklHX1NQTElUX1BUTE9DS19DUFVTPTk5OTk5OQojIENPTkZJ
R19DT01QQUNUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhZU19BRERSX1RfNjRCSVQgaXMgbm90
IHNldApDT05GSUdfWk9ORV9ETUFfRkxBRz0xCkNPTkZJR19CT1VOQ0U9eQpDT05GSUdfVklSVF9U
T19CVVM9eQojIENPTkZJR19LU00gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9NTUFQX01JTl9B
RERSPTQwOTYKIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0UgaXMgbm90IHNldApDT05GSUdf
TkVFRF9QRVJfQ1BVX0tNPXkKIyBDT05GSUdfQ0xFQU5DQUNIRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJR0hQVEUgaXMgbm90IHNldAojIENPTkZJR19YODZfQ0hFQ0tfQklPU19DT1JSVVBUSU9OIGlz
IG5vdCBzZXQKQ09ORklHX1g4Nl9SRVNFUlZFX0xPVz02NAojIENPTkZJR19NQVRIX0VNVUxBVElP
TiBpcyBub3Qgc2V0CkNPTkZJR19NVFJSPXkKQ09ORklHX01UUlJfU0FOSVRJWkVSPXkKQ09ORklH
X01UUlJfU0FOSVRJWkVSX0VOQUJMRV9ERUZBVUxUPTAKQ09ORklHX01UUlJfU0FOSVRJWkVSX1NQ
QVJFX1JFR19OUl9ERUZBVUxUPTEKQ09ORklHX1g4Nl9QQVQ9eQpDT05GSUdfQVJDSF9VU0VTX1BH
X1VOQ0FDSEVEPXkKIyBDT05GSUdfU0VDQ09NUCBpcyBub3Qgc2V0CiMgQ09ORklHX0NDX1NUQUNL
UFJPVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
SFpfMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMzAwIGlzIG5vdCBzZXQKQ09ORklHX0haXzEw
MDA9eQpDT05GSUdfSFo9MTAwMApDT05GSUdfU0NIRURfSFJUSUNLPXkKIyBDT05GSUdfS0VYRUMg
aXMgbm90IHNldApDT05GSUdfQ1JBU0hfRFVNUD15CkNPTkZJR19QSFlTSUNBTF9TVEFSVD0weDEw
MDAwMDAKQ09ORklHX1JFTE9DQVRBQkxFPXkKQ09ORklHX1g4Nl9ORUVEX1JFTE9DUz15CkNPTkZJ
R19QSFlTSUNBTF9BTElHTj0weDEwMDAwMDAKIyBDT05GSUdfQ09NUEFUX1ZEU08gaXMgbm90IHNl
dAojIENPTkZJR19DTURMSU5FX0JPT0wgaXMgbm90IHNldApDT05GSUdfQVJDSF9FTkFCTEVfTUVN
T1JZX0hPVFBMVUc9eQoKIwojIFBvd2VyIG1hbmFnZW1lbnQgYW5kIEFDUEkgb3B0aW9ucwojCiMg
Q09ORklHX1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJR19QTV9SVU5USU1FIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NGSSBpcyBub3Qgc2V0CgojCiMgQ1BV
IEZyZXF1ZW5jeSBzY2FsaW5nCiMKIyBDT05GSUdfQ1BVX0ZSRVEgaXMgbm90IHNldApDT05GSUdf
Q1BVX0lETEU9eQpDT05GSUdfQ1BVX0lETEVfR09WX0xBRERFUj15CkNPTkZJR19DUFVfSURMRV9H
T1ZfTUVOVT15CiMgQ09ORklHX0lOVEVMX0lETEUgaXMgbm90IHNldAoKIwojIEJ1cyBvcHRpb25z
IChQQ0kgZXRjLikKIwpDT05GSUdfUENJPXkKIyBDT05GSUdfUENJX0dPQklPUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1BDSV9HT01NQ09ORklHIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX0dPRElSRUNU
IGlzIG5vdCBzZXQKQ09ORklHX1BDSV9HT0FOWT15CkNPTkZJR19QQ0lfQklPUz15CkNPTkZJR19Q
Q0lfRElSRUNUPXkKQ09ORklHX1BDSV9ET01BSU5TPXkKIyBDT05GSUdfUENJX0NOQjIwTEVfUVVJ
UksgaXMgbm90IHNldAojIENPTkZJR19QQ0lFUE9SVEJVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfU1VQUE9SVFNfTVNJIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX0RFQlVHIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENJX1NUVUIgaXMgbm90IHNldAojIENPTkZJR19QQ0lfSU9WIGlzIG5vdCBzZXQK
Q09ORklHX1BDSV9MQUJFTD15CkNPTkZJR19JU0FfRE1BX0FQST15CkNPTkZJR19JU0E9eQpDT05G
SUdfRUlTQT15CiMgQ09ORklHX0VJU0FfVkxCX1BSSU1JTkcgaXMgbm90IHNldApDT05GSUdfRUlT
QV9QQ0lfRUlTQT15CkNPTkZJR19FSVNBX1ZJUlRVQUxfUk9PVD15CkNPTkZJR19FSVNBX05BTUVT
PXkKIyBDT05GSUdfTUNBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0N4MjAwIGlzIG5vdCBzZXQKIyBD
T05GSUdfT0xQQyBpcyBub3Qgc2V0CkNPTkZJR19BTURfTkI9eQojIENPTkZJR19QQ0NBUkQgaXMg
bm90IHNldAojIENPTkZJR19IT1RQTFVHX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX1JBUElESU8g
aXMgbm90IHNldAoKIwojIEV4ZWN1dGFibGUgZmlsZSBmb3JtYXRzIC8gRW11bGF0aW9ucwojCkNP
TkZJR19CSU5GTVRfRUxGPXkKQ09ORklHX0NPUkVfRFVNUF9ERUZBVUxUX0VMRl9IRUFERVJTPXkK
Q09ORklHX0hBVkVfQU9VVD15CiMgQ09ORklHX0JJTkZNVF9BT1VUIGlzIG5vdCBzZXQKIyBDT05G
SUdfQklORk1UX01JU0MgaXMgbm90IHNldApDT05GSUdfSEFWRV9BVE9NSUNfSU9NQVA9eQpDT05G
SUdfSEFWRV9URVhUX1BPS0VfU01QPXkKQ09ORklHX05FVD15CgojCiMgTmV0d29ya2luZyBvcHRp
b25zCiMKQ09ORklHX1BBQ0tFVD15CkNPTkZJR19VTklYPXkKIyBDT05GSUdfTkVUX0tFWSBpcyBu
b3Qgc2V0CkNPTkZJR19JTkVUPXkKIyBDT05GSUdfSVBfTVVMVElDQVNUIGlzIG5vdCBzZXQKIyBD
T05GSUdfSVBfQURWQU5DRURfUk9VVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfUE5QIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX0lQSVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfSVBHUkVfREVN
VVggaXMgbm90IHNldAojIENPTkZJR19BUlBEIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lOX0NPT0tJ
RVMgaXMgbm90IHNldAojIENPTkZJR19JTkVUX0FIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9F
U1AgaXMgbm90IHNldAojIENPTkZJR19JTkVUX0lQQ09NUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
RVRfWEZSTV9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1RVTk5FTCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lORVRfWEZSTV9NT0RFX1RSQU5TUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
RVRfWEZSTV9NT0RFX1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfWEZSTV9NT0RFX0JF
RVQgaXMgbm90IHNldApDT05GSUdfSU5FVF9MUk89eQpDT05GSUdfSU5FVF9ESUFHPXkKQ09ORklH
X0lORVRfVENQX0RJQUc9eQojIENPTkZJR19UQ1BfQ09OR19BRFZBTkNFRCBpcyBub3Qgc2V0CkNP
TkZJR19UQ1BfQ09OR19DVUJJQz15CkNPTkZJR19ERUZBVUxUX1RDUF9DT05HPSJjdWJpYyIKIyBD
T05GSUdfVENQX01ENVNJRyBpcyBub3Qgc2V0CkNPTkZJR19JUFY2PXkKIyBDT05GSUdfSVBWNl9Q
UklWQUNZIGlzIG5vdCBzZXQKQ09ORklHX0lQVjZfUk9VVEVSX1BSRUY9eQpDT05GSUdfSVBWNl9S
T1VURV9JTkZPPXkKIyBDT05GSUdfSVBWNl9PUFRJTUlTVElDX0RBRCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lORVQ2X0FIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVDZfRVNQIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5FVDZfSVBDT01QIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NSVA2IGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5FVDZfWEZSTV9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9U
VU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9YRlJNX01PREVfVFJBTlNQT1JUIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklH
X0lORVQ2X1hGUk1fTU9ERV9CRUVUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVDZfWEZSTV9NT0RF
X1JPVVRFT1BUSU1JWkFUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9TSVQgaXMgbm90IHNl
dAojIENPTkZJR19JUFY2X1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfTVVMVElQTEVf
VEFCTEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NUk9VVEUgaXMgbm90IHNldAojIENPTkZJ
R19ORVRXT1JLX1NFQ01BUksgaXMgbm90IHNldAojIENPTkZJR19ORVRXT1JLX1BIWV9USU1FU1RB
TVBJTkcgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVIgaXMgbm90IHNldAojIENPTkZJR19J
UF9EQ0NQIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfU0NUUCBpcyBub3Qgc2V0CiMgQ09ORklHX1JE
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1RJUEMgaXMgbm90IHNldAojIENPTkZJR19BVE0gaXMgbm90
IHNldAojIENPTkZJR19MMlRQIGlzIG5vdCBzZXQKQ09ORklHX1NUUD15CkNPTkZJR19CUklER0U9
eQpDT05GSUdfQlJJREdFX0lHTVBfU05PT1BJTkc9eQojIENPTkZJR19ORVRfRFNBIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVkxBTl84MDIxUSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQ05FVCBpcyBub3Qg
c2V0CkNPTkZJR19MTEM9eQojIENPTkZJR19MTEMyIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBYIGlz
IG5vdCBzZXQKIyBDT05GSUdfQVRBTEsgaXMgbm90IHNldAojIENPTkZJR19YMjUgaXMgbm90IHNl
dAojIENPTkZJR19MQVBCIGlzIG5vdCBzZXQKIyBDT05GSUdfRUNPTkVUIGlzIG5vdCBzZXQKIyBD
T05GSUdfV0FOX1JPVVRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05FVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lFRUU4MDIxNTQgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIRUQgaXMgbm90IHNl
dAojIENPTkZJR19EQ0IgaXMgbm90IHNldAojIENPTkZJR19CQVRNQU5fQURWIGlzIG5vdCBzZXQK
CiMKIyBOZXR3b3JrIHRlc3RpbmcKIwojIENPTkZJR19ORVRfUEtUR0VOIGlzIG5vdCBzZXQKIyBD
T05GSUdfSEFNUkFESU8gaXMgbm90IHNldAojIENPTkZJR19DQU4gaXMgbm90IHNldAojIENPTkZJ
R19JUkRBIGlzIG5vdCBzZXQKIyBDT05GSUdfQlQgaXMgbm90IHNldAojIENPTkZJR19BRl9SWFJQ
QyBpcyBub3Qgc2V0CiMgQ09ORklHX1dJUkVMRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfV0lNQVgg
aXMgbm90IHNldAojIENPTkZJR19SRktJTEwgaXMgbm90IHNldAojIENPTkZJR19ORVRfOVAgaXMg
bm90IHNldAojIENPTkZJR19DQUlGIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0VQSF9MSUIgaXMgbm90
IHNldAojIENPTkZJR19ORkMgaXMgbm90IHNldAoKIwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBH
ZW5lcmljIERyaXZlciBPcHRpb25zCiMKQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iL3NiaW4v
aG90cGx1ZyIKQ09ORklHX0RFVlRNUEZTPXkKQ09ORklHX0RFVlRNUEZTX01PVU5UPXkKQ09ORklH
X1NUQU5EQUxPTkU9eQpDT05GSUdfUFJFVkVOVF9GSVJNV0FSRV9CVUlMRD15CkNPTkZJR19GV19M
T0FERVI9eQojIENPTkZJR19GSVJNV0FSRV9JTl9LRVJORUwgaXMgbm90IHNldApDT05GSUdfRVhU
UkFfRklSTVdBUkU9IiIKIyBDT05GSUdfREVCVUdfRFJJVkVSIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfREVWUkVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTX0hZUEVSVklTT1IgaXMgbm90IHNl
dAojIENPTkZJR19DT05ORUNUT1IgaXMgbm90IHNldAojIENPTkZJR19NVEQgaXMgbm90IHNldAoj
IENPTkZJR19QQVJQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfUE5QIGlzIG5vdCBzZXQKQ09ORklH
X0JMS19ERVY9eQojIENPTkZJR19CTEtfREVWX0ZEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RF
Vl9YRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19DUFFfREEgaXMgbm90IHNldAojIENPTkZJR19C
TEtfQ1BRX0NJU1NfREEgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RBQzk2MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JMS19ERVZfVU1FTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQ09X
X0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfTE9PUCBpcyBub3Qgc2V0CgojCiMg
RFJCRCBkaXNhYmxlZCBiZWNhdXNlIFBST0NfRlMsIElORVQgb3IgQ09OTkVDVE9SIG5vdCBzZWxl
Y3RlZAojCiMgQ09ORklHX0JMS19ERVZfTkJEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9T
WDggaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9SQU09eQpDT05GSUdfQkxLX0RFVl9SQU1fQ09V
TlQ9NApDT05GSUdfQkxLX0RFVl9SQU1fU0laRT0yMDQ4CiMgQ09ORklHX0JMS19ERVZfWElQIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ0RST01fUEtUQ0RWRCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQV9P
VkVSX0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSEQgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX1JCRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTElTM0xWMDJEIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUlTQ19ERVZJQ0VTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfSURFPXkK
IyBDT05GSUdfSURFIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIGRldmljZSBzdXBwb3J0CiMKQ09ORklH
X1NDU0lfTU9EPXkKIyBDT05GSUdfUkFJRF9BVFRSUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJPXkK
Q09ORklHX1NDU0lfRE1BPXkKQ09ORklHX1NDU0lfVEdUPXkKIyBDT05GSUdfU0NTSV9ORVRMSU5L
IGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfUFJPQ19GUz15CgojCiMgU0NTSSBzdXBwb3J0IHR5cGUg
KGRpc2ssIHRhcGUsIENELVJPTSkKIwpDT05GSUdfQkxLX0RFVl9TRD15CiMgQ09ORklHX0NIUl9E
RVZfU1QgaXMgbm90IHNldAojIENPTkZJR19DSFJfREVWX09TU1QgaXMgbm90IHNldApDT05GSUdf
QkxLX0RFVl9TUj15CiMgQ09ORklHX0JMS19ERVZfU1JfVkVORE9SIGlzIG5vdCBzZXQKQ09ORklH
X0NIUl9ERVZfU0c9eQojIENPTkZJR19DSFJfREVWX1NDSCBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
U0lfTVVMVElfTFVOIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9DT05TVEFOVFMgaXMgbm90IHNl
dApDT05GSUdfU0NTSV9MT0dHSU5HPXkKQ09ORklHX1NDU0lfU0NBTl9BU1lOQz15CgojCiMgU0NT
SSBUcmFuc3BvcnRzCiMKIyBDT05GSUdfU0NTSV9TUElfQVRUUlMgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX0ZDX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JU0NTSV9BVFRSUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfU0FTX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9T
QVNfTElCU0FTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TUlBfQVRUUlMgaXMgbm90IHNldAoj
IENPTkZJR19TQ1NJX0xPV0xFVkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9ESCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfT1NEX0lOSVRJQVRPUiBpcyBub3Qgc2V0CkNPTkZJR19BVEE9eQoj
IENPTkZJR19BVEFfTk9OU1RBTkRBUkQgaXMgbm90IHNldApDT05GSUdfQVRBX1ZFUkJPU0VfRVJS
T1I9eQpDT05GSUdfU0FUQV9QTVA9eQoKIwojIENvbnRyb2xsZXJzIHdpdGggbm9uLVNGRiBuYXRp
dmUgaW50ZXJmYWNlCiMKQ09ORklHX1NBVEFfQUhDST15CkNPTkZJR19TQVRBX0FIQ0lfUExBVEZP
Uk09eQojIENPTkZJR19TQVRBX0lOSUMxNjJYIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9BQ0FS
RF9BSENJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TSUwyNCBpcyBub3Qgc2V0CkNPTkZJR19B
VEFfU0ZGPXkKCiMKIyBTRkYgY29udHJvbGxlcnMgd2l0aCBjdXN0b20gRE1BIGludGVyZmFjZQoj
CiMgQ09ORklHX1BEQ19BRE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9RU1RPUiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NBVEFfU1g0IGlzIG5vdCBzZXQKQ09ORklHX0FUQV9CTURNQT15CgojCiMg
U0FUQSBTRkYgY29udHJvbGxlcnMgd2l0aCBCTURNQQojCkNPTkZJR19BVEFfUElJWD15CiMgQ09O
RklHX1NBVEFfTVYgaXMgbm90IHNldAojIENPTkZJR19TQVRBX05WIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0FUQV9QUk9NSVNFIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TSUwgaXMgbm90IHNldAoj
IENPTkZJR19TQVRBX1NJUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfU1ZXIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0FUQV9VTEkgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1ZJQSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NBVEFfVklURVNTRSBpcyBub3Qgc2V0CgojCiMgUEFUQSBTRkYgY29udHJvbGxl
cnMgd2l0aCBCTURNQQojCiMgQ09ORklHX1BBVEFfQUxJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFU
QV9BTUQgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0FSVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdf
UEFUQV9BVElJWFAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0FUUDg2N1ggaXMgbm90IHNldAoj
IENPTkZJR19QQVRBX0NNRDY0WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1NTIwIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFUQV9DUzU1MzAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NTNTUz
NSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1NTM2IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFU
QV9DWVBSRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9FRkFSIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9IUFQzNjYgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDM3WCBpcyBub3Qgc2V0
CiMgQ09ORklHX1BBVEFfSFBUM1gyTiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSFBUM1gzIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9JVDgyMTMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0lU
ODIxWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSk1JQ1JPTiBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBVEFfTUFSVkVMTCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTkVUQ0VMTCBpcyBub3Qgc2V0
CiMgQ09ORklHX1BBVEFfTklOSkEzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTlM4NzQxNSBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfT0xEUElJWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
T1BUSURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUERDMjAyN1ggaXMgbm90IHNldAojIENP
TkZJR19QQVRBX1BEQ19PTEQgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JBRElTWVMgaXMgbm90
IHNldAojIENPTkZJR19QQVRBX1JEQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0MxMjAwIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TQ0ggaXMgbm90IHNldAojIENPTkZJR19QQVRBX1NFUlZF
UldPUktTIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TSUw2ODAgaXMgbm90IHNldAojIENPTkZJ
R19QQVRBX1NJUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfVE9TSElCQSBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfVFJJRkxFWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfVklBIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUEFUQV9XSU5CT05EIGlzIG5vdCBzZXQKCiMKIyBQSU8tb25seSBTRkYgY29u
dHJvbGxlcnMKIwojIENPTkZJR19QQVRBX0NNRDY0MF9QQ0kgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX01QSUlYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9OUzg3NDEwIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9PUFRJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9QTEFURk9STSBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfUURJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9SWjEwMDAgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX1dJTkJPTkRfVkxCIGlzIG5vdCBzZXQKCiMKIyBHZW5lcmlj
IGZhbGxiYWNrIC8gbGVnYWN5IGRyaXZlcnMKIwpDT05GSUdfQVRBX0dFTkVSSUM9eQpDT05GSUdf
UEFUQV9MRUdBQ1k9eQojIENPTkZJR19NRCBpcyBub3Qgc2V0CiMgQ09ORklHX1RBUkdFVF9DT1JF
IGlzIG5vdCBzZXQKIyBDT05GSUdfRlVTSU9OIGlzIG5vdCBzZXQKCiMKIyBJRUVFIDEzOTQgKEZp
cmVXaXJlKSBzdXBwb3J0CiMKIyBDT05GSUdfRklSRVdJUkUgaXMgbm90IHNldAojIENPTkZJR19G
SVJFV0lSRV9OT1NZIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJPIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUFDSU5UT1NIX0RSSVZFUlMgaXMgbm90IHNldApDT05GSUdfTkVUREVWSUNFUz15CiMgQ09ORklH
X0RVTU1ZIGlzIG5vdCBzZXQKIyBDT05GSUdfQk9ORElORyBpcyBub3Qgc2V0CiMgQ09ORklHX01B
Q1ZMQU4gaXMgbm90IHNldAojIENPTkZJR19FUVVBTElaRVIgaXMgbm90IHNldAojIENPTkZJR19U
VU4gaXMgbm90IHNldAojIENPTkZJR19WRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDTkVUIGlz
IG5vdCBzZXQKQ09ORklHX01JST15CiMgQ09ORklHX1BIWUxJQiBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9FVEhFUk5FVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRERVZfMTAwMD15CiMgQ09ORklHX0FD
RU5JQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RMMksgaXMgbm90IHNldApDT05GSUdfRTEwMDA9eQpD
T05GSUdfRTEwMDBFPXkKIyBDT05GSUdfSVAxMDAwIGlzIG5vdCBzZXQKQ09ORklHX0lHQj15CkNP
TkZJR19JR0JWRj15CiMgQ09ORklHX05TODM4MjAgaXMgbm90IHNldAojIENPTkZJR19IQU1BQ0hJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfWUVMTE9XRklOIGlzIG5vdCBzZXQKIyBDT05GSUdfUjgxNjkg
aXMgbm90IHNldAojIENPTkZJR19TSVMxOTAgaXMgbm90IHNldAojIENPTkZJR19TS0dFIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0tZMiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJQV9WRUxPQ0lUWSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RJR09OMyBpcyBub3Qgc2V0CiMgQ09ORklHX0JOWDIgaXMgbm90IHNl
dAojIENPTkZJR19DTklDIGlzIG5vdCBzZXQKIyBDT05GSUdfUUxBM1hYWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUTDEgaXMgbm90IHNldAojIENPTkZJR19BVEwxRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0FUTDFDIGlzIG5vdCBzZXQKIyBDT05GSUdfSk1FIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RNTUFD
X0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSF9HQkUgaXMgbm90IHNldApDT05GSUdfTkVUREVW
XzEwMDAwPXkKQ09ORklHX01ESU89eQojIENPTkZJR19DSEVMU0lPX1QxIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0hFTFNJT19UMyBpcyBub3Qgc2V0CiMgQ09ORklHX0NIRUxTSU9fVDQgaXMgbm90IHNl
dAojIENPTkZJR19DSEVMU0lPX1Q0VkYgaXMgbm90IHNldAojIENPTkZJR19FTklDIGlzIG5vdCBz
ZXQKQ09ORklHX0lYR0JFPXkKQ09ORklHX0lYR0I9eQojIENPTkZJR19TMklPIGlzIG5vdCBzZXQK
IyBDT05GSUdfVlhHRSBpcyBub3Qgc2V0CiMgQ09ORklHX01ZUkkxMEdFIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUWEVOX05JQyBpcyBub3Qgc2V0CiMgQ09ORklHX05JVSBpcyBub3Qgc2V0CiMgQ09O
RklHX01MWDRfRU4gaXMgbm90IHNldAojIENPTkZJR19NTFg0X0NPUkUgaXMgbm90IHNldAojIENP
TkZJR19URUhVVEkgaXMgbm90IHNldAojIENPTkZJR19CTlgyWCBpcyBub3Qgc2V0CiMgQ09ORklH
X1FMQ05JQyBpcyBub3Qgc2V0CiMgQ09ORklHX1FMR0UgaXMgbm90IHNldAojIENPTkZJR19CTkEg
aXMgbm90IHNldAojIENPTkZJR19TRkMgaXMgbm90IHNldAojIENPTkZJR19CRTJORVQgaXMgbm90
IHNldAojIENPTkZJR19UUiBpcyBub3Qgc2V0CiMgQ09ORklHX1dMQU4gaXMgbm90IHNldAoKIwoj
IEVuYWJsZSBXaU1BWCAoTmV0d29ya2luZyBvcHRpb25zKSB0byBzZWUgdGhlIFdpTUFYIGRyaXZl
cnMKIwojIENPTkZJR19XQU4gaXMgbm90IHNldAoKIwojIENBSUYgdHJhbnNwb3J0IGRyaXZlcnMK
IwojIENPTkZJR19GRERJIGlzIG5vdCBzZXQKIyBDT05GSUdfSElQUEkgaXMgbm90IHNldAojIENP
TkZJR19QUFAgaXMgbm90IHNldAojIENPTkZJR19TTElQIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
X0ZDIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUQ09OU09MRSBpcyBub3Qgc2V0CiMgQ09ORklHX05F
VFBPTEwgaXMgbm90IHNldAojIENPTkZJR19ORVRfUE9MTF9DT05UUk9MTEVSIGlzIG5vdCBzZXQK
IyBDT05GSUdfVk1YTkVUMyBpcyBub3Qgc2V0CiMgQ09ORklHX0lTRE4gaXMgbm90IHNldAojIENP
TkZJR19QSE9ORSBpcyBub3Qgc2V0CgojCiMgSW5wdXQgZGV2aWNlIHN1cHBvcnQKIwpDT05GSUdf
SU5QVVQ9eQojIENPTkZJR19JTlBVVF9GRl9NRU1MRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfUE9MTERFViBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1NQQVJTRUtNQVAgaXMgbm90IHNl
dAoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwojIENPTkZJR19JTlBVVF9NT1VTRURFViBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOUFVUX0pPWURFViBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0VW
REVWIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfRVZCVUcgaXMgbm90IHNldAoKIwojIElucHV0
IERldmljZSBEcml2ZXJzCiMKIyBDT05GSUdfSU5QVVRfS0VZQk9BUkQgaXMgbm90IHNldAojIENP
TkZJR19JTlBVVF9NT1VTRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0pPWVNUSUNLIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5QVVRfVEFCTEVUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfVE9V
Q0hTQ1JFRU4gaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9NSVNDIGlzIG5vdCBzZXQKCiMKIyBI
YXJkd2FyZSBJL08gcG9ydHMKIwpDT05GSUdfU0VSSU89eQpDT05GSUdfU0VSSU9fSTgwNDI9eQpD
T05GSUdfU0VSSU9fU0VSUE9SVD15CiMgQ09ORklHX1NFUklPX0NUODJDNzEwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VSSU9fUENJUFMyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fTElCUFMyIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fUkFXIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fQUxU
RVJBX1BTMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklPX1BTMk1VTFQgaXMgbm90IHNldAojIENP
TkZJR19HQU1FUE9SVCBpcyBub3Qgc2V0CgojCiMgQ2hhcmFjdGVyIGRldmljZXMKIwpDT05GSUdf
VlQ9eQpDT05GSUdfQ09OU09MRV9UUkFOU0xBVElPTlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNP
TkZJR19IV19DT05TT0xFPXkKIyBDT05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HIGlzIG5vdCBz
ZXQKQ09ORklHX1VOSVg5OF9QVFlTPXkKIyBDT05GSUdfREVWUFRTX01VTFRJUExFX0lOU1RBTkNF
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0xFR0FDWV9QVFlTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VS
SUFMX05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9aT01JIGlzIG5vdCBzZXQKIyBD
T05GSUdfTl9HU00gaXMgbm90IHNldAojIENPTkZJR19UUkFDRV9TSU5LIGlzIG5vdCBzZXQKIyBD
T05GSUdfREVWS01FTSBpcyBub3Qgc2V0CgojCiMgU2VyaWFsIGRyaXZlcnMKIwpDT05GSUdfU0VS
SUFMXzgyNTA9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15CkNPTkZJR19GSVhfRUFSTFlD
T05fTUVNPXkKQ09ORklHX1NFUklBTF84MjUwX1BDST15CkNPTkZJR19TRVJJQUxfODI1MF9OUl9V
QVJUUz0zMgpDT05GSUdfU0VSSUFMXzgyNTBfUlVOVElNRV9VQVJUUz00CkNPTkZJR19TRVJJQUxf
ODI1MF9FWFRFTkRFRD15CkNPTkZJR19TRVJJQUxfODI1MF9NQU5ZX1BPUlRTPXkKIyBDT05GSUdf
U0VSSUFMXzgyNTBfRk9VUlBPUlQgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfODI1MF9BQ0NF
TlQgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfODI1MF9CT0NBIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VSSUFMXzgyNTBfRVhBUl9TVDE2QzU1NCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF84
MjUwX0hVQjYgaXMgbm90IHNldApDT05GSUdfU0VSSUFMXzgyNTBfU0hBUkVfSVJRPXkKQ09ORklH
X1NFUklBTF84MjUwX0RFVEVDVF9JUlE9eQpDT05GSUdfU0VSSUFMXzgyNTBfUlNBPXkKCiMKIyBO
b24tODI1MCBzZXJpYWwgcG9ydCBzdXBwb3J0CiMKIyBDT05GSUdfU0VSSUFMX01GRF9IU1UgaXMg
bm90IHNldApDT05GSUdfU0VSSUFMX0NPUkU9eQpDT05GSUdfU0VSSUFMX0NPUkVfQ09OU09MRT15
CiMgQ09ORklHX1NFUklBTF9KU00gaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfVElNQkVSREFM
RSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9BTFRFUkFfSlRBR1VBUlQgaXMgbm90IHNldAoj
IENPTkZJR19TRVJJQUxfQUxURVJBX1VBUlQgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfUENI
X1VBUlQgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfWElMSU5YX1BTX1VBUlQgaXMgbm90IHNl
dAojIENPTkZJR19UVFlfUFJJTlRLIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBNSV9IQU5ETEVSIGlz
IG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NIGlzIG5vdCBzZXQKIyBDT05GSUdfTlZSQU0gaXMg
bm90IHNldAojIENPTkZJR19SVEMgaXMgbm90IHNldAojIENPTkZJR19HRU5fUlRDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFRMSyBpcyBub3Qgc2V0CiMgQ09ORklHX1IzOTY0IGlzIG5vdCBzZXQKIyBD
T05GSUdfQVBQTElDT00gaXMgbm90IHNldAojIENPTkZJR19TT05ZUEkgaXMgbm90IHNldAojIENP
TkZJR19NV0FWRSBpcyBub3Qgc2V0CiMgQ09ORklHX1BDODczNnhfR1BJTyBpcyBub3Qgc2V0CiMg
Q09ORklHX05TQ19HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfUkFXX0RSSVZFUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0hBTkdDSEVDS19USU1FUiBpcyBub3Qgc2V0CiMgQ09ORklHX1RDR19UUE0gaXMg
bm90IHNldAojIENPTkZJR19URUxDTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19ERVZQT1JUPXkKIyBD
T05GSUdfUkFNT09QUyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NQSSBpcyBub3Qgc2V0CgojCiMgUFBTIHN1cHBvcnQKIwojIENPTkZJR19QUFMgaXMgbm90IHNl
dAoKIwojIFBQUyBnZW5lcmF0b3JzIHN1cHBvcnQKIwoKIwojIFBUUCBjbG9jayBzdXBwb3J0CiMK
CiMKIyBFbmFibGUgRGV2aWNlIERyaXZlcnMgLT4gUFBTIHRvIHNlZSB0aGUgUFRQIGNsb2NrIG9w
dGlvbnMuCiMKQ09ORklHX0FSQ0hfV0FOVF9PUFRJT05BTF9HUElPTElCPXkKIyBDT05GSUdfR1BJ
T0xJQiBpcyBub3Qgc2V0CiMgQ09ORklHX1cxIGlzIG5vdCBzZXQKIyBDT05GSUdfUE9XRVJfU1VQ
UExZIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdNT04gaXMgbm90IHNldAojIENPTkZJR19USEVSTUFM
IGlzIG5vdCBzZXQKIyBDT05GSUdfV0FUQ0hET0cgaXMgbm90IHNldApDT05GSUdfU1NCX1BPU1NJ
QkxFPXkKCiMKIyBTb25pY3MgU2lsaWNvbiBCYWNrcGxhbmUKIwojIENPTkZJR19TU0IgaXMgbm90
IHNldApDT05GSUdfQkNNQV9QT1NTSUJMRT15CgojCiMgQnJvYWRjb20gc3BlY2lmaWMgQU1CQQoj
CiMgQ09ORklHX0JDTUEgaXMgbm90IHNldAojIENPTkZJR19NRkRfU1VQUE9SVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JFR1VMQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX01FRElBX1NVUFBPUlQgaXMg
bm90IHNldAoKIwojIEdyYXBoaWNzIHN1cHBvcnQKIwojIENPTkZJR19BR1AgaXMgbm90IHNldApD
T05GSUdfVkdBX0FSQj15CkNPTkZJR19WR0FfQVJCX01BWF9HUFVTPTE2CiMgQ09ORklHX0RSTSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NUVUJfUE9VTFNCTyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZHQVNU
QVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fT1VUUFVUX0NPTlRST0wgaXMgbm90IHNldAoj
IENPTkZJR19GQiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9MQ0RfU1VQUE9SVCBpcyBu
b3Qgc2V0CgojCiMgRGlzcGxheSBkZXZpY2Ugc3VwcG9ydAojCiMgQ09ORklHX0RJU1BMQVlfU1VQ
UE9SVCBpcyBub3Qgc2V0CgojCiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09O
RklHX1ZHQV9DT05TT0xFPXkKQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9MTEJBQ0s9eQpDT05GSUdf
VkdBQ09OX1NPRlRfU0NST0xMQkFDS19TSVpFPTY0CiMgQ09ORklHX01EQV9DT05TT0xFIGlzIG5v
dCBzZXQKQ09ORklHX0RVTU1ZX0NPTlNPTEU9eQojIENPTkZJR19TT1VORCBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9TVVBQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NVUFBPUlQgaXMgbm90
IHNldAojIENPTkZJR19VV0IgaXMgbm90IHNldAojIENPTkZJR19NTUMgaXMgbm90IHNldAojIENP
TkZJR19NRU1TVElDSyBpcyBub3Qgc2V0CiMgQ09ORklHX05FV19MRURTIGlzIG5vdCBzZXQKIyBD
T05GSUdfQUNDRVNTSUJJTElUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lORklOSUJBTkQgaXMgbm90
IHNldAojIENPTkZJR19FREFDIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0NMQVNTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRE1BREVWSUNFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FVWERJU1BMQVkgaXMg
bm90IHNldAojIENPTkZJR19VSU8gaXMgbm90IHNldAoKIwojIFZpcnRpbyBkcml2ZXJzCiMKIyBD
T05GSUdfVklSVElPX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJUlRJT19CQUxMT09OIGlzIG5v
dCBzZXQKIyBDT05GSUdfU1RBR0lORyBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QTEFURk9STV9E
RVZJQ0VTIGlzIG5vdCBzZXQKQ09ORklHX0NMS1NSQ19JODI1Mz15CkNPTkZJR19DTEtFVlRfSTgy
NTM9eQpDT05GSUdfSTgyNTNfTE9DSz15CkNPTkZJR19DTEtCTERfSTgyNTM9eQpDT05GSUdfSU9N
TVVfU1VQUE9SVD15CiMgQ09ORklHX1ZJUlRfRFJJVkVSUyBpcyBub3Qgc2V0CgojCiMgRmlybXdh
cmUgRHJpdmVycwojCiMgQ09ORklHX0VERCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZJUk1XQVJFX01F
TU1BUCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFTExfUkJVIGlzIG5vdCBzZXQKIyBDT05GSUdfRENE
QkFTIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1JSUQgaXMgbm90IHNldAojIENPTkZJR19ETUlfU1lT
RlMgaXMgbm90IHNldAojIENPTkZJR19JU0NTSV9JQkZUX0ZJTkQgaXMgbm90IHNldAojIENPTkZJ
R19HT09HTEVfRklSTVdBUkUgaXMgbm90IHNldAoKIwojIEZpbGUgc3lzdGVtcwojCiMgQ09ORklH
X0VYVDJfRlMgaXMgbm90IHNldAojIENPTkZJR19FWFQzX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0VY
VDRfRlM9eQpDT05GSUdfRVhUNF9VU0VfRk9SX0VYVDIzPXkKQ09ORklHX0VYVDRfRlNfWEFUVFI9
eQpDT05GSUdfRVhUNF9GU19QT1NJWF9BQ0w9eQpDT05GSUdfRVhUNF9GU19TRUNVUklUWT15CiMg
Q09ORklHX0VYVDRfREVCVUcgaXMgbm90IHNldApDT05GSUdfSkJEMj15CkNPTkZJR19GU19NQkNB
Q0hFPXkKIyBDT05GSUdfUkVJU0VSRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19KRlNfRlMgaXMg
bm90IHNldAojIENPTkZJR19YRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19CVFJGU19GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX05JTEZTMl9GUyBpcyBub3Qgc2V0CkNPTkZJR19GU19QT1NJWF9BQ0w9
eQpDT05GSUdfRklMRV9MT0NLSU5HPXkKIyBDT05GSUdfRlNOT1RJRlkgaXMgbm90IHNldAojIENP
TkZJR19ETk9USUZZIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5PVElGWV9VU0VSIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkFOT1RJRlkgaXMgbm90IHNldAojIENPTkZJR19RVU9UQSBpcyBub3Qgc2V0CiMg
Q09ORklHX1FVT1RBQ1RMIGlzIG5vdCBzZXQKIyBDT05GSUdfQVVUT0ZTNF9GUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZVU0VfRlMgaXMgbm90IHNldApDT05GSUdfR0VORVJJQ19BQ0w9eQoKIwojIENh
Y2hlcwojCiMgQ09ORklHX0ZTQ0FDSEUgaXMgbm90IHNldAoKIwojIENELVJPTS9EVkQgRmlsZXN5
c3RlbXMKIwojIENPTkZJR19JU085NjYwX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVURGX0ZTIGlz
IG5vdCBzZXQKCiMKIyBET1MvRkFUL05UIEZpbGVzeXN0ZW1zCiMKIyBDT05GSUdfTVNET1NfRlMg
aXMgbm90IHNldAojIENPTkZJR19WRkFUX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTlRGU19GUyBp
cyBub3Qgc2V0CgojCiMgUHNldWRvIGZpbGVzeXN0ZW1zCiMKQ09ORklHX1BST0NfRlM9eQojIENP
TkZJR19QUk9DX0tDT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPQ19WTUNPUkUgaXMgbm90IHNl
dApDT05GSUdfUFJPQ19TWVNDVEw9eQpDT05GSUdfUFJPQ19QQUdFX01PTklUT1I9eQpDT05GSUdf
U1lTRlM9eQpDT05GSUdfVE1QRlM9eQpDT05GSUdfVE1QRlNfUE9TSVhfQUNMPXkKQ09ORklHX1RN
UEZTX1hBVFRSPXkKIyBDT05GSUdfSFVHRVRMQkZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFVHRVRM
Ql9QQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09ORklHRlNfRlMgaXMgbm90IHNldAojIENPTkZJ
R19NSVNDX0ZJTEVTWVNURU1TIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUV09SS19GSUxFU1lTVEVN
UyBpcyBub3Qgc2V0CgojCiMgUGFydGl0aW9uIFR5cGVzCiMKIyBDT05GSUdfUEFSVElUSU9OX0FE
VkFOQ0VEIGlzIG5vdCBzZXQKQ09ORklHX01TRE9TX1BBUlRJVElPTj15CkNPTkZJR19OTFM9eQpD
T05GSUdfTkxTX0RFRkFVTFQ9Imlzbzg4NTktMSIKIyBDT05GSUdfTkxTX0NPREVQQUdFXzQzNyBp
cyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV83MzcgaXMgbm90IHNldAojIENPTkZJR19O
TFNfQ09ERVBBR0VfNzc1IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTIgaXMgbm90IHNldAojIENPTkZJR19OTFNf
Q09ERVBBR0VfODU1IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NyBpcyBub3Qg
c2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09E
RVBBR0VfODYxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MiBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjMgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBB
R0VfODY0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NSBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV84NjYgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODY5IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzkzNiBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV85NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTMy
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzk0OSBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV84NzQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV84IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzEyNTAgaXMgbm90IHNldAojIENPTkZJR19OTFNf
Q09ERVBBR0VfMTI1MSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19BU0NJSSBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19JU084ODU5XzEgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8yIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19J
U084ODU5XzQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV81IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX0lTTzg4NTlfNiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzcgaXMg
bm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV85IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lT
Tzg4NTlfMTMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8xNCBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19JU084ODU5XzE1IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0tPSThfUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19LT0k4X1UgaXMgbm90IHNldAojIENPTkZJR19OTFNfVVRGOCBp
cyBub3Qgc2V0CgojCiMgS2VybmVsIGhhY2tpbmcKIwpDT05GSUdfVFJBQ0VfSVJRRkxBR1NfU1VQ
UE9SVD15CiMgQ09ORklHX1BSSU5US19USU1FIGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfTUVT
U0FHRV9MT0dMRVZFTD00CkNPTkZJR19FTkFCTEVfV0FSTl9ERVBSRUNBVEVEPXkKQ09ORklHX0VO
QUJMRV9NVVNUX0NIRUNLPXkKQ09ORklHX0ZSQU1FX1dBUk49MjA0OApDT05GSUdfTUFHSUNfU1lT
UlE9eQpDT05GSUdfU1RSSVBfQVNNX1NZTVM9eQojIENPTkZJR19VTlVTRURfU1lNQk9MUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFQlVHX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0hFQURFUlNfQ0hFQ0s9
eQpDT05GSUdfREVCVUdfU0VDVElPTl9NSVNNQVRDSD15CkNPTkZJR19ERUJVR19LRVJORUw9eQpD
T05GSUdfREVCVUdfU0hJUlE9eQpDT05GSUdfTE9DS1VQX0RFVEVDVE9SPXkKQ09ORklHX0hBUkRM
T0NLVVBfREVURUNUT1I9eQpDT05GSUdfQk9PVFBBUkFNX0hBUkRMT0NLVVBfUEFOSUM9eQpDT05G
SUdfQk9PVFBBUkFNX0hBUkRMT0NLVVBfUEFOSUNfVkFMVUU9MQpDT05GSUdfQk9PVFBBUkFNX1NP
RlRMT0NLVVBfUEFOSUM9eQpDT05GSUdfQk9PVFBBUkFNX1NPRlRMT0NLVVBfUEFOSUNfVkFMVUU9
MQpDT05GSUdfREVURUNUX0hVTkdfVEFTSz15CkNPTkZJR19ERUZBVUxUX0hVTkdfVEFTS19USU1F
T1VUPTEyMAojIENPTkZJR19CT09UUEFSQU1fSFVOR19UQVNLX1BBTklDIGlzIG5vdCBzZXQKQ09O
RklHX0JPT1RQQVJBTV9IVU5HX1RBU0tfUEFOSUNfVkFMVUU9MAojIENPTkZJR19TQ0hFRF9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDSEVEU1RBVFMgaXMgbm90IHNldAojIENPTkZJR19USU1F
Ul9TVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX09CSkVDVFMgaXMgbm90IHNldAojIENP
TkZJR19TTFVCX1NUQVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfS01FTUxFQUsgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19SVF9NVVRFWEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRfTVVU
RVhfVEVTVEVSIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX1NQSU5MT0NLPXkKIyBDT05GSUdfREVC
VUdfTVVURVhFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tfQUxMT0MgaXMgbm90IHNl
dAojIENPTkZJR19QUk9WRV9MT0NLSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BBUlNFX1JDVV9Q
T0lOVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9DS19TVEFUIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfQVRPTUlDX1NMRUVQIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTE9DS0lOR19BUElf
U0VMRlRFU1RTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU1RBQ0tfVVNBR0UgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfSElHSE1F
TSBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19CVUdWRVJCT1NFPXkKQ09ORklHX0RFQlVHX0lORk89
eQojIENPTkZJR19ERUJVR19JTkZPX1JFRFVDRUQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19W
TSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZJUlRVQUwgaXMgbm90IHNldAojIENPTkZJR19E
RUJVR19XUklURUNPVU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTUVNT1JZX0lOSVQgaXMg
bm90IHNldAojIENPTkZJR19ERUJVR19MSVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9MSVNU
X1NPUlQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX05PVElGSUVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0NSRURFTlRJQUxTIGlzIG5v
dCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9GUkFNRV9QT0lOVEVSUz15CkNPTkZJR19GUkFNRV9QT0lO
VEVSPXkKIyBDT05GSUdfQk9PVF9QUklOVEtfREVMQVkgaXMgbm90IHNldAojIENPTkZJR19SQ1Vf
VE9SVFVSRV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS1RSQUNFX1NFTEZfVEVTVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFQlVHX0JMT0NLX0VYVF9ERVZUIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfRk9SQ0VfV0VBS19QRVJfQ1BVIGlzIG5vdCBzZXQKIyBDT05GSUdfRkFVTFRfSU5KRUNU
SU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTEFURU5DWVRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZ
U0NUTF9TWVNDQUxMX0NIRUNLIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX1BBR0VBTExPQz15CkNP
TkZJR19VU0VSX1NUQUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNF
Uj15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX0dSQVBIX1RSQUNFUj15CkNPTkZJR19IQVZFX0ZVTkNU
SU9OX0dSQVBIX0ZQX1RFU1Q9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9UUkFDRV9NQ09VTlRfVEVT
VD15CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRSQUNFPXkKQ09ORklHX0hBVkVfRlRSQUNFX01DT1VO
VF9SRUNPUkQ9eQpDT05GSUdfSEFWRV9TWVNDQUxMX1RSQUNFUE9JTlRTPXkKQ09ORklHX0hBVkVf
Q19SRUNPUkRNQ09VTlQ9eQpDT05GSUdfVFJBQ0lOR19TVVBQT1JUPXkKIyBDT05GSUdfRlRSQUNF
IGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPVklERV9PSENJMTM5NF9ETUFfSU5JVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0JVSUxEX0RPQ1NSQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNQV9BUElfREVCVUcg
aXMgbm90IHNldAojIENPTkZJR19BVE9NSUM2NF9TRUxGVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NBTVBMRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tHREI9eQojIENPTkZJR19LR0RC
IGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LTUVNQ0hFQ0s9eQojIENPTkZJR19LTUVNQ0hF
Q0sgaXMgbm90IHNldAojIENPTkZJR19URVNUX0tTVFJUT1ggaXMgbm90IHNldAojIENPTkZJR19T
VFJJQ1RfREVWTUVNIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9WRVJCT1NFX0JPT1RVUD15CkNPTkZJ
R19FQVJMWV9QUklOVEs9eQojIENPTkZJR19FQVJMWV9QUklOVEtfREJHUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFQlVHX1NUQUNLT1ZFUkZMT1cgaXMgbm90IHNldAojIENPTkZJR19YODZfUFREVU1Q
IGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX1JPREFUQT15CkNPTkZJR19ERUJVR19ST0RBVEFfVEVT
VD15CkNPTkZJR19ET1VCTEVGQVVMVD15CiMgQ09ORklHX0lPTU1VX1NUUkVTUyBpcyBub3Qgc2V0
CkNPTkZJR19IQVZFX01NSU9UUkFDRV9TVVBQT1JUPXkKQ09ORklHX0lPX0RFTEFZX1RZUEVfMFg4
MD0wCkNPTkZJR19JT19ERUxBWV9UWVBFXzBYRUQ9MQpDT05GSUdfSU9fREVMQVlfVFlQRV9VREVM
QVk9MgpDT05GSUdfSU9fREVMQVlfVFlQRV9OT05FPTMKQ09ORklHX0lPX0RFTEFZXzBYODA9eQoj
IENPTkZJR19JT19ERUxBWV8wWEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9fREVMQVlfVURFTEFZ
IGlzIG5vdCBzZXQKIyBDT05GSUdfSU9fREVMQVlfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19ERUZB
VUxUX0lPX0RFTEFZX1RZUEU9MAojIENPTkZJR19DUEFfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19PUFRJTUlaRV9JTkxJTklORyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NUUklDVF9VU0VS
X0NPUFlfQ0hFQ0tTIGlzIG5vdCBzZXQKCiMKIyBTZWN1cml0eSBvcHRpb25zCiMKIyBDT05GSUdf
S0VZUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZX0RNRVNHX1JFU1RSSUNUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VDVVJJVFkgaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWUZTIGlzIG5v
dCBzZXQKQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfREFDPXkKQ09ORklHX0RFRkFVTFRfU0VDVVJJ
VFk9IiIKIyBDT05GSUdfQ1JZUFRPIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfS1ZNPXkKIyBDT05G
SUdfVklSVFVBTElaQVRJT04gaXMgbm90IHNldAojIENPTkZJR19CSU5BUllfUFJJTlRGIGlzIG5v
dCBzZXQKCiMKIyBMaWJyYXJ5IHJvdXRpbmVzCiMKQ09ORklHX0JJVFJFVkVSU0U9eQpDT05GSUdf
R0VORVJJQ19GSU5EX0ZJUlNUX0JJVD15CiMgQ09ORklHX0NSQ19DQ0lUVCBpcyBub3Qgc2V0CkNP
TkZJR19DUkMxNj15CiMgQ09ORklHX0NSQ19UMTBESUYgaXMgbm90IHNldAojIENPTkZJR19DUkNf
SVRVX1QgaXMgbm90IHNldApDT05GSUdfQ1JDMzI9eQojIENPTkZJR19DUkM3IGlzIG5vdCBzZXQK
IyBDT05GSUdfTElCQ1JDMzJDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JDOCBpcyBub3Qgc2V0CkNP
TkZJR19aTElCX0lORkxBVEU9eQojIENPTkZJR19YWl9ERUMgaXMgbm90IHNldAojIENPTkZJR19Y
Wl9ERUNfQkNKIGlzIG5vdCBzZXQKQ09ORklHX0RFQ09NUFJFU1NfR1pJUD15CkNPTkZJR19IQVNf
SU9NRU09eQpDT05GSUdfSEFTX0lPUE9SVD15CkNPTkZJR19IQVNfRE1BPXkKQ09ORklHX05MQVRU
Uj15CiMgQ09ORklHX0FWRVJBR0UgaXMgbm90IHNldAojIENPTkZJR19DT1JESUMgaXMgbm90IHNl
dAo=
--0016e64c145ec3dde704adf46a09--
