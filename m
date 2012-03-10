Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2CJDcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:32:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35957 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2CJDcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:32:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120308195825.GC2412@linux.vnet.ibm.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	<1331032571.11248.277.camel@twins>
	<CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
	<1331048093.11248.317.camel@twins>
	<20120308195825.GC2412@linux.vnet.ibm.com>
Date: Sat, 10 Mar 2012 11:32:16 +0800
Message-ID: <CACvQF51u8G=3sREvAV4Gf9Y9-+tKXWfzRzXGLcXgdh=hXZ_JxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
From: Lai Jiangshan <eag0628@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 3:58 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Mar 06, 2012 at 04:34:53PM +0100, Peter Zijlstra wrote:
>> On Tue, 2012-03-06 at 23:12 +0800, Lai Jiangshan wrote:
>> > On Tue, Mar 6, 2012 at 7:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > > On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
>> > >>         srcu_head is bigger, it is worth, it provides more ability and simplify
>> > >>         the srcu code.
>> > >
>> > > Dubious claim.. memory footprint of various data structures is deemed
>> > > important. rcu_head is 16 bytes, srcu_head is 32 bytes. I think it would
>> > > be real nice not to have two different callback structures and not grow
>> > > them as large.
>> >
>> > CC: tj@kernel.org
>> > It could be better if workqueue also supports 2*sizeof(long) work callbacks.
>>
>> That's going to be very painful if at all possible.
>>
>> > I prefer ability/functionality a little more, it eases the caller's pain.
>> > preemptible callbacks also eases the pressure of the whole system.
>> > But I'm also ok if we limit the srcu-callbacks in softirq.
>>
>> You don't have to use softirq, you could run a complete list from a
>> single worklet. Just keep the single linked rcu_head list and enqueue a
>> static (per-cpu) worker to process the entire list.
>
> I like the idea of SRCU using rcu_head.  I am a little concerned about
> what happens when there are lots of SRCU callbacks, but am willing to
> wait to solve those problems until the situation arises.
>
> But I guess I should ask...  Peter, what do you expect the maximum
> call_srcu() rate to be in your use cases?  If tens of thousands are
> possible, some adjustments will be needed.

Different from RCU(global domain), SRCU is separated
by domains, I think the rate is not high for a given domain,
but the real answer depends on the practice.

>
>                                                        Thanx, Paul
>
