Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2JSNhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:37:07 -0400
Received: from mail.x86-64.org ([217.9.48.20]:36031 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab2JSNhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:37:06 -0400
Date: Fri, 19 Oct 2012 15:37:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS fix for tip/x86/urgent
Message-ID: <20121019133701.GA5923@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

below is a RAS fix which reverts the addition of a sysfs attribute
which we agreed is not needed, post-factum. And this should go in now
because that sysfs attribute is going to end up in 3.7 otherwise and
thus exposed to userspace; removing it then would be a lot harder.

Thanks.

The following changes since commit c9623de4fc2f8320fe94316b46171683be3b1d59:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2012-10-18 16:10:42 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/cmci_threshold

for you to fetch changes up to 5bc66170dc486556a1e36fd384463536573f4b82:

  x86, MCE: Remove bios_cmci_threshold sysfs attribute (2012-10-19 15:22:29 +0200)

----------------------------------------------------------------
Remove a useless sysfs attribute added during this merge window before
it becomes a public interface.

----------------------------------------------------------------
Borislav Petkov (1):
      x86, MCE: Remove bios_cmci_threshold sysfs attribute

 arch/x86/kernel/cpu/mcheck/mce.c | 6 ------
 1 file changed, 6 deletions(-)

---
Actual commit:

commit 5bc66170dc486556a1e36fd384463536573f4b82
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Thu Oct 18 15:10:56 2012 +0200

    x86, MCE: Remove bios_cmci_threshold sysfs attribute
    
    450cc201038f3 ("x86/mce: Provide boot argument to honour bios-set CMCI
    threshold") added the bios_cmci_threshold sysfs attribute which was
    supposed to communicate to userspace tools that BIOS CMCI threshold has
    been honoured.
    
    However, this info is not of any importance to userspace - it should
    rather get the actual error count it has been thresholded already from
    MCi_STATUS[38:52].
    
    So drop this before it becomes a used interface (good thing we caught
    this early in 3.7-rc1, right after the merge window closed).
    
    Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    Acked-by: Tony Luck <tony.luck@intel.com>
    Link: http://lkml.kernel.org/r/20121017105940.GA14590@x1.osrc.amd.com
    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29e87d3b2843..46cbf8689692 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2209,11 +2209,6 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
        &mce_cmci_disabled
 };
 
-static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
-       __ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
-       &mce_bios_cmci_threshold
-};
-
 static struct device_attribute *mce_device_attrs[] = {
        &dev_attr_tolerant.attr,
        &dev_attr_check_interval.attr,
@@ -2222,7 +2217,6 @@ static struct device_attribute *mce_device_attrs[] = {
        &dev_attr_dont_log_ce.attr,
        &dev_attr_ignore_ce.attr,
        &dev_attr_cmci_disabled.attr,
-       &dev_attr_bios_cmci_threshold.attr,
        NULL
 };

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
