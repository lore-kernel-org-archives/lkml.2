Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2AIO3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:29:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37252 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2AIO3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:29:37 -0500
MIME-Version: 1.0
In-Reply-To: <1326107563.2442.65.camel@twins>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	<1326103578.2442.50.camel@twins>
	<20120110001445.GA20542@linux-youquan.bj.intel.com>
	<1326107563.2442.65.camel@twins>
Date: Mon, 9 Jan 2012 15:29:36 +0100
Message-ID: <CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I'm also using sched_mc level for doing powersaving load balance on
ARM platform and we have real benefits.

On 9 January 2012 12:12, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-01-09 at 19:14 -0500, Youquan Song wrote:
>> > Yes it is.. also that knob should die! Like i've been saying for way too
>> > long. I'm >< close to committing a patch removing all the power_saving
>> > magic from the scheduler.
>> Sorry. I do not notice it.
>
> I hadn't posted it before, but just about every time people post
> something related to smt/mc power balancing I say this needs to get
> cleaned up. Since telling people doesn't seem to have any effect what so
> ever, stronger measures are needed.
>
>> But currently in many real tests, the knob prove to save power in semi-idle system.
>> They are useful in many user scenarios currently.
>
> I'm not saying the stuff is without merit, I'm just saying that a) the
> interface is utter crap and b) nobody seems to spend enough time on it
> to 1) understand the load-balancer so that 2) he can integrate the power
> saving stuff properly.
>
> Instead I get one sporadic band-aid after another.
>

I can also help to on the topic

> Also, fundamentally, the split between {smt/mc/numa/book}_power_savings
> is completely and fundamentally broken, nobody cares about the actual
> topology.

We might modify the way we choose between power or performance mode
because it's not always a matter of gathering or spreading tasks on
cpus but until we found a best interface it's the way to enable
powersaving mode

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
