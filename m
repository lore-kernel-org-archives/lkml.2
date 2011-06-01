Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab1FARV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:21:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:30362 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab1FARV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:21:26 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DE674EB.1000200@die-jansens.de>
Date: Wed, 01 Jun 2011 19:20:43 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <20110405152729.232781355@chello.nl>	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
In-Reply-To: <1306946120.2497.606.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.06.2011 18:35, Peter Zijlstra wrote:
> On Wed, 2011-06-01 at 15:58 +0200, Arne Jansen wrote:
>> git bisect blames this commit for a problem I have with v3.0-rc1:
>> If I printk large amounts of data, the machine locks up.
>> As the commit does not revert cleanly on top of 3.0, I haven't been
>> able to double check.
>> The test I use is simple, just add something like
>>
>> for (i=0; i<  10000; ++i) printk("test %d\n", i);
>>
>> and trigger it, in most cases I can see the first 10 printks before
>> I have to power cycle the machine (sysrq-b does not work anymore).
>> Attached my .config.
>
> I've made me a module that does the above, I've also changed my .config
> to match yours (smp=y, sched-cgroup=y, autogroup=n, preempt=n, no_hz=y),
> but sadly I cannot reproduce, I get all 10k prints on my serial line.
>
> Even without serial line it works (somehow booting without visible
> console is scary as hell :)
>
> Which makes me ask, how are you observing your console?
>

They don't go out to the serial line, I only observe them with a
tail -f on messages. Default log level doesn't go the console here.

> Because those 10k lines aren't even near the amount of crap a regular
> boot spews out on this box, although I guess the tight loop might
> generate it slightly faster than a regular boot does.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

