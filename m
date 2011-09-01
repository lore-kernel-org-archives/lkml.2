Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1IACKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 22:10:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab1IACJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 22:09:59 -0400
Date: Thu, 1 Sep 2011 10:09:47 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: sifram rajas <sifram.rajas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: General question about TASK_INTERRUPTIBLE and schedule_timeout()
Message-ID: <20110901020947.GA9096@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <CA+OjSzzrYggQjDrgd6m+oF1sZkJFzf-3vSedAT3DAD9V2jTC3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+OjSzzrYggQjDrgd6m+oF1sZkJFzf-3vSedAT3DAD9V2jTC3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 06:18:19PM +0530, sifram rajas wrote:
> Hi,
> 
> I have a general question about the following 2 lines of code I see
> all over the kernel:
> 1         set_current_state(TASK_INTERRUPTIBLE) ;
> 2         schedule_timeout(<some value>);
> 
> In the above code, if we encounter an interrupt after executing line
> 1, we will end up
> call schedule() from the architecture specific code for CONFIG_PREEMPT
> kernels, after
> the interrupt handler has been invokled.

Yes.

> 
> This will cause the current task to sleep interruptibly forever
> instead of for a certain timeout interval.

No.

schedule() will not put an preempted task to sleep, see:
asmlinkage void __sched schduule(void)
{
...
        if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
                if (unlikely(signal_pending_state(prev->state, prev))) {
                        prev->state = TASK_RUNNING;
                } else {
		...
		}
        }
...
}

Thanks,
Yong

> 
> Won't this defeat the purpose of the above code to schedule out or
> sleep for a certain finite timeout ?
> If yes, then what are the techniques to solve this problem ?
> 
> 
> Thanks,
> Sifram.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
