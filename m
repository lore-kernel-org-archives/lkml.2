Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0ETFZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:25:53 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:64405 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0ETFZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:25:51 -0400
Date: Thu, 20 May 2010 01:25:35 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@acpica.org
Subject: [git pull request] ACPICA patches for Linux-2.6.35
Message-id: <alpine.LFD.2.00.1005200121250.2921@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git acpica

This will update the files shown below.

Nothing Earth-shaking in this ACPICA update.
The most "interesting", perhaps, is a workaround we had to put in place
for some Toshiba machines which corrupt their DSDT at run-time.

thanks,
Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.34/acpi-acpica-20100428-2.6.34-rc5.diff.gz

 Documentation/kernel-parameters.txt |    1 +
 arch/x86/kernel/acpi/boot.c         |    4 +
 drivers/acpi/acpica/Makefile        |    4 +-
 drivers/acpi/acpica/acevents.h      |   51 ++-
 drivers/acpi/acpica/acglobal.h      |   25 +-
 drivers/acpi/acpica/acinterp.h      |    9 +-
 drivers/acpi/acpica/aclocal.h       |   19 +-
 drivers/acpi/acpica/actables.h      |    4 +
 drivers/acpi/acpica/dsfield.c       |    2 +-
 drivers/acpi/acpica/dsmethod.c      |    2 +-
 drivers/acpi/acpica/dsmthdat.c      |   10 +-
 drivers/acpi/acpica/dsobject.c      |   14 +-
 drivers/acpi/acpica/dsopcode.c      |   13 +-
 drivers/acpi/acpica/dswexec.c       |    6 +-
 drivers/acpi/acpica/dswstate.c      |   10 +-
 drivers/acpi/acpica/evevent.c       |    2 +-
 drivers/acpi/acpica/evgpe.c         |  167 ++++++---
 drivers/acpi/acpica/evgpeblk.c      |  766 +++--------------------------------
 drivers/acpi/acpica/evgpeinit.c     |  653 +++++++++++++++++++++++++++++
 drivers/acpi/acpica/evgpeutil.c     |  337 +++++++++++++++
 drivers/acpi/acpica/evmisc.c        |    2 +-
 drivers/acpi/acpica/evxface.c       |   24 +-
 drivers/acpi/acpica/evxfevnt.c      |  191 +++++----
 drivers/acpi/acpica/exconfig.c      |   21 +-
 drivers/acpi/acpica/exconvrt.c      |    4 +-
 drivers/acpi/acpica/excreate.c      |    4 +-
 drivers/acpi/acpica/exdebug.c       |  261 ++++++++++++
 drivers/acpi/acpica/exfield.c       |    2 +-
 drivers/acpi/acpica/exfldio.c       |   16 +-
 drivers/acpi/acpica/exmisc.c        |    8 +-
 drivers/acpi/acpica/exmutex.c       |   46 +-
 drivers/acpi/acpica/exnames.c       |    4 +-
 drivers/acpi/acpica/exoparg1.c      |   18 +-
 drivers/acpi/acpica/exoparg2.c      |   37 +--
 drivers/acpi/acpica/exoparg3.c      |    4 +-
 drivers/acpi/acpica/exoparg6.c      |    4 +-
 drivers/acpi/acpica/exprep.c        |    4 +-
 drivers/acpi/acpica/exregion.c      |   17 +-
 drivers/acpi/acpica/exresnte.c      |    4 +-
 drivers/acpi/acpica/exresolv.c      |   11 +-
 drivers/acpi/acpica/exresop.c       |    8 +-
 drivers/acpi/acpica/exstore.c       |  218 +----------
 drivers/acpi/acpica/exsystem.c      |   10 +-
 drivers/acpi/acpica/hwregs.c        |    6 +-
 drivers/acpi/acpica/hwsleep.c       |    2 +-
 drivers/acpi/acpica/hwvalid.c       |    2 +-
 drivers/acpi/acpica/nsaccess.c      |    2 +-
 drivers/acpi/acpica/nsdump.c        |    4 +-
 drivers/acpi/acpica/nsnames.c       |    2 +-
 drivers/acpi/acpica/nssearch.c      |    2 +-
 drivers/acpi/acpica/nsutils.c       |    4 +-
 drivers/acpi/acpica/psargs.c        |    4 +-
 drivers/acpi/acpica/psloop.c        |    3 +-
 drivers/acpi/acpica/psxface.c       |    5 +
 drivers/acpi/acpica/rscreate.c      |   14 +-
 drivers/acpi/acpica/rslist.c        |    6 +-
 drivers/acpi/acpica/rsmisc.c        |    4 +-
 drivers/acpi/acpica/tbfadt.c        |   16 +-
 drivers/acpi/acpica/tbfind.c        |    2 +-
 drivers/acpi/acpica/tbinstal.c      |   69 ++--
 drivers/acpi/acpica/tbutils.c       |  101 ++++-
 drivers/acpi/acpica/tbxface.c       |   80 +++-
 drivers/acpi/acpica/tbxfroot.c      |    6 +-
 drivers/acpi/acpica/utalloc.c       |    2 +-
 drivers/acpi/acpica/utcopy.c        |   14 +-
 drivers/acpi/acpica/utdelete.c      |    6 +-
 drivers/acpi/acpica/uteval.c        |    2 +-
 drivers/acpi/acpica/utglobal.c      |    1 +
 drivers/acpi/acpica/utmisc.c        |    6 +-
 drivers/acpi/acpica/utmutex.c       |    4 +-
 drivers/acpi/acpica/utobject.c      |    8 +-
 drivers/acpi/bus.c                  |   44 ++
 drivers/acpi/scan.c                 |    2 +-
 drivers/acpi/system.c               |    5 +-
 include/acpi/acexcep.h              |    2 +-
 include/acpi/acoutput.h             |    2 +
 include/acpi/acpiosxf.h             |    4 +-
 include/acpi/acpixf.h               |   43 +-
 include/acpi/actbl2.h               |   27 ++
 include/acpi/actypes.h              |   44 +-
 80 files changed, 2143 insertions(+), 1424 deletions(-)
 create mode 100644 drivers/acpi/acpica/evgpeinit.c
 create mode 100644 drivers/acpi/acpica/evgpeutil.c
 create mode 100644 drivers/acpi/acpica/exdebug.c

through these commits:

Alexey Starikovskiy (1):
      ACPICA: Fix for acpi_reallocate_root_table for incorrect root table copy

Bob Moore (12):
      ACPICA: Add support for MCHI table
      ACPICA: Standardize integer output for ACPICA warnings/errors
      ACPICA: Update version to 20100304
      ACPICA: Update comments/headers, no functional change
      ACPICA: Add write support for DataTable operation regions
      ACPICA: Update DSDT copy/detection.
      ACPICA: Clarify/rename some root table descriptor fields
      ACPICA: Add GPE support for dynamically loaded ACPI tables
      ACPICA: Split large file, evgpeblk
      ACPICA: Rename acpi_ex_system_do_suspend->acpi_ex_system_do_sleep
      ACPICA: Update/clarify some parameter names associated with acpi_handle
      ACPICA: Update version to 20100428.

Lin Ming (8):
      ACPICA: Enhance configuration for output of AML Debug Object
      ACPICA: Fix for possible fault in acpi_ex_release_mutex
      ACPICA: Add detection of corrupted/replaced DSDT
      ACPICA: Add subsystem option to force copy of DSDT to local memory
      ACPI: add boot option acpi=copy_dsdt to fix corrupt DSDT
      ACPICA: Minimize the differences between linux GPE code and ACPICA code base
      ACPICA: Prevent possible allocation overrun during object copy
      ACPI: fix early DSDT dmi check warnings on ia64

Robert Moore (1):
      ACPICA: Update version to 20100331.

with this log:

commit cce4f632db200aef147c59084437168174b23f11
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed May 12 09:26:48 2010 +0800

    ACPI: fix early DSDT dmi check warnings on ia64
    
    WARNING: at drivers/firmware/dmi_scan.c:423 dmi_matches+0x70/0x160()
    dmi check: not initialized yet.
    
    This is caused by commit aa2110c
    (ACPI: add boot option acpi=copy_dsdt to fix corrupt DSDT).
    DMI is not initialized yet in acpi_early_init on ia64.
    
    The DSDT DMI check table is x86 specific, so make it empty on other archs.
    And this fixes the warnings on ia64.
    
    Reported-and-tested-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2aae2d918d88fdf0f8c066520cda0a30409db23f
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 6 13:59:07 2010 +0800

    ACPICA: Update version to 20100428.
    
    Version 20100428.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b47cf58edfa15cb8f384a4a5e7e7d65babb602f6
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Apr 27 11:54:40 2010 +0800

    ACPICA: Update/clarify some parameter names associated with acpi_handle
    
    Simple rename of some parameters to standardize them.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ada241dcec7eb21ff1690a1ba6213299b743bb5b
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Apr 27 11:48:02 2010 +0800

    ACPICA: Rename acpi_ex_system_do_suspend->acpi_ex_system_do_sleep
    
    Suspend has other meanings in ACPI context, name was misleading.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 17b82327f3e7ab5a068f8019768008ee82d912be
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Apr 27 11:46:25 2010 +0800

    ACPICA: Prevent possible allocation overrun during object copy
    
    Original code did not handle the case where the object to be
    copied was a namespace node.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3fe50208b29b2463eb6c181c1433dd1beb39f282
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Apr 27 11:41:19 2010 +0800

    ACPICA: Split large file, evgpeblk
    
    Create two new files, evgpeinit.c and evgpeutil.c. Updated
    unix and linux makefiles.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 186c307f008d2a53961cd970aaf7cb9c33e79cb1
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Apr 27 11:32:28 2010 +0800

    ACPICA: Add GPE support for dynamically loaded ACPI tables
    
    For all GPEs, including FADT-based and GPE Block Devices, execute
    any _PRW methods in the new table, and process any _Lxx/_Exx GPE
    methods in the new table. Any runtime GPE that is referred to
    by an _Lxx/_Exx method in the new table is immediately enabled.
    ACPICA BZ 833.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=833
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b9ee2043096b02e5da8c62f9a8a8f2e172b3606b
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Apr 27 11:16:14 2010 +0800

    ACPICA: Clarify/rename some root table descriptor fields
    
    Original fields were not very descriptive and led to maintenance
    problems.  New fields should help to understand the existing code.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4eb0450c5d61dd0064ef0904d74088d35284ae2
Author: Robert Moore <robert.moore@intel.com>
Date:   Thu Apr 8 14:57:43 2010 +0800

    ACPICA: Update version to 20100331.
    
    Version 20100331.
    
    Signed-off-by: Robert Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f849d2cc6863c7874889ea60a871fb71399dd3f
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Apr 6 14:52:37 2010 +0800

    ACPICA: Minimize the differences between linux GPE code and ACPICA code base
    
    We have ported Rafael's major GPE changes
    (ACPI: Use GPE reference counting to support shared GPEs) into ACPICA code base.
    But the port and Rafael's original patch have some differences, so we made
    below patch to make linux GPE code consistent with ACPICA code base.
    
    Most changes are about comments and coding styles.
    Other noticeable changes are based on:
    
    Rafael: Reduce code duplication related to GPE lookup
    https://patchwork.kernel.org/patch/86237/
    
    Rafael: Always use the same lock for GPE locking
    https://patchwork.kernel.org/patch/90471/
    
    A new field gpe_count in struct acpi_gpe_block_info to record the number
    of individual GPEs in block.
    
    Rename acpi_ev_save_method_info to acpi_ev_match_gpe_method.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Robert Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aa2110cb1a7510f9b834adfb39b05d4843a35d35
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 8 14:34:27 2010 +0800

    ACPI: add boot option acpi=copy_dsdt to fix corrupt DSDT
    
    Some BIOS on Toshiba machines corrupt the DSDT, so add a new
    boot option acpi=copy_dsdt to workaround it.
    Add warning message to ask users to use this option if corrupt DSDT detected.
    
    Also build a DMI blacklist to check it and automatically copy DSDT.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=14679
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 43323cb4c4b619414913f54fef9d492aabadd033
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 7 11:05:11 2010 +0800

    ACPICA: Update DSDT copy/detection.
    
    Move initialization of DSDT pointer. Emit address of DSDT
    in the dump of both table headers (good/bad DSDT).
    Now handles the case where the root table can be reallocated,
    which would invalidate the original pointer.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 69ec87efa815d69140423014bb5f91e034faac22
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 1 11:14:12 2010 +0800

    ACPICA: Add subsystem option to force copy of DSDT to local memory
    
    Optionally copy the entire DSDT to local memory (instead of
    simply mapping it.) There are some BIOSs that corrupt or replace
    the original DSDT, creating the need for this option. Default is
    FALSE, do not copy the DSDT.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=14679
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 729df0f848daf2f17d02107199fa92efe909d995
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 1 10:47:56 2010 +0800

    ACPICA: Add detection of corrupted/replaced DSDT
    
    This change adds support to detect a DSDT that has been corrupted
    and/or replaced from outside the OS (by firmware). This is
    typically catastrophic for the system, but has been seen on
    some machines.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=14679
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1637e9c649a0eb72c467041d78275aabdd48a41
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 1 11:09:00 2010 +0800

    ACPICA: Add write support for DataTable operation regions
    
    The original implementation only supported reading from a DataTable
    region. However, some machines have been seen that actually write
    to the ACPI table contained in such a region. This change adds
    support for writing to a DataTable region.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 333b04ae338e3421297d46c508f053a6767d2883
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Apr 1 11:06:34 2010 +0800

    ACPICA: Fix for acpi_reallocate_root_table for incorrect root table copy
    
    When copying the root table to the new allocation, the length
    used was incorrect. The new size was used instead of the current
    table size, meaning too much data was copied.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a7499bc84eabb200f9dc23770a46d9a31b1e763a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 1 11:04:54 2010 +0800

    ACPICA: Update comments/headers, no functional change
    
    Also split some long lines.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 21e44ba85b0bc9ec970dd2ddb37966ef8c23ad24
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Mar 5 18:01:03 2010 +0800

    ACPICA: Update version to 20100304
    
    Version 20100304.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0f40281d52161dddeb1bc12879425266a53f26f
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Mar 5 17:59:54 2010 +0800

    ACPICA: Fix for possible fault in acpi_ex_release_mutex
    
    Fixed a problem with the AML Mutex handling function
    acpi_ex_release_mutex where the function could fault under the very
    rare condition when the interpreter has blocked, the interpreter
    lock is released, the interpreter is then reentered via the
    same thread, and attempts to acquire a mutex that was previously
    acquired. FreeBSD report 140979.
    
    http://www.freebsd.org/cgi/query-pr.cgi?pr=140979
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f6a22b0bc417042e83117f52ab1a03696af185ab
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Mar 5 17:56:40 2010 +0800

    ACPICA: Standardize integer output for ACPICA warnings/errors
    
    Always use 0x prefix for hex output, use %u for integer output
    (all integers are unsigned.)
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0e264f0bc22207b99f33ee06e614186480682f15
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Mar 3 16:30:35 2010 +0800

    ACPICA: Add support for MCHI table
    
    Disassembler and header file support for MCHI - Managment
    Controller Host Interface table.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4cdf1a562bfb5852954aadbe8515557b8acc8168
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Mar 3 16:28:28 2010 +0800

    ACPICA: Enhance configuration for output of AML Debug Object
    
    This change will enable debug object output via a global variable,
    acpi_gbl_enable_aml_debug_object. This will help with remote machine
    debugging. Also, moved all debug object support code to a new
    file, exdebug.c. Entire debug object module can now be
    configured out of the ACPICA build if desired.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
