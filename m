Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0ISQno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 12:43:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab0ISQnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 12:43:43 -0400
Message-ID: <4C963DAC.4040604@redhat.com>
Date: Sun, 19 Sep 2010 18:43:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: raw_spinlock_t rules
References: <4C960B78.4010804@redhat.com> <1284914302.23787.2749.camel@gandalf.stny.rr.com>
In-Reply-To: <1284914302.23787.2749.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/19/2010 06:38 PM, Steven Rostedt wrote:
> On Sun, 2010-09-19 at 15:09 +0200, Avi Kivity wrote:
> >  Some time ago, the i8259 emulation code in kvm was changed to use
> >  raw_spinlock_t, as it was called in a preempt_disable() and
> >  local_irq_disable() context, which doesn't work with preemptible
> >  spinlocks used with CONFIG_PREEMPT_RT.
> >
> >  In Linux 2.6.37, the spinlock will no longer be taken in these contexts,
> >  so I'd like to change it to a normal spinlock_t.  However, it is still
> >  taken in a spin_lock_irq() context.
> >
> >  Is it okay to do this change?  I figured since spin_lock_irq() is part
> >  of the spinlock infrastructure it might to the right thing.
> >
>
> In PREEMPT_RT all interrupts (besides the timer) is converted to a
> thread. The spin_lock_irq() will not disable interrupts in PREEMPT_RT,
> because it is not needed (irqs are threaded and wont cause a deadlock if
> they share the same spin_locks).
>
> Note, spin_locks used by the timer will must be raw_spin_lock(), and
> threaded context must disable interrupts for real before using it.
>

Thanks.  So it looks like we can convert that spinlock.

-- 
error compiling committee.c: too many arguments to function

