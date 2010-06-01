Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0FAR1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:27:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41208 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0FAR1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:27:35 -0400
Date: Tue, 1 Jun 2010 19:27:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100601172730.GB11880@basil.fritz.box>
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C053ACC.5020708@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 07:52:28PM +0300, Avi Kivity wrote:
> We are running everything on NUMA (since all modern machines are now NUMA). 
>  At what scale do the issues become observable?

On Intel platforms it's visible starting with 4 sockets.

>
>>> I understand that reason and do not propose to get back to old spinlock
>>> on physical HW! But with virtualization performance hit is unbearable.
>>>      
>> Extreme unfairness can be unbearable too.
>>    
>
> Well, the question is what happens first.  In our experience, vcpu 
> overcommit is a lot more painful.  People will never see the NUMA 
> unfairness issue if they can't use kvm due to the vcpu overcommit problem.

You really have to address both, if you don't fix them both
users will eventually into one of them and be unhappy.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
