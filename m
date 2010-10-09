Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab0JICrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 22:47:07 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40185 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760141Ab0JICrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 22:47:05 -0400
Date: Fri, 08 Oct 2010 22:46:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI patches for Linux-2.6.36-rc7
Message-id: <alpine.LFD.2.00.1010082243390.3961@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
Fixes a 2.6.34 regression, and works around a machine that went into an 
infinite AML loop in the name of Vista+Nvidia compatibility.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.36/acpi-release-20100702-2.6.36-rc7.diff.gz

 drivers/acpi/blacklist.c      |   17 +++++++++++++++++
 drivers/acpi/processor_core.c |    1 +
 2 files changed, 18 insertions(+), 0 deletions(-)

through these commits:

Lee, Chun-Yi (1):
      ACPI: add DMI to disable AML Vista compatibility on MSI GX723 Notebook

Yinghai Lu (1):
      ACPI: Handle ACPI0007 Device in acpi_early_set_pdc

with this log:

commit 7cfff7f21221725f587ba90bd1acf0e2e0304901
Merge: c9933f7 3deb11e
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 8 22:37:46 2010 -0400

    Merge branch 'msi-dmi' into release

commit c9933f795c0740eaf97e6291a68a9787346d5997
Merge: cb655d0 c1e0ddb
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 8 22:35:02 2010 -0400

    Merge branch 'pdc-regression' into release

commit 3deb11ef16632fb76daead0db281f6f7d19332f2
Author: Lee, Chun-Yi <jlee@novell.com>
Date:   Fri Oct 1 16:28:29 2010 +0800

    ACPI: add DMI to disable AML Vista compatibility on MSI GX723 Notebook
    
    The brightness control hotkey don't work with Vista compatibility
    because the MSI GX723 includes an infinite while loop in DSDT when
    brightness control hotkey pressed.
    
    The MSI GX723 uses Nvidia video.  Perhaps the loop is specific
    to the Nvidia Vista driver...
    
    This patch should be reverted once nouveau grows support
    to call the ACPI NVIF method.
    
    Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1e0ddbf0a97e1704d7f13b4934f9acca002402d
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Sep 17 23:26:24 2010 -0700

    ACPI: Handle ACPI0007 Device in acpi_early_set_pdc
    
    After
    | commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
    | Author: Alex Chiang <achiang@hp.com>
    | Date:   Mon Feb 22 12:11:39 2010 -0700
    |
    |    ACPI: processor: driver doesn't need to evaluate _PDC
    |
    |    Now that the early _PDC evaluation path knows how to correctly
    |    evaluate _PDC on only physically present processors, there's no
    |    need for the processor driver to evaluate it later when it loads.
    |
    |    To cover the hotplug case, push _PDC evaluation down into the
    |    hotplug paths.
    
    only cpu with Processor Statement get processed with _PDC
    
    If bios is using Device object instead of Processor statement.
    SSDTs for Pstate/Cstate/Tstate can not be loaded dynamically.
    
    Need to try to scan ACPI0007 in addition to Processor.
    
    That commit is between 2.6.34-rc1 and 2.6.34-rc2, so stable tree for 2.6.34+
    need this patch.
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
