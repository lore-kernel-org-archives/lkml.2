Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1CWC7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 22:59:51 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:58706 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1CWC7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 22:59:49 -0400
Date: Tue, 22 Mar 2011 22:59:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle driver registration
 and selection
In-reply-to: <20110322123233.28725.92874.stgit@tringupt.in.ibm.com>
Message-id: <alpine.LFD.2.02.1103222254420.10549@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123233.28725.92874.stgit@tringupt.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the original cpuidle prototype supported multiple driver registration,
but no production use for it could be imagined, and so it was deleted.

Subsequently on x86, we added intel_idle to replace acpi_idle
and a typical kernel will have them both built in.
We still don't allow mutliple registrations, we just arrange
affairs such that the preferred intel_idle probes before 
the backup, acpi_idle.  If intel_idle recognizes the platform,
its probe succeeds, else acpi_idle gets a go.
If there is a problem with intel_idle, or a comparison needs to be made,
a bootparam is available to tell intel_idle not to probe.

This mechanism takes approximately 10 lines of code -- the bootparam
to disable the preferred driver.

What is the benefit of all the code to support the feature of run-time
multiple driver registration and switching?

thanks,
Len Brown, Intel Open Source Technology Center

