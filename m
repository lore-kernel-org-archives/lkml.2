Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1BULzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab1BULzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:55:19 -0500
Date: Mon, 21 Feb 2011 12:54:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, ananth@in.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH] kprobes - do not allow optimized kprobes in entry code
Message-ID: <20110221115452.GA1919@jolsa.brq.redhat.com>
References: <1297696354-6990-1-git-send-email-jolsa@redhat.com>
 <4D5A4A66.4010503@hitachi.com>
 <20110215123058.GB3135@jolsa.brq.redhat.com>
 <4D5AA209.7070309@hitachi.com>
 <20110215170507.GD3135@jolsa.brq.redhat.com>
 <4D5B4654.30407@hitachi.com>
 <20110217151103.GA11156@elte.hu>
 <20110218162619.GA9425@jolsa.brq.redhat.com>
 <4D5FD04D.8020209@hitachi.com>
 <20110220125948.GC25700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220125948.GC25700@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 01:59:48PM +0100, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > Thanks, I've also tested. (But my machine has no L1-icache-prefetches* support) 
> > What I can tell is both of L1-icache-load and L1-icache-load-misses is reduced by 
> > the patch. ;-)
> 
> That's actually a pretty interesting result: it means that compressing entry code 
> into a single section compresses the icache footprint in a measurable way. The 
> icache miss rate went down by about 6%:
> 
> >          1,234,272 L1-icache-load-misses      ( +-   0.105% )
> >          1,155,816 L1-icache-load-misses      ( +-   0.113% )
> 
> Which, assuming that there's no kernel build and bootup related skew effect that is 
> larger than 2-3% means that this is an improvement.
> 
> perf feature request: would be nice if it was able to do:
> 
> 	perf stat --record ...
> 	perf diff
> 
> and it would show a comparison of the two runs.
> 
> In hindsight it makes sense: the patch probably reduced the fragmentation of the 
> icache for this workload.
> 
> But it's still surprising :-)
> 
> Mind splitting the patch up into two parts, the first one that does the performance 
> optimization intentionally (with numbers, explanation, etc.), the second one that 
> uses the new section for kprobes exclusion?
np, I'll send v2 shortly

thanks,
jirka

> 
> Thanks,
> 
> 	Ingo
