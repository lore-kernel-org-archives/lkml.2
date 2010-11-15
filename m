Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab0KOR3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:29:24 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:50056 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0KOR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:29:23 -0500
Date: Mon, 15 Nov 2010 12:29:05 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: stable@kernel.org
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull 2.6.36.stable] intel_idle patches for 2.6.36.stable
Message-id: <alpine.LFD.2.00.1011151227190.2939@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.36.git idle-release

to sync 2.6.36.y with upstream changes to the intel_idle driver.

After applying this series, 2.6.36.y and upstream intel_idle.c
are identical.

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

ps.  a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.36/idle-release-2.6.36.diff.gz

 arch/x86/include/asm/mwait.h  |   15 +++++++++
 arch/x86/kernel/acpi/cstate.c |   11 +------
 drivers/acpi/acpi_pad.c       |    7 +---
 drivers/idle/intel_idle.c     |   70 +++++++++++++++++++++++++++-------------
 4 files changed, 64 insertions(+), 39 deletions(-)
 create mode 100644 arch/x86/include/asm/mwait.h

through these commits:

H. Peter Anvin (1):
      x86, mwait: Move mwait constants to a common header file

Len Brown (4):
      intel_idle: simplify test for leave_mm()
      intel_idle: delete bogus data from cpuidle_state.power_usage
      intel_idle: add initial Sandy Bridge support
      intel_idle: do not use the LAPIC timer for ATOM C2

with this log:

commit d84eee4807915da8b7ffecd00956f3417433622f
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 23 23:25:53 2010 -0400

    intel_idle: do not use the LAPIC timer for ATOM C2
    
    If we use the LAPIC timer during ATOM C2 on
    some nvidia chisets, the system stalls.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=21032
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 935558a7fefe0a307618857ad8a06e8a485b3b47
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 7 00:12:03 2010 -0400

    intel_idle: add initial Sandy Bridge support
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1768bd405dc30d4db74af5eb693d6c2d3389c5a6
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:23:25 2010 -0400

    intel_idle: delete bogus data from cpuidle_state.power_usage
    
    The mW data in this field is a total fabrication
    and serves no purpose other than to mislead
    those who might see it in sysfs.  Delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 645fd1ddc110eea7ab596b6fa27add5cff912e84
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 20:43:06 2010 -0400

    intel_idle: simplify test for leave_mm()
    
    A run-time test to invoke leave_mm() for the deepest
    supported C-state is redundant, since the appropriate
    C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 27a52cf2d75b81e762c8fc41fd8fca3dac2aa8ca
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri Sep 17 15:36:40 2010 -0700

    x86, mwait: Move mwait constants to a common header file
    
    We have MWAIT constants spread across three different .c files, for no
    good reason.  Move them all into a common header file.
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
    Cc: Len Brown <lenb@kernel.org>
    LKML-Reference: <tip-*@git.kernel.org>
