Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab0JZTw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:52:57 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:58786 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab0JZTw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:52:56 -0400
Date: Tue, 26 Oct 2010 15:52:41 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [git pull request] idle patches for 2.6.37-merge
Message-id: <alpine.LFD.2.00.1010261551090.14156@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.36/idle-release-2.6.36-rc8.diff.gz

 drivers/acpi/processor_idle.c |    1 -
 drivers/idle/intel_idle.c     |   61 +++++++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 16 deletions(-)

through these commits:

Len Brown (5):
      intel_idle: simplify test for leave_mm()
      intel_idle: delete bogus data from cpuidle_state.power_usage
      acpi_idle: delete bogus data from cpuidle_state.power_usage
      intel_idle: add initial Sandy Bridge support
      intel_idle: do not use the LAPIC timer for ATOM C2

with this log:

commit c25d29952b2a8c9aaf00e081c9162a0e383030cd
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 23 23:25:53 2010 -0400

    intel_idle: do not use the LAPIC timer for ATOM C2
    
    If we use the LAPIC timer during ATOM C2 on
    some nvidia chisets, the system stalls.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=21032
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 00527cc6bbcac05ab7d54c40bda1ff2a0625ab10
Merge: 0f3f164 d13780d
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 23 02:33:50 2010 -0400

    Merge branch 'intel_idle+snb' into idle-release
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d13780d439d08a57c87c1a07b6e76ddde61da1aa
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 7 00:12:03 2010 -0400

    intel_idle: add initial Sandy Bridge support
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f3f164d9794f57d8afb033819f508a486c1304d
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:25:02 2010 -0400

    acpi_idle: delete bogus data from cpuidle_state.power_usage
    
    The mW data in this field comes from AML _CST,
    which was typed in by a BIOS writer, and is thus
    considered unreliable.
    
    Linux does not use it for making any decisions.
    We do display it in sysfs where somebody might
    read it and assume it is meaningful, so delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dea44c6b7df7f8bb67cb059b4c14b24288c4cd04
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:23:25 2010 -0400

    intel_idle: delete bogus data from cpuidle_state.power_usage
    
    The mW data in this field is a total fabrication
    and serves no purpose other than to mislead
    those who might see it in sysfs.  Delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c8381cc3d8a9cc6c80f65bf60863c776651f245c
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 20:43:06 2010 -0400

    intel_idle: simplify test for leave_mm()
    
    A run-time test to invoke leave_mm() for the deepest
    supported C-state is redundant, since the appropriate
    C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
