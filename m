Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414Ab0FQRNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:13:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab0FQRNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:13:36 -0400
Subject: Re: Sched_class documentation
From: Peter Zijlstra <peterz@infradead.org>
To: sebastiano spicuglia <spicuglia.sebastiano@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikuunLAsrtS2GhSkICkYfN_0H0jdZyo7fxjQl9b@mail.gmail.com>
References: <20100523144912.jfmkhsp50kcgk8os@webmail-stud.polimi.it>
	 <20100525071147.GC5985@elte.hu>
	 <AANLkTikuunLAsrtS2GhSkICkYfN_0H0jdZyo7fxjQl9b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Jun 2010 19:13:08 +0200
Message-ID: <1276794788.27822.603.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 19:02 +0200, sebastiano spicuglia wrote:
> Hi Ingo,
> 
> I made many progress. But I have two doubts yet.
> First: what does hrtick_start do?

higher resolution ticks

> I think that: if I call hrtick_start(rq, 500)  then, after 500ns, the
> task_tick function will be invocated.
> Is it right?

Yep, instead of waiting for the next system tick is programs a hrtimer
to deliver it -- its disabled by default though, since programming
timers is rather expensive :/

> Second: if my schedule_class decides to preempt the current task, it
> has to call resched_task(rq->curr).
> Is it right?

Either that or resched_cpu(), depending on which is most convenient.

It sets TIF_RESCHED and possibly IPIs the remote CPU. The TIF flag is
then observed (on re-entry to userspace in case of the IPI) and we call
into schedule().
