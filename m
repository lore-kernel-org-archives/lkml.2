Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0IGIA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:00:27 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:54309 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0IGIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:00:22 -0400
Message-ID: <4C85F0E3.2050908@ladisch.de>
Date: Tue, 07 Sep 2010 09:59:31 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hungry for hardware timers
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>
In-Reply-To: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> I am investigating how many hardware timers are available for kernel,
> system applications and user applications for x86 platforms.

Why would you want to have a separate timer for your application?

> Is there any help available for it so that systems developers can use
> a hook up an interrupt and use any hardware timer.

The kernel is supposed to abstract away the hardware; just use POSIX
timers.

> In APIC timer, but each core is having only one timer and it is
> already utilized by Linux :
> ... APIC TMICT: 00002078
> ... APIC TMCCT: 00000b5f
> ... APIC TDCR: 00000003

Having per-CPU timers allows the kernel to avoid synchronizing between
CPUs.

> HPET have 3 timers :
> [    0.328157] hpet: ID: 0x8086a201, PERIOD: 0x429b17f
> [    0.328315] hpet: CFG: 0x3, STATUS: 0x0
> [    0.328472] hpet: COUNTER_l: 0x6ff120, COUNTER_h: 0x0
> [    0.329006] hpet: T0: CFG_l: 0x138, CFG_h: 0xf00000
> [    0.329165] hpet: T0: CMP_l: 0x701baa, CMP_h: 0x0
> [    0.329324] hpet: T0 ROUTE_l: 0x0, ROUTE_h: 0x0
> [    0.329483] hpet: T1: CFG_l: 0x0, CFG_h: 0xf00000
> [    0.330006] hpet: T1: CMP_l: 0xffffffff, CMP_h: 0x0
> [    0.330166] hpet: T1 ROUTE_l: 0x0, ROUTE_h: 0x0
> [    0.331005] hpet: T2: CFG_l: 0x0, CFG_h: 0xf00800
> [    0.331168] hpet: T2: CMP_l: 0xdf751c, CMP_h: 0x0
> [    0.331328] hpet: T2 ROUTE_l: 0x0, ROUTE_h: 0x0
> 
> T0 and T2 is already used by Linux and T1 is used for RTC

T2 shouldn't be used.  What does /proc/interrupts say?

> System 8254 timer have 3 timers but it seems it is also used by Linux :
> [ 4923.510233] 0: 83ae 1: 1102 2: 37f2
> [ 4923.510251] 0: 8382 1: d10 2: 37dc

That thing is horribly slow; nobody would want to use this, if possible.


Regards,
Clemens
