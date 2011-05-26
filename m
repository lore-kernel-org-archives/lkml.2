Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab1EZQVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:21:50 -0400
Received: from service87.mimecast.com ([94.185.240.25]:45592 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756464Ab1EZQVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:21:49 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1306426148.2497.83.camel@laptop>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
	 <20110526154508.GA13788@redhat.com>  <1306425584.2497.81.camel@laptop>
	 <1306426148.2497.83.camel@laptop>
Organization: ARM Ltd
Date: Thu, 26 May 2011 17:22:28 +0100
Message-ID: <1306426948.27474.243.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 26 May 2011 16:21:53.0749 (UTC) FILETIME=[066F3050:01CC1BC1]
X-MC-Unique: 111052617214503101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 18:09 +0200, Peter Zijlstra wrote:
> On Thu, 2011-05-26 at 17:59 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-05-26 at 17:45 +0200, Oleg Nesterov wrote:
> > > Stupid question. Can't we fix this problem if we do
> > > 
> > >         -       if (p == current)
> > >         +       if (cpu == raw_smp_processor_id())
> > > 
> > > ?
> > > 
> > > I forgot the rules... but iirc task_cpu(p) can't be changed under us?
> > 
> > Easy enough to test.. brain gave out again,. hold on ;-)
> 
> The below seems to run all-right so far, I'll let it run for a while.

Just got the following:

INFO: task kjournald:904 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald       D c0284c88     0   904      2 0x00000000
[<c0284c88>] (schedule+0x54c/0x620) from [<c0284dd8>] (io_schedule+0x7c/0xac)
[<c0284dd8>] (io_schedule+0x7c/0xac) from [<c00dc1c0>] (sleep_on_buffer+0x8/0x10)
[<c00dc1c0>] (sleep_on_buffer+0x8/0x10) from [<c02854ac>] (__wait_on_bit+0x54/0x9c)
[<c02854ac>] (__wait_on_bit+0x54/0x9c) from [<c028556c>] (out_of_line_wait_on_bit+0x78/0x84)
[<c028556c>] (out_of_line_wait_on_bit+0x78/0x84) from [<c014bc4c>] (journal_commit_transaction+0x734/0x13f4)
[<c014bc4c>] (journal_commit_transaction+0x734/0x13f4) from [<c014f598>] (kjournald+0xb8/0x210)
[<c014f598>] (kjournald+0xb8/0x210) from [<c0066320>] (kthread+0x80/0x88)
[<c0066320>] (kthread+0x80/0x88) from [<c002ea14>] (kernel_thread_exit+0x0/0x8)

	M.
-- 
Reality is an implementation detail.


