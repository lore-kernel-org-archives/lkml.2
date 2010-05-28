Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0E1Umy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:42:54 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:37107 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902Ab0E1Umu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:42:50 -0400
Date: Fri, 28 May 2010 16:42:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI patches for 2.6.35-merge
Message-id: <alpine.LFD.2.00.1005281641080.4045@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.34/acpi-release-20100121-2.6.34.diff.gz

 Documentation/acpi/apei/einj.txt          |   59 ++
 Documentation/kernel-parameters.txt       |   12 +-
 arch/ia64/include/asm/acpi.h              |    1 -
 arch/ia64/pci/pci.c                       |    5 +-
 arch/x86/include/asm/acpi.h               |    2 -
 arch/x86/include/asm/mce.h                |    8 +
 arch/x86/kernel/acpi/boot.c               |   19 +-
 arch/x86/kernel/acpi/sleep.c              |    2 -
 arch/x86/kernel/cpu/mcheck/Makefile       |    2 +
 arch/x86/kernel/cpu/mcheck/mce-apei.c     |  138 +++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   23 +
 arch/x86/kernel/cpu/mcheck/mce.c          |   79 +++-
 arch/x86/lguest/boot.c                    |    1 -
 arch/x86/pci/acpi.c                       |    5 +-
 drivers/acpi/Kconfig                      |    9 +
 drivers/acpi/Makefile                     |    5 +-
 drivers/acpi/acpi_pad.c                   |   13 +-
 drivers/acpi/acpica/evxfevnt.c            |   33 +-
 drivers/acpi/acpica/hwacpi.c              |   20 +-
 drivers/acpi/apei/Kconfig                 |   30 +
 drivers/acpi/apei/Makefile                |    5 +
 drivers/acpi/apei/apei-base.c             |  593 ++++++++++++++++++++
 drivers/acpi/apei/apei-internal.h         |  114 ++++
 drivers/acpi/apei/cper.c                  |   84 +++
 drivers/acpi/apei/einj.c                  |  548 ++++++++++++++++++
 drivers/acpi/apei/erst.c                  |  855 +++++++++++++++++++++++++++++
 drivers/acpi/apei/ghes.c                  |  427 ++++++++++++++
 drivers/acpi/apei/hest.c                  |  173 ++++++
 drivers/acpi/atomicio.c                   |  360 ++++++++++++
 drivers/acpi/ec.c                         |    3 +-
 drivers/acpi/hed.c                        |  112 ++++
 drivers/acpi/hest.c                       |  139 -----
 drivers/acpi/pci_root.c                   |   67 ++-
 drivers/acpi/processor_idle.c             |   30 +-
 drivers/acpi/sleep.c                      |  157 +------
 drivers/acpi/sleep.h                      |    2 +-
 drivers/acpi/tables.c                     |    4 +-
 drivers/acpi/video.c                      |  118 ++++-
 drivers/acpi/video_detect.c               |    2 +-
 drivers/pci/pcie/aer/aerdrv.h             |   17 +
 drivers/pci/pcie/aer/aerdrv_acpi.c        |   77 +++
 drivers/pci/pcie/aer/aerdrv_core.c        |    8 +-
 drivers/pci/probe.c                       |    8 -
 fs/debugfs/file.c                         |   21 +-
 include/acpi/acpi_bus.h                   |    2 +-
 include/acpi/acpi_drivers.h               |    3 +-
 include/acpi/acpi_hest.h                  |   12 -
 include/acpi/apei.h                       |   34 ++
 include/acpi/atomicio.h                   |   10 +
 include/acpi/hed.h                        |   18 +
 include/acpi/processor.h                  |   13 -
 include/acpi/video.h                      |   16 +
 include/linux/acpi.h                      |    1 -
 include/linux/cper.h                      |  314 +++++++++++
 include/linux/debugfs.h                   |    2 +
 include/linux/pci.h                       |    3 +-
 include/linux/uuid.h                      |   70 +++
 lib/Makefile                              |    2 +-
 lib/uuid.c                                |   53 ++
 59 files changed, 4472 insertions(+), 471 deletions(-)
 create mode 100644 Documentation/acpi/apei/einj.txt
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-apei.c
 create mode 100644 drivers/acpi/apei/Kconfig
 create mode 100644 drivers/acpi/apei/Makefile
 create mode 100644 drivers/acpi/apei/apei-base.c
 create mode 100644 drivers/acpi/apei/apei-internal.h
 create mode 100644 drivers/acpi/apei/cper.c
 create mode 100644 drivers/acpi/apei/einj.c
 create mode 100644 drivers/acpi/apei/erst.c
 create mode 100644 drivers/acpi/apei/ghes.c
 create mode 100644 drivers/acpi/apei/hest.c
 create mode 100644 drivers/acpi/atomicio.c
 create mode 100644 drivers/acpi/hed.c
 delete mode 100644 drivers/acpi/hest.c
 delete mode 100644 include/acpi/acpi_hest.h
 create mode 100644 include/acpi/apei.h
 create mode 100644 include/acpi/atomicio.h
 create mode 100644 include/acpi/hed.h
 create mode 100644 include/linux/cper.h
 create mode 100644 include/linux/uuid.h
 create mode 100644 lib/uuid.c

through these commits:

Andrea Gelmini (1):
      drivers/acpi/sleep.h: Checkpatch cleanup

Bjorn Helgaas (2):
      ACPI: pci_root: save downstream bus range
      ACPI: pci_root: pass acpi_pci_root to arch-specific scan

Huang Ying (14):
      ACPI, IO memory pre-mapping and atomic accessing
      ACPI, APEI, APEI supporting infrastructure
      ACPI, APEI, HEST table parsing
      ACPI, APEI, EINJ support
      ACPI, APEI, Document for APEI
      ACPI, APEI, PCIE AER, use general HEST table parsing in AER firmware_first setup
      ACPI Hardware Error Device (PNP0C33) support
      Unified UUID/GUID definition
      ACPI, APEI, UEFI Common Platform Error Record (CPER) header
      ACPI, APEI, Generic Hardware Error Source memory error support
      ACPI, APEI, Error Record Serialization Table (ERST) support
      ACPI, APEI, Use ERST for persistent storage of MCE
      Add x64 support to debugfs
      ACPI, APEI, EINJ injection parameters support

Julia Lawall (2):
      drivers/acpi: use kasprintf
      ACPI: EC: Use kmemdup

Kamal Mostafa (1):
      ACPI: video: fix acpi_backlight=video

Len Brown (3):
      ACPI: delete the "acpi=ht" boot option
      ACPICA: simplify SCI_EN workaround
      ACPI: delete unused c-state promotion/demotion data strucutures

Matthew Garrett (2):
      ACPI: Export EDID blocks to the kernel
      ACPI: Unconditionally set SCI_EN on resume

Venkatesh Pallipadi (2):
      ACPI: Minor cleanup eliminating redundant PMTIMER_TICKS to NS conversion
      ACPI: Don't let acpi_pad needlessly mark TSC unstable

with this log:

commit d3b383338f105f50724c10a7d81b04a3930e886b
Merge: edbe77b 68ca406
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 16:20:35 2010 -0400

    Merge branch 'ht-delete-2.6.35' into release

commit edbe77ba94217868caf5f391d2a083729bef3742
Merge: 64a4222 0dc698b
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 16:18:20 2010 -0400

    Merge branch 'misc-2.6.35' into release

commit 64a4222f7e087b5030eff0f6e47285696089d983
Merge: 91dd696 eeb4bcb e92a716
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 16:18:12 2010 -0400

    Merge branches 'video' and 'video-edid' into release

commit 91dd6964390b331beb731623cb59c4a933ff8162
Merge: dc1544e b6dacf6
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 16:17:27 2010 -0400

    Merge branch 'acpi_enable' into release

commit dc1544ea5d6dfdf29440295788e639e4b44c605a
Merge: 6e320ec 5728377
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 16:17:16 2010 -0400

    Merge branch 'bjorn-pci-root-v4-2.6.35' into release

commit 0dc698b93f3eecdda43b22232131324eb41e510c
Author: Venkatesh Pallipadi <venki@google.com>
Date:   Tue May 18 14:39:16 2010 -0700

    ACPI: Don't let acpi_pad needlessly mark TSC unstable
    
    acpi pad driver kind of aggressively marks TSC as unstable at init
    time, on mwait capable and non X86_FEATURE_NONSTOP_TSC systems. This is
    irrespective of whether pad driver is ever going to be used on the
    system or deep C-states are supported/used. This will affect every user
    who just happens to compile in (or get a kernel version which
    compiles in) acpi pad driver.
    
    Move mark_tsc_unstable() out of init to the actual idle invocation path
    of the pad driver.
    
    There is also another bug/missing_feature in the code that it does not
    support 'always running apic timer' and switches to broadcast mode
    unconditionally. Shaohua, can you take a look at that please.
    
    Signed-off-by: Venkatesh Pallipadi <venki@google.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b6fecaa8685a9922d11db2cd79e76f43c3edc970
Author: Andrea Gelmini <andrea.gelmini@gelma.net>
Date:   Sat Feb 27 17:51:42 2010 +0100

    drivers/acpi/sleep.h: Checkpatch cleanup
    
    drivers/acpi/sleep.h:3: WARNING: space prohibited between function name and open parenthesis '('
    
    Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2da513f582a96c053aacc2c92873978d2ea7abff
Author: Venkatesh Pallipadi <venki@google.com>
Date:   Thu Apr 22 16:48:33 2010 -0700

    ACPI: Minor cleanup eliminating redundant PMTIMER_TICKS to NS conversion
    
    acpi_enter_[simple,bm] does
    idle timing in ns, convert it to timeval, then to us, then to
    pmtimer_ticks and then back to ns.
    
    This patch changes things to
    idle timing in ns, convert it to us, and then to pmtimer_ticks.
    
    Just saves an imul along this path, but makes the code cleaner.
    
    Signed-off-by: Venkatesh Pallipadi <venki@google.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 34a18d6fe5430184e4ca96eeb074ee671d89fe7b
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 21 19:40:02 2010 -0400

    ACPI: delete unused c-state promotion/demotion data strucutures
    
    These were used before cpuidle by the native ACPI idle driver,
    which tracked promotion and demotion between states.
    
    The code was referenced by CONFIG_ACPI_PROCFS
    for /proc/acpi/processor/*/power,
    but as we no longer do promotion/demotion, that
    reference has been a NOP since the transition.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eeb4bcb4771679d7b3446c0293334faee11b090a
Author: Kamal Mostafa <kamal@canonical.com>
Date:   Sat May 1 12:09:49 2010 -0700

    ACPI: video: fix acpi_backlight=video
    
    Make "acpi_backlight=video" param enable ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO
    as intended, instead of incorrectly enabling video output switching.
    
    BugLink: http://bugs.launchpad.net/bugs/573120
    
    Signed-off-by: Kamal Mostafa <kamal@canonical.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Cc: Jiri Kosina <jkosina@suse.cz>
    Cc: <stable@kernel.org>
    Acked-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d6bd535d88429b4804d6d917ab4f586306f9a855
Author: Julia Lawall <julia@diku.dk>
Date:   Sat May 15 23:16:21 2010 +0200

    ACPI: EC: Use kmemdup
    
    Use kmemdup when some other buffer is immediately copied into the
    allocated region.
    
    A simplified version of the semantic patch that makes this change is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression from,to,size,flag;
    statement S;
    @@
    
    -  to = \(kmalloc\|kzalloc\)(size,flag);
    +  to = kmemdup(from,size,flag);
       if (to==NULL || ...) S
    -  memcpy(to, from, size);
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aeb834d95e771499cb0492d127aec3246d1595c8
Author: Julia Lawall <julia@diku.dk>
Date:   Tue Apr 27 14:06:04 2010 -0700

    drivers/acpi: use kasprintf
    
    kasprintf combines kmalloc and sprintf, and takes care of the size
    calculation itself.
    
    The semantic patch that makes this change is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression a,flag;
    expression list args;
    statement S;
    @@
    
      a =
    -  \(kmalloc\|kzalloc\)(...,flag)
    +  kasprintf(flag,args)
      <... when != a
      if (a == NULL || ...) S
      ...>
    - sprintf(a,args);
    // </smpl>
    
    [akpm@linux-foundation.org: don't change handling of `count']
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6e320ec1d98f9eb93d5b2a5d70e2f40dce923f1b
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:24 2010 +0800

    ACPI, APEI, EINJ injection parameters support
    
    Some hardware error injection needs parameters, for example, it is
    useful to specify memory address and memory address mask for memory
    errors.
    
    Some BIOSes allow parameters to be specified via an unpublished
    extension. This patch adds support to it. The parameters will be
    ignored on machines without necessary BIOS support.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 15b0beaa332b3923cce2ed109e0fb141ec1425d9
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:23 2010 +0800

    Add x64 support to debugfs
    
    Add debugfs_create_x64. This is needed by ACPI APEI EINJ parameters support.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 482908b49ebfa453dd0455910c951c750567c05d
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:22 2010 +0800

    ACPI, APEI, Use ERST for persistent storage of MCE
    
    Traditionally, fatal MCE will cause Linux print error log to console
    then reboot. Because MCE registers will preserve their content after
    warm reboot, the hardware error can be logged to disk or network after
    reboot. But system may fail to warm reboot, then you may lose the
    hardware error log. ERST can help here. Through saving the hardware
    error log into flash via ERST before go panic, the hardware error log
    can be gotten from the flash after system boot successful again.
    
    The fatal MCE processing procedure with ERST involved is as follow:
    
    - Hardware detect error, MCE raised
    - MCE read MCE registers, check error severity (fatal), prepare error record
    - Write MCE error record into flash via ERST
    - Go panic, then trigger system reboot
    - System reboot, /sbin/mcelog run, it reads /dev/mcelog to check flash
      for error record of previous boot via ERST, and output and clear
      them if available
    - /sbin/mcelog logs error records into disk or network
    
    ERST only accepts CPER record format, but there is no pre-defined CPER
    section can accommodate all information in struct mce, so a customized
    section type is defined to hold struct mce inside a CPER record as an
    error section.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a08f82d08053fb6e3aa3635c2c26456d96337c8b
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:21 2010 +0800

    ACPI, APEI, Error Record Serialization Table (ERST) support
    
    ERST is a way provided by APEI to save and retrieve hardware error
    record to and from some simple persistent storage (such as flash).
    
    The Linux kernel support implementation is quite simple and workable
    in NMI context. So it can be used to save hardware error record into
    flash in hardware error exception or NMI handler, where other more
    complex persistent storage such as disk is not usable. After saving
    hardware error records via ERST in hardware error exception or NMI
    handler, the error records can be retrieved and logged into disk or
    network after a clean reboot.
    
    For more information about ERST, please refer to ACPI Specification
    version 4.0, section 17.4.
    
    This patch incorporate fixes from Jin Dongming.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    CC: Jin Dongming <jin.dongming@np.css.fujitsu.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d334a49113a4a33109fd24e46073280ecd1bea0d
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:20 2010 +0800

    ACPI, APEI, Generic Hardware Error Source memory error support
    
    Generic Hardware Error Source provides a way to report platform
    hardware errors (such as that from chipset). It works in so called
    "Firmware First" mode, that is, hardware errors are reported to
    firmware firstly, then reported to Linux by firmware. This way, some
    non-standard hardware error registers or non-standard hardware link
    can be checked by firmware to produce more valuable hardware error
    information for Linux.
    
    Now, only SCI notification type and memory errors are supported. More
    notification type and hardware error type will be added later. These
    memory errors are reported to user space through /dev/mcelog via
    faking a corrected Machine Check, so that the error memory page can be
    offlined by /sbin/mcelog if the error count for one page is beyond the
    threshold.
    
    On some machines, Machine Check can not report physical address for
    some corrected memory errors, but GHES can do that. So this simplified
    GHES is implemented firstly.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 06d65deade9aabba58e0518df86dcd324e86b832
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:19 2010 +0800

    ACPI, APEI, UEFI Common Platform Error Record (CPER) header
    
    CPER stands for Common Platform Error Record, it is the hardware error
    record format used to describe platform hardware error by various APEI
    tables, such as ERST, BERT and HEST etc.
    
    For more information about CPER, please refer to Appendix N of UEFI
    Specification version 2.3.
    
    This patch mainly includes the data structure difinition header file
    used by other files.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fab1c23242528771a955c475ef23d99156a71a7f
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:18 2010 +0800

    Unified UUID/GUID definition
    
    There are many different UUID/GUID definitions in kernel, such as that
    in EFI, many file systems, some drivers, etc. Every kernel components
    need UUID/GUID has its own definition. This patch provides a unified
    definition for UUID/GUID.
    
    UUID is defined via typedef. This makes that UUID appears more like a
    preliminary type, and makes the data type explicit (comparing with
    implicit "u8 uuid[16]").
    
    The binary representation of UUID/GUID can be little-endian (used by
    EFI, etc) or big-endian (defined by RFC4122), so both is defined.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 801eab8118f61255d8e2be35939c572042618742
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:17 2010 +0800

    ACPI Hardware Error Device (PNP0C33) support
    
    Hardware Error Device (PNP0C33) is used to report some hardware errors
    notified via SCI, mainly the corrected errors. Some APEI Generic
    Hardware Error Source (GHES) may use SCI on hardware error device to
    notify hardware error to kernel.
    
    After receiving notification from ACPI core, it is forwarded to all
    listeners via a notifier chain. The listener such as APEI GHES should
    check corresponding error source for new events when notified.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit affb72c3a8984ba55e055b0a0228c3ea1a056758
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:16 2010 +0800

    ACPI, APEI, PCIE AER, use general HEST table parsing in AER firmware_first setup
    
    Now, a dedicated HEST tabling parsing code is used for PCIE AER
    firmware_first setup. It is rebased on general HEST tabling parsing
    code of APEI. The firmware_first setup code is moved from PCI core to
    AER driver too, because it is only AER related.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea8c071cad789b1919355fc7a67182a5c9994e6b
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:15 2010 +0800

    ACPI, APEI, Document for APEI
    
    Add document for APEI, including kernel parameters and EINJ debug file
    sytem interface.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e40213450b53157967a1f83eda50e9a941c13a08
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:14 2010 +0800

    ACPI, APEI, EINJ support
    
    EINJ provides a hardware error injection mechanism, this is useful for
    debugging and testing of other APEI and RAS features.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9dc966641677795f4d6b0a9ba630d6a3a3e24a57
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:13 2010 +0800

    ACPI, APEI, HEST table parsing
    
    HEST describes error sources in detail; communicating operational
    parameters (i.e. severity levels, masking bits, and threshold values)
    to OS as necessary. It also allows the platform to report error
    sources for which OS would typically not implement support (for
    example, chipset-specific error registers).
    
    HEST information may be needed by other subsystems. For example, HEST
    PCIE AER error source information describes whether a PCIE root port
    works in "firmware first" mode, this is needed by general PCIE AER
    error subsystem. So a public HEST tabling parsing interface is
    provided.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a643ce207f3e70030bdb431e2a363cc111a60c1a
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:12 2010 +0800

    ACPI, APEI, APEI supporting infrastructure
    
    APEI stands for ACPI Platform Error Interface, which allows to report
    errors (for example from the chipset) to the operating system. This
    improves NMI handling especially. In addition it supports error
    serialization and error injection.
    
    For more information about APEI, please refer to ACPI Specification
    version 4.0, chapter 17.
    
    This patch provides some common functions used by more than one APEI
    tables, mainly framework of interpreter for EINJ and ERST.
    
    A machine readable language is defined for EINJ and ERST for OS to
    execute, and so to drive the firmware to fulfill the corresponding
    functions. The machine language for EINJ and ERST is compatible, so a
    common framework is defined for them.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 15651291a2f8c11e7e6a42d8bfde7a213ff13262
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue May 18 14:35:11 2010 +0800

    ACPI, IO memory pre-mapping and atomic accessing
    
    Some ACPI IO accessing need to be done in atomic context. For example,
    APEI ERST operations may be used for permanent storage in hardware
    error handler. That is, it may be called in atomic contexts such as
    IRQ or NMI, etc. And, ERST/EINJ implement their operations via IO
    memory/port accessing.  But the IO memory accessing method provided by
    ACPI (acpi_read/acpi_write) maps the IO memory during it is accessed,
    so it can not be used in atomic context. To solve the issue, the IO
    memory should be pre-mapped during EINJ/ERST initializing. A linked
    list is used to record which memory area has been mapped, when memory
    is accessed in hardware error handler, search the linked list for the
    mapped virtual address from the given physical address.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b6dacf63e9fb2e7a1369843d6cef332f76fca6a3
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue May 11 13:49:25 2010 -0400

    ACPI: Unconditionally set SCI_EN on resume
    
    The ACPI spec tells us that the firmware will reenable SCI_EN on resume.
    Reality disagrees in some cases. The ACPI spec tells us that the only way
    to set SCI_EN is via an SMM call.
    https://bugzilla.kernel.org/show_bug.cgi?id=13745 shows us that doing so
    may break machines. Tracing the ACPI calls made by Windows shows that it
    unconditionally sets SCI_EN on resume with a direct register write, and
    therefore the overwhelming probability is that everything is fine with
    this behaviour.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b430acbd7c4b919886fa7fd92eeb7a695f1940d3
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 6 17:41:08 2010 -0400

    ACPICA: simplify SCI_EN workaround
    
    acpi_hw_set_mode() double checks its effectiveness
    by calling acpi_hw_get_mode() -- polling up to 3 seconds.
    
    It would be more logical for its caller, acpi_enable()
    acpi_enable() to do the double-checking.  (lets assume
    that acpi_disable() isn't interesting)
    
    The ACPI specification is unclear on this point.
    Some parts say that the BIOS sets SCI_EN and then returns to the OS,
    but one part says "OSPM polls the SCI_EN bit until it is sampled SET".
    
    The systems I have on hand do the former,
    SCI_EN is observed to be set upon return from the BIOS.
    
    So we move the check up out of acpi_hw_set_mode()
    up into acpi_enable() where it makes logical sense.
    
    Then we replace the 3-second polling loop
    with a single check.  If this check fails, we'll see:
    
    	"Hardware did not enter ACPI mode"
    
    and the system will bail out of ACPI initialization
    and likely fail to boot.  If we see that in practice,
    we can restore the polling, but put it into acpi_enable.
    
    This patch is important if acpi_enable() is used in
    the resume from S3 path.  Many systems today are seen
    coming back from S3 with SCI_EN off, and then failing
    to set SCI_EN in response to acpi_enable().  Those systems
    will take 3 seconds longer to resume due to this loop.
    
    However, it is possible that we will not use acpi_enable()
    in the S3 resume path, and bang SCI_EN directly, which
    would make the loop harmless, as it would be invisible
    to all systems except those that need it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e92a716240258989f19c7345e8b135e6d214431a
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue Jan 12 14:17:03 2010 -0500

    ACPI: Export EDID blocks to the kernel
    
    The ACPI spec includes a provision for hardware to provide EDID via the
    ACPI video extension. In the KMS world it's necessary for a way to obtain
    this from within the kernel. Add a function that either returns the EDID
    for the provided ACPI display ID or the first display of the provided type.
    Also add support for ensuring that devices with legacy IDs are supported.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57283776b2b821ba4d592f61cad04d0293412740
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Mar 11 12:20:11 2010 -0700

    ACPI: pci_root: pass acpi_pci_root to arch-specific scan
    
    The acpi_pci_root structure contains all the individual items (acpi_device,
    domain, bus number) we pass to pci_acpi_scan_root(), so just pass the
    single acpi_pci_root pointer directly.
    
    This will make it easier to add _CBA support later.  For _CBA, we need the
    entire downstream bus range, not just the base bus number.  We have that in
    the acpi_pci_root structure, so passing the pointer makes it available to
    the arch-specific code.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6ad95513d60096b569e4e4bd721420f03b57e4d4
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Mar 11 12:20:06 2010 -0700

    ACPI: pci_root: save downstream bus range
    
    Previously, we only saved the root bus number, i.e., the beginning of the
    downstream bus range.  We now support IORESOURCE_BUS resources, so this
    patch uses that to keep track of both the beginning and the end of the
    downstream bus range.
    
    It's important to know both the beginning and the end for supporting _CBA
    (see PCI Firmware spec, rev 3.0, sec 4.1.3) and so we know the limits for
    any possible PCI bus renumbering (we can't renumber downstream buses to be
    outside the bus number range claimed by the host bridge).
    
    It's clear from the spec that the bus range is supposed to be in _CRS, but
    if we don't find it there, we'll assume [_BBN - 0xFF] or [0 - 0xFF].
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 68ca406930d6380b3be7ada5f15fcf85bfcbd552
Author: Len Brown <len.brown@intel.com>
Date:   Fri Feb 19 00:09:22 2010 -0500

    ACPI: delete the "acpi=ht" boot option
    
    acpi=ht was important in 2003 -- before ACPI was
    universally deployed and enabled by default in
    the major Linux distributions.
    
    At that time, there were a fair number of people who
    or chose to, or needed to, run with acpi=off,
    yet also wanted access to Hyper-threading.
    
    Today we find that many invocations of "acpi=ht"
    are accidental, and thus is it possible that it
    is doing more harm than good.
    
    In 2.6.34, we warn on invocation of acpi=ht.
    In 2.6.35, we delete the boot option.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
