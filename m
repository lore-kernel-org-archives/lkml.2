Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1AZQL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:11:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1AZQL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:11:27 -0500
Subject: Re: [PATCH 05/16] KVM-HDR: Implement wallclock over KVM - KVM
 Virtual Memory
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
In-Reply-To: <4D403AEE.6010208@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-6-git-send-email-glommer@redhat.com>
	 <4D4001D6.9030909@redhat.com>
	 <1296044403.15920.54.camel@mothafucka.localdomain>
	 <4D403AEE.6010208@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 26 Jan 2011 13:45:04 -0200
Message-ID: <1296056704.3591.28.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:17 +0200, Avi Kivity wrote:
> On 01/26/2011 02:20 PM, Glauber Costa wrote:
> > On Wed, 2011-01-26 at 13:13 +0200, Avi Kivity wrote:
> > >  On 01/24/2011 08:06 PM, Glauber Costa wrote:
> > >  >  As a proof of concept to KVM - Kernel Virtual Memory, this patch
> > >  >  implements wallclock grabbing on top of it. At first, it may seem
> > >  >  as a waste of work to just redo it, since it is working well. But over the
> > >  >  time, other MSRs were added - think ASYNC_PF - and more will probably come.
> > >  >  After this patch, we won't need to ever add another virtual MSR to KVM.
> > >  >
> > >
> > >  So instead of adding MSRs, we're adding area identifiers.  What did we gain?
> >
> > * No risk of namespace clashes of any kind,
> > * less need for userspace coordination for feature enablement,
> 
> That's a bug, not a feature.

I don't see why.
I's about feature enablement, not feature discovery. 

> > * more robust mechanism that can do discovery even on early boot,
> 
> cpuid/wrmsr should be robust enough.
> 
> > * more informative result values can be passed on to guest kernel,
> 
> True.
> 
> > * more flexibility, since we go back to userspace if we can't handle
> > some request. Also, some requests are better handled by userspace
> > anyway. But again, maybe this is a separate issue here...
> 
> Yes.
> 
> > * size information goes together with base, allowing for extending
> > structures (well, maybe I should add versioning explicitly?)
> >
> 
> We could do that as well with wrmsr, by having the size as the first 
> field of the structure.  Usually the size isn't really interesting, 
> though, since you need to discover/enable the new features independently.

Which structure? For msrs, we're usually going for just an u64, but of
course we could change that when needed.



