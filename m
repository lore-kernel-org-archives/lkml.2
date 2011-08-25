Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1HYBit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 21:38:49 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63470 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1HYBir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 21:38:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
References: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
Date: Wed, 24 Aug 2011 21:38:46 -0400
Message-ID: <CACqU3MXy6vyeLeTbZ+8OXfMowO2j0avSy6XgYJQ-C9N9YyU3GQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 24
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd32f3a6a807d04ab4a7df1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd32f3a6a807d04ab4a7df1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 24, 2011 at 2:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wr=
ote:
> Hi all,
>
> The powerpc allyesconfig build still fails today.
>
> Changes since 20110823:
>
> New tree: kvmtool
>
> The security tree lost its build failure.
>
> The ptrace tree gained a build failure (yeaterday) for which I have
> reveretd a commit.
>
> The tty tree gained a build failure so I used the version from
> next-20110823.
>
> The staging tree gained a conflict against the fbdev tree and a build
> failure for which I reverted a commit.
>
> The moduleh tree gained a conflict against the staging tree.
>
Quickly testing a new configuration blows up on the following:

console [ttyS0] enabled
Fast TSC calibration failed
TSC: Unable to calibrate against PIT
TSC: No reference (HPET/PMTIMER) available
Marking TSC unstable due to could not calculate TSC khz
Calibrating delay loop... 154.88 BogoMIPS (lpj=3D77440)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Intel QEMU Virtual CPU version 0.13.0 stepping 03
BUG: unable to handle kernel paging request at 827bf688
IP: [<c13945e2>] apply_alternatives+0xc3/0x18a
*pde =3D 00000000
Oops: 0000 [#1] DEBUG_PAGEALLOC

Pid: 0, comm: swapper Not tainted 3.1.0-rc3-next-20110824+ #5 Bochs Bochs
EIP: 0060:[<c13945e2>] EFLAGS: 00000286 CPU: 0
EIP is at apply_alternatives+0xc3/0x18a
EAX: ffffffff EBX: c13df690 ECX: 00000005 EDX: 827bf688
ESI: 827bf688 EDI: c1367e9e EBP: c1367fa8 ESP: c1367e70
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=3Dc1366000 task=3Dc136c340 task.ti=3Dc1366000)
Stack:
 00000002 c137b700 c1142ac0 00000dc6 c1367e9e 8268a422 00000005 827bf688
 c13dffd8 c1367e05 05000086 f6890046 00f69000 c1367eb0 00000086 00000000
 00000046 c1367ec0 00000046 00000000 c1367edc c101f3cc 00000dd3 00000000
Call Trace:
 [<c1142ac0>] ? serial8250_start_tx+0xe0/0xe0
 [<c101f3cc>] ? console_unlock+0x10c/0x150
 [<c12ab669>] ? common_interrupt+0x29/0x30
 [<c1023c64>] ? irq_exit+0x54/0x90
 [<c1003a93>] ? do_IRQ+0x43/0xa0
 [<c12ab669>] ? common_interrupt+0x29/0x30
 [<c13954a8>] ? check_fpu+0xae/0xdc
 [<c13946c0>] alternative_instructions+0x17/0x32
 [<c1395567>] check_bugs+0x91/0x93
 [<c138f6bb>] start_kernel+0x28e/0x299
 [<c138f1b7>] ? loglevel+0x1a/0x1a
 [<c138f0b3>] i386_start_kernel+0xb3/0xbb
Code: ec fe ff ff 8d 0c 0b 89 8d dc fe ff ff 8d 54 13 04 8b bd d8 fe
ff ff 89 95 e4 fe ff ff 89 b5 e0 fe ff ff 8b 8d e0 fe ff ff 89 d6 <f3>
a4 80 bd f6 fe ff ff e8 75 17 80 bd ec fe ff ff 05 75 0e 89
EIP: [<c13945e2>] apply_alternatives+0xc3/0x18a SS:ESP 0068:c1367e70
CR2: 00000000827bf688
---[ end trace 4eaa2a86a8e2da22 ]---

.config attached. I'll try to bisect it.

 - Arnaud

> -------------------------------------------------------------------------=
---
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ). =A0If yo=
u
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one. =A0You should use "git fetch" as mentioned in the FAQ on the wik=
i
> (see below).
>
> You can see which trees have been included by looking in the Next/Trees
> file in the source. =A0There are also quilt-import.log and merge.log file=
s
> in the Next directory. =A0Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
> and sparc64 defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
>
> Below is a summary of the state of the merge.
>
> We are up to 199 trees (counting Linus' and 28 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do=
.
>
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next . =A0If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
>
> Thanks to Randy Dunlap for doing many randconfig builds.
>
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ . =A0Thanks to Frank Seidel.
>
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auug.org=
.au
>
> $ git checkout master
> $ git reset --hard stable
> Merging origin/master
> Merging fixes/fixes
> Merging kbuild-current/rc-fixes
> Merging arm-current/master
> Merging m68k-current/for-linus
> Merging powerpc-merge/merge
> Merging 52xx-and-virtex-current/powerpc/merge
> Merging sparc-current/master
> Merging scsi-rc-fixes/master
> Merging net-current/master
> Merging sound-current/for-linus
> Merging pci-current/for-linus
> Merging wireless-current/master
> Merging driver-core.current/driver-core-linus
> Merging tty.current/tty-linus
> Merging usb.current/usb-linus
> Merging staging.current/staging-linus
> Merging cpufreq-current/fixes
> Merging input-current/for-linus
> Merging md-current/for-linus
> Merging audit-current/for-linus
> Merging crypto-current/master
> Merging ide-curent/master
> Merging dwmw2/master
> Merging sh-current/sh-fixes-for-linus
> Merging rmobile-current/rmobile-fixes-for-linus
> Merging fbdev-current/fbdev-fixes-for-linus
> Merging devicetree-current/devicetree/merge
> Merging spi-current/spi/merge
> Merging arm/for-next
> Merging arm-lpae/for-next
> CONFLICT (content): Merge conflict in arch/arm/include/asm/pgalloc.h
> CONFLICT (content): Merge conflict in arch/arm/include/asm/pgtable.h
> CONFLICT (content): Merge conflict in arch/arm/include/asm/tlb.h
> Merging arm-soc/for-next
> Merging at91/at91-next
> Merging davinci/davinci-next
> Merging i.MX/for-next
> Merging linux-spec/for-next
> Merging msm/for-next
> CONFLICT (content): Merge conflict in arch/arm/mach-msm/io.c
> Merging omap/for-next
> Merging pxa/for-next
> Merging samsung/next-samsung
> Merging s5p/for-next
> Merging tegra/for-next
> Merging ux500-core/ux500-core
> Merging xilinx/arm-next
> Merging blackfin/for-linus
> Merging cris/for-next
> Merging ia64/test
> Merging m68k/for-next
> Merging m68knommu/for-next
> Merging microblaze/next
> Merging mips/mips-for-linux-next
> Merging openrisc/for-upstream
> Merging parisc/for-next
> Merging powerpc/next
> Merging 4xx/next
> Merging 52xx-and-virtex/powerpc/next
> Merging galak/next
> Merging s390/features
> Merging sh/sh-latest
> Merging rmobile/rmobile-latest
> Merging sparc/master
> Merging tile/master
> Merging unicore32/unicore32
> Merging xtensa/master
> Merging ceph/for-next
> Merging cifs/master
> Merging configfs/linux-next
> Merging ecryptfs/next
> Merging ext3/for_next
> Merging ext4/dev
> Merging fatfs/master
> Merging fuse/for-next
> Merging gfs2/master
> Merging hfsplus/for-next
> Merging jfs/next
> Merging logfs/master
> Merging nfs/linux-next
> Merging nfsd/nfsd-next
> Merging nilfs2/for-next
> Merging ocfs2/linux-next
> Merging omfs/for-next
> Merging squashfs/master
> Merging udf/for_next
> Merging v9fs/for-next
> Merging ubifs/linux-next
> Merging xfs/master
> Merging vfs/for-next
> Merging vfs-scale/vfs-scale-working
> Merging pci/linux-next
> Merging hid/for-next
> Merging quilt/i2c
> Merging bjdooks-i2c/next-i2c
> Merging quilt/jdelvare-hwmon
> Merging hwmon-staging/hwmon-next
> Merging quilt/kernel-doc
> Merging docs/docs-move
> Merging v4l-dvb/master
> Merging kbuild/for-next
> Merging kconfig/for-next
> Merging ide/master
> Merging libata/NEXT
> Merging infiniband/for-next
> Merging acpi/test
> Merging idle-test/idle-test
> Merging powertools/tools-test
> Merging cpupowerutils/master
> Merging ieee1394/for-next
> Merging ubi/linux-next
> Merging dlm/next
> Merging swiotlb/master
> Merging ibft/master
> Merging scsi/master
> Merging iscsi-target/for-next
> Merging slave-dma/next
> Merging async_tx/next
> Merging net/master
> CONFLICT (delete/modify): arch/powerpc/configs/40x/hcu4_defconfig deleted=
 in HEAD and modified in net/master. Version net/master of arch/powerpc/con=
figs/40x/hcu4_defconfig left in tree.
> CONFLICT (content): Merge conflict in drivers/net/Kconfig
> CONFLICT (content): Merge conflict in drivers/net/Makefile
> $ git rm -f arch/powerpc/configs/40x/hcu4_defconfig
> Applying: powerpc: update ppc64_defconfig for net device movement
> Applying: sparc: update sparc32_defconfig for net device movement
> Applying: sparc: update sparc64_defconfig for net device movement
> Merging wireless/master
> Merging bluetooth/master
> Merging mtd/master
> Merging l2-mtd/master
> CONFLICT (content): Merge conflict in drivers/mtd/maps/lantiq-flash.c
> Merging crypto/master
> Merging sound/for-next
> Merging sound-asoc/for-next
> Merging cpufreq/next
> Merging quilt/rr
> Merging input/next
> Merging input-mt/next
> Merging lsm/for-next
> Merging block/for-next
> Merging quilt/device-mapper
> Merging embedded/master
> Merging firmware/master
> Merging pcmcia/master
> Merging battery/master
> Merging leds/for-mm
> CONFLICT (content): Merge conflict in drivers/leds/Kconfig
> Merging backlight/for-mm
> Merging mmc/mmc-next
> Merging kgdb/kgdb-next
> Merging slab/for-next
> Merging uclinux/for-next
> Merging md/for-next
> Merging mfd/for-next
> Merging hdlc/hdlc-next
> Merging drm/drm-next
> Merging fbdev/master
> Merging viafb/viafb-next
> Merging omap_dss2/for-next
> Merging voltage/for-next
> Merging security/next
> CONFLICT (content): Merge conflict in fs/ocfs2/xattr.c
> Merging selinux/master
> Merging lblnet/master
> Merging agp/agp-next
> Merging watchdog/master
> Merging bdev/master
> Merging dwmw2-iommu/master
> Merging cputime/cputime
> Merging osd/linux-next
> Merging jc_docs/docs-next
> Merging nommu/master
> Merging trivial/for-next
> Merging audit/for-next
> Merging pm/linux-next
> CONFLICT (content): Merge conflict in arch/s390/include/asm/thread_info.h
> CONFLICT (content): Merge conflict in drivers/mfd/twl4030-irq.c
> Merging apm/for-next
> Merging fsnotify/for-next
> Merging irda/for-next
> Merging i7core_edac/linux_next
> Merging i7300_edac/linux_next
> CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
> Merging devicetree/devicetree/next
> CONFLICT (content): Merge conflict in drivers/of/base.c
> Merging spi/spi/next
> Merging gpio/gpio/next
> Merging tip/auto-latest
> CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
> Merging rcu/rcu/next
> Merging kvm/linux-next
> Merging oprofile/for-next
> Merging ptrace/ptrace
> [master 12688b4] Revert "signal: Add block_sigmask() for adding sigmask t=
o current->blocked"
> Merging xen/upstream/xen
> Merging xen-two/linux-next
> Merging xen-pvhvm/linux-next
> Merging edac-amd/for-next
> Merging percpu/for-next
> Merging workqueues/for-next
> Merging sfi/sfi-test
> Merging asm-generic/next
> Merging drivers-x86/linux-next
> Merging hwpoison/hwpoison
> Merging sysctl/master
> Merging namespace/master
> Merging regmap/for-next
> Merging driver-core/driver-core-next
> Merging tty/tty-next
> $ git reset --hard HEAD^
> Merging refs/next/20110823/tty
> Merging usb/usb-next
> Applying: usb: include module.h in the DesignWare USB3 DRD driver
> Merging staging/staging-next
> CONFLICT (content): Merge conflict in drivers/staging/xgifb/XGI_main_26.c
> Merging bkl-config/config
> Merging tmem/linux-next
> Merging writeback/next
> Merging arm-dt/devicetree/arm-next
> Merging moduleh/module.h-split
> CONFLICT (content): Merge conflict in drivers/staging/iio/accel/adis16220=
_core.c
> CONFLICT (content): Merge conflict in include/linux/dmaengine.h
> Applying: dm: use export.h instead of module.h where possible
> Applying: block: bsg-lib.c needs export.h not module.h
> Applying: PM: EXPORT_SYMBOL needs export.h
> Merging kvmtool/master
> CONFLICT (content): Merge conflict in include/net/9p/9p.h
> Merging scsi-post-merge/merge-base:master
> $ git checkout akpm
> Applying: Expand root=3DPARTUUID=3DUUID syntax to support selecting a roo=
t partition by
> Applying: This patch makes two changes:
> Applying: On thread exit shm_exit_ns() is called, it uses shm_ids(ns).rw_=
mutex. =A0It
> Applying: Because of x86-implement-strict-user-copy-checks-for-x86_64.pat=
ch
> Applying: When no floppy is found the module code can be released while a=
 timer
> Applying: The parameter's origin type is long. =A0On an i386 architecture=
, it can
> Applying: Add support for Aspire 1410 BIOS v1.3314. =A0Fixes the followin=
g error:
> Applying: This makes the iris driver use the platform API, so it is prope=
rly exposed
> Applying: On x86_32 casting the unsigned int result of get_random_int() t=
o long may
> Applying: This new driver replaces the old PCEngines Alix 2/3 LED driver =
with a new
> Applying: Cc: Ed Wildgoose <git@wildgooses.com>
> Applying: Replace the bubble sort in sanitize_e820_map() with a call to t=
he generic
> Applying: The x86 timer interrupt handler is the only handler not traced =
in the
> Applying: The current interrupt traces from irq_handler_entry and irq_han=
dler_exit
> Applying: Don't allow everybody to use a modem.
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: A call to va_copy() should always be followed by a call to va_e=
nd() in the
> Applying: Don't dereference em if it's NULL or an error pointer.
> Applying: Some messing with error codes to return 0 on out id's and match
> Applying: fb_set_suspend() must be called with the console semaphore held=
, which
> Applying: hwmon was using an idr with a NULL pointer, so convert to an
> Applying: A straightforward looking use of idr for a device id.
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: Add new check (assert_init) to make sure objects are initialize=
d and
> Applying: del_timer_sync() calls debug_object_assert_init() to assert tha=
t a timer
> Applying: ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit=
_le() for
> Applying: The dqc_bitmap field of struct ocfs2_local_disk_chunk is 32-bit=
 aligned,
> Applying: The address limit is already set in flush_old_exec() so those c=
alls to
> Applying: When do pci remove/rescan on system that have more iommus, got
> Applying: The current implementation of dmi_name_in_vendors() is an invit=
ation to
> Applying: For headers that get exported to userland and make use of u32 s=
tyle
> Applying: Fix sparse warnings of right shift bigger than source value siz=
e:
> Applying: We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb() =
:
> Applying: Some mangling of errors was necessary to maintain current inter=
face.
> Applying: This does involve additional use of the spin lock in idr.c. =A0=
Is this an
> Applying: Instead of open coding this function use kstrtoul_from_user() d=
irectly.
> Applying: brd_make_request() always returns 0, which doesn't make much se=
nse.
> Applying: The address limit is already set in flush_old_exec() so this as=
signment of
> Applying: The basic idea behind cross memory attach is to allow MPI progr=
ams doing
> Applying: - Add x86_64 specific wire up
> Applying: acct_isolated of compaction uses page_lru_base_type which retur=
ns only
> Applying: Change ISOLATE_XXX macro with bitwise isolate_mode_t type. =A0N=
ormally,
> Applying: In async mode, compaction doesn't migrate dirty or writeback pa=
ges. =A0So,
> Applying: In __zone_reclaim case, we don't want to shrink mapped page. =
=A0Nonetheless,
> Applying: unmap_and_move() is one a big messy function. =A0Clean it up.
> Applying: radix_tree_tag_get()'s BUG (when it sees a tag after saw_unset_=
tag) was
> Applying: per-task block plug can reduce block queue lock contention and =
increase
> Applying: The tracing ring-buffer used this function briefly, but not any=
more.
> Applying: After selecting a task to kill, the oom killer iterates all pro=
cesses and
> Applying: Remove PageSwapBacked (!page_is_file_cache) cases from
> Applying: Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.c=
om>
> Applying: The current implementation of the /dev/hpet driver couples open=
ing the
> Applying: smp_call_function() only lets all other CPUs execute a specific=
 function,
> Applying: auto_demotion_disable is called only for online CPUs. =A0For ho=
tplugged
> Applying: Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following war=
ning:
> Applying: Strict user copy checks are only really supported on x86_32 eve=
n though
> Applying: The help text for this config is duplicated across the x86, par=
isc, and
> Applying: s/lib-/obj-/ for usercopy.o
> Applying: After an "unexpected" reboot, I found this Oops in my logs:
> Applying: In the move of the lis3 driver, the hp_accel.c file got dropped=
 from the
> Applying: Add axis correction for HP EliteBook 2730p.
> Applying: Add axis correction for HP EliteBook 8540w.
> Applying: Add axis correction for HP ProBook 6555b.
> Applying: Adapt the help text for CONFIG_HP_ACCEL to the move of
> Applying: Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> Applying: Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> Applying: Change exported functions to use the device given as parameter
> Applying: Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> Applying: Add V2 of the LED driver for a single timer channel for the TPU=
 hardware
> Applying: Add support for slice by 8 to existing crc32 algorithm. =A0Also=
 modify
> Applying: don't include asm/msr.h
> Applying: This is the one use of an ida that doesn't retry on receiving -=
EAGAIN.
> Applying: One can get this information from minix/inode.c, but adding the
> Applying: Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> Applying: Force this on for -next/mm testing purposes.
> Applying: Add a proc_dointvec_bool() sysctl handler for cases where the i=
nput value
> Applying: Use the new proc_do_intvec_bool() handler for various boolean i=
nputs.
> Applying: Add a proc_dointvec_unsigned() sysctl handler for positive valu=
e cases.
> Applying: Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Applying: Use the new proc_do_intvec_unsigned() handler for various unsig=
ned inputs.
> Applying: A default echo function has been provided so it is no longer an=
 error when
> Applying: This client driver allows you to use a GPIO pin as a source for=
 PPS
> Applying: remove unneeded cast of void*
> Applying: Straightforward. =A0As an aside, the ida_init calls are not nee=
ded as far as
> Merging akpm
> Applying: do_mounts: remove __init_data from root_wait
> [master 9cba48a] Revert "Staging: add driver for Realtek RTS5139 cardread=
er"
>

--000e0cd32f3a6a807d04ab4a7df1
Content-Type: application/octet-stream; name=".config"
Content-Disposition: attachment; filename=".config"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grr2cvw61

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
X1VOQ0FDSEVEPXkKQ09ORklHX0FSQ0hfUkFORE9NPXkKIyBDT05GSUdfU0VDQ09NUCBpcyBub3Qg
c2V0CiMgQ09ORklHX0NDX1NUQUNLUFJPVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMTAw
IGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMzAwIGlz
IG5vdCBzZXQKQ09ORklHX0haXzEwMDA9eQpDT05GSUdfSFo9MTAwMApDT05GSUdfU0NIRURfSFJU
SUNLPXkKIyBDT05GSUdfS0VYRUMgaXMgbm90IHNldApDT05GSUdfQ1JBU0hfRFVNUD15CkNPTkZJ
R19QSFlTSUNBTF9TVEFSVD0weDEwMDAwMDAKQ09ORklHX1JFTE9DQVRBQkxFPXkKQ09ORklHX1g4
Nl9ORUVEX1JFTE9DUz15CkNPTkZJR19QSFlTSUNBTF9BTElHTj0weDEwMDAwMDAKIyBDT05GSUdf
Q09NUEFUX1ZEU08gaXMgbm90IHNldAojIENPTkZJR19DTURMSU5FX0JPT0wgaXMgbm90IHNldApD
T05GSUdfQVJDSF9FTkFCTEVfTUVNT1JZX0hPVFBMVUc9eQoKIwojIFBvd2VyIG1hbmFnZW1lbnQg
YW5kIEFDUEkgb3B0aW9ucwojCiMgQ09ORklHX1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJR19Q
TV9SVU5USU1FIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NG
SSBpcyBub3Qgc2V0CgojCiMgQ1BVIEZyZXF1ZW5jeSBzY2FsaW5nCiMKIyBDT05GSUdfQ1BVX0ZS
RVEgaXMgbm90IHNldApDT05GSUdfQ1BVX0lETEU9eQpDT05GSUdfQ1BVX0lETEVfR09WX0xBRERF
Uj15CkNPTkZJR19DUFVfSURMRV9HT1ZfTUVOVT15CiMgQ09ORklHX0lOVEVMX0lETEUgaXMgbm90
IHNldAoKIwojIEJ1cyBvcHRpb25zIChQQ0kgZXRjLikKIwpDT05GSUdfUENJPXkKIyBDT05GSUdf
UENJX0dPQklPUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSV9HT01NQ09ORklHIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENJX0dPRElSRUNUIGlzIG5vdCBzZXQKQ09ORklHX1BDSV9HT0FOWT15CkNPTkZJ
R19QQ0lfQklPUz15CkNPTkZJR19QQ0lfRElSRUNUPXkKQ09ORklHX1BDSV9ET01BSU5TPXkKIyBD
T05GSUdfUENJX0NOQjIwTEVfUVVJUksgaXMgbm90IHNldAojIENPTkZJR19QQ0lFUE9SVEJVUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfU1VQUE9SVFNfTVNJIGlzIG5vdCBzZXQKIyBDT05GSUdf
UENJX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX1NUVUIgaXMgbm90IHNldAojIENPTkZJ
R19QQ0lfSU9WIGlzIG5vdCBzZXQKQ09ORklHX1BDSV9MQUJFTD15CkNPTkZJR19JU0FfRE1BX0FQ
ST15CkNPTkZJR19JU0E9eQpDT05GSUdfRUlTQT15CiMgQ09ORklHX0VJU0FfVkxCX1BSSU1JTkcg
aXMgbm90IHNldApDT05GSUdfRUlTQV9QQ0lfRUlTQT15CkNPTkZJR19FSVNBX1ZJUlRVQUxfUk9P
VD15CkNPTkZJR19FSVNBX05BTUVTPXkKIyBDT05GSUdfTUNBIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0N4MjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfT0xQQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FMSVgg
aXMgbm90IHNldApDT05GSUdfQU1EX05CPXkKIyBDT05GSUdfUENDQVJEIGlzIG5vdCBzZXQKIyBD
T05GSUdfSE9UUExVR19QQ0kgaXMgbm90IHNldAojIENPTkZJR19SQVBJRElPIGlzIG5vdCBzZXQK
CiMKIyBFeGVjdXRhYmxlIGZpbGUgZm9ybWF0cyAvIEVtdWxhdGlvbnMKIwpDT05GSUdfQklORk1U
X0VMRj15CkNPTkZJR19DT1JFX0RVTVBfREVGQVVMVF9FTEZfSEVBREVSUz15CkNPTkZJR19IQVZF
X0FPVVQ9eQojIENPTkZJR19CSU5GTVRfQU9VVCBpcyBub3Qgc2V0CiMgQ09ORklHX0JJTkZNVF9N
SVNDIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVRPTUlDX0lPTUFQPXkKQ09ORklHX0hBVkVfVEVY
VF9QT0tFX1NNUD15CkNPTkZJR19ORVQ9eQoKIwojIE5ldHdvcmtpbmcgb3B0aW9ucwojCkNPTkZJ
R19QQUNLRVQ9eQpDT05GSUdfVU5JWD15CiMgQ09ORklHX05FVF9LRVkgaXMgbm90IHNldApDT05G
SUdfSU5FVD15CiMgQ09ORklHX0lQX01VTFRJQ0FTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX0FE
VkFOQ0VEX1JPVVRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX1BOUCBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9JUElQIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0lQR1JFX0RFTVVYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJQRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZTl9DT09LSUVTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5FVF9BSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfRVNQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5FVF9JUENPTVAgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1hGUk1fVFVO
TkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19J
TkVUX1hGUk1fTU9ERV9UUkFOU1BPUlQgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1hGUk1fTU9E
RV9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUIGlzIG5vdCBz
ZXQKQ09ORklHX0lORVRfTFJPPXkKQ09ORklHX0lORVRfRElBRz15CkNPTkZJR19JTkVUX1RDUF9E
SUFHPXkKIyBDT05GSUdfVENQX0NPTkdfQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdfVENQX0NP
TkdfQ1VCSUM9eQpDT05GSUdfREVGQVVMVF9UQ1BfQ09ORz0iY3ViaWMiCiMgQ09ORklHX1RDUF9N
RDVTSUcgaXMgbm90IHNldApDT05GSUdfSVBWNj15CiMgQ09ORklHX0lQVjZfUFJJVkFDWSBpcyBu
b3Qgc2V0CkNPTkZJR19JUFY2X1JPVVRFUl9QUkVGPXkKQ09ORklHX0lQVjZfUk9VVEVfSU5GTz15
CiMgQ09ORklHX0lQVjZfT1BUSU1JU1RJQ19EQUQgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9B
SCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2X0VTUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2
X0lQQ09NUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfTUlQNiBpcyBub3Qgc2V0CiMgQ09ORklH
X0lORVQ2X1hGUk1fVFVOTkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVDZfVFVOTkVMIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1RSQU5TUE9SVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lORVQ2X1hGUk1fTU9ERV9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9YRlJN
X01PREVfQkVFVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9ST1VURU9QVElN
SVpBVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfU0lUIGlzIG5vdCBzZXQKIyBDT05GSUdf
SVBWNl9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JUFY2X01VTFRJUExFX1RBQkxFUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lQVjZfTVJPVVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUV09SS19T
RUNNQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUV09SS19QSFlfVElNRVNUQU1QSU5HIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVURklMVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfRENDUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lQX1NDVFAgaXMgbm90IHNldAojIENPTkZJR19SRFMgaXMgbm90IHNl
dAojIENPTkZJR19USVBDIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNIGlzIG5vdCBzZXQKIyBDT05G
SUdfTDJUUCBpcyBub3Qgc2V0CkNPTkZJR19TVFA9eQpDT05GSUdfQlJJREdFPXkKQ09ORklHX0JS
SURHRV9JR01QX1NOT09QSU5HPXkKIyBDT05GSUdfTkVUX0RTQSBpcyBub3Qgc2V0CiMgQ09ORklH
X1ZMQU5fODAyMVEgaXMgbm90IHNldAojIENPTkZJR19ERUNORVQgaXMgbm90IHNldApDT05GSUdf
TExDPXkKIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUQUxLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5vdCBzZXQKIyBDT05GSUdf
TEFQQiBpcyBub3Qgc2V0CiMgQ09ORklHX0VDT05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTl9S
T1VURVIgaXMgbm90IHNldAojIENPTkZJR19QSE9ORVQgaXMgbm90IHNldAojIENPTkZJR19JRUVF
ODAyMTU0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSEVEIGlzIG5vdCBzZXQKIyBDT05GSUdf
RENCIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUTUFOX0FEViBpcyBub3Qgc2V0CgojCiMgTmV0d29y
ayB0ZXN0aW5nCiMKIyBDT05GSUdfTkVUX1BLVEdFTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hBTVJB
RElPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJEQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JUIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZfUlhSUEMgaXMgbm90IHNl
dAojIENPTkZJR19XSVJFTEVTUyBpcyBub3Qgc2V0CiMgQ09ORklHX1dJTUFYIGlzIG5vdCBzZXQK
IyBDT05GSUdfUkZLSUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUXzlQIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0FJRiBpcyBub3Qgc2V0CiMgQ09ORklHX0NFUEhfTElCIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkZDIGlzIG5vdCBzZXQKCiMKIyBEZXZpY2UgRHJpdmVycwojCgojCiMgR2VuZXJpYyBEcml2
ZXIgT3B0aW9ucwojCkNPTkZJR19VRVZFTlRfSEVMUEVSX1BBVEg9Ii9zYmluL2hvdHBsdWciCkNP
TkZJR19ERVZUTVBGUz15CkNPTkZJR19ERVZUTVBGU19NT1VOVD15CkNPTkZJR19TVEFOREFMT05F
PXkKQ09ORklHX1BSRVZFTlRfRklSTVdBUkVfQlVJTEQ9eQpDT05GSUdfRldfTE9BREVSPXkKIyBD
T05GSUdfRklSTVdBUkVfSU5fS0VSTkVMIGlzIG5vdCBzZXQKQ09ORklHX0VYVFJBX0ZJUk1XQVJF
PSIiCiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0RFVlJF
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU19IWVBFUlZJU09SIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q09OTkVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFS
UE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BOUCBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWPXkK
IyBDT05GSUdfQkxLX0RFVl9GRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfWEQgaXMgbm90
IHNldAojIENPTkZJR19CTEtfQ1BRX0RBIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0NQUV9DSVNT
X0RBIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9EQUM5NjAgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX1VNRU0gaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0NPV19DT01NT04gaXMg
bm90IHNldAojIENPTkZJR19CTEtfREVWX0xPT1AgaXMgbm90IHNldAoKIwojIERSQkQgZGlzYWJs
ZWQgYmVjYXVzZSBQUk9DX0ZTLCBJTkVUIG9yIENPTk5FQ1RPUiBub3Qgc2VsZWN0ZWQKIwojIENP
TkZJR19CTEtfREVWX05CRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfU1g4IGlzIG5vdCBz
ZXQKQ09ORklHX0JMS19ERVZfUkFNPXkKQ09ORklHX0JMS19ERVZfUkFNX0NPVU5UPTQKQ09ORklH
X0JMS19ERVZfUkFNX1NJWkU9MjA0OAojIENPTkZJR19CTEtfREVWX1hJUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0NEUk9NX1BLVENEVkQgaXMgbm90IHNldAojIENPTkZJR19BVEFfT1ZFUl9FVEggaXMg
bm90IHNldAojIENPTkZJR19CTEtfREVWX0hEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9S
QkQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xJUzNMVjAyRCBpcyBub3Qgc2V0CiMgQ09O
RklHX01JU0NfREVWSUNFUyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0lERT15CiMgQ09ORklHX0lE
RSBpcyBub3Qgc2V0CgojCiMgU0NTSSBkZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19TQ1NJX01PRD15
CiMgQ09ORklHX1JBSURfQVRUUlMgaXMgbm90IHNldApDT05GSUdfU0NTST15CkNPTkZJR19TQ1NJ
X0RNQT15CkNPTkZJR19TQ1NJX1RHVD15CiMgQ09ORklHX1NDU0lfTkVUTElOSyBpcyBub3Qgc2V0
CkNPTkZJR19TQ1NJX1BST0NfRlM9eQoKIwojIFNDU0kgc3VwcG9ydCB0eXBlIChkaXNrLCB0YXBl
LCBDRC1ST00pCiMKQ09ORklHX0JMS19ERVZfU0Q9eQojIENPTkZJR19DSFJfREVWX1NUIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ0hSX0RFVl9PU1NUIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfU1I9
eQojIENPTkZJR19CTEtfREVWX1NSX1ZFTkRPUiBpcyBub3Qgc2V0CkNPTkZJR19DSFJfREVWX1NH
PXkKIyBDT05GSUdfQ0hSX0RFVl9TQ0ggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX01VTFRJX0xV
TiBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQ09OU1RBTlRTIGlzIG5vdCBzZXQKQ09ORklHX1ND
U0lfTE9HR0lORz15CkNPTkZJR19TQ1NJX1NDQU5fQVNZTkM9eQoKIwojIFNDU0kgVHJhbnNwb3J0
cwojCiMgQ09ORklHX1NDU0lfU1BJX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9GQ19B
VFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSVNDU0lfQVRUUlMgaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX1NBU19BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU0FTX0xJQlNBUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU1JQX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9MT1dMRVZFTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfREggaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX09TRF9JTklUSUFUT1IgaXMgbm90IHNldApDT05GSUdfQVRBPXkKIyBDT05GSUdfQVRB
X05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9WRVJCT1NFX0VSUk9SPXkKQ09ORklH
X1NBVEFfUE1QPXkKCiMKIyBDb250cm9sbGVycyB3aXRoIG5vbi1TRkYgbmF0aXZlIGludGVyZmFj
ZQojCkNPTkZJR19TQVRBX0FIQ0k9eQpDT05GSUdfU0FUQV9BSENJX1BMQVRGT1JNPXkKIyBDT05G
SUdfU0FUQV9JTklDMTYyWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfQUNBUkRfQUhDSSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NBVEFfU0lMMjQgaXMgbm90IHNldApDT05GSUdfQVRBX1NGRj15Cgoj
CiMgU0ZGIGNvbnRyb2xsZXJzIHdpdGggY3VzdG9tIERNQSBpbnRlcmZhY2UKIwojIENPTkZJR19Q
RENfQURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfUVNUT1IgaXMgbm90IHNldAojIENPTkZJ
R19TQVRBX1NYNCBpcyBub3Qgc2V0CkNPTkZJR19BVEFfQk1ETUE9eQoKIwojIFNBVEEgU0ZGIGNv
bnRyb2xsZXJzIHdpdGggQk1ETUEKIwpDT05GSUdfQVRBX1BJSVg9eQojIENPTkZJR19TQVRBX01W
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9OViBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfUFJP
TUlTRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfU0lMIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FU
QV9TSVMgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NWVyBpcyBub3Qgc2V0CiMgQ09ORklHX1NB
VEFfVUxJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9WSUEgaXMgbm90IHNldAojIENPTkZJR19T
QVRBX1ZJVEVTU0UgaXMgbm90IHNldAoKIwojIFBBVEEgU0ZGIGNvbnRyb2xsZXJzIHdpdGggQk1E
TUEKIwojIENPTkZJR19QQVRBX0FMSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQU1EIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFUQV9BUlRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQVRJSVhQ
IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BVFA4NjdYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFU
QV9DTUQ2NFggaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NTNTUyMCBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfQ1M1NTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DUzU1MzUgaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX0NTNTUzNiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1lQUkVTUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfRUZBUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSFBU
MzY2IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzN1ggaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX0hQVDNYMk4gaXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDNYMyBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfSVQ4MjEzIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9JVDgyMVggaXMgbm90
IHNldAojIENPTkZJR19QQVRBX0pNSUNST04gaXMgbm90IHNldAojIENPTkZJR19QQVRBX01BUlZF
TEwgaXMgbm90IHNldAojIENPTkZJR19QQVRBX05FVENFTEwgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX05JTkpBMzIgaXMgbm90IHNldAojIENPTkZJR19QQVRBX05TODc0MTUgaXMgbm90IHNldAoj
IENPTkZJR19QQVRBX09MRFBJSVggaXMgbm90IHNldAojIENPTkZJR19QQVRBX09QVElETUEgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX1BEQzIwMjdYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9Q
RENfT0xEIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9SQURJU1lTIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9SREMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1NDMTIwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfU0NIIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TRVJWRVJXT1JLUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfU0lMNjgwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TSVMg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX1RPU0hJQkEgaXMgbm90IHNldAojIENPTkZJR19QQVRB
X1RSSUZMRVggaXMgbm90IHNldAojIENPTkZJR19QQVRBX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBVEFfV0lOQk9ORCBpcyBub3Qgc2V0CgojCiMgUElPLW9ubHkgU0ZGIGNvbnRyb2xsZXJzCiMK
IyBDT05GSUdfUEFUQV9DTUQ2NDBfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9NUElJWCBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTlM4NzQxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
T1BUSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUExBVEZPUk0gaXMgbm90IHNldAojIENPTkZJ
R19QQVRBX1FESSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUloxMDAwIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9XSU5CT05EX1ZMQiBpcyBub3Qgc2V0CgojCiMgR2VuZXJpYyBmYWxsYmFjayAv
IGxlZ2FjeSBkcml2ZXJzCiMKQ09ORklHX0FUQV9HRU5FUklDPXkKQ09ORklHX1BBVEFfTEVHQUNZ
PXkKIyBDT05GSUdfTUQgaXMgbm90IHNldAojIENPTkZJR19UQVJHRVRfQ09SRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZVU0lPTiBpcyBub3Qgc2V0CgojCiMgSUVFRSAxMzk0IChGaXJlV2lyZSkgc3Vw
cG9ydAojCiMgQ09ORklHX0ZJUkVXSVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfRklSRVdJUkVfTk9T
WSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyTyBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ0lOVE9TSF9E
UklWRVJTIGlzIG5vdCBzZXQKQ09ORklHX05FVERFVklDRVM9eQojIENPTkZJR19EVU1NWSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JPTkRJTkcgaXMgbm90IHNldAojIENPTkZJR19NQUNWTEFOIGlzIG5v
dCBzZXQKIyBDT05GSUdfRVFVQUxJWkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfVFVOIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVkVUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ05FVCBpcyBub3Qgc2V0CkNP
TkZJR19NSUk9eQojIENPTkZJR19QSFlMSUIgaXMgbm90IHNldApDT05GSUdfRVRIRVJORVQ9eQpD
T05GSUdfTURJTz15CiMgQ09ORklHX05FVF9WRU5ET1JfM0NPTSBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9WRU5ET1JfQURBUFRFQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfQUxURU9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9BTUQgaXMgbm90IHNldAojIENPTkZJR19O
RVRfVkVORE9SX0FQUExFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9BVEhFUk9TIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9CUk9BRENPTSBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9WRU5ET1JfQlJPQ0FERSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfQ0hFTFNJ
TyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfQ0lTQ08gaXMgbm90IHNldAojIENPTkZJ
R19ETkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9ERUMgaXMgbm90IHNldAojIENP
TkZJR19ORVRfVkVORE9SX0RMSU5LIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9FTVVM
RVggaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX0VYQVIgaXMgbm90IHNldAojIENPTkZJ
R19ORVRfVkVORE9SX0ZVSklUU1UgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX0hQIGlz
IG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfSU5URUw9eQpDT05GSUdfRTEwMD15CkNPTkZJR19F
MTAwMD15CkNPTkZJR19FMTAwMEU9eQpDT05GSUdfSUdCPXkKQ09ORklHX0lHQlZGPXkKQ09ORklH
X0lYR0I9eQpDT05GSUdfSVhHQkU9eQpDT05GSUdfTkVUX1ZFTkRPUl9JODI1WFg9eQpDT05GSUdf
RUxQTFVTPXkKQ09ORklHX0VMMTY9eQpDT05GSUdfQVBSSUNPVD15CkNPTkZJR19FRVhQUkVTUz15
CkNPTkZJR19FRVhQUkVTU19QUk89eQpDT05GSUdfTFA0ODZFPXkKQ09ORklHX05JNTI9eQpDT05G
SUdfWk5FVD15CiMgQ09ORklHX0lQMTAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0pNRSBpcyBub3Qg
c2V0CiMgQ09ORklHX05FVF9WRU5ET1JfTUFSVkVMTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9W
RU5ET1JfTUVMTEFOT1ggaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX01JQ1JFTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfTVlSSSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZFQUxO
WCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfTkFUU0VNSSBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9WRU5ET1JfTlZJRElBIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9PS0kg
aXMgbm90IHNldAojIENPTkZJR19FVEhPQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9QQUNLRVRf
RU5HSU5FIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9RTE9HSUMgaXMgbm90IHNldAoj
IENPTkZJR19ORVRfVkVORE9SX1JBQ0FMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9S
RUFMVEVLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9SREMgaXMgbm90IHNldAojIENP
TkZJR19ORVRfVkVORE9SX1NFRVEgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX1NJUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NGQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfU01T
QyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfU1RNSUNSTyBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9WRU5ET1JfU1VOIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9URUhVVEkg
aXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX1RJIGlzIG5vdCBzZXQKQ09ORklHX05FVF9W
RU5ET1JfVklBPXkKQ09ORklHX1ZJQV9SSElORT15CkNPTkZJR19WSUFfUkhJTkVfTU1JTz15CiMg
Q09ORklHX1ZJQV9WRUxPQ0lUWSBpcyBub3Qgc2V0CiMgQ09ORklHX1RSIGlzIG5vdCBzZXQKIyBD
T05GSUdfV0xBTiBpcyBub3Qgc2V0CgojCiMgRW5hYmxlIFdpTUFYIChOZXR3b3JraW5nIG9wdGlv
bnMpIHRvIHNlZSB0aGUgV2lNQVggZHJpdmVycwojCiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0Cgoj
CiMgQ0FJRiB0cmFuc3BvcnQgZHJpdmVycwojCiMgQ09ORklHX0ZEREkgaXMgbm90IHNldAojIENP
TkZJR19ISVBQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BQUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NM
SVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfRkMgaXMgbm90IHNldAojIENPTkZJR19ORVRDT05T
T0xFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUUE9MTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9Q
T0xMX0NPTlRST0xMRVIgaXMgbm90IHNldAojIENPTkZJR19WTVhORVQzIGlzIG5vdCBzZXQKIyBD
T05GSUdfSVNETiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05FIGlzIG5vdCBzZXQKCiMKIyBJbnB1
dCBkZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19JTlBVVD15CiMgQ09ORklHX0lOUFVUX0ZGX01FTUxF
U1MgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9QT0xMREVWIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfU1BBUlNFS01BUCBpcyBub3Qgc2V0CgojCiMgVXNlcmxhbmQgaW50ZXJmYWNlcwojCiMg
Q09ORklHX0lOUFVUX01PVVNFREVWIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfSk9ZREVWIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfRVZERVYgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9F
VkJVRyBpcyBub3Qgc2V0CgojCiMgSW5wdXQgRGV2aWNlIERyaXZlcnMKIwojIENPTkZJR19JTlBV
VF9LRVlCT0FSRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01PVVNFIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UQUJMRVQgaXMg
bm90IHNldAojIENPTkZJR19JTlBVVF9UT1VDSFNDUkVFTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
UFVUX01JU0MgaXMgbm90IHNldAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19TRVJJ
Tz15CkNPTkZJR19TRVJJT19JODA0Mj15CkNPTkZJR19TRVJJT19TRVJQT1JUPXkKIyBDT05GSUdf
U0VSSU9fQ1Q4MkM3MTAgaXMgbm90IHNldAojIENPTkZJR19TRVJJT19QQ0lQUzIgaXMgbm90IHNl
dAojIENPTkZJR19TRVJJT19MSUJQUzIgaXMgbm90IHNldAojIENPTkZJR19TRVJJT19SQVcgaXMg
bm90IHNldAojIENPTkZJR19TRVJJT19BTFRFUkFfUFMyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VS
SU9fUFMyTVVMVCBpcyBub3Qgc2V0CiMgQ09ORklHX0dBTUVQT1JUIGlzIG5vdCBzZXQKCiMKIyBD
aGFyYWN0ZXIgZGV2aWNlcwojCkNPTkZJR19WVD15CkNPTkZJR19DT05TT0xFX1RSQU5TTEFUSU9O
Uz15CkNPTkZJR19WVF9DT05TT0xFPXkKQ09ORklHX0hXX0NPTlNPTEU9eQojIENPTkZJR19WVF9I
V19DT05TT0xFX0JJTkRJTkcgaXMgbm90IHNldApDT05GSUdfVU5JWDk4X1BUWVM9eQojIENPTkZJ
R19ERVZQVFNfTVVMVElQTEVfSU5TVEFOQ0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVHQUNZX1BU
WVMgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfTk9OU1RBTkRBUkQgaXMgbm90IHNldAojIENP
TkZJR19OT1pPTUkgaXMgbm90IHNldAojIENPTkZJR19OX0dTTSBpcyBub3Qgc2V0CiMgQ09ORklH
X1RSQUNFX1NJTksgaXMgbm90IHNldAojIENPTkZJR19ERVZLTUVNIGlzIG5vdCBzZXQKCiMKIyBT
ZXJpYWwgZHJpdmVycwojCkNPTkZJR19TRVJJQUxfODI1MD15CkNPTkZJR19TRVJJQUxfODI1MF9D
T05TT0xFPXkKQ09ORklHX0ZJWF9FQVJMWUNPTl9NRU09eQpDT05GSUdfU0VSSUFMXzgyNTBfUENJ
PXkKQ09ORklHX1NFUklBTF84MjUwX05SX1VBUlRTPTMyCkNPTkZJR19TRVJJQUxfODI1MF9SVU5U
SU1FX1VBUlRTPTQKQ09ORklHX1NFUklBTF84MjUwX0VYVEVOREVEPXkKQ09ORklHX1NFUklBTF84
MjUwX01BTllfUE9SVFM9eQojIENPTkZJR19TRVJJQUxfODI1MF9GT1VSUE9SVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFUklBTF84MjUwX0FDQ0VOVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF84
MjUwX0JPQ0EgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfODI1MF9FWEFSX1NUMTZDNTU0IGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMXzgyNTBfSFVCNiBpcyBub3Qgc2V0CkNPTkZJR19TRVJJ
QUxfODI1MF9TSEFSRV9JUlE9eQpDT05GSUdfU0VSSUFMXzgyNTBfREVURUNUX0lSUT15CkNPTkZJ
R19TRVJJQUxfODI1MF9SU0E9eQoKIwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1cHBvcnQKIwoj
IENPTkZJR19TRVJJQUxfTUZEX0hTVSBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfQ09SRT15CkNP
TkZJR19TRVJJQUxfQ09SRV9DT05TT0xFPXkKIyBDT05GSUdfU0VSSUFMX0pTTSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFUklBTF9USU1CRVJEQUxFIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0FM
VEVSQV9KVEFHVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9BTFRFUkFfVUFSVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFUklBTF9QQ0hfVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklB
TF9YSUxJTlhfUFNfVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RUWV9QUklOVEsgaXMgbm90IHNl
dAojIENPTkZJR19JUE1JX0hBTkRMRVIgaXMgbm90IHNldAojIENPTkZJR19IV19SQU5ET00gaXMg
bm90IHNldAojIENPTkZJR19OVlJBTSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQyBpcyBub3Qgc2V0
CiMgQ09ORklHX0dFTl9SVEMgaXMgbm90IHNldAojIENPTkZJR19EVExLIGlzIG5vdCBzZXQKIyBD
T05GSUdfUjM5NjQgaXMgbm90IHNldAojIENPTkZJR19BUFBMSUNPTSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NPTllQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01XQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdf
UEM4NzM2eF9HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfTlNDX0dQSU8gaXMgbm90IHNldAojIENP
TkZJR19SQVdfRFJJVkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFOR0NIRUNLX1RJTUVSIGlzIG5v
dCBzZXQKIyBDT05GSUdfVENHX1RQTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFTENMT0NLIGlzIG5v
dCBzZXQKQ09ORklHX0RFVlBPUlQ9eQojIENPTkZJR19SQU1PT1BTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJIGlzIG5vdCBzZXQKCiMKIyBQUFMgc3VwcG9y
dAojCiMgQ09ORklHX1BQUyBpcyBub3Qgc2V0CgojCiMgUFBTIGdlbmVyYXRvcnMgc3VwcG9ydAoj
CgojCiMgUFRQIGNsb2NrIHN1cHBvcnQKIwoKIwojIEVuYWJsZSBEZXZpY2UgRHJpdmVycyAtPiBQ
UFMgdG8gc2VlIHRoZSBQVFAgY2xvY2sgb3B0aW9ucy4KIwpDT05GSUdfQVJDSF9XQU5UX09QVElP
TkFMX0dQSU9MSUI9eQojIENPTkZJR19HUElPTElCIGlzIG5vdCBzZXQKIyBDT05GSUdfVzEgaXMg
bm90IHNldAojIENPTkZJR19QT1dFUl9TVVBQTFkgaXMgbm90IHNldAojIENPTkZJR19IV01PTiBp
cyBub3Qgc2V0CiMgQ09ORklHX1RIRVJNQUwgaXMgbm90IHNldAojIENPTkZJR19XQVRDSERPRyBp
cyBub3Qgc2V0CkNPTkZJR19TU0JfUE9TU0lCTEU9eQoKIwojIFNvbmljcyBTaWxpY29uIEJhY2tw
bGFuZQojCiMgQ09ORklHX1NTQiBpcyBub3Qgc2V0CkNPTkZJR19CQ01BX1BPU1NJQkxFPXkKCiMK
IyBCcm9hZGNvbSBzcGVjaWZpYyBBTUJBCiMKIyBDT05GSUdfQkNNQSBpcyBub3Qgc2V0CiMgQ09O
RklHX01GRF9TVVBQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUVESUFfU1VQUE9SVCBpcyBub3Qgc2V0CgojCiMgR3JhcGhpY3Mgc3VwcG9ydAoj
CiMgQ09ORklHX0FHUCBpcyBub3Qgc2V0CkNPTkZJR19WR0FfQVJCPXkKQ09ORklHX1ZHQV9BUkJf
TUFYX0dQVVM9MTYKIyBDT05GSUdfRFJNIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RVQl9QT1VMU0JP
IGlzIG5vdCBzZXQKIyBDT05GSUdfVkdBU1RBVEUgaXMgbm90IHNldAojIENPTkZJR19WSURFT19P
VVRQVVRfQ09OVFJPTCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkFDS0xJR0hUX0xDRF9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBEaXNwbGF5IGRldmljZSBzdXBw
b3J0CiMKIyBDT05GSUdfRElTUExBWV9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBDb25zb2xlIGRp
c3BsYXkgZHJpdmVyIHN1cHBvcnQKIwpDT05GSUdfVkdBX0NPTlNPTEU9eQpDT05GSUdfVkdBQ09O
X1NPRlRfU0NST0xMQkFDSz15CkNPTkZJR19WR0FDT05fU09GVF9TQ1JPTExCQUNLX1NJWkU9NjQK
IyBDT05GSUdfTURBX0NPTlNPTEUgaXMgbm90IHNldApDT05GSUdfRFVNTVlfQ09OU09MRT15CiMg
Q09ORklHX1NPVU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1NVUFBPUlQgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU1VQUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VXQiBpcyBub3Qgc2V0CiMg
Q09ORklHX01NQyBpcyBub3Qgc2V0CiMgQ09ORklHX01FTVNUSUNLIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVXX0xFRFMgaXMgbm90IHNldAojIENPTkZJR19BQ0NFU1NJQklMSVRZIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5GSU5JQkFORCBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUMgaXMgbm90IHNldAoj
IENPTkZJR19SVENfQ0xBU1MgaXMgbm90IHNldAojIENPTkZJR19ETUFERVZJQ0VTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVVYRElTUExBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VJTyBpcyBub3Qgc2V0
CgojCiMgVmlydGlvIGRyaXZlcnMKIwojIENPTkZJR19WSVJUSU9fUENJIGlzIG5vdCBzZXQKIyBD
T05GSUdfVklSVElPX0JBTExPT04gaXMgbm90IHNldAojIENPTkZJR19TVEFHSU5HIGlzIG5vdCBz
ZXQKIyBDT05GSUdfWDg2X1BMQVRGT1JNX0RFVklDRVMgaXMgbm90IHNldApDT05GSUdfQ0xLU1JD
X0k4MjUzPXkKQ09ORklHX0NMS0VWVF9JODI1Mz15CkNPTkZJR19JODI1M19MT0NLPXkKQ09ORklH
X0NMS0JMRF9JODI1Mz15CiMgQ09ORklHX0lPTU1VX1NVUFBPUlQgaXMgbm90IHNldAojIENPTkZJ
R19WSVJUX0RSSVZFUlMgaXMgbm90IHNldAoKIwojIEZpcm13YXJlIERyaXZlcnMKIwojIENPTkZJ
R19FREQgaXMgbm90IHNldAojIENPTkZJR19GSVJNV0FSRV9NRU1NQVAgaXMgbm90IHNldAojIENP
TkZJR19ERUxMX1JCVSBpcyBub3Qgc2V0CiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0RNSUlEIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1JX1NZU0ZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSVNDU0lfSUJGVF9GSU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfR09PR0xFX0ZJUk1XQVJFIGlz
IG5vdCBzZXQKCiMKIyBGaWxlIHN5c3RlbXMKIwojIENPTkZJR19FWFQyX0ZTIGlzIG5vdCBzZXQK
IyBDT05GSUdfRVhUM19GUyBpcyBub3Qgc2V0CkNPTkZJR19FWFQ0X0ZTPXkKQ09ORklHX0VYVDRf
VVNFX0ZPUl9FWFQyMz15CkNPTkZJR19FWFQ0X0ZTX1hBVFRSPXkKQ09ORklHX0VYVDRfRlNfUE9T
SVhfQUNMPXkKQ09ORklHX0VYVDRfRlNfU0VDVVJJVFk9eQojIENPTkZJR19FWFQ0X0RFQlVHIGlz
IG5vdCBzZXQKQ09ORklHX0pCRDI9eQpDT05GSUdfRlNfTUJDQUNIRT15CiMgQ09ORklHX1JFSVNF
UkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfWEZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQlRSRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19OSUxG
UzJfRlMgaXMgbm90IHNldApDT05GSUdfRlNfUE9TSVhfQUNMPXkKQ09ORklHX0ZJTEVfTE9DS0lO
Rz15CiMgQ09ORklHX0ZTTk9USUZZIGlzIG5vdCBzZXQKIyBDT05GSUdfRE5PVElGWSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lOT1RJRllfVVNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZBTk9USUZZIGlz
IG5vdCBzZXQKIyBDT05GSUdfUVVPVEEgaXMgbm90IHNldAojIENPTkZJR19RVU9UQUNUTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FVVE9GUzRfRlMgaXMgbm90IHNldAojIENPTkZJR19GVVNFX0ZTIGlz
IG5vdCBzZXQKQ09ORklHX0dFTkVSSUNfQUNMPXkKCiMKIyBDYWNoZXMKIwojIENPTkZJR19GU0NB
Q0hFIGlzIG5vdCBzZXQKCiMKIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zCiMKIyBDT05GSUdfSVNP
OTY2MF9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VERl9GUyBpcyBub3Qgc2V0CgojCiMgRE9TL0ZB
VC9OVCBGaWxlc3lzdGVtcwojCiMgQ09ORklHX01TRE9TX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
VkZBVF9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX05URlNfRlMgaXMgbm90IHNldAoKIwojIFBzZXVk
byBmaWxlc3lzdGVtcwojCkNPTkZJR19QUk9DX0ZTPXkKIyBDT05GSUdfUFJPQ19LQ09SRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BST0NfVk1DT1JFIGlzIG5vdCBzZXQKQ09ORklHX1BST0NfU1lTQ1RM
PXkKQ09ORklHX1BST0NfUEFHRV9NT05JVE9SPXkKQ09ORklHX1NZU0ZTPXkKQ09ORklHX1RNUEZT
PXkKQ09ORklHX1RNUEZTX1BPU0lYX0FDTD15CkNPTkZJR19UTVBGU19YQVRUUj15CiMgQ09ORklH
X0hVR0VUTEJGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hVR0VUTEJfUEFHRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0NPTkZJR0ZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlTQ19GSUxFU1lTVEVNUyBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVFdPUktfRklMRVNZU1RFTVMgaXMgbm90IHNldAoKIwojIFBh
cnRpdGlvbiBUeXBlcwojCiMgQ09ORklHX1BBUlRJVElPTl9BRFZBTkNFRCBpcyBub3Qgc2V0CkNP
TkZJR19NU0RPU19QQVJUSVRJT049eQpDT05GSUdfTkxTPXkKQ09ORklHX05MU19ERUZBVUxUPSJp
c284ODU5LTEiCiMgQ09ORklHX05MU19DT0RFUEFHRV80MzcgaXMgbm90IHNldAojIENPTkZJR19O
TFNfQ09ERVBBR0VfNzM3IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNf
Q09ERVBBR0VfODUyIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NSBpcyBub3Qg
c2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09E
RVBBR0VfODYwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MSBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBB
R0VfODYzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NCBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV84NjUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODY2IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2OSBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV85MzYgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTUw
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzkzMiBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODc0IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfOCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19D
T0RFUEFHRV8xMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzEyNTEgaXMgbm90
IHNldAojIENPTkZJR19OTFNfQVNDSUkgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8x
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMiBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19JU084ODU5XzMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV80IGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0lTTzg4NTlfNSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzYg
aXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV83IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0lTTzg4NTlfOSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzEzIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0lTTzg4NTlfMTQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8x
NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19LT0k4X1IgaXMgbm90IHNldAojIENPTkZJR19OTFNf
S09JOF9VIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX1VURjggaXMgbm90IHNldAoKIwojIEtlcm5l
bCBoYWNraW5nCiMKQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQ9eQojIENPTkZJR19QUklO
VEtfVElNRSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX01FU1NBR0VfTE9HTEVWRUw9NApDT05G
SUdfRU5BQkxFX1dBUk5fREVQUkVDQVRFRD15CkNPTkZJR19FTkFCTEVfTVVTVF9DSEVDSz15CkNP
TkZJR19GUkFNRV9XQVJOPTIwNDgKQ09ORklHX01BR0lDX1NZU1JRPXkKQ09ORklHX1NUUklQX0FT
TV9TWU1TPXkKIyBDT05GSUdfVU5VU0VEX1NZTUJPTFMgaXMgbm90IHNldAojIENPTkZJR19ERUJV
R19GUyBpcyBub3Qgc2V0CkNPTkZJR19IRUFERVJTX0NIRUNLPXkKQ09ORklHX0RFQlVHX1NFQ1RJ
T05fTUlTTUFUQ0g9eQpDT05GSUdfREVCVUdfS0VSTkVMPXkKQ09ORklHX0RFQlVHX1NISVJRPXkK
Q09ORklHX0xPQ0tVUF9ERVRFQ1RPUj15CkNPTkZJR19IQVJETE9DS1VQX0RFVEVDVE9SPXkKQ09O
RklHX0JPT1RQQVJBTV9IQVJETE9DS1VQX1BBTklDPXkKQ09ORklHX0JPT1RQQVJBTV9IQVJETE9D
S1VQX1BBTklDX1ZBTFVFPTEKQ09ORklHX0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklDPXkKQ09O
RklHX0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklDX1ZBTFVFPTEKQ09ORklHX0RFVEVDVF9IVU5H
X1RBU0s9eQpDT05GSUdfREVGQVVMVF9IVU5HX1RBU0tfVElNRU9VVD0xMjAKIyBDT05GSUdfQk9P
VFBBUkFNX0hVTkdfVEFTS19QQU5JQyBpcyBub3Qgc2V0CkNPTkZJR19CT09UUEFSQU1fSFVOR19U
QVNLX1BBTklDX1ZBTFVFPTAKIyBDT05GSUdfU0NIRURfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19TQ0hFRFNUQVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfVElNRVJfU1RBVFMgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19PQkpFQ1RTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xVQl9TVEFUUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFQlVHX0tNRU1MRUFLIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdf
UlRfTVVURVhFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUX01VVEVYX1RFU1RFUiBpcyBub3Qgc2V0
CkNPTkZJR19ERUJVR19TUElOTE9DSz15CiMgQ09ORklHX0RFQlVHX01VVEVYRVMgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19MT0NLX0FMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPVkVfTE9D
S0lORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NQQVJTRV9SQ1VfUE9JTlRFUiBpcyBub3Qgc2V0CiMg
Q09ORklHX0xPQ0tfU1RBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0FUT01JQ19TTEVFUCBp
cyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZURVNUUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFQlVHX1NUQUNLX1VTQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfS09C
SkVDVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0hJR0hNRU0gaXMgbm90IHNldApDT05GSUdf
REVCVUdfQlVHVkVSQk9TRT15CiMgQ09ORklHX0RFQlVHX0lORk8gaXMgbm90IHNldAojIENPTkZJ
R19ERUJVR19WTSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZJUlRVQUwgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19XUklURUNPVU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTUVNT1JZ
X0lOSVQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19MSVNUIGlzIG5vdCBzZXQKIyBDT05GSUdf
VEVTVF9MSVNUX1NPUlQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRyBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFQlVHX05PVElGSUVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0NSRURFTlRJ
QUxTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9GUkFNRV9QT0lOVEVSUz15CkNPTkZJR19G
UkFNRV9QT0lOVEVSPXkKIyBDT05GSUdfQk9PVF9QUklOVEtfREVMQVkgaXMgbm90IHNldAojIENP
TkZJR19SQ1VfVE9SVFVSRV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS1RSQUNFX1NFTEZf
VEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0JMT0NLX0VYVF9ERVZUIGlzIG5vdCBzZXQK
IyBDT05GSUdfREVCVUdfRk9SQ0VfV0VBS19QRVJfQ1BVIGlzIG5vdCBzZXQKIyBDT05GSUdfRkFV
TFRfSU5KRUNUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTEFURU5DWVRPUCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NZU0NUTF9TWVNDQUxMX0NIRUNLIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSEFTX0RF
QlVHX1NUUklDVF9VU0VSX0NPUFlfQ0hFQ0tTPXkKIyBDT05GSUdfREVCVUdfU1RSSUNUX1VTRVJf
Q09QWV9DSEVDS1MgaXMgbm90IHNldApDT05GSUdfREVCVUdfUEFHRUFMTE9DPXkKQ09ORklHX1VT
RVJfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VSPXkKQ09O
RklHX0hBVkVfRlVOQ1RJT05fR1JBUEhfVFJBQ0VSPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fR1JB
UEhfRlBfVEVTVD15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNFX01DT1VOVF9URVNUPXkKQ09O
RklHX0hBVkVfRFlOQU1JQ19GVFJBQ0U9eQpDT05GSUdfSEFWRV9GVFJBQ0VfTUNPVU5UX1JFQ09S
RD15CkNPTkZJR19IQVZFX1NZU0NBTExfVFJBQ0VQT0lOVFM9eQpDT05GSUdfSEFWRV9DX1JFQ09S
RE1DT1VOVD15CkNPTkZJR19UUkFDSU5HX1NVUFBPUlQ9eQojIENPTkZJR19GVFJBQ0UgaXMgbm90
IHNldAojIENPTkZJR19QUk9WSURFX09IQ0kxMzk0X0RNQV9JTklUIGlzIG5vdCBzZXQKIyBDT05G
SUdfQlVJTERfRE9DU1JDIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BX0FQSV9ERUJVRyBpcyBub3Qg
c2V0CiMgQ09ORklHX0FUT01JQzY0X1NFTEZURVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FNUExF
UyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FSQ0hfS0dEQj15CiMgQ09ORklHX0tHREIgaXMgbm90
IHNldApDT05GSUdfSEFWRV9BUkNIX0tNRU1DSEVDSz15CiMgQ09ORklHX0tNRU1DSEVDSyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RFU1RfS1NUUlRPWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NUUklDVF9E
RVZNRU0gaXMgbm90IHNldApDT05GSUdfWDg2X1ZFUkJPU0VfQk9PVFVQPXkKQ09ORklHX0VBUkxZ
X1BSSU5USz15CiMgQ09ORklHX0VBUkxZX1BSSU5US19EQkdQIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfU1RBQ0tPVkVSRkxPVyBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QVERVTVAgaXMgbm90
IHNldApDT05GSUdfREVCVUdfUk9EQVRBPXkKQ09ORklHX0RFQlVHX1JPREFUQV9URVNUPXkKQ09O
RklHX0RPVUJMRUZBVUxUPXkKIyBDT05GSUdfSU9NTVVfU1RSRVNTIGlzIG5vdCBzZXQKQ09ORklH
X0hBVkVfTU1JT1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSU9fREVMQVlfVFlQRV8wWDgwPTAKQ09O
RklHX0lPX0RFTEFZX1RZUEVfMFhFRD0xCkNPTkZJR19JT19ERUxBWV9UWVBFX1VERUxBWT0yCkNP
TkZJR19JT19ERUxBWV9UWVBFX05PTkU9MwpDT05GSUdfSU9fREVMQVlfMFg4MD15CiMgQ09ORklH
X0lPX0RFTEFZXzBYRUQgaXMgbm90IHNldAojIENPTkZJR19JT19ERUxBWV9VREVMQVkgaXMgbm90
IHNldAojIENPTkZJR19JT19ERUxBWV9OT05FIGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSU9f
REVMQVlfVFlQRT0wCiMgQ09ORklHX0NQQV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX09QVElN
SVpFX0lOTElOSU5HIGlzIG5vdCBzZXQKCiMKIyBTZWN1cml0eSBvcHRpb25zCiMKIyBDT05GSUdf
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
--000e0cd32f3a6a807d04ab4a7df1--
