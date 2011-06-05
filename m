Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1FEKWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 06:22:30 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:15972 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1FEKW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 06:22:29 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEB58D8.4000805@die-jansens.de>
Date: Sun, 05 Jun 2011 12:22:16 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop> <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de> <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins> <4DE8B13D.9020302@die-jansens.de> <1307097052.2353.3061.camel@twins> <20110605081747.GA17920@elte.hu> <4DEB4FA7.3050400@die-jansens.de> <20110605095555.GA22058@elte.hu>
In-Reply-To: <20110605095555.GA22058@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 11:55, Ingo Molnar wrote:
>
> * Arne Jansen<lists@die-jansens.de>  wrote:
>
>>> ( Arne, please also double check on a working bootup that the NMI
>>>    watchdog is actually ticking, by checking the NMI counts in
>>>    /proc/interrupts go up slowly but surely on all CPUs. )
>>
>> It does, but _very_ slowly. Some CPUs do not count up for tens of
>> minutes if the machine is idle. If I generate some load like 'make
>> tags', the counters go up quite quickly.
>> After 4 minutes and one 'make cscope' it looks like this:
>> NMI:          8         13         43          5          2
>> 3        22          1   Non-maskable interrupts
>>
>> But I never see a single tick on console or in dmesg, even when I
>> replace the early_printk with a printk.
>
> hm, that might be because the NMI watchdog uses halted cycles to
> tick.
>
> That's not a problem (the kernel cannot lock up while there are no
> cycles ticking) but nevertheless could you work this around please
> by starting 8 infinite shell loops:
>
>     for ((i=0; i<8; i++)); do while : ; do : ; done&  done
>
> ?
>
> This will saturate all cores and makes sure the NMI watchdog is
> ticking everywhere.
>
> Hopefully this wont make the bug go away :-)
>

OK, now we get going. I get the ticks, the bug is still there, and
all CPUs still tick after the lockup. I also added an early_printk
inside the lockup-if, and it reports hard lockups. At first for only
one or 2 CPUs, and after some time all CPUs are locked up.

-Arne
