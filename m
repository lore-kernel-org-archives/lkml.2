Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1CYPgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:36:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59520 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1CYPgJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 25 Mar 2011 11:36:09 -0400
Date: Fri, 25 Mar 2011 11:35:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, venki@google.com,
        ak@linux.intel.com, suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
        peterz@infradead.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        arjan@linux.intel.com
Subject: Re: [Xen-devel] Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle
 driver registration and selection
Message-ID: <20110325153524.GN27651@dumpdata.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123233.28725.92874.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103222254420.10549@x980>
 <4D89BBDD.5090505@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231633030.12911@x980>
 <4D8B5197.2060306@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103250245570.32565@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103250245570.32565@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D8CB63D.0110,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 03:05:36AM -0400, Len Brown wrote:
> > I think there are other problems too, related to saving and restoring
> > of pm_idle pointer. For example, cpuidle itself saves current value
> > of pm_idle, flips it and then restores the saved value. There is
> > no guarantee that the saved function still exists. APM does exact
> > same thing (though it may not be used these days).
> > 
> > The problem also is that a number of architectures have copied the
> > same design based on pm_idle; so its spreading.
> 
> pm_idle is a primitive design yes, but I think the issue
> with pm_idle is a theoretical one, at least on x86;
> as there isn't any other code scribbling on pm_idle
> in practice.  So this is clean-up, rather than bug-fix work...
> 
> > > It isn't immediately clear to me that all of these options
> > > need to be preserved.
> > 
> > So what do you suggest can be removed?
> 
> I sent a series of small patches yesterday to get the ball rolling...
> https://lkml.org/lkml/2011/3/24/54
> 
> I think the xen thing can go away.

The xen thing being the setting of cpuidle to halt or the proposed
patch?
