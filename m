Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1FQGyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 02:54:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1FQGyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 02:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <4DFA5C2E.40507@codeaurora.org>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
	<4DFA5C2E.40507@codeaurora.org>
Date: Fri, 17 Jun 2011 08:54:14 +0200
Message-ID: <BANLkTi=ik=iRtDb3K__CPxSH_8GusoBHKA@mail.gmail.com>
Subject: Re: [RFC] Add Arm cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 21:40, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 06/16/2011 01:49 AM, Vincent Guittot wrote:
>> +config SCHED_MC
>> +     bool "Multi-core scheduler support"
>> +     depends on SMP && ARM_CPU_TOPOLOGY
>> +     default n
>> +     help
>> +       Multi-core scheduler support improves the CPU scheduler's decision
>> +       making when dealing with multi-core CPU chips at a cost of slightly
>> +       increased overhead in some places. If unsure say N here.
>> +
>> +config SCHED_SMT
>> +     bool "SMT scheduler support"
>> +     depends on SMP && ARM_CPU_TOPOLOGY
>> +     default n
>> +     help
>> +       Improves the CPU scheduler's decision making when dealing with
>> +       MultiThreading at a cost of slightly increased overhead in some
>> +       places. If unsure say N here.
>> +
>
> The default is already n so you can drop those two lines.
>

ok

>> +              * This is a multiprocessor system
>> +              * multiprocessor format & multiprocessor mode field are set
>> +              */
>> +
>> +             if (mpidr & (0x1 << 24)) {
>> +                     /* core performance interdependency */
>> +                     cpuid_topo->thread_id = (mpidr & 0x3);
>> +                     cpuid_topo->core_id =  ((mpidr >> 8) & 0xF);
>> +                     cpuid_topo->socket_id = ((mpidr >> 16) & 0xFF);
>> +             } else {
>> +                     /* normal core interdependency */
>> +                     cpuid_topo->thread_id = -1;
>> +                     cpuid_topo->core_id = (mpidr & 0x3);
>> +                     cpuid_topo->socket_id = ((mpidr >> 8) & 0xF);
>> +             }
>> +
>
> The ARM ARM says these fields are IMPLEMENTATION DEFINED meaning that
> different vendors may attribute different meaning to these fields if
> they wish. Does that mean this should be a platform_*() function?
>

The ARM ARM also provides a recommended use of the fields of this
register and the TRM of each Cortex adds some details. On the cortex
A9, each platform can only set the value of the Cluster ID with the
CLUSTERID pins. I have tried to consolidate the value of MPIDR  across
several platforms and they all match with the description.

Have you got an example of a MPIDR register which doesn't match with
the implementation ?

> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>
