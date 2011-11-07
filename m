Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1KGRyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:54:12 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:38314 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137Ab1KGRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:54:07 -0500
Message-ID: <4EB81B3B.5080006@kernel.org>
Date: Mon, 07 Nov 2011 12:54:03 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT pull] ACPI & cpuidle power management patches for Linux 3.2-merge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

Note that linux-next will not include the cpuidle patch below that
touches ARM until 11/7 -- though it has been built and tested
by some ARM people previously.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-acpi@vger.kernel.org

 Documentation/ABI/stable/sysfs-acpi-pmprofile |   22 +++
 arch/arm/mach-at91/cpuidle.c                  |   41 +++--
 arch/arm/mach-davinci/cpuidle.c               |   51 +++---
 arch/arm/mach-exynos4/cpuidle.c               |   30 ++--
 arch/arm/mach-kirkwood/cpuidle.c              |   42 +++--
 arch/arm/mach-omap2/cpuidle34xx.c             |  133 +++++++++-----
 arch/sh/kernel/cpu/shmobile/cpuidle.c         |   28 ++-
 arch/x86/platform/mrst/pmu.c                  |    2 +-
 drivers/acpi/acpica/hwregs.c                  |   11 +-
 drivers/acpi/atomicio.c                       |    2 +-
 drivers/acpi/bus.c                            |    8 +-
 drivers/acpi/processor_driver.c               |   20 +--
 drivers/acpi/processor_idle.c                 |  251 ++++++++++++++++++++-----
 drivers/acpi/scan.c                           |    3 +-
 drivers/acpi/sysfs.c                          |   14 ++-
 drivers/cpuidle/cpuidle.c                     |   86 +++------
 drivers/cpuidle/driver.c                      |   25 +++
 drivers/cpuidle/governors/ladder.c            |   41 +++-
 drivers/cpuidle/governors/menu.c              |   29 ++--
 drivers/cpuidle/sysfs.c                       |   22 ++-
 drivers/idle/intel_idle.c                     |  130 ++++++++++---
 drivers/pnp/pnpacpi/rsparser.c                |   62 ++-----
 drivers/thermal/thermal_sys.c                 |    4 +-
 include/acpi/acpi_drivers.h                   |    2 +-
 include/acpi/actypes.h                        |    1 -
 include/acpi/processor.h                      |    1 +
 include/linux/cpuidle.h                       |   52 +++---
 tools/power/x86/turbostat/turbostat.c         |   28 ++--
 28 files changed, 729 insertions(+), 412 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-acpi-pmprofile

through these commits:

Bart Van Assche (1):
      ACPI: Fix CONFIG_ACPI_DOCK=n compiler warning

Deepthi Dharwar (4):
      cpuidle: Move dev->last_residency update to driver enter routine; remove dev->last_state
      cpuidle: Remove CPUIDLE_FLAG_IGNORE and dev->prepare()
      cpuidle: Split cpuidle_state structure and move per-cpu statistics fields
      cpuidle: Single/Global registration of idle states

Len Brown (2):
      tools/power turbostat: less verbose debugging
      mrst pmu: update comment

Rafael J. Wysocki (2):
      ACPI: Drop ACPI_NO_HARDWARE_INIT
      thermal: Prevent polling from happening during system suspend

Rakib Mullick (1):
      ACPI: Fix possible recursive locking in hwregs.c

Thomas Meyer (1):
      ACPI: use kstrdup()

Thomas Renninger (1):
      ACPI: Export FADT pm_profile integer value to userspace

Tony Luck (1):
      ACPI atomicio: Convert width in bits to bytes in __acpi_ioremap_fast()

Witold Szczeponik (1):
      PNPACPI: Simplify disabled resource registration

with this log:

commit efb90582c575084723cc14302c1300cb26c7e01f
Merge: e751b75 46bcfad 22f4521 aeae1e9
Author: Len Brown <len.brown@intel.com>
Date:   Sun Nov 6 22:14:50 2011 -0500

    Merge branches 'acpi', 'idle', 'mrst-pmu' and 'pm-tools' into next

commit e751b759e82629798c4a5e4a87eb3a30c0510154
Merge: 3bf3f8b f7f71cf c1056b4 362b646 18fd470
Author: Len Brown <len.brown@intel.com>
Date:   Sun Nov 6 22:10:14 2011 -0500

    Merge branches 'atomic-io', 'lockdep', 'misc', 'pm-profile' and 'pnp-cleanup' into acpi

commit 46bcfad7a819bd17ac4e831b04405152d59784ab
Author: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date:   Fri Oct 28 16:20:42 2011 +0530

    cpuidle: Single/Global registration of idle states
    
    This patch makes the cpuidle_states structure global (single copy)
    instead of per-cpu. The statistics needed on per-cpu basis
    by the governor are kept per-cpu. This simplifies the cpuidle
    subsystem as state registration is done by single cpu only.
    Having single copy of cpuidle_states saves memory. Rare case
    of asymmetric C-states can be handled within the cpuidle driver
    and architectures such as POWER do not have asymmetric C-states.
    
    Having single/global registration of all the idle states,
    dynamic C-state transitions on x86 are handled by
    the boot cpu. Here, the boot cpu  would disable all the devices,
    re-populate the states and later enable all the devices,
    irrespective of the cpu that would receive the notification first.
    
    Reference:
    https://lkml.org/lkml/2011/4/25/83
    
    Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
    Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
    Tested-by: Jean Pihet <j-pihet@ti.com>
    Reviewed-by: Kevin Hilman <khilman@ti.com>
    Acked-by: Arjan van de Ven <arjan@linux.intel.com>
    Acked-by: Kevin Hilman <khilman@ti.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
Author: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date:   Fri Oct 28 16:20:33 2011 +0530

    cpuidle: Split cpuidle_state structure and move per-cpu statistics fields
    
    This is the first step towards global registration of cpuidle
    states. The statistics used primarily by the governor are per-cpu
    and have to be split from rest of the fields inside cpuidle_state,
    which would be made global i.e. single copy. The driver_data field
    is also per-cpu and moved.
    
    Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
    Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
    Tested-by: Jean Pihet <j-pihet@ti.com>
    Reviewed-by: Kevin Hilman <khilman@ti.com>
    Acked-by: Arjan van de Ven <arjan@linux.intel.com>
    Acked-by: Kevin Hilman <khilman@ti.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b25edc42bfb9602f0503474b2c94701d5536ce60
Author: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date:   Fri Oct 28 16:20:24 2011 +0530

    cpuidle: Remove CPUIDLE_FLAG_IGNORE and dev->prepare()
    
    The cpuidle_device->prepare() mechanism causes updates to the
    cpuidle_state[].flags, setting and clearing CPUIDLE_FLAG_IGNORE
    to tell the governor not to chose a state on a per-cpu basis at
    run-time. State demotion is now handled by the driver and it returns
    the actual state entered. Hence, this mechanism is not required.
    Also this removes per-cpu flags from cpuidle_state enabling
    it to be made global.
    
    Reference:
    https://lkml.org/lkml/2011/3/25/52
    
    Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm>
    Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
    Tested-by: Jean Pihet <j-pihet@ti.com>
    Acked-by: Arjan van de Ven <arjan@linux.intel.com>
    Reviewed-by: Kevin Hilman <khilman@ti.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e978aa7d7d57d04eb5f88a7507c4fb98577def77
Author: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date:   Fri Oct 28 16:20:09 2011 +0530

    cpuidle: Move dev->last_residency update to driver enter routine; remove dev->last_state
    
    Cpuidle governor only suggests the state to enter using the
    governor->select() interface, but allows the low level driver to
    override the recommended state. The actual entered state
    may be different because of software or hardware demotion. Software
    demotion is done by the back-end cpuidle driver and can be accounted
    correctly. Current cpuidle code uses last_state field to capture the
    actual state entered and based on that updates the statistics for the
    state entered.
    
    Ideally the driver enter routine should update the counters,
    and it should return the state actually entered rather than the time
    spent there. The generic cpuidle code should simply handle where
    the counters live in the sysfs namespace, not updating the counters.
    
    Reference:
    https://lkml.org/lkml/2011/3/25/52
    
    Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
    Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
    Tested-by: Jean Pihet <j-pihet@ti.com>
    Reviewed-by: Kevin Hilman <khilman@ti.com>
    Acked-by: Arjan van de Ven <arjan@linux.intel.com>
    Acked-by: Kevin Hilman <khilman@ti.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1056b42a87b59375f8f81a92ef029165f44fcce
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Wed Nov 2 20:16:05 2011 +0100

    ACPI: Fix CONFIG_ACPI_DOCK=n compiler warning
    
    Recently the ACPI ops structs were constified but the inline version
    of register_hotplug_dock_device() was overlooked (see also commit
    9c8b04b, June 25 2011). Update the inline function
    register_hotplug_dock_device() that is enabled with
    CONFIG_ACPI_DOCK=n too. This patch fixes at least the following
    compiler warnings:
    
    drivers/ata/libata-acpi.c: In function .ata_acpi_associate.:
    drivers/ata/libata-acpi.c:266:11: warning: passing argument 2 of .register_hotplug_dock_device. discards qualifiers from pointer target type
    include/acpi/acpi_drivers.h:146:19: note: expected .struct acpi_dock_ops *. but argument is of type .const struct acpi_dock_ops *.
    drivers/ata/libata-acpi.c:275:11: warning: passing argument 2 of .register_hotplug_dock_device. discards qualifiers from pointer target type
    include/acpi/acpi_drivers.h:146:19: note: expected .struct acpi_dock_ops *. but argument is of type .const struct acpi_dock_ops *.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 362b646062b2073bd5c38efb42171d86e4f717e6
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Nov 4 03:33:46 2011 +0100

    ACPI: Export FADT pm_profile integer value to userspace
    
    There are a lot userspace approaches to detect the usage of the
    platform (laptop, workstation, server, ...) and adjust kernel tunables
    accordingly (io/process scheduler, power management, ...).
    
    These approaches need constant maintaining and are ugly to implement
    (detect PCMCIA controller -> laptop,
    does not work on recent systems anymore, ...)
    On ACPI systems there is an easy and reliable way (if implemented
    in BIOS and most recent platforms have this value set).
    -> export it to userspace.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 51e20d0e3a60cf46b52ee1af598a35834919ed27
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Nov 6 14:21:38 2011 +0100

    thermal: Prevent polling from happening during system suspend
    
    The thermal driver should use a freezable workqueue to schedule
    polling to prevent thermal_zone_device_update() from being run
    during system suspend, when the devices it relies on may be inactive.
    Make it use the system freezable workqueue for this purpose.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4505a2015f4c4b2f21137cc3a6b7400b0f3e073e
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Nov 6 14:20:42 2011 +0100

    ACPI: Drop ACPI_NO_HARDWARE_INIT
    
    ACPI_NO_HARDWARE_INIT is only used by acpi_early_init() and
    acpi_bus_init() when calling acpi_enable_subsystem(), but
    acpi_enable_subsystem() doesn't check that flag, so it can be
    dropped.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3bf3f8b19d2bfccc40f13c456bf339fd8f535ebc
Author: Luck, Tony <tony.luck@intel.com>
Date:   Fri Oct 21 14:42:55 2011 -0700

    ACPI atomicio: Convert width in bits to bytes in __acpi_ioremap_fast()
    
    Callers to __acpi_ioremap_fast() pass the bit_width that they found in the
    acpi_generic_address structure. Convert from bits to bytes when passing to
    __acpi_find_iomap() - as it wants to see bytes, not bits.
    
    cc: stable@kernel.org
    Signed-off-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 18fd470a48396c8795ba7256c5973e92ffa25cb3
Author: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Date:   Thu Oct 27 20:56:47 2011 +0200

    PNPACPI: Simplify disabled resource registration
    
    The attached patch simplifies 29df8d8f8702f0f53c1375015f09f04bc8d023c1.  As
    the "pnp_xxx" structs are not designed to cope with IORESOURCE_DISABLED, and
    hence no code can test for this value, setting this value is actually a "no op"
    and can be skipped altogether.  It is sufficient to remove the checks for
    "empty" resources and continue processing.
    
    The patch is applied against 3.1.
    
    Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
    Acked-by: Bjorn Helgaas <bhelgaas@google.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f7f71cfbf0c276ee3d8d856d0f35a41aed997fa4
Author: Rakib Mullick <rakib.mullick@gmail.com>
Date:   Sun Nov 6 21:18:17 2011 +0600

    ACPI: Fix possible recursive locking in hwregs.c
    
    Calling pm-suspend might trigger a recursive lock in it's code path.
    In function acpi_hw_clear_acpi_status, acpi_os_acquire_lock holds
    the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(),
    then without releasing acpi_gbl_hardware_lock, this function calls
    acpi_ev_walk_gpe_list, which tries to hold acpi_gbl_gpe_lock.
    Both acpi_gbl_hardware_lock and acpi_gbl_gpe_lock are at same
    lock-class and which might cause lock recursion deadlock.
    
    Following patch fixes this scenario by just releasing
    acpi_gbl_hardware_lock before calling acpi_ev_walk_gpe_list.
    
     Changes since v0(https://lkml.org/lkml/2011/9/21/355):
    	- Fix changelog, thanks to Lin Ming.
    
     Changes since v1 (https://lkml.org/lkml/2011/11/3/89):
    	- Update changelog and rename goto label, courtesy Srivatsa S. Bhat.
    
    Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
    Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 581de59e8dff8eaa52809e768a585e9ef336aa4a
Author: Thomas Meyer <thomas@m3y3r.de>
Date:   Sat Aug 6 11:32:56 2011 +0200

    ACPI: use kstrdup()
    
     Use kstrdup rather than duplicating its implementation
    
     The semantic patch that makes this output is available
     in scripts/coccinelle/api/kstrdup.cocci.
    
     More information about semantic patching is available at
     http://coccinelle.lip6.fr/
    
    Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22f4521d664030e417f41953e922f61c65f2e189
Author: Len Brown <len.brown@intel.com>
Date:   Fri Aug 12 00:13:47 2011 -0400

    mrst pmu: update comment
    
    referenced MeeGo, in particular, but really means Linux, in general.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aeae1e92daec5a38b40ad12598b97501b675a381
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 3 21:41:33 2011 -0400

    tools/power turbostat: less verbose debugging
    
    dump only the counters which are active
    
    Signed-off-by: Len Brown <len.brown@intel.com>
