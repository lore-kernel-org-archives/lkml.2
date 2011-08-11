Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1HKBpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 21:45:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45349 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1HKBpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 21:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7N6vqqsrodDGURQhASrWo=9oZHtxwAuXiXs514+iGT4NKw+Q@mail.gmail.com>
References: <CAK7N6vqqsrodDGURQhASrWo=9oZHtxwAuXiXs514+iGT4NKw+Q@mail.gmail.com>
Date: Thu, 11 Aug 2011 10:45:33 +0900
Message-ID: <CAK7N6vqP6Fr0xxZ9h_r0RnzeQ-nB9TpefmnKR9Qqhv3C+_0DTA@mail.gmail.com>
Subject: Re: Interrupt not getting re-enabled after handler is killed
From: anish singh <anish198519851985@gmail.com>
To: linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding Linux Kernel in loop.

On Wed, Aug 10, 2011 at 5:16 PM, anish singh
<anish198519851985@gmail.com> wrote:
> Intention:
> Wanted to modify the behavior of threaded interrupt handler
> not being called after the threaded_handler was killed.
>
> Reason:
> Well there is no reason as such but just want to see what all
> needs to be done to get this right.I know that what i am doing
> is completely wrong as i would get a strom of irq's and device
> will be unstable[1].
>
> Modification:
> I thought if i remove the below line from exit_irq_thread function
> set_bit(IRQTF_DIED, &tsk->irqaction->flags);
> it would do.But nothing happened then i inspected closely i found that
> in-case we need to do that we have to again create kthread
> which i am not doing in-case we again receive the interrupt of the killed
> threaded_handler.
>
> So i came to this conclusion:
> Right now we need more that just setting the flag bit to get this right.
> Is the above right ?Yes/no?
>
> Or
>
> if my understanding is not right then probably the interrupt controller
> itself is not sending the interrupt after the thread is killed.If this is right
> where is the code for that?
> In my limited search i couldn't find where we are disabling the interrupt
> once the threaded_handler is killed.
>
> Hope i am clear about what i want to know.
>
> [1] http://thread.gmane.org/gmane.linux.kernel/811061
>
