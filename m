Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0EERXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:23:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44122 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0EERXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=DKSFqZqCih/3sLuFrlxexUN0387MHweHgeQGxWeiGm1bnLcrQaQX1M/B1gETWSAlqz
         dyab/yULwxHEZDe9/8xoWTopXLCq32W1OENYD5NlUQME2OQ8YLw+D1RfFKtF7iiYZfBu
         jlFYjvdzBMLMAHdg78sCd+hhDhVcvV9CItIUQ=
Date: Wed, 5 May 2010 19:23:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ronny =?iso-8859-1?Q?Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
Cc: rostedt@goodmis.org, Arjan van de Ven <arjan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tracing of power:power_start events doesn't work
Message-ID: <20100505172339.GC6320@nowhere>
References: <4BDECD66.2010906@tu-dresden.de> <1273019517.22438.10.camel@gandalf.stny.rr.com> <4BE11169.3010602@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BE11169.3010602@tu-dresden.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:34:17AM +0200, Ronny Tschüter wrote:
> On Wed 2010-05-05 02:31, Steven Rostedt wrote:
>> On Mon, 2010-05-03 at 15:19 +0200, Ronny Tschüter wrote:
>>    
>>> Hello,
>>>
>>> i use kernel version 2.6.33.2 (x86-64, Core 2 Duo) and the perf events
>>> to track frequency and c states of my cpu. But if i want to trace
>>> power:power_start events, it does not work. After typing
>>>
>>> echo "power:power_start" | sudo tee set_event
>>>
>>> on the console, the trace doesn't contain such events.
>>> power:power_frequency and power:power_end events are reported correctly
>>> by the system. I read in the mailing list that Robert Schoene had a
>>> similiar problem, but with power:power_end events. Is there a known bug
>>> regarding to trace_power_start methods in process.c?
>>>      
>> Is this for perf or ftrace? I'm assuming you did this from the debugfs
>> tracing directory. The set_event file is for ftrace not perf.
>>    
> It is for perf - i'm interested in event tracing. I used the event  
> tracing system like it is described in Documentation/trace/events.txt.  
> In addition i wrote a program which uses syscall(__NR_perf_counter_open,  
> ... ) to trace power events. But the result is the same -  
> power:power_end events are reported, power:power_start events not.
>
> Bye Ronny


Hi, can you please compare the perf and ftrace output to
see if ftrace works while perf doesn't for example?

In perf:
	perf record -f -c 1 -a -e power:power_start
	^C
	perf report

In ftrace:
	echo 1 > $DEBUGFS/tracing/events/power/power_start/enable
	cat $DEBUGFS/trace_pipe

Thanks.

