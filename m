Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab0HEXQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:16:24 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:63900 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab0HEXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:16:21 -0400
Date: Thu, 05 Aug 2010 19:15:57 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, devel@acpica.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPICA patches for Linux 2.6.36-merge
Message-id: <alpine.LFD.2.00.1008051914130.5386@localhost.localdomain>
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

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.35/acpi-acpica-20100702-2.6.35-rc4.diff.gz

 drivers/acpi/acpica/acevents.h  |    4 +-
 drivers/acpi/acpica/acglobal.h  |    7 -
 drivers/acpi/acpica/achware.h   |    5 +-
 drivers/acpi/acpica/aclocal.h   |    6 +-
 drivers/acpi/acpica/acnamesp.h  |    7 -
 drivers/acpi/acpica/acobject.h  |   16 ++--
 drivers/acpi/acpica/acpredef.h  |   13 +-
 drivers/acpi/acpica/acstruct.h  |   32 +++---
 drivers/acpi/acpica/dsinit.c    |   14 +-
 drivers/acpi/acpica/dsmethod.c  |   20 +++-
 drivers/acpi/acpica/dsmthdat.c  |   16 +--
 drivers/acpi/acpica/dsobject.c  |   16 +++-
 drivers/acpi/acpica/dsopcode.c  |    6 +-
 drivers/acpi/acpica/dsutils.c   |    4 +-
 drivers/acpi/acpica/evevent.c   |    5 +-
 drivers/acpi/acpica/evgpe.c     |   69 +++++++++---
 drivers/acpi/acpica/evgpeblk.c  |   70 ++---------
 drivers/acpi/acpica/evgpeinit.c |  236 +++----------------------------------
 drivers/acpi/acpica/evrgnini.c  |   10 +-
 drivers/acpi/acpica/evxfevnt.c  |  249 ++++++++++++++++-----------------------
 drivers/acpi/acpica/exconfig.c  |    2 +-
 drivers/acpi/acpica/exdump.c    |    6 +-
 drivers/acpi/acpica/exfldio.c   |    4 +-
 drivers/acpi/acpica/exprep.c    |   23 +---
 drivers/acpi/acpica/exregion.c  |    6 +-
 drivers/acpi/acpica/hwgpe.c     |   35 +-----
 drivers/acpi/acpica/hwsleep.c   |    2 +-
 drivers/acpi/acpica/nsaccess.c  |    9 +-
 drivers/acpi/acpica/nsalloc.c   |   94 +++++++--------
 drivers/acpi/acpica/nsdump.c    |    2 +-
 drivers/acpi/acpica/nsinit.c    |   16 ++--
 drivers/acpi/acpica/nsnames.c   |    4 +-
 drivers/acpi/acpica/nsparse.c   |    4 +-
 drivers/acpi/acpica/nsrepair.c  |    2 +-
 drivers/acpi/acpica/nsrepair2.c |    7 +
 drivers/acpi/acpica/nssearch.c  |   15 +--
 drivers/acpi/acpica/nsutils.c   |  113 ------------------
 drivers/acpi/acpica/nswalk.c    |   15 +--
 drivers/acpi/acpica/nsxfobj.c   |    2 +-
 drivers/acpi/acpica/utglobal.c  |    2 +-
 drivers/acpi/acpica/utxface.c   |    8 +-
 drivers/acpi/button.c           |    6 +-
 drivers/acpi/ec.c               |   39 +-----
 drivers/acpi/osl.c              |   20 ---
 drivers/acpi/scan.c             |    7 +-
 drivers/acpi/sleep.c            |   15 +--
 drivers/acpi/system.c           |    6 +-
 drivers/acpi/wakeup.c           |   18 ++-
 drivers/pci/pci-acpi.c          |    6 +-
 include/acpi/acoutput.h         |    3 +-
 include/acpi/acpixf.h           |   13 +-
 include/acpi/actbl2.h           |   48 ++++++++
 include/acpi/actypes.h          |    8 +-
 53 files changed, 470 insertions(+), 895 deletions(-)

through these commits:

Alexey Starikovskiy (3):
      ACPICA: Expand initialization counters to 32 bits
      ACPICA: Performance enhancement for namespace search and access
      ACPICA: Optimization: Reduce the number of namespace walks

Bob Moore (13):
      ACPICA: Add comment: _BCL cannot be sorted on the fly
      ACPICA: iASL/Core: Add support for _WDG/_WED MS methods
      ACPICA: Core: Replace all %d format specifiers with %u (unsigned)
      ACPICA: Expand device initialization counters to 32 bits
      ACPICA: Update flags for operand object
      ACPICA: Add signatures for undefined tables: ATKG, GSCI, IEIT
      ACPICA: Update version to 20100528
      ACPICA: Add support for WDDT - Watchdog Descriptor Table
      ACPICA: Update debug output components
      ACPICA: Remove obsolete GPE function
      ACPICA: Fix lint warning for 64-bit constant
      ACPICA: Fix for Alias references within Package objects
      ACPICA: Update version to 20100702

Lin Ming (1):
      ACPICA: Rename acpi_hw_gpe_register_bit

Rafael J. Wysocki (10):
      ACPICA: Introduce acpi_gpe_wakeup()
      ACPICA: Remove wakeup GPE reference counting which is not used
      ACPI / EC: Drop suspend and resume routines
      ACPI / EC: Do not use acpi_set_gpe
      ACPICA: Use low-level GPE enable during GPE block initialization
      ACPICA: Drop acpi_set_gpe
      ACPI: Fix bogus GPE test in acpi_bus_set_run_wake_flags()
      ACPI / ACPICA: Do not execute _PRW methods during initialization
      ACPI / ACPICA: Fail acpi_gpe_wakeup() if ACPI_GPE_CAN_WAKE is unset
      ACPI / ACPICA: Simplify acpi_ev_initialize_gpe_block()

with this log:

commit a0d468718b9049f7396d101075a129a2d683ad66
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 8 00:44:42 2010 +0200

    ACPI / ACPICA: Simplify acpi_ev_initialize_gpe_block()
    
    Simplify the main loop in acpi_ev_initialize_gpe_block() by
    rearranging code and removing the "enabled" label that is not
    necessary any more.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ce10df8d83d0528e80cd319b35ac5f6812b4f62
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 8 00:45:34 2010 +0200

    ACPI / ACPICA: Fail acpi_gpe_wakeup() if ACPI_GPE_CAN_WAKE is unset
    
    Make acpi_gpe_wakeup() return error code for GPEs whose
    ACPI_GPE_CAN_WAKE flag is not set.  This way acpi_gpe_wakeup() will
    only wake for the GPEs reported by the host OS as "wakeup" ones with
    the help of acpi_gpe_can_wake().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9874647ba1bdf3e1af25e079070a00676f60f2f0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 8 00:43:36 2010 +0200

    ACPI / ACPICA: Do not execute _PRW methods during initialization
    
    Currently, during initialization ACPICA walks the entire ACPI
    namespace in search of any device objects with assciated _PRW
    methods.  All of the _PRW methods found are executed in the process
    to extract the GPE information returned by them, so that the GPEs in
    question can be marked as "able to wakeup" (more precisely, the
    ACPI_GPE_CAN_WAKE flag is set for them).  The only purpose of this
    exercise is to avoid enabling the CAN_WAKE GPEs automatically, even
    if there are _Lxx/_Exx methods associated with them.  However, it is
    both costly and unnecessary, because the host OS has to execute the
    _PRW methods anyway to check which devices can wake up the system
    from sleep states.  Moreover, it then uses full information
    returned by _PRW, including the GPE information, so it can take care
    of disabling the GPEs if necessary.
    
    Remove the code that walks the namespace and executes _PRW from
    ACPICA and modify comments to reflect that change.  Make
    acpi_bus_set_run_wake_flags() disable GPEs for wakeup devices
    so that they don't cause spurious wakeup events to be signaled.
    This not only reduces the complexity of the ACPICA initialization
    code, but in some cases it should reduce the kernel boot time as
    well.
    
    Unfortunately, for this purpose we need a new ACPICA function,
    acpi_gpe_can_wake(), to be called by the host OS in order to disable
    the GPEs that can wake up the system and were previously enabled by
    acpi_ev_initialize_gpe_block() or acpi_ev_update_gpes() (such a GPE
    should be disabled only once, because the initialization code enables
    it only once, but it may be pointed to by _PRW for multiple devices
    and that's why the additional function is necessary).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8e18c956152ec9c26c94c6401c174691a8f04e7
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 8 00:42:51 2010 +0200

    ACPI: Fix bogus GPE test in acpi_bus_set_run_wake_flags()
    
    When we check if a GPE can be used for runtime signaling, we only
    search the FADT GPE blocks, which is incorrect, becuase the GPE
    may be located elsewhere.  We really should be using the GPE device
    information previously returned by _PRW here, so make that happen.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e6c3e996e3c80d00cf931538e17126efe45f45c
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jul 6 10:39:01 2010 +0800

    ACPICA: Update version to 20100702
    
    Version 20100702.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 09079250db4d470f75eddcce31e0229c92d6c3bf
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jul 6 10:37:13 2010 +0800

    ACPICA: Fix for Alias references within Package objects
    
    This fixes a problem where a reference to an Alias within the
    definition of a Package was not always resolved properly. Aliases
    to objects like Processors, ThermalZones, etc. were resolved to the
    actual object instead of a reference to the object as it should be.
    Package objects are only allowed to contain integer, string,
    buffer, package, and reference objects.
    
    https://bugzilla.redhat.com/show_bug.cgi?id=608648
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 150dba38f0c3d2d5f5edc58145d202de08ed623c
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jul 6 10:35:55 2010 +0800

    ACPICA: Fix lint warning for 64-bit constant
    
    cast to u64.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit de5668fe7549c0586c6f64fa5661604cf7029a99
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jul 6 10:30:37 2010 +0800

    ACPICA: Remove obsolete GPE function
    
    Remove acpi_hw_write_gpe_enable_reg, it had been reduced down to a
    single line of code, and called from only one place.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ddcc6a037c0f9378f29658636a2c2b54c4238ec4
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jul 6 10:02:16 2010 +0800

    ACPICA: Update debug output components
    
    Add data table compiler output component
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9d8b5e7b28179784e2c6250086a44021fbb9c5a0
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jul 6 09:58:11 2010 +0800

    ACPICA: Add support for WDDT - Watchdog Descriptor Table
    
    Header file support.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 546eb57695875712f676e5f729159b0779f1c0af
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 1 11:07:20 2010 +0800

    ACPICA: Drop acpi_set_gpe
    
    The acpi_set_gpe() function is a little awkward, because it doesn't
    really work as advertised in the "disable" case.  Namely, if a GPE
    has been enabled with acpi_enable_gpe() and triggered a notification
    to occur, and if acpi_set_gpe() is used to disable it before
    acpi_ev_asynch_enable_gpe() runs, the GPE will be immediately enabled
    by the latter as though the acpi_set_gpe() had no effect.
    
    Thus, since it's been possible to make all of its callers use
    alternative operations to disable or enable GPEs, acpi_set_gpe() can
    be dropped.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3bd741bd0dfcc1845ae6892baa5192c91addc84c
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 1 11:01:12 2010 +0800

    ACPICA: Use low-level GPE enable during GPE block initialization
    
    The GPE block initialization code in acpi_ev_initialize_gpe_block()
    uses acpi_set_gpe() to make sure that the GPEs with nonzero
    runtime counter will remain enabled, but since it already has
    a struct acpi_gpe_event_info object for each GPE, it might use
    the low-level GPE enabling function, acpi_clear_and_enable_gpe(),
    for this purpose.
    
    To make that happen, move acpi_clear_and_enable_gpe() to
    drivers/acpi/acpica/evgpe.c and rename it to acpi_ev_enable_gpe(),
    modify the two existing users of it accordingly and modify
    acpi_ev_initialize_gpe_block() to use it instead of acpi_set_gpe()
    and to check its return value.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3784730b02b9f147a55b0e4623fcad671273e6e6
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jun 25 01:21:42 2010 +0200

    ACPI / EC: Do not use acpi_set_gpe
    
    The EC driver is the last user of acpi_set_gpe() and since it is
    guaranteed that the EC GPE will not be shared, acpi_disable_gpe()
    and acpi_enable_gpe() may be used for disabling the GPE temporarilty
    if a GPE storm is detected and re-enabling it during EC transactions.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b63559f5ce08bc8f94ce144a8d06f7af607ecc53
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jun 25 01:20:38 2010 +0200

    ACPI / EC: Drop suspend and resume routines
    
    The suspend and resume routines provided by the EC driver are not
    really necessary, because the handler of the GPE disabled by them
    is not going to be executed after suspend_device_irqs() and before
    resume_device_irqs() anyway.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a44061aa8b5d58b2729faca4c155a94a5bea2a09
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jul 1 10:11:45 2010 +0800

    ACPICA: Remove wakeup GPE reference counting which is not used
    
    After the previous patch that introduced acpi_gpe_wakeup() and
    modified the ACPI suspend and wakeup code to use it, the third
    argument of acpi_{enable|disable}_gpe() and the GPE wakeup
    reference counter are not necessary any more.  Remove them and
    modify all of the users of acpi_{enable|disable}_gpe()
    accordingly.  Also drop GPE type constants that aren't used
    any more.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8b6f970107cfc9c00cdcdb12ec6c7e135cf379f
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jun 25 01:18:39 2010 +0200

    ACPICA: Introduce acpi_gpe_wakeup()
    
    ACPICA uses reference counters to avoid disabling GPEs too early in
    case they have been enabled for many times.  This is done separately
    for runtime and for wakeup, but the wakeup GPE reference counter is
    not really necessary, because GPEs are only enabled to wake up the
    system at the hardware level by acpi_enter_sleep_state().  Thus it
    only is necessary to set the corresponding bits in the wakeup enable
    masks of these GPEs' registers right before the system enters a sleep
    state.  Moreover, the GPE wakeup enable bits can only be set when the
    target sleep state of the system is known and they need to be cleared
    immediately after wakeup regardless of how many wakeup devices are
    associated with a given GPE.
    
    On the basis of the above observations, introduce function
    acpi_gpe_wakeup() to be used for setting or clearing the enable bit
    corresponding to a given GPE in its enable register's enable_for_wake
    mask.  Modify the ACPI suspend and wakeup code the use
    acpi_gpe_wakeup() instead of acpi_{enable|disable}_gpe() to set
    and clear GPE enable bits in their registers' enable_for_wake masks
    during system transitions to a sleep state and back to the working
    state, respectively.  [This will allow us to drop the third
    argument of acpi_{enable|disable}_gpe() and simplify the GPE
    handling code.]
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b76df673522d94e3eafcf16935b3d7e5dded3078
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Jul 1 10:07:17 2010 +0800

    ACPICA: Rename acpi_hw_gpe_register_bit
    
    Rename acpi_hw_gpe_register_bit to acpi_hw_get_gpe_register_bit
    in order to be same with ACPICA code base.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ccba77eb45c36cf1d8b22f241eb8a4a292c1362e
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon May 31 09:23:22 2010 +0800

    ACPICA: Update version to 20100528
    
    Version 20100528.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4461cf546ec8c97b6b997b8e533d6de1960499d3
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon May 31 09:22:12 2010 +0800

    ACPICA: Add signatures for undefined tables: ATKG, GSCI, IEIT
    
    These ACPI tables have been seen in the field, but the actual
    table definitions are unkown at this time.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a9fc03125ea0001ff18bc29da9539b587fdbd1d7
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed May 26 13:59:51 2010 +0800

    ACPICA: Optimization: Reduce the number of namespace walks
    
    On control method exit, only walk the namespace if the method is
    known to have created namespace objects outside of its local scope.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 20d33aea7ae7ad858f3f91c834d9043cd8122d38
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu May 27 09:27:34 2010 +0800

    ACPICA: Update flags for operand object
    
    Remove obsolete AOPOBJ_SINGLE_DATUM. Add AOPOBJ_INVALID for
    use if the host OS rejects the address of an operation region
    (currently only used by Linux.)
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c45b5c097001480e66d4c523eb715ad317a4ef77
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed May 26 11:53:07 2010 +0800

    ACPICA: Performance enhancement for namespace search and access
    
    This change enhances the performance of namespace searches and
    walks by adding a backpointer to the parent in each namespace
    node. On large namespaces, this change can improve overall ACPI
    performance by up to 9X.  Adding a pointer to each namespace node
    increases the overall size of the internal namespace by about 5%,
    since each namespace entry usually consists of both a namespace
    node and an ACPI operand object.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5821f75421aa7c7bafdec291223153597f649934
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed May 26 11:48:22 2010 +0800

    ACPICA: Expand device initialization counters to 32 bits
    
    Expand the various device initialization counters from 16-bit
    to 32-bit.  Allows for very large namespaces.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b27d65975c252ff774edff8e01f0a9fd46d8ab62
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed May 26 11:47:13 2010 +0800

    ACPICA: Core: Replace all %d format specifiers with %u (unsigned)
    
    With only a few exceptions, ACPICA does not use signed integers.
    Therefore, %d is incorrect.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96b7b7ad79e4bd8a0ae67dd201f7532ef4abf1c1
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed May 26 11:20:47 2010 +0800

    ACPICA: Expand initialization counters to 32 bits
    
    Expand the various initialization counters from 16-bit to 32-bit.
    Allows for very large namespaces.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 507f7d5e27015be1e5dda5c56bb5e10315b76f71
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed May 26 11:18:35 2010 +0800

    ACPICA: iASL/Core: Add support for _WDG/_WED MS methods
    
    These objects are defined by "Windows Instrumentation", and are
    not part of the ACPI spec. Adds compiler support and runtime
    typechecking support in the ACPICA core. ACPICA BZ 860.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=860
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aa9d36060fb7480a5907660b7ba61c3fda20fc61
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed May 26 11:03:56 2010 +0800

    ACPICA: Add comment: _BCL cannot be sorted on the fly
    
    Because of package index values used for _BQC and _BCM.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
