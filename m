Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1JZGUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:20:18 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:51459 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1JZGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:20:17 -0400
Message-ID: <4EA7A69B.1050101@scalemp.com>
Date: Wed, 26 Oct 2011 08:20:11 +0200
From: Eial Czerwacki <eial@scalemp.com>
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101020 Remi/fc8 Thunderbird/3.1.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] AMD: modify cpu probe from APICID to initial APICID
References: <4EA6695C.1000904@scalemp.com>	<9B14D1490DDECA4E974F6B9FC9EBAB3140CD274366@VMBX108.ihostexchange.net>	<4EA699B5.4030008@scalemp.com>	<9B14D1490DDECA4E974F6B9FC9EBAB3140CD27436C@VMBX108.ihostexchange.net>	<4EA6A24D.1000400@scalemp.com> <CAE9FiQUrq-3GDhaZS8gOL5NBHF-ZcWjHiWWUYP4AdM2+q_12Ow@mail.gmail.com>
In-Reply-To: <CAE9FiQUrq-3GDhaZS8gOL5NBHF-ZcWjHiWWUYP4AdM2+q_12Ow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 11:51 PM, Yinghai Lu wrote:
> On Tue, Oct 25, 2011 at 4:49 AM, Eial Czerwacki<eial@scalemp.com>  wrote:
>> Make AMD probe processors using APICID rather than the initial APICID.
>>
>>
>> Signed-off-by: Eial Czerwacki<eial@scalemp.com>
>> Signed-off-by: Shai Fultheim<shai@scalemp.com>
>> ---
>>
>> --- a/arch/x86/kernel/cpu/amd.c 2011-09-14 05:58:19.542910736 -0700
>> +++ b/arch/x86/kernel/cpu/amd.c 2011-09-14 06:01:41.493209624 -0700
>> @@ -299,9 +299,9 @@ static void __cpuinit amd_detect_cmp(str
>>
>>         bits = c->x86_coreid_bits;
>>         /* Low order bits define the core id (index of core in socket) */
>> -       c->cpu_core_id = c->initial_apicid&      ((1<<      bits)-1);
>> +       c->cpu_core_id = c->apicid&      ((1<<      bits)-1);
>>         /* Convert the initial APIC ID into the socket ID */
>> -       c->phys_proc_id = c->initial_apicid>>      bits;
>> +       c->phys_proc_id = c->apicid>>      bits;
>>         /* use socket ID also for last level cache */
>>         per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
>>         /* fixup topology information on multi-node processors */
>>
>
> No, that is not right.
>
> We have to initial apicid to get socket/core mapping.
>
> BTW, your mail client has some problem with formatting.
>
> Thanks
>
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

ok, I'll review the patch again.

is the format ok now?


Thanks,

Eial.
