Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0G1F1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:27:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55000 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab0G1F1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:27:10 -0400
Message-ID: <4C4FBEDC.4000008@monstr.eu>
Date: Wed, 28 Jul 2010 07:23:40 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead local_irq_save/restore
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu> 	<1274863724-14906-2-git-send-email-monstr@monstr.eu> <1274884963.22648.245.camel@gandalf.stny.rr.com> 	<20100526100805.171b3c48.akpm@linux-foundation.org> <4C4D4C2E.8010103@monstr.eu> 	<20100727161819.cf6feab1.akpm@linux-foundation.org> <AANLkTim3Po8XD3UFB-h6UH4HWtSZP9MA+V63TE5tQgku@mail.gmail.com>
In-Reply-To: <AANLkTim3Po8XD3UFB-h6UH4HWtSZP9MA+V63TE5tQgku@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Tue, Jul 27, 2010 at 19:18, Andrew Morton wrote:
>> On Mon, 26 Jul 2010 10:49:50 +0200 Michal Simek wrote:
>>> start/stop_critical_timing function for preemptirqsoff, preemptoff
>>> and irqsoff tracers contains atomic_inc and atomic_dec operations.
>>>
>>> Atomic operations used local_irq_save/restore macros to ensure
>>> atomic access but they are traced by the same function which is causing
>>> recursion problem.
>>>
>>> The reason is when these tracers are turn ON then local_irq_save/restore
>>> macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
>>> which call start/stop_critical_timing.
>>>
>>> Microblaze was affected because use generic atomic implementation.
>> Seems that this will also affect blackfin, mn10300 and score.  I guess
>> they aren't supporting tracing yet?
> 
> do you mean TRACE_IRQFLAGS_SUPPORT ?  Blackfin should ... my
> understanding was that arches just needed to implement asm/irqflags.h
> for it.

Blackin uses own include/asm/atomic.h implementation where shouldn't be 
a problem with irqflags tracer. Look at my second post.

Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
