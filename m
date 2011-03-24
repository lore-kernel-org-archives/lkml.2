Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab1CXHSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:18:46 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:41373 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab1CXHSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:18:44 -0400
Date: Thu, 24 Mar 2011 03:18:14 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, arjan@linux.intel.com,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
In-reply-to: <4D89C40B.4020809@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1103231659210.12911@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
 <20110322145054.GB26952@dumpdata.com> <4D89C40B.4020809@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is a CONFIG_XEN kernel supposed to use just HLT in idle?

xen_arch_setup() does this:

        pm_idle = default_idle;
        boot_option_idle_override = IDLE_HALT;

which has that effect.  I guess this makes sense b/c the
CONFIG_XEN kernel is Dom0 and the real C-sates are done
by the hypervisor?

Would the same CONFIG_XEN kernel binary ever not
run xen_arch_setup(), run on raw hardware, and want
to use idle states other than HLT?

thanks,
-Len Brown, Intel Open Source Technology Center


