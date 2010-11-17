Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab0KQHot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:44:49 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:46466 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab0KQHos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:44:48 -0500
Date: Wed, 17 Nov 2010 02:44:39 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [git pull 2.6.36.stable] intel_idle patches for
 2.6.36.stable
In-reply-to: <20101115184944.GB9597@kroah.com>
Message-id: <alpine.LFD.2.00.1011170231210.24426@x980>
References: <alpine.LFD.2.00.1011151227190.2939@x980>
 <20101115184944.GB9597@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ... I need git commit ids for the
> upstream patches that went into Linus's tree, and they should only be
> bug fixes or other stuff that is applicable for -stable.

git cherry-pick doesn't preserve the original commit id,
but I'll be happy to go back and add them to the commit messages.

> > commit 935558a7fefe0a307618857ad8a06e8a485b3b47
> > Author: Len Brown <len.brown@intel.com>
> > Date:   Wed Jul 7 00:12:03 2010 -0400
> > 
> >     intel_idle: add initial Sandy Bridge support
> >     
> >     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> Is this patch really ok for -stable?  What is the git commit id of it in
> Linus's tree?

It is okay for your local neighborhood enterprise release,
so I figured it is okay for stable.

> > commit 1768bd405dc30d4db74af5eb693d6c2d3389c5a6
> > Author: Len Brown <len.brown@intel.com>
> > Date:   Fri Oct 15 21:23:25 2010 -0400
> > 
> >     intel_idle: delete bogus data from cpuidle_state.power_usage
> >     
> >     The mW data in this field is a total fabrication
> >     and serves no purpose other than to mislead
> >     those who might see it in sysfs.  Delete it.
> >     
> >     Signed-off-by: Len Brown <len.brown@intel.com>
> > 
> > commit 645fd1ddc110eea7ab596b6fa27add5cff912e84
> > Author: Len Brown <len.brown@intel.com>
> > Date:   Fri Oct 15 20:43:06 2010 -0400
> > 
> >     intel_idle: simplify test for leave_mm()
> >     
> >     A run-time test to invoke leave_mm() for the deepest
> >     supported C-state is redundant, since the appropriate
> >     C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
> >     
> >     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> Is this patch really for -stable?

Yes.  It fixes a bug in the original driver that was
due to an oversight by yours truly.  The bug causes
a performance degragation as compared to acpi_idle.

> > commit 27a52cf2d75b81e762c8fc41fd8fca3dac2aa8ca
> > Author: H. Peter Anvin <hpa@linux.intel.com>
> > Date:   Fri Sep 17 15:36:40 2010 -0700
> > 
> >     x86, mwait: Move mwait constants to a common header file
> >     
> >     We have MWAIT constants spread across three different .c files, for no
> >     good reason.  Move them all into a common header file.
> >     
> >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> >     Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
> >     Cc: Len Brown <lenb@kernel.org>
> >     LKML-Reference: <tip-*@git.kernel.org>
> 
> Why would this be ok for -stable?

It is a trivial patch that is syntax only.
I think it makes sense for -stable because it allows
the paches that are on top of it to be identical in
upstream and in -stable.  If you leave out the trival
syntax patch, I think it adds unnecessary risk of
backporting error for subsequent patches.

> While I understand you would like the driver to be the same in both
> kernel versions, you still have to follow the normal -stable rules.

I've now read Documentation/stable_kernel_rules.txt

I'll be happy to add upstream commit id's, as I've done
before when I e-mail you plain patches.
I do not advocate deleting the trivial syntax patches,
because their presence allows stable to match upstream
almost exactly, and that significantly reduces the risk
of backporting error of subsequent patches.  I think that
has significant value and near zero risk, which is important
when optimizing for maintenance.

thanks,
Len Brown, Intel Open Source Technology Center




