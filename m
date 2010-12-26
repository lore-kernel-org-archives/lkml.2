Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0LZWmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:42:20 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:40796 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0LZWmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:42:08 -0500
Date: Sun, 26 Dec 2010 17:41:49 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git pull] ACPI patches for 2.6.27-rc7
Message-id: <alpine.LFD.2.00.1012261740390.2945@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Some regression fixes for your stocking:-)

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.37/acpi-release-20101013-2.6.37-rc7.diff.gz

 drivers/acpi/acpica/evgpeinit.c |    3 +
 drivers/acpi/battery.c          |    5 --
 drivers/acpi/scan.c             |   97 ++++++++++++++++++++++++---------------
 3 files changed, 63 insertions(+), 42 deletions(-)

through these commits:

Len Brown (1):
      Revert "ACPI battery: update status upon sysfs query"

Rafael J. Wysocki (2):
      ACPI: Execute _PRW for devices reported as inactive or not present
      ACPI / ACPICA: Disable GPEs during initialization

with this log:

commit bbbcde9d9614683fbeb41f00728cfbfb7f75a7ad
Merge: d7c1255 5acdb1a cde44d1
Author: Len Brown <len.brown@intel.com>
Date:   Sun Dec 26 17:05:07 2010 -0500

    Merge branches 'bugzilla-25412' and 'bugzilla-25302' into release

commit 5acdb1af907d5908b4942d425c0983f353dd8fc5
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Dec 26 12:47:06 2010 +0100

    ACPI / ACPICA: Disable GPEs during initialization
    
    GPEs with corresponding _Lxx/_Exx control methods need to be disabled
    during initialization in case they have been enabled by the BIOS, so
    that they don't fire up until they are enabled by acpi_update_gpes().
    
    References: https://bugzilla.kernel.org/show_bug.cgi?id=25412
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cde44d1740bcb3dcfecbf792a71826431e61686e
Author: Len Brown <len.brown@intel.com>
Date:   Fri Dec 24 21:43:16 2010 -0500

    Revert "ACPI battery: update status upon sysfs query"
    
    This reverts commit 3138b32d5e0998ba3cbd1c74bdc1887d74c5279b.
    
    as it caused a crash upon battery removal:
    https://bugzilla.kernel.org/show_bug.cgi?id=25302
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b581a7f9c3abc6c7afacd021747543d32ff17adb
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Dec 17 22:34:01 2010 +0100

    ACPI: Execute _PRW for devices reported as inactive or not present
    
    If a device is reported as inactive or not present by its _STA
    control method, acpi_bus_check_add() skips it without evaluating its
    _PRW method.  This leads to a problem when the device's _PRW method
    points to a GPE, because in that case the GPE may be enabled by
    ACPICA during the subsequent acpi_update_gpes() call which, in
    turn, may cause a GPE storm to appear.
    
    To avoid this issue, make acpi_bus_check_add() evaluate _PRW for
    inactive or not present devices and register the wakeup GPE
    information returned by them, so that acpi_update_gpes() does not
    enable their GPEs unnecessarily.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
