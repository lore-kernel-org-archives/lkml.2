Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0DOQVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:21:31 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:38298 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0DOQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:21:30 -0400
Message-ID: <4BC73D02.5090108@petalogix.com>
Date: Thu, 15 Apr 2010 18:21:22 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: sched_clock - microblaze
References: <4BC728DD.5020404@petalogix.com> <1271343970.3856.7.camel@iscandar.digidescorp.com>
In-Reply-To: <1271343970.3856.7.camel@iscandar.digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> Michal,
> 
> On Thu, 2010-04-15 at 16:55 +0200, Michal Simek wrote:
> 
>> Is unimplemented sched_clock the reason why ftrace not show fine grain time?
>>
>> Or is there any other thing which is wrong?
>>
> 
> I think that's it. On my platform we have a free-running 1 MHz counter
> so I implemented a platform sched_clock for that, and I get nice ftrace
> times.
> 
>  0) + 65.000 us   |  finish_task_switch();
>  0)               |  lock_sock_nested() {
>  0) + 52.000 us   |    local_bh_disable();
>  0) + 53.000 us   |    local_bh_enable();
>  0) ! 264.000 us  |  }

I don't understand why I should add any "new" free running counter 
because we have one free running counter which do it (clocksource timer 
- timer1). Or am I missing something?

Thanks for sending your code.
Michal



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
