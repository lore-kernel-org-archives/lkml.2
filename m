Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab1FATbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:31:43 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:62926 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485Ab1FATbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:31:41 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DE6936F.7090700@die-jansens.de>
Date: Wed, 01 Jun 2011 21:30:55 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <20110405152729.232781355@chello.nl>	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>	 <4DE674EB.1000200@die-jansens.de>  <1306951751.2497.626.camel@laptop> <1306953870.2497.627.camel@laptop>
In-Reply-To: <1306953870.2497.627.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.06.2011 20:44, Peter Zijlstra wrote:
> On Wed, 2011-06-01 at 20:09 +0200, Peter Zijlstra wrote:
>> On Wed, 2011-06-01 at 19:20 +0200, Arne Jansen wrote:
>>> On 01.06.2011 18:35, Peter Zijlstra wrote:
>>>> On Wed, 2011-06-01 at 15:58 +0200, Arne Jansen wrote:
>>>>> git bisect blames this commit for a problem I have with v3.0-rc1:
>>>>> If I printk large amounts of data, the machine locks up.
>>>>> As the commit does not revert cleanly on top of 3.0, I haven't been
>>>>> able to double check.
>>>>> The test I use is simple, just add something like
>>>>>
>>>>> for (i=0; i<   10000; ++i) printk("test %d\n", i);
>>>>>
>>>>> and trigger it, in most cases I can see the first 10 printks before
>>>>> I have to power cycle the machine (sysrq-b does not work anymore).
>>>>> Attached my .config.
>>>>
>>>> I've made me a module that does the above, I've also changed my .config
>>>> to match yours (smp=y, sched-cgroup=y, autogroup=n, preempt=n, no_hz=y),
>>>> but sadly I cannot reproduce, I get all 10k prints on my serial line.
>>>>
>>>> Even without serial line it works (somehow booting without visible
>>>> console is scary as hell :)
>>>>
>>>> Which makes me ask, how are you observing your console?
>>>>
>>>
>>> They don't go out to the serial line, I only observe them with a
>>> tail -f on messages. Default log level doesn't go the console here.
>>
>> Right ok, so I used your exact .config, added a few drivers needed for
>> my hardware and indeed, it doesn't even finish booting and gets stuck
>> someplace.
>>
>> Sadly it looks like even the NMI watchdog is dead,.. /me goes try and
>> make sense of this.
>
> Sadly both 0122ec5b02f766c355b3168df53a6c038a24fa0d^1 and
> 0122ec5b02f766c355b3168df53a6c038a24fa0d itself boot just fine and run
> the test module without problems.

I can only partially confirm this:

2acca55ed98ad9b9aa25e7e587ebe306c0313dc7 runs fine
0122ec5b02f766c355b3168df53a6c038a24fa0d freezes after line 189
ab2515c4b98f7bc4fa11cad9fa0f811d63a72a26 freezes after line 39

>
> I will have to re-bisect this.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

