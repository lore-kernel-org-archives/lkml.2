Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab0LKHRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 02:17:38 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:63769 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0LKHRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 02:17:35 -0500
Date: Sat, 11 Dec 2010 02:17:30 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [git pull] ACPI patches for Linux-2.6.37-rc5
Message-id: <alpine.LFD.2.00.1012110215310.27156@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1894795178-1292051852=:27156"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1894795178-1292051852=:27156
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

A pair of regression fixes, plus some bug fixes and build fixes.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.37/acpi-release-20101013-2.6.37-rc5.diff.gz

 drivers/acpi/ac.c                |   46 ++++++++++------
 drivers/acpi/apei/erst.c         |   34 ++++++------
 drivers/acpi/apei/hest.c         |   10 ++--
 drivers/acpi/battery.c           |    5 ++
 drivers/acpi/ec.c                |    3 +
 drivers/acpi/osl.c               |  113 ++++++++++++++++++++++++++------------
 drivers/acpi/power.c             |   12 ++--
 drivers/acpi/processor_thermal.c |    9 ---
 drivers/acpi/sleep.c             |    4 +-
 drivers/pnp/pnpacpi/core.c       |    2 +-
 include/acpi/video.h             |    5 +-
 include/linux/acpi.h             |    2 +-
 include/linux/video_output.h     |   15 +++++
 13 files changed, 165 insertions(+), 95 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: EC: Add another dmi match entry for MSI hardware

Chris Wilson (1):
      ACPI: video: fix build for CONFIG_ACPI=n

Huang Ying (1):
      ACPI, APEI, use raw spinlock in ERST

Jan Beulich (3):
      ACPI/PNP: avoid section mismatch warning
      ACPI: eliminate unused variable warning for !ACPI_SLEEP
      ACPI/HEST: adjust section selection

Len Brown (1):
      ACPI: video: fix build for VIDEO_OUTPUT_CONTROL=n

Lin Ming (2):
      acpi: fix _OSI string setup regression
      ACPI: fix allowing to add/remove multiple _OSI strings

Rafael J. Wysocki (2):
      ACPI / PM: Check device state before refcounting power resources
      ACPI / PM: Do not refcount power resources that can't be turned on

Zhang Rui (4):
      ACPI ac: update AC status upon sysfs query
      ACPI battery: update status upon sysfs query
      ACPI: fix a section mismatch
      ACPI thermal: remove two unused functions

with this log:

commit 6cc5615f7c4decd7b6c4da9317d0e0b5fbdf7290
Merge: a5dc4f8 3138b32 12b3b5a bec4f22 12d3206
Author: Len Brown <len.brown@intel.com>
Date:   Sat Dec 11 02:02:02 2010 -0500

    Merge branches 'bugzilla-15418', 'bugzilla-21722', 'bugzilla-22932', 'misc-2.6.37' and 'osi-regression' into release

commit bec4f22a2dbd5a26079cbddbcadf38f8c7e5381f
Author: Jan Beulich <JBeulich@novell.com>
Date:   Tue Dec 7 14:58:44 2010 +0000

    ACPI/HEST: adjust section selection
    
    Properly const-, __init-, and __read_mostly-annotate this code.
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 091aad6af4ab29af693ced5d6970ceee9d5981c8
Author: Jan Beulich <JBeulich@novell.com>
Date:   Tue Dec 7 14:52:25 2010 +0000

    ACPI: eliminate unused variable warning for !ACPI_SLEEP
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66c3ec4f1f70ee87833363166b594855631d7ba6
Author: Jan Beulich <JBeulich@novell.com>
Date:   Tue Dec 7 15:05:49 2010 +0000

    ACPI/PNP: avoid section mismatch warning
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b9047599695ae835252ba3d6a19eada98c19dc89
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 8 10:40:26 2010 +0800

    ACPI thermal: remove two unused functions
    
    When CONFIG_CPU_FREQ=n ...
    
    drivers/acpi/processor_thermal.c:159:12: warning: ¡acpi_thermal_cpufreq_increase¢ defined but not used
    drivers/acpi/processor_thermal.c:163:12: warning: ¡acpi_thermal_cpufreq_decrease¢ defined but not used
    
    Remove unused declaration of ¡acpi_thermal_cpufreq_increase¢ and
    ¡acpi_thermal_cpufreq_decrease¢
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 32d47eeff05981bfb89a95747eb182bc12630d58
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 8 10:40:36 2010 +0800

    ACPI: fix a section mismatch
    
    WARNING: drivers/acpi/acpi.o(.text+0xeda): Section mismatch in reference from the function acpi_os_initialize1() to the function .init.text:set_osi_linux()
    
    The function acpi_os_initialize1() references
    the function __init set_osi_linux().
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b38bb5f7f06356a89bb2cbf92ad346025e95192
Author: Huang Ying <ying.huang@intel.com>
Date:   Thu Dec 2 10:40:53 2010 +0800

    ACPI, APEI, use raw spinlock in ERST
    
    ERST writing may be used in NMI or Machine Check Exception handler. So
    it need to use raw spinlock instead of normal spinlock.  This patch
    fixes it.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b72512ed706efb26087fcbbc5f98ed64ac1230d5
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sun Sep 5 14:51:49 2010 +0100

    ACPI: video: fix build for CONFIG_ACPI=n
    
    In file included from drivers/gpu/drm/i915/intel_opregion.c:30:
    include/acpi/video.h:22: warning: ¡struct acpi_device¢ declared inside parameter list
    ...
    include/acpi/video.h:24: error: ¡ENODEV¢ undeclared (first use in this function)
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3353bebe7c89725ab2f476b9d8d618259402d52e
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 30 18:21:46 2010 -0500

    ACPI: video: fix build for VIDEO_OUTPUT_CONTROL=n
    
    drivers/built-in.o: In function `acpi_video_bus_put_devices':
    video.c:(.text+0x79663): undefined reference to
    `video_output_unregister'
    drivers/built-in.o: In function `acpi_video_bus_add':
    video.c:(.text+0x7b0b3): undefined reference to `video_output_register'
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 12d3206466d2074ef0684aaf7759ae01a0a92560
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Dec 9 16:51:06 2010 +0800

    ACPI: fix allowing to add/remove multiple _OSI strings
    
    commit b0ed7a91(ACPICA/ACPI: Add new host interfaces for _OSI suppor)
    introduced another regression that only one _OSI string can be added or
    removed.
    
    Now multiple _OSI strings can be added or removed, for example
    
    acpi_osi=Linux acpi_osi=FreeBSD acpi_osi="!Windows 2006"
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d90aa92c0c1625d7f02050e4d2924805840cda3d
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Dec 9 16:50:52 2010 +0800

    acpi: fix _OSI string setup regression
    
    commit b0ed7a91(ACPICA/ACPI: Add new host interfaces for _OSI suppor)
    introduced a regression that _OSI string setup fails.
    
    There are 2 paths to setup _OSI string.
    
    DMI:
    acpi_dmi_osi_linux -> set_osi_linux -> acpi_osi_setup -> copy _OSI
    string to osi_setup_string
    
    Boot command line:
    acpi_osi_setup -> copy _OSI string to osi_setup_string
    
    Later, acpi_osi_setup_late will be called to handle osi_setup_string.
    If _OSI string is "Linux" or "!Linux", then the call path is,
    
    acpi_osi_setup_late -> acpi_cmdline_osi_linux -> set_osi_linux ->
    acpi_osi_setup -> copy _OSI string to osi_setup_string
    
    This actually never installs _OSI string(acpi_install_interface not
    called), but just copy the _OSI string to osi_setup_string.
    
    This patch fixes the regression.
    
    Reported-and-tested-by: Lukas Hejtmanek <xhejtman@ics.muni.cz>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a5dc4f898c2a0f66e2cefada6c687db82ba2fcbc
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Dec 9 17:07:54 2010 -0500

    ACPI: EC: Add another dmi match entry for MSI hardware
    
    http://bugzilla.kernel.org/show_bug.cgi?id=15418
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3138b32d5e0998ba3cbd1c74bdc1887d74c5279b
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 8 10:40:49 2010 +0800

    ACPI battery: update status upon sysfs query
    
    Sometimes the Battery driver doesn't get notifications when it's
    plugged/unplugged. And this results in the incorrect Battery
    status reported by the power supply sysfs I/F.
    
    Update Battery status first when querying from sysfs.
    http://marc.info/?l=linux-acpi&m=128855015826728&w=2
    
    Tested_by: Seblu <seblu@seblu.net>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3151dbb04ad5a5bd6358371c0bfb457216d00205
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 8 10:40:45 2010 +0800

    ACPI ac: update AC status upon sysfs query
    
    http://marc.info/?l=linux-acpi&m=128855015826728&w=2
    https://bugzilla.kernel.org/show_bug.cgi?id=21722
    
    Tested_by: Seblu <seblu@seblu.net>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 12b3b5afed67e08aa641d30e57df20dab2e33432
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:03:32 2010 +0100

    ACPI / PM: Do not refcount power resources that can't be turned on
    
    If turning on a power resource fails, do not reference count it,
    since it cannot be in use in that case.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 212967c69afd348342548272aedbe4d46a9325d6
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:02:36 2010 +0100

    ACPI / PM: Check device state before refcounting power resources
    
    Commit 3e384ee6c687cb397581ee8f9440fc8220cfac80 (ACPI / PM: Fix
    reference counting of power resources) introduced a regression by
    causing fan power resources to be turned on and reference counted
    unnecessarily during resume, so on some boxes fans are always on
    after resume.
    
    Fix the problem by checking if the current device state is different
    from the new state before reference counting and turning on power
    resources in acpi_power_transition().
    
    Addresses https://bugzilla.kernel.org/show_bug.cgi?id=22932 .
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-and-tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
--8323328-1894795178-1292051852=:27156--
