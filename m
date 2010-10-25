Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab0JYRZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:25:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759174Ab0JYRZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:25:38 -0400
Date: Mon, 25 Oct 2010 19:25:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101025172521.GC1636@elte.hu>
References: <20101022183900.GG6498@redhat.com>
 <20101023200216.GA19324@elte.hu>
 <1287881618.16971.657.camel@gandalf.stny.rr.com>
 <20101024112540.GA21267@elte.hu>
 <20101025085927.GA11025@elte.hu>
 <20101025093045.GA21997@elte.hu>
 <20101025114501.GA2000@elte.hu>
 <20101025121059.GA3063@elte.hu>
 <1288009103.15336.58.camel@twins>
 <1288021672.15336.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288021672.15336.63.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

>   60:	 89 44 24 04          	mov    %eax,0x4(%esp)                89 44 24 04          	mov    %eax,0x4(%esp)
>   64:	 f0 fe 07             	lock incb (%edi)                     f0 fe 07             	lock incb (%edi)
>   67:* 0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)              e9 03 00 00 00       	jmp    0x6f              <--- PATCHED INSN
>   6c:	 58                   	pop    %eax                          58                   	pop    %eax
>   6d:	 eb 1d                	jmp    0x8c                          eb 1d                	jmp    0x8c

Hm, the NOP looks correct, and none of the instructions before or after the patch 
site seem to be corrupted.

Another piece of info: i'm using Athlon64, while Peter is using westmere EP. So it's 
not CPU model dependent.

Thanks,

	Ingo
