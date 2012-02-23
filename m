Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab2BWI4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:56:52 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:18545 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2BWI4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:56:51 -0500
Message-ID: <4F45FF46.3060702@atmel.com>
Date: Thu, 23 Feb 2012 09:56:38 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v2 09/19] ARM: at91: make sdram/ddr register base soc
 independent
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <0acddc0a57ea5a198f662bf37047ebe95e3eb695.1329903206.git.nicolas.ferre@atmel.com> <4F456D1E.8070807@gmail.com>
In-Reply-To: <4F456D1E.8070807@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 11:33 PM, Ryan Mallon :
> On 22/02/12 20:39, Nicolas Ferre wrote:
> 
>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>
>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> <snip>
> 
>> +void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
>> +{
>> +	if (id > 1) {
>> +		pr_warn("%s: id > 2\n", __func__);
>> +		return;
>> +	}
>> +	at91_ramc_base[id] = ioremap(addr, size);
>> +	if (!at91_ramc_base[id])
>> +		pr_warn("Impossible to ioremap ramc.%d 0x%x\n", id, addr);
>> +}
> 
> 
> If this fails then you will oops if you call either at91_ramc_read or
> at91_ramc_write since they don't check if at91_ramc_base[id] is a valid
> pointer. Either this function should panic, like the other at91_ioremap
> functions, or the at91_ramc_read/write functions should check for a
> valid pointer.

Yes, as you pointed out, it is done in a not-related following patch.
I will bring the code here.


> Nitpick: The id check should probably also be BUG() or WARN() since it
> indicates a bug in the core AT91 code. pr_warn is likely to missed and
> not reported by users. Since the value is int, the check should be:
> 
>   if (id < 0 || id > 1)
> 
> Obviously the chance of this error happening are slim, but if you are
> going to check and warn for it, it should be done properly :-).

Yes, I agree and modify it at the very moment.

thanks, best regards,
-- 
Nicolas Ferre
