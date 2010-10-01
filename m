Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0JAFgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:36:18 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:63103 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0JAFgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:36:17 -0400
Date: Fri, 01 Oct 2010 01:36:03 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Power Management List <linux-pm@lists.osdl.org>
Subject: [git pull request] idle patches for 2.6.36-rc6
Message-id: <alpine.LFD.2.00.1010010134120.7033@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

Two regressio fixes for those cutting over to intel_idle from acpi_idle,
both are candidates for 2.6.35.stable.

First, if you have a Lenovo S10-3 netbook, you could not boot.
Second, intel_idle was not as quiet as acpi_idle on multi-core.
Plus some low risk fluff patches to get out of the way.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.36/idle-release-2.6.36-rc6.diff.gz

 drivers/acpi/processor_driver.c  |    2 +-
 drivers/cpuidle/governors/menu.c |    2 +-
 drivers/idle/intel_idle.c        |   20 +++++++++++++++-----
 drivers/pci/quirks.c             |   20 ++++++++++++++++++++
 include/linux/cpuidle.h          |    1 +
 5 files changed, 38 insertions(+), 7 deletions(-)
 mode change 100755 => 100644 drivers/idle/intel_idle.c

through these commits:

Len Brown (2):
      intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
      acpi_idle: add missing \n to printk

Lucas De Marchi (1):
      cpuidle: Fix typos

Namhyung Kim (1):
      intel_idle: add missing __percpu markup

Suresh Siddha (1):
      intel_idle: Voluntary leave_mm before entering deeper

Thomas Weber (1):
      intel_idle: Change mode 755 => 644

with this log:

commit 6110a1f43c27b516e16d5ce8860fca50748c2a87
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Thu Sep 30 21:19:07 2010 -0400

    intel_idle: Voluntary leave_mm before entering deeper
    
    Avoid TLB flush IPIs for the cores in deeper c-states by voluntary leave_mm()
    before entering into that state. CPUs tend to flush TLB in those c-states
    anyways.
    
    acpi_idle does this with C3-type states, but it was not caried over
    when intel_idle was introduced.  intel_idle can apply it
    to C-states in addition to those that ACPI might export as C3...
    
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9587a678fa56ea6d7f39b048f24f5d03a89bf9b3
Merge: e9a64ed 4731fdc
Author: Len Brown <len.brown@intel.com>
Date:   Tue Sep 28 23:30:58 2010 -0400

    Merge branch 'meego-7093' into idle-release

commit e9a64ed4994db04c9963495b03d8a86538e3ad55
Author: Len Brown <len.brown@intel.com>
Date:   Fri Sep 24 20:50:02 2010 -0400

    acpi_idle: add missing \n to printk
    
    otherwise, these two lines print as one:
    
    ACPI: acpi_idle yielding to intel_idle
    ACPI: SSDT 3f5d8741 00203 (v02 PmRef  Cpu0Ist 00003000 INTL 20050624)
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3265eba0bed7645cacd5e2cb3614d504b5ac29e6
Author: Namhyung Kim <namhyung@gmail.com>
Date:   Sun Aug 8 03:10:03 2010 +0900

    intel_idle: add missing __percpu markup
    
    intel_idle_cpuidle_devices is a percpu pointer
    but was missing __percpu markup.
    
    Signed-off-by: Namhyung Kim <namhyung@gmail.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 68f160125f0655c21a1c9f896ddff97d98012cb0
Author: Thomas Weber <weber@corscience.de>
Date:   Mon Jul 12 08:56:43 2010 +0200

    intel_idle: Change mode 755 => 644
    
    Remove execution permission from source file.
    
    Signed-off-by: Thomas Weber <weber@corscience.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 20e3341bb138bc9860adea4d76707470357b76ab
Author: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date:   Tue Sep 7 12:53:49 2010 -0400

    cpuidle: Fix typos
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4731fdcf6f7bdab3e369a3f844d4ea4d4017284d
Author: Len Brown <len.brown@intel.com>
Date:   Fri Sep 24 21:02:27 2010 -0400

    intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
    
    When the Lenovo Ideapad S10-3 is booted with HT enabled,
    it hits a boot hang in the intel_idle driver.
    
    This occurs when entering ATM-C4 for the first time,
    unless BM_STS is first cleared.
    
    acpi_idle doesn't see this because it first checks
    and clears BM_STS, but it would hit the same hang
    if that check were disabled.
    
    http://bugs.meego.com/show_bug.cgi?id=7093
    https://bugs.launchpad.net/ubuntu/+source/linux/+bug/634702
    
    Signed-off-by: Len Brown <len.brown@intel.com>
