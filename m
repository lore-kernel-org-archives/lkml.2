Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1A0MRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:17:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1A0MRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:17:31 -0500
Message-ID: <4D416256.1040507@redhat.com>
Date: Thu, 27 Jan 2011 14:17:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH 05/16] KVM-HDR: Implement wallclock over KVM - KVM Virtual
 Memory
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>	 <1295892397-11354-6-git-send-email-glommer@redhat.com>	 <4D4001D6.9030909@redhat.com>	 <1296044403.15920.54.camel@mothafucka.localdomain>	 <4D403AEE.6010208@redhat.com> <1296056704.3591.28.camel@mothafucka.localdomain>
In-Reply-To: <1296056704.3591.28.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 05:45 PM, Glauber Costa wrote:
> On Wed, 2011-01-26 at 17:17 +0200, Avi Kivity wrote:
> >  On 01/26/2011 02:20 PM, Glauber Costa wrote:
> >  >  On Wed, 2011-01-26 at 13:13 +0200, Avi Kivity wrote:
> >  >  >   On 01/24/2011 08:06 PM, Glauber Costa wrote:
> >  >  >   >   As a proof of concept to KVM - Kernel Virtual Memory, this patch
> >  >  >   >   implements wallclock grabbing on top of it. At first, it may seem
> >  >  >   >   as a waste of work to just redo it, since it is working well. But over the
> >  >  >   >   time, other MSRs were added - think ASYNC_PF - and more will probably come.
> >  >  >   >   After this patch, we won't need to ever add another virtual MSR to KVM.
> >  >  >   >
> >  >  >
> >  >  >   So instead of adding MSRs, we're adding area identifiers.  What did we gain?
> >  >
> >  >  * No risk of namespace clashes of any kind,
> >  >  * less need for userspace coordination for feature enablement,
> >
> >  That's a bug, not a feature.
>
> I don't see why.
> I's about feature enablement, not feature discovery.

Well, "zero userspace coordination" would be a bug, since it would 
remove userspace-controlled discovery.  Since the userspace patches for 
these types of features are usually very small, "less coordination" 
doesn't buy us much.

> >
> >  >  * size information goes together with base, allowing for extending
> >  >  structures (well, maybe I should add versioning explicitly?)
> >  >
> >
> >  We could do that as well with wrmsr, by having the size as the first
> >  field of the structure.  Usually the size isn't really interesting,
> >  though, since you need to discover/enable the new features independently.
>
> Which structure? For msrs, we're usually going for just an u64, but of
> course we could change that when needed.

It's usually a physical address of a structure (together with an enable 
bit).

-- 
error compiling committee.c: too many arguments to function

