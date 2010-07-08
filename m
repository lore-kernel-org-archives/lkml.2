Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0GHJGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:06:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:33524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab0GHJGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:06:46 -0400
Subject: Re: high power consumption in recent kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, Arjan Van De Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 11:06:32 +0200
Message-ID: <1278579992.1900.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 01:45 +0900, Norbert Preining wrote:

> it seems that some of the (?)recent(?) changes have increased the
> power consumption of my note book considerably.
> 
> First of all, running powertop with normal programs started, but 
> doing nothing, I am still at 14W while I could go down to 9W before
> (but the 9W was with dimmed display).
> 
> In the list of top causes for wakeup I have
> Top causes for wakeups:
>   34.2% (185.3)   [kernel scheduler] Load balancing tick
>   23.9% (129.6)   [extra timer interrupt]
>   10.8% ( 58.6)   firefox-bin
>    9.2% ( 49.7)   [iwlagn] <interrupt>
>    7.2% ( 39.1)   [kernel core] hrtimer_start (tick_sched_timer)
>    3.9% ( 20.9)   PS/2 keyboard/mouse/touchpad interrupt
> which show one new thing to me I haven't seen before, the Loa balancing tick.

I think that is what powertop calls our regular tick (Arjan?), and as
long as you're not idle nohz can't kick in, I'd be looking at what keeps
nohz from happening,.. those extra timer interrupts could be
responsible..

> Furthermore, I also had the feeling that while being suspend to RAM 
> the battery is also emptied faster then before, but by now I have not
> concise data points for that.
> 
> I am running the latest kernel pulled from git.kernel.org, linux-2.6.

Right, I'm quite puzzled by that, looking through the result of:
  git log v2.6.34..origin/master kernel/sched*

Nothing really shouts me, me, me :-)

You could try and look at:

99bd5e2f245d8 (sched: Fix select_idle_sibling() logic in select_task_rq_fair())
3c93717cfa513 (sched: Fix over-scheduling bug)

And that latter only if you actually have group scheduling enabled.

Other than that, I'm afraid I'll have to ask you to bisect this.

> I have seen some patches from Venkatesh Pallipadi dealing twith this 
> issue (http://lkml.org/lkml/2010/6/9/109) but it does not apply to
> the current kernel sources at all.

Those patches are merged and waiting for the .36 merge window, try a
-tip kernel
(git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git) if
you want to give them a go.


