Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0CTAOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:14:10 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:51928 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab0CTAOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:14:07 -0400
Message-ID: <4BA41305.7070403@oracle.com>
Date: Fri, 19 Mar 2010 17:12:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: 2.6.33 GP fault only when built with tracing
References: <4BA2B69D.3000309@oracle.com> <1268956555.758.18.camel@gandalf.stny.rr.com>
In-Reply-To: <1268956555.758.18.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA41348.005F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 16:55, Steven Rostedt wrote:
> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
>> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
>> but when I enable lots of tracing config options and then boot with
>> ftrace=nop on the kernel command line, I see a GP fault when the parport &
>> parport_pc modules are loading/initializing.
> 
> Do you see it without adding the "ftrace=nop"? The only thing that
> should do is expand the ring buffer on boot up.

Yes, it happens with or without "ftrace=nop" as a kernel boot argument.


>>
>> It happens in drivers/parport/share.c::parport_register_device(), when that
>> function calls try_module_get().
>>
>> If I comment out the trace_module_get() calls in include/linux/module.h,
>> the kernel boots with no problems.
> 
> 
> Interesting. Well, trace_module_get() is a TRACE_EVENT tracepoint. But
> should be disabled here. It may be something to do with DEFINE_TRACE. 
> 
> (added Mathieu to Cc since he wrote that code)


-- 
~Randy
