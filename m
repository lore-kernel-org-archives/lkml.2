Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0H0LFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:05:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38924 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0H0LFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:05:08 -0400
X-AuditID: b753bd60-a84dbba000000a18-6d-4c779bdf79f4
Message-ID: <4C779BDB.70003@hitachi.com>
Date: Fri, 27 Aug 2010 20:04:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv11 2.6.36-rc2-tip 10/15] 10: tracing: config option to
 enable both kprobe-tracer and uprobe-tracer.
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6> <20100825134315.5447.96501.sendpatchset@localhost6.localdomain6> <4C76038A.40400@hitachi.com> <20100827093135.GI14431@linux.vnet.ibm.com>
In-Reply-To: <20100827093135.GI14431@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/27 18:31), Srikar Dronamraju wrote:
>>>  config PROBE_EVENTS
>>> -	def_bool n
>>> +	bool "Enable kprobes and uprobe based dynamic events"
>>> +	select TRACING
>>> +	default n
>>
>> Hmm, without this series, KPROBE_EVENT is set "y" by default.
>> (PROBE_EVENTS is introduced by 8/15)
>> I'd like to set this "y" by default, because it doesn't
>> affect other parts.
>>
>> Thank you,
>>
> 
> This is based on what we discussed here
> http://lkml.org/lkml/2010/8/2/86.
> 
> To recollect, 
> Frederic wanted that there should be one option to select both
> UPROBE_EVENT and KPROBE_EVENT. 
> 
> However if we make PROBE_EVENTS (which is the option to enable both
> events) default "Y", then both UPROBE_EVENT and KPROBE_EVENT will be
> selected.
> 
> Also if we look at http://lkml.org/lkml/2010/6/21/160, Steven
> Rostedt didnt want UPROBE_EVENT to selected by default.
> 
> I agree that we should keep UPROBE_EVENT to be 'default n' till it gets
> tested. Hence we have two choices. Either set the common knob to be
> 'default n' or dont have the common knob for now (i.e drop this
> patch for now).
> 
> I think we should go with the first one, i.e have a common knob thats
> by default unselected.

Yeah, I'm OK to have a common knob, but I just don't like to set
KPROBE_EVENT unselected by default. I think there is no reason
to change default selecting (currently, KPROBE_EVENT=y by default.)

So, I think we should have below selecting list;
--- Tracers
...
[*] Enable dynamic events
   [ ] Enable user-space dynamic events (EXPERIMENTAL)
...

What would you think about this ? :)

Thank you,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
