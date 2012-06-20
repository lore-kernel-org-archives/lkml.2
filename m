Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2FTVqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:46:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41661 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab2FTVqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:46:23 -0400
Message-ID: <4FE2449F.8000700@zytor.com>
Date: Wed, 20 Jun 2012 14:46:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@kernel.org, agordeev@redhat.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86/apic: Try to spread IRQ vectors to different
 priority levels
References: <20120607131514.GD4759@dhcp-26-207.brq.redhat.com>  <tip-1bccd58bfffc5a677051937b332b71f0686187c1@git.kernel.org>  <4FE2071B.5040602@zytor.com> <1340228471.3696.62.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1340228471.3696.62.camel@sbsiddha-desk.sc.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 02:41 PM, Suresh Siddha wrote:
>>
>> OK, stupid question: WHY?
>>
>> In general, in Linux the random prioritization is actually a negative.
> 
> Thinking loud in the context of your e-mail. With the relatively recent
> changes like the commit mentioned below, window of higher priority class
> preempting the lower priority class is minimized to the point at which
> the cpu decides which interrupt to be serviced next. And in this case,
> it doesn't matter if the two vectors are in two different priority
> classes or the same class. Higher the vector number higher the priority
> for the cpu to service next.
>  
> commit e58aa3d2d0cc01ad8d6f7f640a0670433f794922
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Mar 26 00:06:51 2010 +0000
> 
>     genirq: Run irq handlers with interrupts disabled
> 
> 
>> The only reason for the spreading by 8 is because of bugs/misfeatures in
>> old APIC implementations which made them handle more than two interrupts
>> per priority level rather inefficiently.
> 
> Peter, Is it just inefficiency or a functional bug in those old apic's?
> Just wondering if it is just inefficiency and given the above linux
> behavior does the inefficiency matter?
> 
> Anyways, these are old platforms that we probably don't want to mess
> with. Perhaps we should go back to '8' and add a comment with all this
> info, that the real intention is not to spread them across different
> priority class but to avoid running into some old apic bugs.
> 

I think it's just an inefficiency, in the sense that the interrupt will
be held at the IOAPIC until the LAPIC frees up a slot, but I could be
wrong.  xAPIC implementations can queue an interrupt per vector, and so
are unaffected; arguably we might not even want to do the "spread by 8"
at all on those implementations.

Overall, I think there is no real upside or downside, but the poster
seemed to assume that there would be an automatic upside, and I don't
think there is.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

