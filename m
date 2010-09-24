Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab0IXQN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:13:56 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5451 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0IXQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:13:55 -0400
Message-ID: <4C9CCE42.3030309@caviumnetworks.com>
Date: Fri, 24 Sep 2010 09:13:54 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] MIPS: Add a platform hook for swiotlb setup.
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com> <1285281496-24696-9-git-send-email-ddaney@caviumnetworks.com> <4C9CCD1B.506@mvista.com>
In-Reply-To: <4C9CCD1B.506@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2010 16:13:54.0621 (UTC) FILETIME=[7C0F0ED0:01CB5C03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 09:08 AM, Sergei Shtylyov wrote:
> Hello.
>
> David Daney wrote:
>
>> This allows platforms that are using the swiotlb to initialize it.
>
>> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
>> ---
>> arch/mips/include/asm/bootinfo.h | 5 +++++
>> arch/mips/kernel/setup.c | 5 +++++
>> 2 files changed, 10 insertions(+), 0 deletions(-)
>
>> diff --git a/arch/mips/include/asm/bootinfo.h
>> b/arch/mips/include/asm/bootinfo.h
>> index 15a8ef0..b3cf989 100644
>> --- a/arch/mips/include/asm/bootinfo.h
>> +++ b/arch/mips/include/asm/bootinfo.h
>> @@ -125,4 +125,9 @@ extern unsigned long fw_arg0, fw_arg1, fw_arg2,
>> fw_arg3;
>> */
>> extern void plat_mem_setup(void);
>>
>> +/*
>> + * Optional platform hook to call swiotlb_setup().
>> + */
>> +extern void plat_swiotlb_setup(void);
>> +
>> #endif /* _ASM_BOOTINFO_H */
>> diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
>> index 85aef3f..8b650da 100644
>> --- a/arch/mips/kernel/setup.c
>> +++ b/arch/mips/kernel/setup.c
>> @@ -488,6 +488,11 @@ static void __init arch_mem_init(char **cmdline_p)
>>
>> bootmem_init();
>> sparse_init();
>> +
>> +#ifdef CONFIG_SWIOTLB
>> + plat_swiotlb_setup();
>> +#endif
>
> We should avoid #ifdef's in function bodies. Why not defile an empty
> 'inline' in the header above if CONFIG_SWIOTLB is not defined?
>

Good idea.  I will wait several days and collect any more feedback and 
generate a new patch set.

David Daney
