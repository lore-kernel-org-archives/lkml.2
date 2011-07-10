Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab1GJEUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 00:20:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46980 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750734Ab1GJEUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 00:20:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/aDYZR7QHaKaVGmtA7qnDX86IhNS+oC8kXf6bReO
	4TCY//6UYfyEo8
Subject: Re: [BUG] Why does mwait_idle_with_hints() call MWAIT with
 interrupts disabled ?
From: Mike Galbraith <efault@gmx.de>
To: Linux Smiths <linuxsmiths@gmail.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAM3a_yr+KxisXDJcZChOtyYJYENFt7Uh1KPtZJ4rtgAF5vRqeQ@mail.gmail.com>
References: <CAM3a_ypyYiwNz-7ewiHnsLGi=+ZWWHkTi7nM2EKW6u=UNOa0DQ@mail.gmail.com>
	 <CAM3a_yr+KxisXDJcZChOtyYJYENFt7Uh1KPtZJ4rtgAF5vRqeQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 06:20:36 +0200
Message-ID: <1310271636.7643.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-09 at 06:00 +0530, Linux Smiths wrote:
> Venkatesh,
>                  I see that you have introduced __sti_mwait(), so
> maybe you can explain why we use __mwait() in mwait_idle_with_hints()
> and __sti_mwait() in mwait_idle().
> 
> I know that even before your patch, mwait_idle_with_hints() used to
> behave differently from mwait_idle(), in that it did not use to enable
> interrupt before entering MWAIT sleep, but I'm hoping you can answer
> this question for me.

I got curious enough to blow an inch of virtual dust off the manual..

Software_Delelopers_Manual_Volume:2A:Instruction_Set_Reference:A-M

MWAIT for Address Range Monitoring

For address-range monitoring, the MWAIT instruction operates with the MONITOR
instruction. The two instructions allow the definition of an address at which to wait
(MONITOR) and a implementation-dependent-optimized operation to commence at
the wait address (MWAIT). The execution of MWAIT is a hint to the processor that it
can enter an implementation-dependent-optimized state while waiting for an event
or a store operation to the address range armed by MONITOR.
ECX specifies optional extensions for the MWAIT instruction. EAX may contain hints
such as the preferred optimized state the processor should enter.
For Pentium 4 processors (CPUID signature family 15 and model 3), non-zero values
for EAX and ECX are reserved. Later processors defined ECX=1 as a valid extension
(see below).

A store to the address range armed by the MONITOR instruction, an interrupt, an NMI
or SMI, a debug exception, a machine check exception, the BINIT# signal, the INIT#
signal, or the RESET# signal will exit the implementation-dependent-optimized
state. An interrupt will cause the processor to exit only if the state was entered with
interrupts enabled or if ECX=1.
                   ^^^^^^^^^^^

