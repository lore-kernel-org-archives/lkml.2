Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2LRL55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:57:57 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54888 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2LRL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:57:56 -0500
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 06:57:56 EST
MIME-Version: 1.0
In-Reply-To: <CAKfTPtDHcGrgSKxPvWzX5yia=_pct29ybKmUv=OEgCagZTpASA@mail.gmail.com>
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
	<1355319092-30980-4-git-send-email-vincent.guittot@linaro.org>
	<50C93AC1.1060202@intel.com>
	<CAKfTPtB9iz1ePsS+juQVRhuWREYB1duGWRJT7ya8XBXPhC-mkw@mail.gmail.com>
	<50C9E552.1010600@intel.com>
	<CAKfTPtCUDEC50xexmLQ1d9qvBz1iJnf4aGSGjN==jqZwpxrwiQ@mail.gmail.com>
	<CAKfTPtAhFtGKOtwumuav+pndoAZiKjHvYoE2NZxtgP+qHuHY3g@mail.gmail.com>
	<50CA84FF.5070907@intel.com>
	<CAKfTPtCarhT3J3xOD6jOh_91Pm5FK4V_DAk5QLs_=8rVF+-fsQ@mail.gmail.com>
	<50CD746E.7010807@intel.com>
	<CAKfTPtAt-TUoJpXbL+dAQ2zGTYtewdXpFDN_mSeu4MnuC-2Xjg@mail.gmail.com>
	<50CF3916.4010001@intel.com>
	<CAKfTPtDHcGrgSKxPvWzX5yia=_pct29ybKmUv=OEgCagZTpASA@mail.gmail.com>
Date: Tue, 18 Dec 2012 19:29:46 +0800
Message-ID: <CAGjg+kHPDY9X_-MaOkumc4FbFi0a+=Lc5uXi28JZ8mJO=hyngA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
From: Alex Shi <lkml.alex@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Alex Shi <alex.shi@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, linux@arm.linux.org.uk,
        pjt@google.com, santosh.shilimkar@ti.com, Morten.Rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, viresh.kumar@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 5:53 PM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> On 17 December 2012 16:24, Alex Shi <alex.shi@intel.com> wrote:
>>>>>>>> The scheme below tries to summaries the idea:
>>>>>>>>
>>>>>>>> Socket      | socket 0 | socket 1   | socket 2   | socket 3   |
>>>>>>>> LCPU        | 0 | 1-15 | 16 | 17-31 | 32 | 33-47 | 48 | 49-63 |
>>>>>>>> buddy conf0 | 0 | 0    | 1  | 16    | 2  | 32    | 3  | 48    |
>>>>>>>> buddy conf1 | 0 | 0    | 0  | 16    | 16 | 32    | 32 | 48    |
>>>>>>>> buddy conf2 | 0 | 0    | 16 | 16    | 32 | 32    | 48 | 48    |
>>>>>>>>
>>>>>>>> But, I don't know how this can interact with NUMA load balance and the
>>>>>>>> better might be to use conf3.
>>>>>>>
>>>>>>> I mean conf2 not conf3

>
> Cyclictest is the ultimate small tasks use case which points out all
> weaknesses of a scheduler for such kind of tasks.
> Music playback is a more realistic one and it also shows improvement
>
>> granularity or one tick, thus we really don't need to consider task
>> migration cost. But when the task are not too small, migration is more
>
> For which kind of machine are you stating that hypothesis ?

Seems the biggest argument between us is you didn't want to admit 'not
too small tasks' exists and that will cause more migrations because
your patch.

>> even so they should run in the same socket for power saving
>> consideration(my power scheduling patch can do this), instead of spread
>> to all sockets.
>
> This is may be good for your scenario and your machine :-)
> Packing small tasks is the best choice for any scenario and machine.

That's clearly wrong, I had explained many times, your single buddy
CPU is impossible packing all tasks for a  big machine, like for just
16 LCPU, while it suppose do.

Anyway you have right insist your design. and I thought I can not say
more clear about the scalability issue. I won't judge the patch again.
