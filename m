Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0CaGHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:07:52 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:35318 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0CaGHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OkIC9w+3CO9JV+6OFpI/o+SQO7DGxLw5bTvHNmwIF6Go6SClkI/zk3gjiPmFKo+NSf
         NV6V397XvxuFWwXZzxtXnkxIFmJBUClJzLVcGj8BXHG5Fm9C7IB4MydjbD3AmEsKnec/
         xLv6eVHCdLe/GywEU4UCDSq5YnoBozeZAvsbE=
MIME-Version: 1.0
In-Reply-To: <004701caab40$68b576e0$544ff780@am.dhcp.ti.com>
References: <35697.192.168.10.89.1265898023.squirrel@dbdmail.itg.ti.com>
	 <004701caab40$68b576e0$544ff780@am.dhcp.ti.com>
Date: Wed, 31 Mar 2010 11:37:47 +0530
Message-ID: <x2q7f9d1ffb1003302307nb8e91be0o55da59c3375f1720@mail.gmail.com>
Subject: [PATCH-V2] OMAP: Fix for bus width which improves SD card's 
	peformance.
From: kishore kadiyala <kishorek.kadiyala@gmail.com>
To: Madhusudhan <madhu.cr@ti.com>
Cc: tony@atomide.com, svenkatr@ti.com, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, jarkko.lavinen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves low speeds for SD cards.
OMAP-MMC controller's can support maximum bus width of '8'.
when bus width is mentioned as "8" in controller data,the SD
stack will check whether bus width is "4" and if not it will
set bus width to "1" and there by degrading performance.
This patch fixes the issue and improves the performance of
SD cards.

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>

---
In V2 : Appended Signed-off by Venkat and Ack by Madhu

 Here are my experiment numbers, on a Class 6 SDHC card:
 Read peformance is increased by 220%
 Write Performance is increased by 52%

 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 83f0aff..8c97c22 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2092,7 +2092,7 @@ static int __init omap_hsmmc_probe(struct
                   MMC_CAP_WAIT_WHILE_BUSY;

      if (mmc_slot(host).wires >= 8)
-               mmc->caps |= MMC_CAP_8_BIT_DATA;
+               mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
      else if (mmc_slot(host).wires >= 4)
              mmc->caps |= MMC_CAP_4_BIT_DATA;

--
1.6.3.3


On Thu, Feb 11, 2010 at 11:04 PM, Madhusudhan <madhu.cr@ti.com> wrote:
>
>
>> -----Original Message-----
>> From: kishore kadiyala [mailto:kishore.kadiyala@ti.com]
>> Sent: Thursday, February 11, 2010 8:20 AM
>> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: jarkko.lavinen@nokia.com; madhu.cr@ti.com
>> Subject: [PATCH] OMAP: Fix for bus width which improves SD card's
>> peformance.
>>
>> This patch improves low speeds for SD cards.
>> OMAP-MMC controller's can support maximum bus width of '8'.
>> when bus width is mentioned as "8" in controller data,the SD
>> stack will check whether bus width is "4" and if not it will
>> set bus width to "1" and there by degrading peformance.
>> This patch fixes the issue and improves the performance of
>> SD cards.
>>
>> Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
>
> ACK
>
> Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
>
>> ---
>>  Here are my experiment numbers, on a Class 6 SDHC card:
>>  Read peformance is increased by 220%
>>  Write Performance is increased by 52%
>>
>>  drivers/mmc/host/omap_hsmmc.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
>> index 83f0aff..8c97c22 100644
>> --- a/drivers/mmc/host/omap_hsmmc.c
>> +++ b/drivers/mmc/host/omap_hsmmc.c
>> @@ -2092,7 +2092,7 @@ static int __init omap_hsmmc_probe(struct
>> platform_device
>> *pdev)
>>                    MMC_CAP_WAIT_WHILE_BUSY;
>>
>>       if (mmc_slot(host).wires >= 8)
>> -             mmc->caps |= MMC_CAP_8_BIT_DATA;
>> +             mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
>>       else if (mmc_slot(host).wires >= 4)
>>               mmc->caps |= MMC_CAP_4_BIT_DATA;
>>
>> --
>> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
