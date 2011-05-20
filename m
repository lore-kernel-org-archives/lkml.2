Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1ETGI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:08:58 -0400
Received: from mail168c2.megamailservers.com ([69.49.111.68]:51624 "EHLO
	mail168c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab1ETGI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:08:56 -0400
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4DD60530.6090900@gaisler.com>
Date: Fri, 20 May 2011 08:07:44 +0200
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the tip tree with the sparc tree
References: <20110517131435.aceca54e.sfr@canb.auug.org.au>	 <4DD51D37.3010907@gaisler.com> <1305819306.2466.7228.camel@twins>
In-Reply-To: <1305819306.2466.7228.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=WwssvlT0cz5J1BoOJvKjEQtles6kVRNS28LycuPzbaY= c=1 sm=1
		a=pl2ZPvC6udcA:10 a=lNNZMRzb4sQA:10 a=U62ajLuCel8A:10 a=IkcTkHD0fZMA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=si9AsuCPRFdM3GB3Y18A:9
		a=tNQq-l9cOjL89p47BZcA:7 a=QEXdDO2ut3YA:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

>On Thu, 2011-05-19 at 15:37 +0200, Daniel Hellstrom wrote:
>
>
>  
>
>>diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
>>index 41102c5..d5b3958 100644
>>--- a/arch/sparc/kernel/smp_32.c
>>+++ b/arch/sparc/kernel/smp_32.c
>>@@ -156,11 +156,11 @@ void arch_send_call_function_ipi_mask(const struct 
>>cpumask *mask)
>>
>> void smp_resched_interrupt(void)
>> {
>>+       irq_enter();
>>+       scheduler_ipi();
>>        local_cpu_data().irq_resched_count++;
>>-       /*
>>-        * do nothing, since it all was about calling re-schedule
>>-        * routine called by interrupt return code.
>>-        */
>>+       irq_exit();
>>+       /* re-schedule routine called by interrupt return code. */
>> }
>>    
>>
>
>That doesn't look like an IPI, that looks like its calls the function on
>the local cpu, which is completely pointless.
>  
>
The above function is one of the IPI interrupt handlers.

The smp_send_reschedule() is called by the generic code, it is 
responsible for sending an IRQ to the target CPU, that CPU comes into 
smp_resched_interrupt above from the IRQ trap handler. So yes, the 
scheduler_ipi() is called on the local CPU, but on the CPU taking the 
IPI not the CPU sending the IPI.

Daniel
