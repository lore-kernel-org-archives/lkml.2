Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab2FRLps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:45:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40673 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FRLpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:45:46 -0400
Message-ID: <4FDF14E5.8080003@monstr.eu>
Date: Mon, 18 Jun 2012 13:45:41 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: Re: [RFC PATCH 8/8] ARM: vmlinux.lds: Setup correct entry point to
 physical address
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-9-git-send-email-monstr@monstr.eu> <20120618113716.GG12029@n2100.arm.linux.org.uk>
In-Reply-To: <20120618113716.GG12029@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 01:37 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 18, 2012 at 01:30:11PM +0200, Michal Simek wrote:
>> linker script setups entry point to virtual address.
>>
>> Signed-off-by: Michal Simek<monstr@monstr.eu>
>>
>> ---
>> Not sure what is the reason to setup entry point to virtual address.
>> ---
>>   arch/arm/kernel/vmlinux.lds.S |    4 +++-
>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
>> index b996bc0..de43b01 100644
>> --- a/arch/arm/kernel/vmlinux.lds.S
>> +++ b/arch/arm/kernel/vmlinux.lds.S
>> @@ -39,7 +39,7 @@
>>   #endif
>>
>>   OUTPUT_ARCH(arm)
>> -ENTRY(stext)
>> +ENTRY(arm_start)
>
> stext etc better stay as the virtual address through this change.  The
> kernel makes use of all stext/etext etc symbols as virtual addresses.

I am not changing stext to physical address. Just elf entry point.
What's it reason to have entry point in virtual address space?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
