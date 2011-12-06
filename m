Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1LFLov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:44:51 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:35316 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231Ab1LFLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:44:50 -0500
Message-ID: <4EDE002E.8040007@numascale.com>
Date: Tue, 06 Dec 2011 12:44:46 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, daniel@numascale-asia.com,
        mingo@elte.hu, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip] Fix build failure x86_default_fixup_cpu_id() with
 !CONFIG_SMP
References: <20111206104755.GA8567@linux.vnet.ibm.com> <4EDDFE79.9010109@linux.vnet.ibm.com>
In-Reply-To: <4EDDFE79.9010109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/2011 12:37, Srivatsa S. Bhat wrote:
> Hi Kamalesh,
>
> On 12/06/2011 04:17 PM, Kamalesh Babulal wrote:
>
>> Hi,
>>
>> tip (a4a7e7e29333) build fails, when compiled with !CONFIG_SMP.
>> I have only build tested the patch.
>>
>> x86: Fix x86_default_fixup_cpu_id() build failure with !CONFIG_SMP
>>
>> arch/x86/kernel/cpu/common.c: In function 'x86_default_fixup_cpu_id':
>> arch/x86/kernel/cpu/common.c:1149: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
>> make[3]: *** [arch/x86/kernel/cpu/common.o] Error 1
>>
>> the code was introduced by commit 64be4c1c24. This patch
>> introduced #ifdef to guard !SMP case.
>>
>> Signed-off-by: Kamalesh Babulal<kamalesh@linux.vnet.ibm.com>
>> ----
>
>
> There was a similar build-fix patch by Steffen Persvold at:
> https://lkml.org/lkml/2011/12/6/28
>
> That would solve your case too, right?
>

I would hope so (I tested with !CONFIG_SMP also), albeit I used :

#ifdef CONFIG_NUMA

and not

#ifdef CONFIG_SMP


but I don't think you can compile with CONFIG_NUMA without having 
CONFIG_SMP  (if I read the Kconfig correctly..).

I used CONFIG_NUMA because the code-path doesn't really make sense on 
non-numa nodes.

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
