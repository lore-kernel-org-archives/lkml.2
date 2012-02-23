Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab2BWIik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:38:40 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:35011 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2BWIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:38:36 -0500
Message-ID: <4F45FAF7.3080409@atmel.com>
Date: Thu, 23 Feb 2012 09:38:15 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v2 11/19] ARM: at91/PMC: make register base soc independent
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <bdea371b518c7b6d04ae1cfacacca2f75b191984.1329903206.git.nicolas.ferre@atmel.com> <4F457128.6060407@gmail.com>
In-Reply-To: <4F457128.6060407@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 11:50 PM, Ryan Mallon :
> On 22/02/12 20:39, Nicolas Ferre wrote:
> 
>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>
>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Reviewed-by: Ryan Mallon <rmallon@gmail.com>
>> ---
> 
> <snip>
> 
>> -	seq_printf(s, "SCSR = %8x\n", scsr = at91_sys_read(AT91_PMC_SCSR));
>> -	seq_printf(s, "PCSR = %8x\n", pcsr = at91_sys_read(AT91_PMC_PCSR));
>> -	seq_printf(s, "MOR  = %8x\n", at91_sys_read(AT91_CKGR_MOR));
>> -	seq_printf(s, "MCFR = %8x\n", at91_sys_read(AT91_CKGR_MCFR));
>> -	seq_printf(s, "PLLA = %8x\n", at91_sys_read(AT91_CKGR_PLLAR));
>> +	seq_printf(s, "SCSR = %8x\n", scsr = at91_pmc_read(AT91_PMC_SCSR));
>> +	seq_printf(s, "PCSR = %8x\n", pcsr = at91_pmc_read(AT91_PMC_PCSR));
> 
> 
> I realise the original code is wrong, so doesn't need to be fixed in
> this patch, but can we please move the assignments out of the seq_printf
> calls.

Well, I would not say "wrong". But ugly, for sure. I queue a patch to
correct this just before this one.

> <snip>
> 
>>  void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
>> @@ -208,7 +207,7 @@ void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
>>  	}
>>  	at91_ramc_base[id] = ioremap(addr, size);
>>  	if (!at91_ramc_base[id])
>> -		pr_warn("Impossible to ioremap ramc.%d 0x%x\n", id, addr);
>> +		panic("Impossible to ioremap ramc.%d 0x%x\n", id, addr);
> 
> 
> This is in the wrong patch, and should be folded into the correct patch.

Absolutely, this belongs to the previous patch. Thanks for highlighting
this.

Best regards,
-- 
Nicolas Ferre
