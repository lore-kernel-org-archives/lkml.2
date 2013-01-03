Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3ACJKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:10:21 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:49817 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab3ACJKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:10:18 -0500
Message-ID: <50E54AF4.4030405@compulab.co.il>
Date: Thu, 03 Jan 2013 11:10:12 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121218 Thunderbird/10.0.11
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: R Sricharan <r.sricharan@ti.com>, ahemaily@gmail.com, tony@atomide.com,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] arm :omap :DMA: fix a bug on reserving the omap SDMA
 channels
References: <1356813800-4705-1-git-send-email-ahemaily@gmail.com> <50E5330B.2060007@ti.com> <50E5438A.1050902@ti.com>
In-Reply-To: <50E5438A.1050902@ti.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/13 10:38, Santosh Shilimkar wrote:
> On Thursday 03 January 2013 12:58 PM, R Sricharan wrote:
>> Hi,
>>
>> On Sunday 30 December 2012 02:13 AM, ahemaily@gmail.com wrote:
>>> From: ahemaily <ahemaily@gmail.com>
>>>
>>> The variable  dma_lch_count  used for comparison
>>> (omap_dma_reserve_channels <= dma_lch_count)
>>> before it initialized to the value from omap_dma_dev_attr : d->lch_count.
>>>
>>> I change the place of dma_lch_count initialization to be before the
>>> comparison.
>>>
>>> Signed-off-by: Abdelrahman Hemaily <ahemaily@gmail.com>
>>> ---
>>>   arch/arm/plat-omap/dma.c |    4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
>>> index c76ed8b..cb3e321 100644
>>> --- a/arch/arm/plat-omap/dma.c
>>> +++ b/arch/arm/plat-omap/dma.c
>>> @@ -2014,12 +2014,12 @@ static int __devinit
>>> omap_system_dma_probe(struct platform_device *pdev)
>>>
>>>       d            = p->dma_attr;
>>>       errata            = p->errata;
>>> -
>>> +    dma_lch_count           = d->lch_count;
>>> +
>>>       if ((d->dev_caps & RESERVE_CHANNEL) && omap_dma_reserve_channels
>>>               && (omap_dma_reserve_channels <= dma_lch_count))
>>>           d->lch_count    = omap_dma_reserve_channels;
>>>
>>> -    dma_lch_count        = d->lch_count;
>>     By removing this line, you are effectively not assigning
>>     d->lch_count after reserving. So the patch should only change
>>     dma_lch_count in the above "if statement" to d->lch_count
>>
> You are right. I missed it in last review. Below should be enough.
> 
> diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> index 37a488a..555ff7b 100644
> --- a/arch/arm/plat-omap/dma.c
> +++ b/arch/arm/plat-omap/dma.c
> @@ -2019,7 +2019,7 @@ static int __devinit omap_system_dma_probe(struct platform_device *pdev)
>      errata            = p->errata;
> 
>      if ((d->dev_caps & RESERVE_CHANNEL) && omap_dma_reserve_channels
> -            && (omap_dma_reserve_channels <= dma_lch_count))
> +            && (omap_dma_reserve_channels <= d->lch_coun))

It looks like the 't' is missing...                     ^^^^^

>          d->lch_count    = omap_dma_reserve_channels;
> 
>      dma_lch_count        = d->lch_count;
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Regards,
Igor.
