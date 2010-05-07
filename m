Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0EGCWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:22:30 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:37406 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0EGCW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:22:28 -0400
Date: Thu, 06 May 2010 22:22:13 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull request] ACPI patches for 2.6.34-rc6
Message-id: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

The big DMI list in sleep.c a temporary brute force and low-risk workaround.
We will endeavor to delete it entirely in 2.6.35 with a clean fix
that was deemed too risky for this late in the .34 release cycle.

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.34/acpi-release-20100121-2.6.34-rc6.diff.gz

 drivers/acpi/acpi_pad.c        |    2 +-
 drivers/acpi/bus.c             |    2 +-
 drivers/acpi/hest.c            |    4 +
 drivers/acpi/power_meter.c     |    2 +-
 drivers/acpi/sbshc.c           |    2 +-
 drivers/acpi/sleep.c           |  144 ++++++++++++++++++++++++++++++++++++++++
 drivers/pnp/pnpacpi/rsparser.c |   26 +------
 drivers/pnp/resource.c         |    4 +
 8 files changed, 160 insertions(+), 26 deletions(-)

through these commits:

Alex Chiang (1):
      ACPI: DMI init_set_sci_en_on_resume for multiple Lenovo ThinkPads

Bjorn Helgaas (2):
      PNPACPI: compute Address Space length rather than using _LEN
      PNP: don't check for conflicts with bridge windows

Dan Carpenter (4):
      ACPI: silence kmemcheck false positive
      acpi_pad: "processor_aggregator" name too long
      power_meter: acpi_device_class "power_meter_resource" too long
      sbshc: acpi_device_class "smbus_host_controller" too long

Kamal Mostafa (1):
      ACPI: sleep: init_set_sci_en_on_resume for Dell Studio 155x

Shaohua Li (1):
      ACPI: fix acpi_hest_firmware_first_pci() caused oops

with this log:

commit 1468cf0542663f873410b83d8bb61ae779e3a845
Merge: f238b41 5cc4a0f ea5bc73 11439a6 4bdae98
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 6 22:04:31 2010 -0400

    Merge branches 'bugzilla-14337', 'bugzilla-14998', 'bugzilla-15407', 'bugzilla-15903' and 'misc-2.6.34' into release

commit ea5bc73f4f56449b2d450068d492bcd17a675d7a
Author: Kamal Mostafa <kamal@canonical.com>
Date:   Tue Apr 27 14:02:40 2010 -0700

    ACPI: sleep: init_set_sci_en_on_resume for Dell Studio 155x
    
    Add Dell Studio models (1558, 1557, 1555) to the 'set_sci_en_on_resume'
    list to fix hang on resume.
    
    BugLink: http://bugs.launchpad.net/bugs/553498
    
    Signed-off-by: Kamal Mostafa <kamal@canonical.com>
    Acked-by: Alex Chiang <achiang@canonical.com>
    Cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4bdae98f1a456ea1fea5ea02f9249d23bceab75b
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Apr 8 11:16:15 2010 +0800

    ACPI: fix acpi_hest_firmware_first_pci() caused oops
    
    acpi_hest_firmware_first_pci() could be called when acpi is disabled
    and cause system oops.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 97c227cb51ddcf52c66f7a7fba69237026418b56
Author: Dan Carpenter <error27@gmail.com>
Date:   Tue Apr 27 14:06:05 2010 -0700

    sbshc: acpi_device_class "smbus_host_controller" too long
    
    acpi_device_class can only be 19 characters and a NULL terminator.
    
    With the current name we get a buffer overflow in acpi_smbus_hc_add()
    when we do:
    	strcpy(acpi_device_class(device), ACPI_SMB_HC_CLASS);
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 18262714ca0fb65c290b8ea1807b2b02bb52d0e3
Author: Dan Carpenter <error27@gmail.com>
Date:   Tue Apr 27 14:01:07 2010 -0700

    power_meter: acpi_device_class "power_meter_resource" too long
    
    acpi_device_class can only be 19 characters and a NULL terminator.
    
    The current code has a buffer overflow in acpi_power_meter_add():
           strcpy(acpi_device_class(device), ACPI_POWER_METER_CLASS);
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Cc: Len Brown <lenb@kernel.org>
    Cc: "Darrick J. Wong" <djwong@us.ibm.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a40770a9537c72b555667851845e73484b22ba17
Author: Dan Carpenter <error27@gmail.com>
Date:   Tue Apr 27 14:06:05 2010 -0700

    acpi_pad: "processor_aggregator" name too long
    
    cpi_device_class can only be 19 characters and a NULL terminator.
    
    With the current name we get a buffer overflow in acpi_pad_add()
    	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
    
    [akpm@linux-foundation.org: call it acpi_pad, per Shaohua Li]
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Cc: walter harms <wharms@bfs.de>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Cc: Len Brown <lenb@kernel.org>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 11439a6fd90b4861df64b4f983726e1c54977ab7
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon May 3 10:47:21 2010 -0600

    PNP: don't check for conflicts with bridge windows
    
    With fa35b4926, I broke a lot of PNP resource assignment.  That commit made
    PNPACPI include bridge windows as PNP resources, and PNP resource assignment
    treats any enabled overlapping PNP resources as conflicts.  Since PCI host
    bridge windows typically include most of the I/O port space, this makes PNP
    port assigments fail.
    
    The PCI host bridge driver will eventually use those PNP window resources,
    so we should make PNP ignore them when checking for conflicts.
    
    This fixes https://bugzilla.kernel.org/show_bug.cgi?id=15903
    
    Reported-and-tested-by: Pavel Kysilka <goldenfish@linuxsoft.cz>
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 07bedca29b0973f36a6b6db36936deed367164ed
Author: Alex Chiang <achiang@canonical.com>
Date:   Tue Apr 20 08:03:14 2010 -0600

    ACPI: DMI init_set_sci_en_on_resume for multiple Lenovo ThinkPads
    
    Multiple Lenovo ThinkPad models with Intel Core i5/i7 CPUs can
    successfully suspend/resume once, and then hang on the second s/r
    cycle.
    
    We got confirmation that this was due to a BIOS defect. The BIOS
    did not properly set SCI_EN coming out of S3. The BIOS guys
    hinted that The Other Leading OS ignores the fact that hardware
    owns the bit and sets it manually.
    
    In any case, an existing DMI table exists for machines where this
    defect is a known problem. Lenovo promise to fix their BIOS, but
    for folks who either won't or can't upgrade their BIOS, allow
    Linux to workaround the issue.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=15407
    https://bugs.launchpad.net/ubuntu/+source/linux/+bug/532374
    
    Confirmed by numerous testers in the launchpad bug that using
    acpi_sleep=sci_force_enable fixes the issue. We add the machines
    to acpisleep_dmi_table[] to automatically enable this workaround.
    
    Cc: stable@kernel.org
    Cc: Colin King <colin.king@canonical.com>
    Signed-off-by: Alex Chiang <achiang@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f238b414a74a13c3d62e31a08e81b585d750df74
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Apr 27 14:45:38 2010 -0600

    PNPACPI: compute Address Space length rather than using _LEN
    
    ACPI _CRS Address Space Descriptors have _MIN, _MAX, and _LEN.  Linux has
    been computing Address Spaces as [_MIN to _MIN + _LEN - 1].  Based on the
    tests in the bug reports below, Windows apparently uses [_MIN to _MAX].
    
    Per spec (ACPI 4.0, Table 6-40), for _CRS fixed-size, fixed location
    descriptors, "_LEN must be (_MAX - _MIN + 1)", and when that's true, it
    doesn't matter which way we compute the end.  But of course, there are
    BIOSes that don't follow this rule, and we're better off if Linux handles
    those exceptions the same way as Windows.
    
    This patch makes Linux use [_MIN to _MAX], as Windows seems to do.  This
    effectively reverts 3162b6f0c5e and replaces it with simpler code.
    
        https://bugzilla.kernel.org/show_bug.cgi?id=14337 (round)
        https://bugzilla.kernel.org/show_bug.cgi?id=15480 (truncate)
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5cc4a0f6b72878ea4e96fdb392d5d24c892a988e
Author: Dan Carpenter <error27@gmail.com>
Date:   Tue Apr 27 00:23:37 2010 +0200

    ACPI: silence kmemcheck false positive
    
    This addresses: https://bugzilla.kernel.org/show_bug.cgi?id=14998
    
    We copy some strings into "event" but we leave the space after the NULL
    terminators uninitialized.  Later in acpi_bus_receive_event() we copy
    the whole struct to another buffer with memcpy().  If the new buffer is
    stored on the stack, kmemcheck prints a warning about the unitialized
    space after the NULL terminators.
    
    It's true that the space is uninitialized, but it's harmless.  The
    buffer is only used in acpi_system_read_event() and we don't read past
    the NULL terminators.
    
    This patch changes the kmalloc() to kzalloc() so that we initialize the
    memory and silence the kmemcheck warning.
    
    Reported-by: Christian Casteyde <casteyde.christian@free.fr>
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
