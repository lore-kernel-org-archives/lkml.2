Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0DLSUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:20:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab0DLSUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:20:04 -0400
Date: Mon, 12 Apr 2010 20:16:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Sachin Sant <sachinp@in.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Shane Wang <shane.wang@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuhotplug: make get_online_cpus() scalability by
	using percpu counter
Message-ID: <20100412181655.GA11872@redhat.com>
References: <4BB9BD8A.9040209@cn.fujitsu.com> <20100405162901.GA3567@redhat.com> <20100406120039.GC5680@redhat.com> <4BBC8A11.3040501@cn.fujitsu.com> <20100407135456.GA12029@redhat.com> <20100409121235.GA5784@redhat.com> <4BC2E6CE.7060401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC2E6CE.7060401@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
> >
> > But, I must admit, I'd like to avoid adding the new member to task_struct.
> >
> > What do you think about the code below?
> >
> > I didn't even try to compile it, just to explain what I mean.
> >
> > In short: we have the per-cpu fast counters, plus the slow counter
> > which is only used when cpu_hotplug_begin() is in progress.
>
> get_online_cpus() in your code is still read-preference.

Yes,

> I wish we quit this ability of get_online_cpus().

Heh. Since I never read the changelogs, I didn't even notice this was
one of the goals of your patch. I thought this is just the side-effect.

Yes, if we want to block the new readers, I don't see how it is possible
to avoid the counter in task_struct.

I can't judge whether this new member worth the trouble. Once again, I am
not arguing, just I don't know. And I think your patch is correct (apart
from pure theoretical race with cpu_hotplug_done afaics).

Oleg.

