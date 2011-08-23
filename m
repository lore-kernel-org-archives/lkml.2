Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1HWQpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:45:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48366 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1HWQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:45:33 -0400
Date: Tue, 23 Aug 2011 17:45:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jiandong Zheng <jdzheng@broadcom.com>
Cc: "Maxin B. John" <maxin.john@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: mach-bcmring: fix build error in core.c
Message-ID: <20110823164514.GG3895@n2100.arm.linux.org.uk>
References: <20110823111824.GA2806@maxin> <4E53D84F.5060604@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E53D84F.5060604@broadcom.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 09:41:51AM -0700, Jiandong Zheng wrote:
> On 8/23/2011 4:18 AM, Maxin B. John wrote:
>> CC      arch/arm/mach-bcmring/core.o
>> arch/arm/mach-bcmring/core.c: In function 'bcmring_init_timer':
>> arch/arm/mach-bcmring/core.c:238: error: implicit declaration of
>> function 'sp804_clockevents_register'
>> make[1]: *** [arch/arm/mach-bcmring/core.o] Error 1
>> make: *** [arch/arm/mach-bcmring] Error 2
>>
>> Please let me know your comments on this fix:
>>
>> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
>> ---
>> diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
>> index 43eadbc..430da12 100644
>> --- a/arch/arm/mach-bcmring/core.c
>> +++ b/arch/arm/mach-bcmring/core.c
>> @@ -235,7 +235,7 @@ void __init bcmring_init_timer(void)
>>   	 */
>>   	bcmring_clocksource_init();
>>
>> -	sp804_clockevents_register(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
>> +	sp804_clockevents_init(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
>>   }
>>
>>   struct sys_timer bcmring_timer = {
>>
> Signed-off-by: Jiandong Zheng <jdzheng@broadcom.com>

Don't you mean acked-by or reviewed-by?

> The same changes was in my comments on May 17 to Russell's serial  
> patches to convert to sp804 clk dev, but seems it got lost.

Unfortunately... sorry about that.
