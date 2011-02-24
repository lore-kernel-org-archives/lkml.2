Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1BXKXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:23:40 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:51183 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1BXKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:23:38 -0500
Message-ID: <886E26C48DE446C3937D89ECF86030B2@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>, <sachi@mistralsolutions.com>,
        "Kevin Hilman" <khilman@deeprootsystems.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Michael Williamson" <michael.williamson@criticallink.com>,
        "Chemparathy, Cyril" <cyril@ti.com>,
        "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1297434088-27995-1-git-send-email-subhasish@mistralsolutions.com> <B85A65D85D7EB246BE421B3FB0FBB593024BE49175@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BE49175@dbde02.ent.ti.com>
Subject: Re: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.
Date: Thu, 24 Feb 2011 15:54:56 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------------------------------
From: "Nori, Sekhar" <nsekhar@ti.com>
Sent: Wednesday, February 23, 2011 9:00 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>; 
<davinci-linux-open-source@linux.davincidsp.com>
Cc: <linux-arm-kernel@lists.infradead.org>; "Watkins, Melissa" 
<m-watkins@ti.com>; <sachi@mistralsolutions.com>; "Kevin Hilman" 
<khilman@deeprootsystems.com>; "Russell King" <linux@arm.linux.org.uk>; 
"Michael Williamson" <michael.williamson@criticallink.com>; "Chemparathy, 
Cyril" <cyril@ti.com>; "Sergei Shtylyov" <sshtylyov@ru.mvista.com>; "open 
list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.

> Hi Subhasish,
>
> On Fri, Feb 11, 2011 at 19:51:28, Subhasish Ghosh wrote:
>> This patch modifies the sram allocator to allocate memory
>> from the DA8XX shared RAM.
>
> It will be nice to know if you tried suspend-to-RAM
> after this change and found it to be working.
>

SG -- My file system is currently mounted from MMC.
          Suspend to RAM seems to have bug with MMC.
           (http://processors.wiki.ti.com/index.php/OMAP-L1_Linux_Drivers_Usage#Suspend-to-RAM)
          I had tried NFS earlier, but I think there is some problem with 
NFS boot and udev with this kernel.
           So, currently I will not be able to do it, but will try if I get 
a chance.

> Thanks,
> Sekhar
>
>>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
>> ---
>>  arch/arm/mach-davinci/da850.c              |    6 +++---
>>  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/da850.c 
>> b/arch/arm/mach-davinci/da850.c
>> index 3443d97..8a4de97 100644
>> --- a/arch/arm/mach-davinci/da850.c
>> +++ b/arch/arm/mach-davinci/da850.c
>> @@ -711,7 +711,7 @@ static struct map_desc da850_io_desc[] = {
>>  },
>>  {
>>  .virtual = SRAM_VIRT,
>> - .pfn = __phys_to_pfn(DA8XX_ARM_RAM_BASE),
>> + .pfn = __phys_to_pfn(DA8XX_SHARED_RAM_BASE),
>>  .length = SZ_8K,
>>  .type = MT_DEVICE
>>  },
>> @@ -1083,8 +1083,8 @@ static struct davinci_soc_info 
>> davinci_soc_info_da850 = {
>>  .gpio_irq = IRQ_DA8XX_GPIO0,
>>  .serial_dev = &da8xx_serial_device,
>>  .emac_pdata = &da8xx_emac_pdata,
>> - .sram_dma = DA8XX_ARM_RAM_BASE,
>> - .sram_len = SZ_8K,
>> + .sram_dma = DA8XX_SHARED_RAM_BASE,
>> + .sram_len = SZ_128K,
>>  .reset_device = &da8xx_wdt_device,
>>  };
>>
>> diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h 
>> b/arch/arm/mach-davinci/include/mach/da8xx.h
>> index cfcb223..c3c3339 100644
>> --- a/arch/arm/mach-davinci/include/mach/da8xx.h
>> +++ b/arch/arm/mach-davinci/include/mach/da8xx.h
>> @@ -70,6 +70,7 @@ extern unsigned int da850_max_speed;
>>  #define DA8XX_AEMIF_CTL_BASE 0x68000000
>>  #define DA8XX_DDR2_CTL_BASE 0xb0000000
>>  #define DA8XX_ARM_RAM_BASE 0xffff0000
>> +#define DA8XX_SHARED_RAM_BASE 0x80000000
>>
>>  void __init da830_init(void);
>>  void __init da850_init(void);
>> -- 
>> 1.7.2.3
>>
>>
> 
