Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907Ab0KQIeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:34:08 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:64514 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab0KQIeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:34:06 -0500
Date: Wed, 17 Nov 2010 03:33:47 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: stable@kernel.org
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull 2.6.36.stable] intel_idle patches for 2.6.36.stable
In-reply-to: <alpine.LFD.2.00.1011170322270.24426@x980>
Message-id: <alpine.LFD.2.00.1011170331150.24426@x980>
References: <alpine.LFD.2.00.1011151227190.2939@x980>
 <alpine.LFD.2.00.1011170322270.24426@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please disregard the previous commit log on this thread,
for it was the 2.6.35.y log, while the (smaller) 2.6.36.y log is below.
      
I've added upstream commit id's to each commit comment in this series.
If that is enough to make -stable happy, then we're done.

If you would rather not pull this series because it 
does not exclude the intermediate syntax patches that 
are upstream, then I understand that viewpoint too. 

thanks,
-Len Brown, Intel Open Source Technology Center

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

This will update the files shown below.

thanks!

ps. a consolidated plain patch is available here:
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

commit 7f3ea665c65b960fe5a2ea1e445e0df6e812008e
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 23 23:25:53 2010 -0400

    intel_idle: do not use the LAPIC timer for ATOM C2
    
    upstream: c25d29952b2a8c9aaf00e081c9162a0e383030cd
    
    If we use the LAPIC timer during ATOM C2 on
    some nvidia chisets, the system stalls.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=21032
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 46a9d923c69249ee31cdf1ca9acf5fb7b9c63e6a
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 7 00:12:03 2010 -0400

    intel_idle: add initial Sandy Bridge support
    
    upstream: d13780d439d08a57c87c1a07b6e76ddde61da1aa
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a040a61b60cb03ffdfaeaa208a2fcf25f0e11727
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:23:25 2010 -0400

    intel_idle: delete bogus data from cpuidle_state.power_usage
    
    upstream: dea44c6b7df7f8bb67cb059b4c14b24288c4cd04
    
    The mW data in this field is a total fabrication
    and serves no purpose other than to mislead
    those who might see it in sysfs.  Delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bd592a79c7eb1c52b812933dc64a37452b2e9047
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 20:43:06 2010 -0400

    intel_idle: simplify test for leave_mm()
    
    upstream: c8381cc3d8a9cc6c80f65bf60863c776651f245c
    
    A run-time test to invoke leave_mm() for the deepest
    supported C-state is redundant, since the appropriate
    C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b53be4ee844a7528565352e0cdab8ff9095a9f8f
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri Sep 17 15:36:40 2010 -0700

    x86, mwait: Move mwait constants to a common header file
    
    upstream: bc83cccc761953f878088cdfa682de0970b5561f
    
    We have MWAIT constants spread across three different .c files, for no
    good reason.  Move them all into a common header file.
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
    Cc: Len Brown <lenb@kernel.org>
    LKML-Reference: <tip-*@git.kernel.org>

