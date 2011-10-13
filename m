Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1JMSQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:16:53 -0400
Received: from claw.goop.org ([74.207.240.146]:49927 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1JMSQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:16:51 -0400
Message-ID: <4E97184D.8020109@goop.org>
Date: Thu, 13 Oct 2011 09:56:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V4 10/10] jump-label: initialize jump-label subsystem
 much earlier
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>  <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com> <1318502628.24856.10.camel@twins>
In-Reply-To: <1318502628.24856.10.camel@twins>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 03:43 AM, Peter Zijlstra wrote:
> On Wed, 2011-10-12 at 17:08 -0700, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Initialize jump_labels much earlier, we can use them.
> We can use them, where? how? what?, that sentence just begs for more.

Er, yeah, looks like I committed it without actually finishing the sentence.

    J

>> diff --git a/init/main.c b/init/main.c
>> index 2a9b88a..f4094ed 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -637,6 +637,7 @@ asmlinkage void __init start_kernel(void)
>>  	acpi_early_init(); /* before LAPIC and SMP init */
>>  	sfi_init_late();
>>  
>> +	jump_label_init();
>>  	ftrace_init();
>>  
>>  	/* Do the rest non-__init'ed, we're now alive */
> Can we push them much earlier still? If possible I'd like them to be
> before sched_init() so that I might use them there, if not possible, at
> the very least before enabling interrupts would be nice.
>
>

