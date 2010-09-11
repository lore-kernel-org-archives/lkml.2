Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0IKUgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 16:36:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0IKUgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 16:36:31 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 11 Sep 2010 22:36:20 +0200
Message-ID: <1284237380.2251.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 12:21 -0700, Linus Torvalds wrote:
> On Sat, Sep 11, 2010 at 11:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Not at all charmed, this look like random changes without conceptual
> > integrity.
> 
> I wish people actually looked at the _numbers_ and reacted to them,
> rather than argue theory.
> 
> Guys, we have cases of bad latency under load. That's a pretty
> undeniable fact. Arguing against a patch because of some theoretical
> issue without at all even acknowledging the latency improvements is, I
> think, really bad form.
> 
> So please. Acknowledge the latency issue. And come up with better
> patches, rather than just shoot down alternatives. Because if the
> answer is just NAK with no alternative, then that answer is worthless.
> No?

>From what I can make up:

  LAT=`cat /proc/sys/kernel/sched_latency_ns`; 
  echo $((LAT/8)) > /proc/sys/kernel/sched_min_granularity_ns

will give you pretty much the same result as Mathieu's patch.

But if you want us to change the scheduler to be more latency sensitive
and trade in throughput for other benchmarks, we can do that.
