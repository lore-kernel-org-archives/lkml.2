Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0JUC7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:59:07 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35228 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab0JUC7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:59:05 -0400
X-AuditID: b753bd60-a60ccba000005dcc-d4-4cbfac732b83
Message-ID: <4CBFAC70.30602@hitachi.com>
Date: Thu, 21 Oct 2010 11:58:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for	trace_sched_wakeup.c
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu> <20101020164324.GC7348@redhat.com>
In-Reply-To: <20101020164324.GC7348@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/21 1:43), Jason Baron wrote:
> On Wed, Oct 20, 2010 at 05:40:45PM +0200, Ingo Molnar wrote:
>> FYI, there's a new mystery hang (sometimes crash) that triggers in -tip - and which 
>> seems to be tracing related. See the crashlog below - config attached.
>>
>> It's not bisectable - small changes in the kernel make the bug come/go. (might be a 
>> race of some sorts)
>>
>> Thanks,
>>
>> 	Ingo
>>
> 
> strange b/c it looks like we get though enabling/disabling the
> tracepoitns individually, but then when we go to enable all the
> tracepoints we hit this hang - perhaps, suggesting a race. Do we always
> fail after "Testing all events:" is printed? Does the crash have any
> more clues. I will try and re-produce this.
> 
> Also, I noticed some recent changes to text_poke_smp() usage of
> stop_machine() on Oct. 14th. That's related to the area where this appears
> to hang, so if things were working with this .config before then, that
> might be a place to look. Adding Masami to the 'cc list.

Recent changes of text_poke_smp() just removed unnecessary
get/put_online_cpu(), so I think it's not related this bug.

It seems there can be a bug in stop_machine() routine under
heavy use. usually that is called just once at a time, but jump
label and optprobe might call it heavily (thousands times?).
So some racy situation can be happen easily.

Thanks,

> 
> thanks,
> 
> -Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
