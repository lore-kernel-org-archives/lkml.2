Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1BPNeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:34:15 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54424 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1BPNeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:34:13 -0500
X-AuditID: b753bd60-a46baba000004916-37-4d5bd252944b
X-AuditID: b753bd60-a46baba000004916-37-4d5bd252944b
Message-ID: <4D5BD24F.3060601@hitachi.com>
Date: Wed, 16 Feb 2011 22:34:07 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
References: <20110208015617.902200587@goodmis.org> <20110215044425.GA9994@elte.hu> <1297776787.23343.104.camel@gandalf.stny.rr.com> <1297787362.23343.109.camel@gandalf.stny.rr.com> <20110215165302.GA2272@nowhere> <20110215183558.GE30208@ghostprotocols.net>
In-Reply-To: <20110215183558.GE30208@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/16 3:35), Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 15, 2011 at 05:53:06PM +0100, Frederic Weisbecker escreveu:
>> On Tue, Feb 15, 2011 at 11:29:22AM -0500, Steven Rostedt wrote:
>>> On Tue, 2011-02-15 at 08:33 -0500, Steven Rostedt wrote:
>>>
>>>> Thanks for letting me waste three days on developing this. I even posted
>>>> an RFC a while back, and no one complained then.
>>>
>>> Sorry about being a bit bitchy in my reply here. I need to make a note
>>> not to reply to LKML before my first cup of coffee. ;)
>>>
>>> Arnaldo,
>>>
>>> Thanks for the post, I'll help you out where you need it. trace-cmd has
>>> some features that reports back to the user on failed filter usage. We
>>> can incorporate that into perf.
> 
> Thanks!

Sounds good :)

>  
>> Cool!
>>
>> That said I agree that we should not block improvements in the generic
>> filtering code because of issues in perf uses of filters.
>>
>> I believe it used to work better in perf by the past, but I saw similar
>> issues lately like those Ingo noticed. So probably something
>> broke and we need to investigate. But until then your patches are
>> still nice improvements: lesser memory usage, lesser kernel stack usage in the
>> fast path, lesser limitation, faster and smarter filter evaluation...
> 
> Yeah, usability of the --filter parameter in perf is a bit
> (understatement) lacking, one has to look at the /format thing in
> /sys/kernel/debug/tracing... and not commit any mistake, else a generic
> invalid 22 message is spit out.

And also, there seems very less comment in perf-record.txt.

--filter=<filter>::
        Event filter.

Hmm, I think, at least, there should be a comment where user should
refer to and if possible, how he can use it...


> I tried it and after some back and forth changing hats and scratching my
> head while doing so, it got to work.
> 
> I talked with Steven and the same operation using trace-cmd would
> produce a better error report, stating that the field used in the filter
> expression was not valid.

If possible, please show us what parameters we can use on that event too.
perf list gives us a list of events, but not show us what parameters
we can use on those events. I think we can update perf list for that
purpose.

e.g.)
perf list --field kvm:kvm_entry
 unsigned short common_type;
 unsigned char common_flags;
 unsigned char common_preempt_count;
 int common_pid;
 int common_lock_depth;
 unsigned int vcpu_id;


> 
> I'll try to get that code from trace-cmd and glue that into
> tools/perf/util/, that eventually will get moved to tools/lib/ or
> something like that, as Borislav has been experimenting with for some
> time already.
> 
> The location in the source tree is not the most important thing at this
> point, usability improvements are, so I'm not rushing to moving code
> around all the time (even doing it more than I would like), lets try to
> improve usability first and then we can move it to tools/lib.
> 
> - Arnaldo


Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
