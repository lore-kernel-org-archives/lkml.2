Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2ETNz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:55:58 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:59757 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2ETNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:55:56 -0400
Message-ID: <4FB8F7E9.4020005@scalemp.com>
Date: Sun, 20 May 2012 16:55:53 +0300
From: Vlad <vlad@scalemp.com>
Reply-To: vlad@scalemp.com
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH v2 2/2] x86: Added read_mostly declaration/definition
 to vars from smp.h
References: <201205151831.57871.vlad@scalemp.com> <20120518081416.GA20872@gmail.com>
In-Reply-To: <20120518081416.GA20872@gmail.com>
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

On 05/18/2012 11:14 AM, Ingo Molnar wrote:
> * Vlad Zolotarov<vlad@scalemp.com>  wrote:
>
>> Added a "read-mostly" qualifier to the following variables in smp.h:
>>   - cpu_sibling_map
>>   - cpu_core_map
>>   - cpu_llc_shared_map
>>   - cpu_llc_id
>>   - cpu_number
>>   - x86_cpu_to_apicid
>>   - x86_bios_cpu_apicid
>>   - x86_cpu_to_logical_apicid
>>
>> As long as all the variables above are only written during the initialization,
>> this change is meant to prevent the false sharing and improve the
>> performance on large multiprocessor systems.
>>
>> Signed-off-by: Vlad Zolotarov<vlad@scalemp.com>
>> Signed-off-by: Shai Fultheim<shai@scalemp.com>
>> ---
>>   arch/x86/include/asm/apic.h    |    2 +-
>>   arch/x86/include/asm/smp.h     |   16 ++++++++--------
>>   arch/x86/kernel/apic/apic.c    |    6 +++---
>>   arch/x86/kernel/setup_percpu.c |    2 +-
>>   arch/x86/kernel/smpboot.c      |    8 ++++----
>>   5 files changed, 17 insertions(+), 17 deletions(-)
>
> This does not build on !SMP kernels that has APIC enabled.

Oops... :) My bad. I'll rebase and respin.

Thanks,
vlad

>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

