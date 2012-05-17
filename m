Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277Ab2EQR5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:57:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56060 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757016Ab2EQR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:57:34 -0400
Message-ID: <4FB53BC2.7060300@mvista.com>
Date: Thu, 17 May 2012 21:56:18 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Daney <david.daney@cavium.com>
CC: Yong Zhang <yong.zhang0@gmail.com>, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] patchset focus on MIPS SMP woes
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com> <4FB523C1.4070902@cavium.com>
In-Reply-To: <4FB523C1.4070902@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/17/2012 08:13 PM, David Daney wrote:

>> From: Yong Zhang<yong.zhang@windriver.com>

>> Since commit 5fbd036b [sched: Cleanup cpu_active madness] and
>> commit 2baab4e9 [sched: Fix select_fallback_rq() vs cpu_active/cpu_online],
>> it's more safe to put notify_cpu_starting() and set_cpu_online() with
>> irq disabled, otherwise we will have a typical race condition which
>> above two commits try to resolve:

>> CPU1 CPU2
>> __cpu_up();
>> mp_ops->boot_secondary();
>> start_secondary();
>> ->init_secondary();
>> local_irq_enable();
>> <IRQ>
>> do something;
>> wake up softirqd;
>> try_to_wake_up();
>> select_fallback_rq();
>> /* select wrong cpu */
>> set_cpu_online();


>> This patchset fix the above issue as well as set_cpu_online is
>> called on the caller cpu.

>> BTW, I'm only running it on Cavium board because of limited source,
>> so if anyone is interested to test it on other board, that's great :)

>> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>

>> Yong Zhang (8):
>> MIPS: Octeon: delay enable irq to ->smp_finish()
>> MIPS: BMIPS: delay irq enable to ->smp_finish()
>> MIPS: SMTC: delay irq enable to ->smp_finish()
>> MIPS: Yosemite: delay irq enable to ->smp_finish()
>> MIPS: call ->smp_finish() a little late
>> MIPS: call set_cpu_online() on the uping cpu with irq disabled
>> MIPS: smp: Warn on too early irq enable
>> MIPS: sync-r4k: remove redundant irq operation

> This entire patch set (modulo the change log grammar items noted by Sergei):

    I noted not only change log grammar, also comment grammar. And a missing 
summary in commit reference. :-)

> Acked-by: David Daney <david.daney@cavium.com>

WBR, Sergei
