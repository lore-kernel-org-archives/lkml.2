Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1HaNF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:05:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64794 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab1HaNFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+OjSzzrYggQjDrgd6m+oF1sZkJFzf-3vSedAT3DAD9V2jTC3A@mail.gmail.com>
References: <CA+OjSzzrYggQjDrgd6m+oF1sZkJFzf-3vSedAT3DAD9V2jTC3A@mail.gmail.com>
Date: Wed, 31 Aug 2011 18:35:24 +0530
Message-ID: <CA+OjSzxRLn+AvMy9W0h1jsqD_Lgp87RhoUihm22aM3X=be2S3A@mail.gmail.com>
Subject: Re: General question about TASK_INTERRUPTIBLE and schedule_timeout()
From: sifram rajas <sifram.rajas@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If this is a problem, then can this be solved by disabling preemption
in the following
manner ? :
preempt_disable() ;
set_current_state(TASK_INTERRUPTIBLE) ;
schedule_timeout(<some value>);
preempt_enable() ;



On Wed, Aug 31, 2011 at 6:18 PM, sifram rajas <sifram.rajas@gmail.com> wrote:
> Hi,
>
> I have a general question about the following 2 lines of code I see
> all over the kernel:
> 1         set_current_state(TASK_INTERRUPTIBLE) ;
> 2         schedule_timeout(<some value>);
>
> In the above code, if we encounter an interrupt after executing line
> 1, we will end up
> call schedule() from the architecture specific code for CONFIG_PREEMPT
> kernels, after
> the interrupt handler has been invokled.
>
> This will cause the current task to sleep interruptibly forever
> instead of for a certain timeout interval.
>
> Won't this defeat the purpose of the above code to schedule out or
> sleep for a certain finite timeout ?
> If yes, then what are the techniques to solve this problem ?
>
>
> Thanks,
> Sifram.
>
