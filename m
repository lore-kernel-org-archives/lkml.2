Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1IBTah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:30:37 -0400
Received: from claw.goop.org ([74.207.240.146]:45092 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab1IBTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:30:35 -0400
Message-ID: <4E612ED5.7050303@goop.org>
Date: Fri, 02 Sep 2011 12:30:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 10/13] xen/pvticket: allow interrupts to be enabled while
 blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>  <17a0f6177a71190dad30a6dcd1da93bec13a7836.1314922370.git.jeremy.fitzhardinge@citrix.com> <1314974905.1861.2.camel@twins>
In-Reply-To: <1314974905.1861.2.camel@twins>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 07:48 AM, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 17:55 -0700, Jeremy Fitzhardinge wrote:
>> +       /* Make sure an interrupt handler can't upset things in a
>> +          partially setup state. */
>>         local_irq_save(flags);
>>  
>> +       /*
>> +        * We don't really care if we're overwriting some other
>> +        * (lock,want) pair, as that would mean that we're currently
>> +        * in an interrupt context, and the outer context had
>> +        * interrupts enabled.  That has already kicked the VCPU out
>> +        * of xen_poll_irq(), so it will just return spuriously and
>> +        * retry with newly setup (lock,want).
>> +        *
>> +        * The ordering protocol on this is that the "lock" pointer
>> +        * may only be set non-NULL if the "want" ticket is correct.
>> +        * If we're updating "want", we must first clear "lock".
>> +        */
>> +       w->lock = NULL; 
> I mean, I don't much care about Xen code, but that's two different
> comment styles.

Yeah, that's the "two line comment style" next to "big block comment"
style - but you're right they look pretty bad juxtaposed like that.

    J

