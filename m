Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1GOB6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 21:58:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34097 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab1GOB6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 21:58:23 -0400
MIME-Version: 1.0
Date: Thu, 14 Jul 2011 21:58:22 -0400
Message-ID: <CACqU3MWoO_atSwXOFpKY=DpmfNO_wto9A84hYYZNhqyLrW0Zag@mail.gmail.com>
Subject: Re: linux-next: Tree for July 7 (kconfig regression)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I introduced a regression in the -kbuild tree in way autoconf.h was
generated. In more details, if the Kconfig did not specify the "0x"
prefix of an hexadecimal default value, this prefix ended up missing
too in autoconf.h, thus breaking the build or generating incorrect
value. Repartition of the faulty symbols is the following:

 arch/arm/Kconfig                   |    2
 arch/blackfin/Kconfig              |    3
 arch/cris/arch-v10/Kconfig         |   17
 arch/cris/arch-v10/drivers/Kconfig |   5
 arch/cris/arch-v32/Kconfig         |   19
 arch/cris/arch-v32/mach-a3/Kconfig |   14
 arch/cris/arch-v32/mach-fs/Kconfig |   22
 arch/m32r/Kconfig                  |   18
 arch/m68k/Kconfig.nommu            |    4
 arch/x86/Kconfig                   |    1
 drivers/media/radio/Kconfig        |   8
 drivers/mtd/devices/Kconfig        |    2
 drivers/mtd/maps/Kconfig           |    1
 drivers/mtd/nand/Kconfig           |    1
 sound/oss/Kconfig                  |   19

A patch, addressing the regression, is available at:

https://patchwork.kernel.org/patch/975652/

It should be part of the -kbuild tree for the next -next iteration.

Sorry for the disturbance,
 - Arnaud

On Thu, Jul 7, 2011 at 3:25 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> The next linux-next release will (probably) be next-20110718.
>
> Changes since 20110706:
>
> The pci-current tree gained a build failure so I used the version from
> next-20110706.
>
> The arm-lpae tree gained a conflict against the arm tree.
>
> The v4l-dvb tree lost its conflict.
>
> The net tree lost a conflict.
>
> The rr tree still has its build failure for which I reverted a commit.
>
> The block tree still has its build failure so I used the version from
> next-20110701.
>
> The staging tree lost its build failures but gained conflicts agains the
> net, trivial and ux500-core trees and another build failure which I have
> just left.
>
> The akpm tree lost its build failures.  I have rmeoved one patch (that is
> included elsewhere) and added 2 patches to my copy of the akpm tree.
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
>
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
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
> We are up to 195 trees (counting Linus' and 28 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
>
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
>
> Thanks to Randy Dunlap for doing many randconfig builds.
>
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
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
> $ git reset --hard HEAD^
> Merging refs/next/20110706/pci-current
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
> CONFLICT (content): Merge conflict in arch/arm/include/asm/proc-fns.h
> CONFLICT (content): Merge conflict in arch/arm/include/asm/tlb.h
> CONFLICT (content): Merge conflict in arch/arm/mm/context.c
> CONFLICT (content): Merge conflict in arch/arm/mm/dma-mapping.c
> CONFLICT (content): Merge conflict in arch/arm/mm/proc-v7.S
> Merging at91/at91-next
> Merging davinci/davinci-next
> Merging i.MX/for-next
> CONFLICT (content): Merge conflict in arch/arm/plat-mxc/devices/platform-imx-dma.c
> Merging linux-spec/for-next
> Merging msm/for-next
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
> CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
> Merging ceph/for-next
> CONFLICT (content): Merge conflict in fs/ceph/export.c
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
> CONFLICT (content): Merge conflict in fs/logfs/logfs.h
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
> Merging of-pci/of-pci
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
> CONFLICT (content): Merge conflict in drivers/ata/libahci.c
> Merging infiniband/for-next
> Merging acpi/test
> Merging idle-test/idle-test
> CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
> Merging powertools/tools-test
> Merging cpupowerutils/master
> Merging ieee1394/for-next
> Merging ubi/linux-next
> Merging dlm/next
> Merging swiotlb/master
> Merging ibft/master
> Merging scsi/master
> Merging slave-dma/next
> Merging async_tx/next
> Merging net/master
> CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc.h
> CONFLICT (content): Merge conflict in drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> CONFLICT (content): Merge conflict in net/bluetooth/l2cap_core.c
> Merging wireless/master
> Merging bluetooth/master
> Merging mtd/master
> Merging l2-mtd/master
> Merging crypto/master
> Merging sound/for-next
> Merging sound-asoc/for-next
> Merging cpufreq/next
> Merging quilt/rr
> CONFLICT (delete/modify): arch/m68k/kernel/module_mm.c deleted in HEAD and modified in quilt/rr. Version quilt/rr of arch/m68k/kernel/module_mm.c left in tree.
> CONFLICT (delete/modify): arch/m68k/kernel/module_no.c deleted in HEAD and modified in quilt/rr. Version quilt/rr of arch/m68k/kernel/module_no.c left in tree.
> $ git rm -f arch/m68k/kernel/module_mm.c arch/m68k/kernel/module_no.c
> Applying: modules/m68k: make arch's use default loader hooks
> [master 88dada7] Revert "module: add /sys/module/<name>/uevent files"
> Merging input/next
> Merging input-mt/next
> Merging lsm/for-next
> Merging block/for-next
> $ git reset --hard HEAD^
> Merging refs/next/20110701/block
> CONFLICT (content): Merge conflict in block/blk-throttle.c
> [master 062083d] Merge commit 'refs/next/20110701/block'
> Merging quilt/device-mapper
> Merging embedded/master
> Merging firmware/master
> Merging pcmcia/master
> Merging battery/master
> Merging leds/for-mm
> CONFLICT (content): Merge conflict in drivers/leds/Kconfig
> Merging backlight/for-mm
> Merging mmc/mmc-next
> CONFLICT (delete/modify): drivers/mmc/host/sdhci-of-core.c deleted in mmc/mmc-next and modified in HEAD. Version HEAD of drivers/mmc/host/sdhci-of-core.c left in tree.
> $ git rm -f drivers/mmc/host/sdhci-of-core.c
> Merging kgdb/kgdb-next
> Merging slab/for-next
> Merging uclinux/for-next
> Merging md/for-next
> Merging mfd/for-next
> CONFLICT (content): Merge conflict in drivers/mfd/Makefile
> Merging hdlc/hdlc-next
> Merging drm/drm-next
> Merging fbdev/master
> Merging viafb/viafb-next
> Merging omap_dss2/for-next
> Merging voltage/for-next
> Merging security-testing/next
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
> CONFLICT (delete/modify): arch/arm/mach-ep93xx/dma-m2p.c deleted in HEAD and modified in trivial/for-next. Version trivial/for-next of arch/arm/mach-ep93xx/dma-m2p.c left in tree.
> CONFLICT (content): Merge conflict in drivers/mtd/maps/pxa2xx-flash.c
> $ git rm -f arch/arm/mach-ep93xx/dma-m2p.c
> Merging audit/for-next
> Merging suspend/linux-next
> Merging apm/for-next
> Merging fsnotify/for-next
> Merging irda/for-next
> Merging i7core_edac/linux_next
> Merging i7300_edac/linux_next
> Merging devicetree/devicetree/next
> Merging spi/spi/next
> Merging gpio/gpio/next
> CONFLICT (content): Merge conflict in arch/arm/mach-ep93xx/Makefile
> CONFLICT (content): Merge conflict in drivers/gpio/Makefile
> CONFLICT (content): Merge conflict in drivers/gpio/gpio-ep93xx.c
> Merging tip/auto-latest
> Merging rcu/rcu/next
> Merging kvm/linux-next
> Merging oprofile/for-next
> Merging ptrace/ptrace
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
> Merging driver-core/driver-core-next
> Merging tty/tty-next
> Merging usb/usb-next
> CONFLICT (content): Merge conflict in Documentation/feature-removal-schedule.txt
> Merging staging/staging-next
> CONFLICT (content): Merge conflict in Documentation/feature-removal-schedule.txt
> CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500-u8500uib.c
> CONFLICT (content): Merge conflict in drivers/staging/bcm/headers.h
> CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dhd_linux.c
> CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> CONFLICT (content): Merge conflict in drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
> CONFLICT (delete/modify): drivers/staging/brcm80211/brcmfmac/wl_iw.c deleted in staging/staging-next and modified in HEAD. Version HEAD of drivers/staging/brcm80211/brcmfmac/wl_iw.c left in tree.
> CONFLICT (content): Merge conflict in drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> CONFLICT (content): Merge conflict in drivers/staging/rtl8192e/r8192E.h
> CONFLICT (content): Merge conflict in drivers/staging/usbip/userspace/src/utils.h
> $ git rm -f drivers/staging/brcm80211/brcmfmac/wl_iw.c
> Merging bkl-config/config
> Merging tmem/linux-next
> Merging writeback/next
> Merging arm-dt/devicetree/arm-next
> Merging scsi-post-merge/merge-base:master
> $ git checkout akpm
> Applying: During allocator-intensive workloads, kswapd will be woken frequently
> Applying: During allocator-intensive workloads, kswapd will be woken frequently
> Applying: When deciding if kswapd is sleeping prematurely, the classzone is taken
> Applying: During allocator-intensive workloads, kswapd will be woken frequently
> Applying: __tlb_remove_page() switches to a new batch page, but still checks space
> Applying: Now, in mem_cgroup_hierarchical_reclaim(), mem_cgroup_local_usage() is
> Applying: ERROR: code indent should use tabs where possible
> Applying: fix kerneldoc layout
> Applying: memcg-fix-reclaimable-lru-check-in-memcg-fix2.patch
> Applying: commit 889976dbcb12 ("memcg: reclaim memory from nodes in round-robin
> Applying: attempt to repair code layout
> Applying: Currently we are keeping faulted page locked throughout whole __do_fault
> Applying: fix code layout
> Applying: The often-NULL data arg to read_cache_page() and read_mapping_page()
> Applying: Correct comment on truncate_inode_pages*() in linux/mm.h; and remove
> Applying: Use consistent variable names in truncate_pagecache(), truncate_setsize(),
> Applying: Make the pagevec_lookup loops in truncate_inode_pages_range(),
> Applying: truncate_inode_pages_range()'s final loop has a nice pincer property,
> Applying: 2.6.36's 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_counter for
> Applying: remap_pfn_range() means map physical address pfn<<PAGE_SHIFT to user addr.
> Applying: Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Applying: If dmi_get_system_info() returns NULL, pch_phub_probe() will dereferencea
> Applying: Vito said:
> Applying: kernel/fork.c:267: error: implicit declaration of function
> Applying: WARNING: line over 80 characters
> Applying: arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undeclared (first use in this function)
> Applying: arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting types for 'sync_serial_ioctl'
> Applying: arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration of function 'kgdb_init'
> Applying: There's a code path in pmcraid that can be reached via device ioctl that
> Applying: The out_msi_disable label should be before cleanup_nomem to additionally
> Applying: It's about time to revert 16d752397301b9 ("thermal: Create
> Applying: We'll soon need to reuse it.
> Applying: THERMAL_HWMON is implemented inside the thermal_sys driver and has no
> Applying: b552a8c56db8 ("ACPI: remove NID_INVAL") removed the left over uses of
> Applying: Add support for Aspire 1410 BIOS v1.3314.  Fixes the following error:
> Applying: With a non-constant 8-bit argument, a call to udelay() generates a warning:
> Applying: On x86_32 casting the unsigned int result of get_random_int() to long may
> Applying: This new driver replaces the old PCEngines Alix 2/3 LED driver with a new
> Applying: Replace the bubble sort in sanitize_e820_map() with a call to the generic
> Applying: In response to new device tree code in the kernel, OLPC will start using
> Applying: Move these definitions into the relevant header file.  This was requested
> Applying: Based on earlier review comments, we'll no longer try to stick all of our
> Applying: Add code needed for basic suspend/resume of the XO-1 laptop.  Based on
> Applying: The System Control Interrupt is used in the OLPC XO-1 to control various
> Applying: Update the EC SCI masks with recent additions.
> Applying: The EC in the OLPC XO-1 delivers GPE events to provide various
> Applying: Configure the XO-1's lid switch GPIO to trigger an SCI interrupt, and
> Applying: EC events indicate change in AC power connectivity, battery state of
> Applying: Add a driver to configure the XO-1 RTC via CS5536 MSRs, to be used as a
> Applying: Add a driver for the ACPI-based EC event interface found on the OLPC
> Applying: Don't allow everybody to use a modem.
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: A call to va_copy() should always be followed by a call to va_end() in the
> Applying: Don't dereference em if it's NULL or an error pointer.
> Applying: The buffer 'sc.cpu_mask' is a kernel buffer.  If bitmap_parse is used
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: fb_set_suspend() must be called with the console semaphore held, which
> Applying: When 1280x1024@75Hz mode is set, console palette is not set properly -
> Applying: Unless I'm very much missing something these tests are intended to check
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: The address limit is already set in flush_old_exec() via set_fs(USER_DS)
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: - Fix checking of wrong return value for backlight_device_register()
> Applying: Add the ams369fg06 amoled panel driver.  The ams369fg06 amoled panel (480
> Applying: backlight: make some varibales static
> Applying: Not all systems expose a firmware or platform mechanism for changing the
> Applying: The Apple MBP model 6.2 (and maybe other recent MBPs) uses an Apple
> Applying: ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_le() for
> Applying: The dqc_bitmap field of struct ocfs2_local_disk_chunk is 32-bit aligned,
> Applying: The address limit is already set in flush_old_exec() so those calls to
> Applying: When do pci remove/rescan on system that have more iommus, got
> Applying: The current implementation of dmi_name_in_vendors() is an invitation to
> Applying: When hot-plugging a root bridge, we always prevent assigning a bus number
> Applying: fix comment layout
> Applying: Aside of the usual motivation for constification, this function has a
> Applying: The address limit is already set in flush_old_exec() so those calls to
> Applying: For headers that get exported to userland and make use of u32 style
> Applying: Fix sparse warnings of right shift bigger than source value size:
> Applying: brd_make_request() always returns 0, which doesn't make much sense.
> Applying: Remove the (unsigned long long) cast in diskstats_show() and adjusts the
> Applying: The address limit is already set in flush_old_exec() so this assignment of
> Applying: x86_64 allmodconfig:
> Applying: x86_64 allmodconfig:
> Applying: alpha allmodconfig:
> Applying: alpha allmodconfig:
> Applying: alpha allmodconfig:
> Applying: Cc: Greg KH <greg@kroah.com>
> Applying: Use the nice enumerated constant.
> Applying: There is no need to define VM_{STACK,DATA}_DEFAULT_FLAGS as variable.
> Applying: The address limit is already set in flush_old_exec() so this
> Applying: Both sys-i386 and sys-x86_64 support now ndelay().  The delay functions
> Applying: When UML is compiled with _FORTIFY_SOURCE we have to export all _chk()
> Applying: To make netconsole usable on UML, its ethernet driver needs netpoll
> Applying: commit 0954828fcbf3bd13d593499b16b901a4e801b0b9 ("kconfig: replace
> Applying: We presently define all kinds of notifiers in notifier.h.  This is not
> Applying: It is not necessary to share the same notifier.h.
> Applying: It is not necessary to share the same notifier.h.
> Applying: notifiers-sys-move-reboot-notifiers-into-rebooth-fix
> Applying: It is not necessary to share the same notifier.h.
> Applying: Cc: David Miller <davem@davemloft.net>
> Applying: It is not necessary to share the same notifier.h.
> Applying: If CONFIG_IKCONFIG=m but CONFIG_IKCONFIG_PROC=n we get a module that has
> Applying: For each CPU, do the calibration delay only once.  For subsequent calls,
> Applying: make cpu_loops_per_jiffy static
> Applying: Cc: Andrew Worsley <amworsley@gmail.com>
> Applying: prevent ARM build breakage :)
> Applying: fix things up after upstream rmk changes
> Applying: MPC5200B contains a limited version of RTC from MPC5121.  Add support for
> Applying: Add support for clock gating.  Power consumption can be reduced by setting
> Applying: Add support for PMIC8xxx based RTC.  PMIC8xxx is Qualcomm's power
> Applying: cosmetic tweaks
> Applying: Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
> Merging akpm
>
