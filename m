Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab2FAMwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:52:25 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46328 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759663Ab2FAMwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:52:23 -0400
X-AuditID: b753bd60-918caba000001453-b0-4fc8bb0419a0
X-AuditID: b753bd60-918caba000001453-b0-4fc8bb0419a0
Message-ID: <4FC8BAF5.5050008@hitachi.com>
Date: Fri, 01 Jun 2012 21:52:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, acme <acme@ghostprotocols.net>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with breakpoints
References: <20120531012829.160060586@goodmis.org>   <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>   <1338473302.13348.336.camel@gandalf.stny.rr.com>   <1338486029.28384.93.camel@twins>   <1338486820.13348.366.camel@gandalf.stny.rr.com>   <1338487413.28384.103.camel@twins>   <1338490218.13348.379.camel@gandalf.stny.rr.com>   <1338491176.28384.114.camel@twins> <20120531195529.GA22976@Krystal>   <1338495006.13348.418.camel@gandalf.stny.rr.com>   <1338495969.28384.119.camel@twins>   <1338496676.13348.430.camel@gandalf.stny.rr.com>   <1338496857.28384.124.camel@twins>  <1338497360.13348.438.camel@gandalf.stny.rr.com>  <4FC84AC8.3020601@hitachi.com> <1338550627.13348.462.camel@gandalf.stny.rr.com>
In-Reply-To: <1338550627.13348.462.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/01 20:37), Steven Rostedt wrote:
> On Fri, 2012-06-01 at 13:53 +0900, Masami Hiramatsu wrote:
> 
>> Hmm, why don't we have two text_poke interfaces for single and
>> batch? As like dyn_ftrace, since modifying massive points takes
>> a lot time, so we may have additional kconfig something like
>> CONFIG_QUICK_BATCH_TEXT_POKE which switches text area to rw while
>> batch text_poke.
>>
> 
> I'll be working on patches to consolidate the two after I get everything
> else working :-)  I still need to work on the ftrace kprobe stuff too.
> 
> I hate having a config option to switch between the two, except for
> something that can be there if we find the new approach is buggy (like
> we have with lockdep). That may be a solution for this if we don't agree
> on one now. That is, bring back stop_machine() when LOCKDEP is enabled.
> But that should only be a temporary work around not a true fix.
> 
> I have no problem with having most of the modifying code be shared
> between text_poke and ftrace. I guess the question is, do we want to do
> it only with the FIXMAP or do we want text_poke and ftrace to use the rw
> method for large batches. Heck, we can set a limit. If we are going to
> update more that 100 locations, we switch the kernel to rw, otherwise we
> do the FIXMAP update.

That's reasonable for me :). You can feel free to change/remove
text_poke_smp_batch which is already old-style interface.

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
