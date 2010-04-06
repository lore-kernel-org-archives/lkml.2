Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0DFVMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:12:03 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:44380 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0DFVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:11:54 -0400
Date: Tue, 06 Apr 2010 17:11:52 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT pull request] ACPI patches for 2.6.34-rc3 - take two
In-reply-to: <alpine.LFD.2.00.1004060308030.21994@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1004061708170.4168@localhost.localdomain>
References: <alpine.LFD.2.00.1004060308030.21994@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1096381456-1270588312=:4168"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1096381456-1270588312=:4168
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Bug fixes, per below.

Note that I've refreshed a patch from Rafael 
(ac7729da880e742613129ee6dea0045328670d2d)
and re-pushed this branch since yesterday.

In the event you already pulled it, I can instead send
a small incremental patch.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.34/acpi-release-20100121-2.6.34-rc3.diff.gz

 drivers/acpi/acpica/evgpe.c    |   19 ++++-------
 drivers/acpi/acpica/exprep.c   |   12 +++++++
 drivers/acpi/battery.c         |    6 ++--
 drivers/acpi/dock.c            |    7 +---
 drivers/acpi/ec.c              |   35 +++++---------------
 drivers/acpi/numa.c            |    6 ++-
 drivers/acpi/osl.c             |   23 +++++++------
 drivers/acpi/scan.c            |   12 +++---
 drivers/acpi/video.c           |   67 +++++++++++++++++++++++++++------------
 drivers/pnp/pnpacpi/rsparser.c |   42 ++++++++++++++++++-------
 10 files changed, 131 insertions(+), 98 deletions(-)

through these commits:

Alan Jenkins (2):
      ACPI: battery: Fix CONFIG_ACPI_SYSFS_POWER=n
      ACPI: battery drivers should call power_supply_changed()

Alexey Starikovskiy (1):
      ACPI: EC: Allow multibyte access to EC

Bjorn Helgaas (2):
      ACPI: use _HID when supplied by root-level devices
      PNPACPI: truncate _CRS windows with _LEN > _MAX - _MIN + 1

Chase Douglas (1):
      ACPI: Reduce ACPI resource conflict message to KERN_WARNING, printk cleanup

David Rientjes (1):
      ACPI: NUMA: map pxms to low node ids

Matthew Garrett (1):
      ACPI: Don't send KEY_UNKNOWN for random video notifications

Rafael J. Wysocki (2):
      ACPI / ACPICA: Do not check reference counters in acpi_ev_enable_gpe()
      ACPI / PM: Move ACPI video resume to a PM notifier

Zhang Rui (2):
      ACPI dock: support multiple ACPI dock devices
      ACPI: fixes a false alarm from lockdep

with this log:

commit c25f7cf2032aaac9bd50d6eee982719878538082
Merge: f79e1ce dadf28a ac7729d 3162b6f bc73675 b7b30de bf02bd2 1638bca 0f9b75e 17c452f
Author: Len Brown <len.brown@intel.com>
Date:   Tue Apr 6 17:06:22 2010 -0400

    Merge branches 'battery', 'bugzilla-14667', 'bugzilla-15096', 'bugzilla-15480', 'bugzilla-15521', 'bugzilla-15605', 'gpe-reference-counters', 'misc', 'pxm-fix' and 'video-random-key' into release

commit ac7729da880e742613129ee6dea0045328670d2d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Apr 5 01:43:51 2010 +0200

    ACPI / PM: Move ACPI video resume to a PM notifier
    
    There is a problem with the ACPI video resume routine that it's
    executed before the GPU that may be accessed by it.  To fix this
    issue, move the ACPI video resume to a power management notifier,
    so that's executed after resuming all devices, including the GPU.
    
    Fixes https://bugzilla.kernel.org/show_bug.cgi?id=15096, which is
    a listed regression from 2.6.31.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Tested-by: Rafa³ Mi³ecki <zajec5@gmail.com>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1638bca898e55f1c89f18b2e5accfac8591fed61
Author: Chase Douglas <chase.douglas@canonical.com>
Date:   Mon Mar 22 15:08:09 2010 -0400

    ACPI: Reduce ACPI resource conflict message to KERN_WARNING, printk cleanup
    
    By default, ACPI resource conflict messages are logged at level
    KERN_ERR. This is a rather high level for a message that is more a
    warning than an indication of a real kernel error. Also, KERN_ERR level
    messages can appear over some boot splash screens, and this message is
    not serious enough to warrant such treatment. Thus, the log level has
    been reduced to KERN_WARNING.
    
    [lenb changed to KERN_WARNING rather than all the way to KERN_INFO]
    
    Also, cleanup message to use %pR resource printing format.
    
    Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f79e1cec8c8aa64895fd7b595dc7b48157df0754
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Tue Jun 30 14:36:16 2009 +0000

    ACPI: battery drivers should call power_supply_changed()
    
    Calling kobject_uevent() directly is a layering violation.  In
    particular, it means we'll miss updating the generic LED trigger.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e363a755e8033e18f733fc0d1687039df8efade0
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Tue Jun 30 14:35:05 2009 +0000

    ACPI: battery: Fix CONFIG_ACPI_SYSFS_POWER=n
    
    Disabling CONFIG_ACPI_SYSFS_POWER changes the behaviour of
    acpi_battery_update().  It will call acpi_battery_get_info()
    even if the battery is not present.  I haven't noticed this
    causing any problem, but it does look like a bad idea.
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3162b6f0c5e1fcad372d64194fb3cb968941b428
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Mar 25 10:32:49 2010 -0600

    PNPACPI: truncate _CRS windows with _LEN > _MAX - _MIN + 1
    
    The ACPI spec (sec 6.4.3.5 in v4.0) requires that for Address Space Resource
    Descriptors, _LEN <= _MAX - _MIN + 1 in all cases, but there are BIOSes that
    violate this.  We experimentally determined that Windows truncates the
    resource so it doesn't extend past _MAX, so let's do the same thing in
    Linux.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=15480
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 17c452f99cf5e073b219a069a419b7b8ab3cfa97
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Dec 11 17:40:46 2009 -0500

    ACPI: Don't send KEY_UNKNOWN for random video notifications
    
    I have a machine here that's sending 0xD1 notifications on the video
    device once every second or so. I have no idea why (it's a prototype,
    it may be broken), but sending KEY_UNKNOWN is unhelpful and results in
    the console becoming unusable. Let's not report keys unless we have
    something useful to say about them.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f9b75ef3722814134f307f51c19e0791da40e69
Author: David Rientjes <rientjes@google.com>
Date:   Thu Mar 25 16:33:04 2010 -0700

    ACPI: NUMA: map pxms to low node ids
    
    pxms are mapped to low node ids to maintain generic kernel use of
    functions such as pxm_to_node() that are used to determine device
    affinity.  Otherwise, there is no pxm-to-node and node-to-pxm matching
    rule for x86_64 users of NUMA emulation where a single pxm may be bound
    to multiple NUMA nodes.
    
    Signed-off-by: David Rientjes <rientjes@google.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7b30de53aef6ce773d34837ba7d8422bd3baeec
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Mar 24 10:44:33 2010 -0600

    ACPI: use _HID when supplied by root-level devices
    
    Previously, we assumed the only Device object immediately below the root
    was the \_SB Scope (which the ACPI CA treats as a Device), so we forced
    the HID of all such objects to ACPI_BUS_HID ("LNXSYBUS").
    
    However, there are DSDTs that supply root-level Device objects with _HIDs.
    This patch makes us pay attention to those _HIDs and only add the synthetic
    ACPI_BUS_HID for root-level objects that do not supply their own _HID.
    
    For example, this DSDT: https://bugzilla.kernel.org/show_bug.cgi?id=15605
    contains:
    
        Scope (_SB) {
    	...
        }
        Device (AMW0) {
    	Name (_HID, EisaId ("PNP0C14"))
    	...
        }
    
    and we should use "PNP0C14" for the AMW0 device, not "LNXSYBUS".
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Tested-by: Yong Wang <yong.y.wang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bf02bd2590eb78d79ba1033d6df80c778b2f5ddf
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Mar 16 23:21:55 2010 +0100

    ACPI / ACPICA: Do not check reference counters in acpi_ev_enable_gpe()
    
    acpi_ev_enable_gpe() should enable the GPE at the hardware level
    regardless of the value of the GPE's runtime reference counter.
    
    There are only two callers of acpi_ev_enable_gpe(), acpi_enable_gpe()
    and acpi_set_gpe().  The first one checks the GPE's runtime
    reference counter itself and only calls acpi_ev_enable_gpe() if it's
    equal to one, and the other one is supposed to enable the GPE
    unconditionally (if called with ACPI_GPE_ENABLE).
    
    This change fixes the problem in acpi_enable_wakeup_device() where
    the GPE will not be enabled for wakeup if it's runtime reference
    counter is zero, which is a regression from 2.6.33.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-by: Robert Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc73675b99fd9850dd914be01d71af99c5d2a1ae
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Mar 22 15:48:54 2010 +0800

    ACPI: fixes a false alarm from lockdep
    
    fixes a false alarm from lockdep, as acpi hotplug workqueue waits other
    workqueues.
    http://bugzilla.kernel.org/show_bug.cgi?id=14553
    https://bugzilla.kernel.org/show_bug.cgi?id=15521
    
    Original-patch-from: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1ee4d61fd9822fb89e63b88a66848477087cd82e
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Mar 22 15:46:49 2010 +0800

    ACPI dock: support multiple ACPI dock devices
    
    There may be multiple ACPI dock devices exist in ACPI namespace
    and we should probe all of them.
    http://bugzilla.kernel.org/show_bug.cgi?id=15521
    
    CC: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dadf28a10c3eb29421837a2e413ab869ebd9e168
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Mar 17 13:14:13 2010 -0400

    ACPI: EC: Allow multibyte access to EC
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14667
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

--8323328-1096381456-1270588312=:4168--
