Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0EWONk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 10:13:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39211 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab0EWONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 10:13:39 -0400
Date: Sun, 23 May 2010 15:13:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
Message-ID: <20100523141300.GD950@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com> <20100523123801.GC950@n2100.arm.linux.org.uk> <AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 09:44:20PM +0800, Ming Lei wrote:
> 2010/5/23 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> >>  ENTRY(ret_to_user)
> >>  ret_slow_syscall:
> >> -     disable_irq                             @ disable interrupts
> >> +     disable_irq_notrace                             @ disable interrupts
> >
> > I think this one does need to be traced - the pending work functions are
> > all C code which could call back into lockdep.
> 
> If there are pending works, schedule will be called to give cpu to it,
> I wonder why the work function to be scheduled will be run with irq
> disabled. Seems we should enable irq again before calling schedule,
> not sure.

No.  I'm talking about things like do_notify_resume().

I think the above should be left as-is, so that as far as lockdep is
concerned, IRQs are off while userspace runs.  What happens between
returning to userspace and re-entering the kernel has no bearing what
so ever on lockdep.
