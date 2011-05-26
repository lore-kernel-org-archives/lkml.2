Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab1EZLdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:33:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:45405 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab1EZLdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:33:37 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 May 2011 13:32:55 +0200
Message-ID: <1306409575.1200.71.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 12:02 +0100, Marc Zyngier wrote:

> The box is currently building kernels in a loop (using -j64...). So far,
> so good. Oh, and that fixed the load-average thing as well.

OK, great.

> Oh wait (my turn...):
> INFO: task gcc:10030 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 
> One of my ssh sessions is locking up periodically, and it generally
> feels a bit sluggish.

The good news is that I can indeed confirm that, I somehow failed to
notice that last night. I simply put the machine to build kernels and
walked off, only to come back 30 minutes or so later to see it was still
happily chugging along.

Further good news is that by disabling 
__ARCH_WANT_INTERRUPTS_ON_CTXSW again it goes away, so it must be
something funny with the relatively little code under that directive.

The bad news is of course that I've got a little more head-scratching to
do, will keep you informed.
