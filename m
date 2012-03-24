Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2CXOjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:39:46 -0400
Received: from tex.lwn.net ([70.33.254.29]:37587 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab2CXOjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:39:45 -0400
Date: Sat, 24 Mar 2012 08:39:43 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Query on Linux process sheduling
Message-ID: <20120324083943.1db775e5@lwn.net>
In-Reply-To: <CAP=ejEsGRF2i0Rr_W8cNZgJ8W+PHzHNpVRsBtMTmfEiVro+Kjw@mail.gmail.com>
References: <CAP=ejEsGRF2i0Rr_W8cNZgJ8W+PHzHNpVRsBtMTmfEiVro+Kjw@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2012 17:25:41 +0530
"B.Vinai Kumar" <vinaibangala2001@gmail.com> wrote:

> I have embedded box running 2.6.28.9 linux kernel and running 6 Real

Wow...ancient history :)

> time task threads (With SCHED_RR as scheduling policy).
> Together all the 6 threads running is consuming around 85% of CPU,
> which is expected.
> 
> All the threads have a 10ms of cycle.
> 
> The issue is for every second I have observed that for 50ms these Real
> time task threads are not scheduling at all. During this 50ms
> the process swapper/idle task is being scheduled(pid 0).
> 
> Is this the behaviour is due to these values?
> 
> # cat /proc/sys/kernel/sched_rt_period_us
> 1000000
> # cat /proc/sys/kernel/sched_rt_runtime_us
> 950000

Indeed, you're on the right track.  The scheduler preserves a little bit
of time for non-RT tasks to give you a chance to recover if something goes
totally nuts.

> What changes can be done to the kernel so that the Real time task
> threads get scheduled in that 50ms interval too?

Setting those two knobs to the same value should do the trick, but it does
increase the risk of losing control of the system.  See
Documentation/scheduler/sched-rt-group.txt for more information on how
these knobs work.

jon
