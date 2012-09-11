Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab2IKNfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:35:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:26983 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2IKNfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:35:17 -0400
Message-ID: <504F3E04.4050906@atmel.com>
Date: Tue, 11 Sep 2012 15:35:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 01/16] ARM: at91: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-1-git-send-email-arnd@arndb.de> <20120911132059.GG31430@game.jcrosoft.org>
In-Reply-To: <20120911132059.GG31430@game.jcrosoft.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 03:20 PM, Jean-Christophe PLAGNIOL-VILLARD :
> On 14:59 Tue 11 Sep     , Arnd Bergmann wrote:
>> Platform data for device drivers should be defined in
>> include/linux/platform_data/*.h, not in the architecture
>> and platform specific directories.
>>
>> This moves such data out of the at91 include directories
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
>> Cc: Vinod Koul <vinod.koul@intel.com>
>> Cc: Dan Williams <djbw@fb.com>
>> ---
>>  arch/arm/mach-at91/at91sam9g45_devices.c                             |    2 +-
>>  arch/arm/mach-at91/at91sam9rl_devices.c                              |    2 +-
>>  arch/arm/mach-at91/include/mach/atmel-mci.h                          |    2 +-
>>  drivers/dma/at_hdmac_regs.h                                          |    2 +-
>>  include/linux/platform_data/atmel-aes.h                              |    2 +-
>>  .../mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h       |    0
>>  6 files changed, 5 insertions(+), 5 deletions(-)
>>  rename arch/arm/mach-at91/include/mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h (100%)
>>
>> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
>> index 0607399..0aa9bdb 100644
>> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
>> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
>> @@ -31,7 +31,7 @@
>>  #include <mach/at91sam9g45_matrix.h>
>>  #include <mach/at91_matrix.h>
>>  #include <mach/at91sam9_smc.h>
>> -#include <mach/at_hdmac.h>
>> +#include <linux/platform_data/dma-atmel.h>
>>  #include <mach/atmel-mci.h>
>>  
>>  #include <media/atmel-isi.h>
>> diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
>> index f09fff9..e4da717 100644
>> --- a/arch/arm/mach-at91/at91sam9rl_devices.c
>> +++ b/arch/arm/mach-at91/at91sam9rl_devices.c
>> @@ -22,7 +22,7 @@
>>  #include <mach/at91sam9rl_matrix.h>
>>  #include <mach/at91_matrix.h>
>>  #include <mach/at91sam9_smc.h>
>> -#include <mach/at_hdmac.h>
>> +#include <linux/platform_data/dma-atmel.h>
> I prefer to have all of them in atmel.h
> 
> as I started

Sorry J. but I do not agree:
- ok for what is currently in include/mach/board.h ==> platform_data/atmel.h
- no for individual drivers that have already a dedicated header file

So for this move of at_hdmac.h ==> dma-atmel.h

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Best regards,

>>  #include "generic.h"
>>  
>> diff --git a/arch/arm/mach-at91/include/mach/atmel-mci.h b/arch/arm/mach-at91/include/mach/atmel-mci.h
>> index 998cb0c..cd580a1 100644
>> --- a/arch/arm/mach-at91/include/mach/atmel-mci.h
>> +++ b/arch/arm/mach-at91/include/mach/atmel-mci.h
>> @@ -1,7 +1,7 @@
>>  #ifndef __MACH_ATMEL_MCI_H
>>  #define __MACH_ATMEL_MCI_H
>>  
>> -#include <mach/at_hdmac.h>
>> +#include <linux/platform_data/dma-atmel.h>
>>  
>>  /**
>>   * struct mci_dma_data - DMA data for MCI interface
>> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
>> index 8a6c8e8..116e4ad 100644
>> --- a/drivers/dma/at_hdmac_regs.h
>> +++ b/drivers/dma/at_hdmac_regs.h
>> @@ -11,7 +11,7 @@
>>  #ifndef AT_HDMAC_REGS_H
>>  #define	AT_HDMAC_REGS_H
>>  
>> -#include <mach/at_hdmac.h>
>> +#include <linux/platform_data/dma-atmel.h>
>>  
>>  #define	AT_DMA_MAX_NR_CHANNELS	8
>>  
>> diff --git a/include/linux/platform_data/atmel-aes.h b/include/linux/platform_data/atmel-aes.h
>> index e7a1949..ab68082 100644
>> --- a/include/linux/platform_data/atmel-aes.h
>> +++ b/include/linux/platform_data/atmel-aes.h
>> @@ -1,7 +1,7 @@
>>  #ifndef __LINUX_ATMEL_AES_H
>>  #define __LINUX_ATMEL_AES_H
>>  
>> -#include <mach/at_hdmac.h>
>> +#include <linux/platform_data/dma-atmel.h>
>>  
>>  /**
>>   * struct aes_dma_data - DMA data for AES
>> diff --git a/arch/arm/mach-at91/include/mach/at_hdmac.h b/include/linux/platform_data/dma-atmel.h
>> similarity index 100%
>> rename from arch/arm/mach-at91/include/mach/at_hdmac.h
>> rename to include/linux/platform_data/dma-atmel.h
>> -- 
>> 1.7.10
>>
> 
> 


-- 
Nicolas Ferre
