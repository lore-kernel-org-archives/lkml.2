Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1GKIDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:03:00 -0400
Received: from linux.securehostdns.com ([174.36.253.246]:51261 "EHLO
	linux.securehostdns.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750785Ab1GKIC6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <1310271636.7643.33.camel@marge.simson.net>
References: <CAM3a_ypyYiwNz-7ewiHnsLGi=+ZWWHkTi7nM2EKW6u=UNOa0DQ@mail.gmail.com>
	<CAM3a_yr+KxisXDJcZChOtyYJYENFt7Uh1KPtZJ4rtgAF5vRqeQ@mail.gmail.com>
	<1310271636.7643.33.camel@marge.simson.net>
Date: Mon, 11 Jul 2011 13:32:53 +0530
Message-ID: <CAM3a_ypSgCuf_8z82MKAt=9DXhz5fih-QYMLCrOVf+bBGde4Rg@mail.gmail.com>
Subject: Re: [BUG] Why does mwait_idle_with_hints() call MWAIT with interrupts
 disabled ?
From: Tomar <tomar@linuxsmiths.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - linux.securehostdns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxsmiths.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,
        Thanks for pointing. This explains it. I was looking at an
older manual which did not have mention of this ECX extension.

Thanks,
Tomar



> I got curious enough to blow an inch of virtual dust off the manual..
>
> Software_Delelopers_Manual_Volume:2A:Instruction_Set_Reference:A-M
>
> MWAIT for Address Range Monitoring
>
> For address-range monitoring, the MWAIT instruction operates with the MONITOR
> instruction. The two instructions allow the definition of an address at which to wait
> (MONITOR) and a implementation-dependent-optimized operation to commence at
> the wait address (MWAIT). The execution of MWAIT is a hint to the processor that it
> can enter an implementation-dependent-optimized state while waiting for an event
> or a store operation to the address range armed by MONITOR.
> ECX specifies optional extensions for the MWAIT instruction. EAX may contain hints
> such as the preferred optimized state the processor should enter.
> For Pentium 4 processors (CPUID signature family 15 and model 3), non-zero values
> for EAX and ECX are reserved. Later processors defined ECX=1 as a valid extension
> (see below).
>
> A store to the address range armed by the MONITOR instruction, an interrupt, an NMI
> or SMI, a debug exception, a machine check exception, the BINIT# signal, the INIT#
> signal, or the RESET# signal will exit the implementation-dependent-optimized
> state. An interrupt will cause the processor to exit only if the state was entered with
> interrupts enabled or if ECX=1.
>                   ^^^^^^^^^^^
>
>
