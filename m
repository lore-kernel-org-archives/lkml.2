Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1HAUAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:00:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46281 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1HAUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110801194809.GE19079@n2100.arm.linux.org.uk>
References: <1312124593-6088-1-git-send-email-linux@bohmer.net>
	<20110731150707.GA2975@n2100.arm.linux.org.uk>
	<CANqCtQJwUsLXfA408GzAr0rQtc2DRjtKqP8-m2UBUGEy-YP5dg@mail.gmail.com>
	<20110801092806.GD15578@n2100.arm.linux.org.uk>
	<CANqCtQK=H_B04A7knZSiuE5RLogTgMKxwtMK1HSqSgKA_U2J7A@mail.gmail.com>
	<20110801194809.GE19079@n2100.arm.linux.org.uk>
Date: Mon, 1 Aug 2011 22:00:00 +0200
X-Google-Sender-Auth: lNcTZvoHuD-XDQB7e-DBrHakb3Q
Message-ID: <CANqCtQLuvFSsL3N3HdxdhnmO=2g4qsUTPX5rym1FUH1Lo8-ofA@mail.gmail.com>
Subject: Re: [PATCH] Add sched_clock to AT91 TCB clocksource driver
From: Remy Bohmer <linux@bohmer.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Remy Bohmer <l.pinguin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> But late_time_init does it before the sched_clock is declared stable.
>> Until that point sched_clock will always return zero, as such we can
>> IMHO safely assume that the scheduler is designed such that it can
>> handle fixed zero timestamps for a while.
>
> You're confused.
>
> If you provide your own sched_clock(), that's what is used by everyone
> who calls sched_clock() both before and after sched_clock_init() has
> been called.
>
> sched_clock_cpu() and cpu_clock() both will return zero up until
> sched_clock_init() has been called, but sched_clock() itself may not.
>
> And these parts of the scheduler I'm talking about use sched_clock()
> itself, not sched_clock_cpu() nor cpu_clock().

Yep. You are right. I was confused... Sorry.

Kind regards,

Remy
