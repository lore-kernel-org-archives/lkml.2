Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0FBIvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:51:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39062 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab0FBIvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:51:01 -0400
Date: Wed, 2 Jun 2010 10:50:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100602085055.GA14221@basil.fritz.box>
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com> <20100601172730.GB11880@basil.fritz.box> <4C05C722.1010804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C05C722.1010804@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 05:51:14AM +0300, Avi Kivity wrote:
> On 06/01/2010 08:27 PM, Andi Kleen wrote:
>> On Tue, Jun 01, 2010 at 07:52:28PM +0300, Avi Kivity wrote:
>>    
>>> We are running everything on NUMA (since all modern machines are now NUMA).
>>>   At what scale do the issues become observable?
>>>      
>> On Intel platforms it's visible starting with 4 sockets.
>>    
>
> Can you recommend a benchmark that shows bad behaviour?  I'll run it with 

Pretty much anything with high lock contention.

> ticket spinlocks and Gleb's patch.  I have a 4-way Nehalem-EX, presumably 
> the huge number of threads will magnify the problem even more there.

Yes more threads cause more lock contention too.

> Do  you have any idea how we can tackle both problems?

Apparently Xen has something, perhaps that can be leveraged
(but I haven't looked at their solution in detail)

Otherwise I would probably try to start with a adaptive
spinlock that at some point calls into the HV (or updates
shared memory?), like john cooper suggested. The tricky part here would
be to find the thresholds and fit that state into
paravirt ops and the standard spinlock_t.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
