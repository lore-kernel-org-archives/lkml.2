Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0G0Xyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:54:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58287 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0G0XyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CMubWTC98jZ2X9HTCvChtBXBDoHN8J50/mzWhyfmqaTrLp4zxVgwH9GAzZBctPA1RE
         vUQKNq4F1wwaXOX4NhJb7ZwzOB4HjKFZm/EJcsEp0h6HbDsADRDip5NmZhbRxpANc0+0
         6qSat036QQl8/lhoevb0rPz0o5OdzOCuy2pfY=
MIME-Version: 1.0
In-Reply-To: <20100727161819.cf6feab1.akpm@linux-foundation.org>
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu> 
	<1274863724-14906-2-git-send-email-monstr@monstr.eu> <1274884963.22648.245.camel@gandalf.stny.rr.com> 
	<20100526100805.171b3c48.akpm@linux-foundation.org> <4C4D4C2E.8010103@monstr.eu> 
	<20100727161819.cf6feab1.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 27 Jul 2010 19:54:04 -0400
Message-ID: <AANLkTim3Po8XD3UFB-h6UH4HWtSZP9MA+V63TE5tQgku@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead 
	local_irq_save/restore
To: Andrew Morton <akpm@linux-foundation.org>
Cc: monstr@monstr.eu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 19:18, Andrew Morton wrote:
> On Mon, 26 Jul 2010 10:49:50 +0200 Michal Simek wrote:
>> start/stop_critical_timing function for preemptirqsoff, preemptoff
>> and irqsoff tracers contains atomic_inc and atomic_dec operations.
>>
>> Atomic operations used local_irq_save/restore macros to ensure
>> atomic access but they are traced by the same function which is causing
>> recursion problem.
>>
>> The reason is when these tracers are turn ON then local_irq_save/restore
>> macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
>> which call start/stop_critical_timing.
>>
>> Microblaze was affected because use generic atomic implementation.
>
> Seems that this will also affect blackfin, mn10300 and score.  I guess
> they aren't supporting tracing yet?

do you mean TRACE_IRQFLAGS_SUPPORT ?  Blackfin should ... my
understanding was that arches just needed to implement asm/irqflags.h
for it.
-mike
