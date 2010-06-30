Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0F3LnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:43:20 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41163 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0F3LnS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 07:43:18 -0400
Message-Id: <4C2B4A100200007800008CC5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 12:43:44 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Peter Zijlstra" <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
	 base implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
 <1277885133.1868.71.camel@laptop>
 <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
 <1277889116.1868.95.camel@laptop> <4C2B14BE.6080505@goop.org>
In-Reply-To: <4C2B14BE.6080505@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 11:56, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 06/30/2010 11:11 AM, Peter Zijlstra wrote:
>> On Wed, 2010-06-30 at 10:00 +0100, Jan Beulich wrote:
>>   
>>>>>> On 30.06.10 at 10:05, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>>           
>>>> On Tue, 2010-06-29 at 15:31 +0100, Jan Beulich wrote:
>>>>       
>>>>> Add optional (alternative instructions based) callout hooks to the
>>>>> contended ticket lock and the ticket unlock paths, to allow hypervisor
>>>>> specific code to be used for reducing/eliminating the bad effects
>>>>> ticket locks have on performance when running virtualized.
>>>>>         
>>>> Uhm, I'd much rather see a single alternative implementation, not a
>>>> per-hypervisor lock implementation.
>>>>       
>>> How would you imaging this to work? I can't see how the mechanism
>>> could be hypervisor agnostic. Just look at the Xen implementation
>>> (patch 2) - do you really see room for meaningful abstraction there?
>>>     
>> I tried not to, it made my eyes bleed.. 
>>
>> But from what I hear all virt people are suffering from spinlocks (and
>> fair spinlocks in particular), so I was thinking it'd be a good idea to
>> get all interested parties to collaborate on one. Fragmentation like
>> this hardly ever works out well.
>>   
> 
> The fastpath of the spinlocks can be common, but if it ends up spinning
> too long (however that might be defined), then it needs to call out to a
> hypervisor-specific piece of code which is effectively "yield this vcpu
> until its worth trying again".  In Xen we can set up an event channel
> that the waiting CPU can block on, and the current lock holder can
> tickle it when it releases the lock (ideally it would just tickle the
> CPU with the next ticket, but that's a further refinement).

It does tickle just the new owner - that's what the list is for.

Jan

