Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2AaHfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:35:44 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:59244 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2AaHfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:35:42 -0500
MIME-Version: 1.0
Date: Tue, 31 Jan 2012 15:28:09 +0800
Message-ID: <CAOwKts8zS1rYA+Y4k-vb8YAaR=aFd1BwryhhWWnWLQyrYrNqyA@mail.gmail.com>
Subject: In many cases softlockup can not be reported after disabling IRQ for
 long time
From: TAO HU <tghk48@motorola.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend with a new subject

On Wed, Jan 25, 2012 at 4:24 PM, TAO HU <tghk48@motorola.com> wrote:
> Hi, All
>
> While playing kernel 3.0.8 with below test code, it does NOT report
> any softlockup with 60%~70% chances.
> NOTE: the softlockup timeout is set to 10 seconds (i.e.
> watchdog_thresh=5) in my test.
> ... ...
> preempt_disable();
> local_irq_disable();
> for (i = 0; i < 20; i++)
>       mdelay(1000);
> local_irq_enable();
> preempt_enable();
> ... ...
>
> However, if I remove local_irq_disable()/local_irq_enable() it will
> report softlockup with no problem.
> I believe it is due to that after local_irq_enable()
> touch_softlockup_watchdog() is called prior softlockup timer.
>
> touch_softlockup_watchdog() basically resets the lockup detection
> process which implies that the 20-second lockup will be ignored.
> I noticed that touch_softlockup_watchdog() is called in dozens of
> places in kernel.
>
> Is that a design limitation or a bug? Any way to improve the situation?
>
> kernel/debug/debug_core.c:453:  touch_softlockup_watchdog_sync();
> kernel/power/hibernate.c:443:   touch_softlockup_watchdog();
> kernel/panic.c:153:             touch_softlockup_watchdog();
> kernel/time/timekeeping.c:684:  touch_softlockup_watchdog();
> kernel/time/tick-sched.c:149:   touch_softlockup_watchdog();
> kernel/time/tick-sched.c:543:   touch_softlockup_watchdog();
> kernel/time/tick-sched.c:596:           touch_softlockup_watchdog();
> kernel/time/tick-sched.c:756:                   touch_softlockup_watchdog();
> kernel/sched_clock.c:277:       touch_softlockup_watchdog();
>
>
>
> --
> Best Regards
> Hu Tao



-- 
Best Regards
Hu Tao
