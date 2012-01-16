Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2APOW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:22:27 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49311 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753921Ab2APOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:22:26 -0500
Message-ID: <4F143296.8090802@ti.com>
Date: Mon, 16 Jan 2012 19:52:14 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: ext-denis.2.karpov@nokia.com
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mmc : omap_hsmmc : Save and restore the sysc across
 reset
References: <1326713587-26463-1-git-send-email-shubhrajyoti@ti.com> <5E7C2FE2AE03DF4CA6AC500032BF8F77C1762A@008-AM1MPN1-072.mgdnok.nokia.com>
In-Reply-To: <5E7C2FE2AE03DF4CA6AC500032BF8F77C1762A@008-AM1MPN1-072.mgdnok.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 January 2012 06:41 PM, ext-denis.2.karpov@nokia.com wrote:
> ext Shubhrajyoti D wrote on 2012-01-16:
>> The commit 11dd62:[omap_hsmmc: context save/restore support]
>>
>> does a reset and restores AUTOIDLE settings.
>> This patch saves the register does a reset and restores
>> the same configuration.
> ...
>>  	if (pdata->get_context_loss_count) {
>> @@ -700,6 +700,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host
>> *host)
>>  		&& time_before(jiffies, timeout))
>>  		;
>> +	sysc = OMAP_HSMMC_READ(host->base, SYSCONFIG);
>>  	/* Do software reset */
>>  	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, SOFTRESET);
>>  	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
>> @@ -707,8 +708,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host
>> *host)
>>  		&& time_before(jiffies, timeout))
>>  		;
>> -	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
>> -			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
>> +	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, sysc);
> The meaning of the code is to restore the register context after it was lost during transition into low power consumption state. SW reset is needed to bring all the registers in a consistent state before reconfiguring some of them. 
Agreed thanks.
> Saving and restoring the SYSCONFIG register across SW reset is not needed. 
>
> Also re-configuring AUTOIDLE feature is not necessary since SYSCONFIG reset value has is 1 already, according to TRM. I guess it was done to make things more explicit.
However in addition to autoidle there are other bits in the register
like the sidle mode , enable wakeup which will get not get overwritten now.

Do you agree?
> Denis

