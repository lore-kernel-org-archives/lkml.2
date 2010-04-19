Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab0DSU5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:57:17 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:51832 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0DSU5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:57:15 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zz1432P98dN936eM9371Pzz1202hz4fhzz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <4BCCC392.3090509@am.sony.com>
Date: Mon, 19 Apr 2010 13:56:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: request to add trace off and trace on with events
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>	 <4BCCBF6D.3030105@am.sony.com> <1271709846.10448.29.camel@gandalf.stny.rr.com>
In-Reply-To: <1271709846.10448.29.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:44 PM, Steven Rostedt wrote:
> On Mon, 2010-04-19 at 13:39 -0700, Tim Bird wrote:
>> On 04/19/2010 01:04 PM, Steven Rostedt wrote:
>>> Hi Tom,
>>>
>>> Could you add a way to do a call to tracing_on() or tracing_off() via
>>> the filters. I would like to do something like:
>>>
>>>
>>> echo 'if (pid == 1234) traceoff' > events/sched/sched_wakeup/filter
>>>
>>> Where, if the sched_wakeup event is hit with pid == 1234 it will turn
>>> tracing off.
>>
>> Just a comment on the nomenclature.  In KFT I called
>> things like this "triggers".  I'm not sure what other
> 
> Yeah, Mathieu calls them triggers too. But if you do, I'm fine with
> calling them that as well.
> 
>> tracing systems call them.  I'm a little worried about
>> overloading the filtering abstraction with trigger
>> semantics.  (I like the idea of triggers, but it might
>> be better to control them with another pseudo-file for
>> clarity.)
>>
>> I suppose both are a form of conditional execution.
>> Filtering has an implicit action of either 'trace this'
>> or 'don't trace this', while triggering usually has
>> an action, often explicit, to start or stop tracing.
>> However, since they both use the conditional testing,
>> it might be a pain to reproduce this code for a different
>> pseudo-file.
> 
> I thought about a separate file, but I like the idea of having control
> over them. We could add a "trigger" file too, but I'm not sure if that
> would be any clearer.

I'm not sure either.  In general I dislike proliferating
pseudo-files.  But if the tracing filter conditional is
different from the trigger conditional, it might be needed
to have something separate.

In KFT there were some non-event related trigger conditionals,
like - start tracing after 20 milliseconds and stop after
80 milliseconds.

Another thing I considered for KFT triggers, but didn't get
around to implementing, was countdown triggers - such as
"start tracing on the 5th execution of do_fork".

With the function or function_graph tracer, since the buffer
overflows quickly, these kinds of triggered trace starts and stops
can help pinpoint the data you need.

Okay - that's probably 4 cents now. :-)
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

