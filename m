Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2HPDrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:47:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44412 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2HPDrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120814114856.GA17040@linux-mips.org>
References: <1344862344-27434-1-git-send-email-chenhc@lemote.com>
	<20120814114856.GA17040@linux-mips.org>
Date: Thu, 16 Aug 2012 11:47:06 +0800
X-Google-Sender-Auth: N23f4-7LkWKTo8q6OnoFbgQfrlM
Message-ID: <CAAhV-H4rbDp86cnrYn-2t05Sv17=LV6Hfchb=dBSeD3oc6x5kQ@mail.gmail.com>
Subject: Re: [PATCH V2] MIPS: Fix poweroff failure when HOTPLUG_CPU configured.
From: Huacai Chen <chenhc@lemote.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        Yong Zhang <yong.zhang@windriver.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 7:48 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Mon, Aug 13, 2012 at 08:52:24PM +0800, Huacai Chen wrote:
>
>> When poweroff machine, kernel_power_off() call disable_nonboot_cpus().
>> And if we have HOTPLUG_CPU configured, disable_nonboot_cpus() is not an
>> empty function but attempt to actually disable the nonboot cpus. Since
>> system state is SYSTEM_POWER_OFF, play_dead() won't be called and thus
>> disable_nonboot_cpus() hangs. Therefore, we make this patch to avoid
>> poweroff failure.
>
>> diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
>> index e9a5fd7..69b17a9 100644
>> --- a/arch/mips/kernel/process.c
>> +++ b/arch/mips/kernel/process.c
>> @@ -72,9 +72,7 @@ void __noreturn cpu_idle(void)
>>                       }
>>               }
>>  #ifdef CONFIG_HOTPLUG_CPU
>> -             if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map) &&
>> -                 (system_state == SYSTEM_RUNNING ||
>> -                  system_state == SYSTEM_BOOTING))
>> +             if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
>
> Looks good - but I'm wondering if the "!cpu_isset(cpu, cpu_callin_map)"
> can be removed as well?
I removed "!cpu_isset(cpu, cpu_callin_map)" and it works well on
Loongson, but I don't know whether it will affect cavium-octeon...

>
> Also, which -stable branches is this patch applicable?
>
>   Ralf
>
