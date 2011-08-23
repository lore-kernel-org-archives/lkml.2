Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1HWRAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:00:13 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4559 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab1HWRAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:00:10 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E53DC8A.3000701@broadcom.com>
Date: Tue, 23 Aug 2011 09:59:54 -0700
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624
 Thunderbird/5.0
MIME-Version: 1.0
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
cc: "Maxin B. John" <maxin.john@gmail.com>,
        "Scott Branden" <sbranden@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: mach-bcmring: fix build error in core.c
References: <20110823111824.GA2806@maxin>
 <4E53D84F.5060604@broadcom.com>
 <20110823164514.GG3895@n2100.arm.linux.org.uk>
In-Reply-To: <20110823164514.GG3895@n2100.arm.linux.org.uk>
X-WSS-ID: 624D027C4R01442934-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2011 9:45 AM, Russell King - ARM Linux wrote:
> On Tue, Aug 23, 2011 at 09:41:51AM -0700, Jiandong Zheng wrote:
>> On 8/23/2011 4:18 AM, Maxin B. John wrote:
>>> CC      arch/arm/mach-bcmring/core.o
>>> arch/arm/mach-bcmring/core.c: In function 'bcmring_init_timer':
>>> arch/arm/mach-bcmring/core.c:238: error: implicit declaration of
>>> function 'sp804_clockevents_register'
>>> make[1]: *** [arch/arm/mach-bcmring/core.o] Error 1
>>> make: *** [arch/arm/mach-bcmring] Error 2
>>>
>>> Please let me know your comments on this fix:
>>>
>>> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
>>> ---
>>> diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
>>> index 43eadbc..430da12 100644
>>> --- a/arch/arm/mach-bcmring/core.c
>>> +++ b/arch/arm/mach-bcmring/core.c
>>> @@ -235,7 +235,7 @@ void __init bcmring_init_timer(void)
>>>    	 */
>>>    	bcmring_clocksource_init();
>>>
>>> -	sp804_clockevents_register(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
>>> +	sp804_clockevents_init(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
>>>    }
>>>
>>>    struct sys_timer bcmring_timer = {
>>>
>> Signed-off-by: Jiandong Zheng<jdzheng@broadcom.com>
>
> Don't you mean acked-by or reviewed-by?
I meant I created the same patch and have tested it. But if acked-by or 
reviewed-by is less confusing, I am OK with it.

>
>> The same changes was in my comments on May 17 to Russell's serial
>> patches to convert to sp804 clk dev, but seems it got lost.
>
> Unfortunately... sorry about that.
>
To avoid this, should I submit every patch to patch system after 
reviewed through maillist?

