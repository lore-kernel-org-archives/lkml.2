Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1HJQuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:50:10 -0400
Received: from claw.goop.org ([74.207.240.146]:59726 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1HJQuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:50:08 -0400
Message-ID: <4E42B6B7.6090709@goop.org>
Date: Wed, 10 Aug 2011 09:49:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: linux-next: Tree for July 25 (xen)
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>  <20110725144629.b752bf14.rdunlap@xenotime.net>  <20110804193534.GB12729@elte.hu> <20110804195539.GA11198@dumpdata.com>  <20110804131516.c4da6595.rdunlap@xenotime.net>  <20110804223259.GB4370@dumpdata.com> <20110804224020.GA21492@dumpdata.com>  <4E3B3117.5050308@xenotime.net> <20110805080531.GA8052@elte.hu>  <20110805211423.GA9765@elte.hu> <20110806015815.GA26833@dumpdata.com>  <4E3D8657.7000704@goop.org> <1312808467.18583.223.camel@gandalf.stny.rr.com>
In-Reply-To: <1312808467.18583.223.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 06:01 AM, Steven Rostedt wrote:
> On Sat, 2011-08-06 at 11:22 -0700, Jeremy Fitzhardinge wrote:
>> On 08/05/2011 06:58 PM, Konrad Rzeszutek Wilk wrote:
>>> On Fri, Aug 05, 2011 at 11:14:23PM +0200, Ingo Molnar wrote:
>>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>>
>>>>> * Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>>>
>>>>>> On 08/04/11 15:40, Konrad Rzeszutek Wilk wrote:
>>>>>>> On Thu, Aug 04, 2011 at 06:32:59PM -0400, Konrad Rzeszutek Wilk wrote:
>>>>>>>>>>> These build failures are still triggering upstream:
>>>>>>>>>>>
>>>>>>>>>>>  arch/x86/xen/trace.c:44:2: error: array index in initializer not of integer type
>>>>>>>>>>>  arch/x86/xen/trace.c:44:2: error: (near initialization for ‘xen_hypercall_names’)
>>>>>>>>>>>  arch/x86/xen/trace.c:45:1: error: ‘__HYPERVISOR_arch_4’ undeclared here (not in a function)
>>>>>>>>>>>  arch/x86/xen/trace.c:45:2: error: array index in initializer not of integer type
>>>>>>>>>>>  arch/x86/xen/trace.c:45:2: error: (near initialization for ‘xen_hypercall_names’)
>>>>>>>>>> Oh, that I haven't seen. Can you send me the .config for that please.
>>>>>>>>> You can't be trying very hard then.  I see lots of these (but no,
>>>>>>>> Ah, I am getting it now. Thanks for reporting it.
>>>>>>> This should do the trick:
>>>>>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>>>>> That patch did the trick here too:
>>>>>
>>>>> Acked-by: Ingo Molnar <mingo@elte.hu>
>>>> Except that i'm still seeing the occasional build failure - see the 
>>>> error log below. Config attached.
>>> Much appreciate for the report. I believe this fix (which I think hit
>>> linux-next yesterday?) should do that:
>>>
>>> commit 1e9ea2656b656edd3c8de98675bbc0340211b5bd
>>> Author: Jeremy Fitzhardinge <jeremy@goop.org>
>>> Date:   Wed Aug 3 09:43:44 2011 -0700
>>>
>>>      xen/tracing: it looks like we wanted CONFIG_FTRACE
>>>     
>>>     Apparently we wanted CONFIG_FTRACE rather the CONFIG_FUNCTION_TRACER.
>>>     
>>>     Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
>>>     Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
>>>     Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>
>>> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
>>> index 45e94ac..3326204 100644
>>> --- a/arch/x86/xen/Makefile
>>> +++ b/arch/x86/xen/Makefile
>>> @@ -15,7 +15,7 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>>>  			grant-table.o suspend.o platform-pci-unplug.o \
>>>  			p2m.o
>>>  
>>> -obj-$(CONFIG_FUNCTION_TRACER) += trace.o
>>> +obj-$(CONFIG_FTRACE) += trace.o
>>>  
>> I'm not sure this is correct either.  Maybe it should be
>> CONFIG_TRACEPOINTS?  Steven?
> Actually, I believe the correct answer is:
>
> CONFIG_EVENT_TRACING

OK, thanks.

    J
