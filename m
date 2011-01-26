Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1AZSLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:11:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1AZSLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:11:36 -0500
Subject: Re: [PATCH 01/16] KVM-HDR: register KVM basic header infrastructure
From: Glauber Costa <glommer@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com
In-Reply-To: <4D405853.6010003@codemonkey.ws>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-2-git-send-email-glommer@redhat.com>
	 <4D400045.2000405@redhat.com>
	 <1296044013.15920.47.camel@mothafucka.localdomain>
	 <4D4039CB.6060008@redhat.com>
	 <1296056170.3591.14.camel@mothafucka.localdomain>
	 <4D405853.6010003@codemonkey.ws>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 26 Jan 2011 15:49:42 -0200
Message-ID: <1296064182.3591.30.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 11:22 -0600, Anthony Liguori wrote:
> On 01/26/2011 09:36 AM, Glauber Costa wrote:
> > On Wed, 2011-01-26 at 17:12 +0200, Avi Kivity wrote:
> >    
> >> On 01/26/2011 02:13 PM, Glauber Costa wrote:
> >>      
> >>>>   - it doesn't lend itself will to live migration.  Extra state must be
> >>>>   maintained in the hypervisor.
> >>>>          
> >>> Yes, but can be queried at any time as well. I don't do it in this
> >>> patch, but this is explicitly mentioned in my TODO.
> >>>        
> >> Using the existing method (MSRs) takes care of this, which reduces churn.
> >>      
> > No, it doesn't.
> >
> > First, we have to explicitly list some msrs for save/restore in
> > userspace anyway. But also, the MSRs only holds values. For the case I'm
> > trying to hit here, being: msrs being used to register something, like
> > kvmclock, there is usually accompanying code as well.
> >
> >
> >    
> >>>>   - it isn't how normal hardware operates
> >>>>          
> >>> Since we're trying to go for guest cooperation here, I don't really see
> >>> a need to stay close to hardware here.
> >>>        
> >> For Linux there is not much difference, since we can easily adapt it.
> >> But we don't know the impact on other guests, and we can't refactor
> >> them.  Staying close to precedent means it will be easier for other
> >> guests to work with a kvm host, if they choose.
> >>      
> > I honestly don't see the difference. I am not proposing anything
> > terribly different, in the end, for the sake of this specific point of
> > guest supportability it's all 1 msr+cpuid vs n msr+cpuid.
> >    
> 
> If type becomes implied based on the MSR number, you'd get the best of 
> both worlds, no?
> 
> I do think advertising features in CPUID is nicer than writing to an MSR 
> and then checking for an ack in the memory region.
Fine. But back to the point, I think the reasoning here is that I see
all those areas as just a single feature, shared data.

> 
> >>> * This mechanism just bumps us out to userspace if we can't handle a
> >>> request. As such, it allows for pure guest kernel ->   userspace
> >>> communication, that can be used, for instance, to emulate new features
> >>> in older hypervisors one does not want to change. BTW, maybe there is
> >>> value in exiting to userspace even if we stick to the
> >>> one-msr-per-feature approach?
> >>>        
> >> Yes.
> >>
> >> I'm not 100% happy with emulating MSRs in userspace, but we can think
> >> about a mechanism that allows userspace to designate certain MSRs as
> >> handled by userspace.
> >>
> >> Before we do that I'd like to see what fraction of MSRs can be usefully
> >> emulated in userspace (beyond those that just store a value and ignore it).
> >>      
> > None of the existing. But for instance, I was discussing this issue with
> > anthony a while ago, and he thinks that in order to completely avoid
> > bogus softlockups, qemu/userspace, which is the entity here that knows
> > when it has stopped (think ctrl+Z or stop + cont, save/restore, etc),
> > could notify this to the guest kernel directly through a shared variable
> > like this.
> >
> > See, this is not about "new features", but rather, about between pieces
> > of memory. So what I'm doing in the end is just generalizing "an MSR for
> > shared memory", instead of one new MSR for each piece of data.
> >    
> 
> I do think having a standard mechanism for small regions of shared 
> memory between the hypervisor and guest is a reasonable thing to do.

Through what I am proposing, or through something else? (including
slight variations)


