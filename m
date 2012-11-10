Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2KJDis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 22:38:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2KJDio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 22:38:44 -0500
Message-ID: <509DCC5E.7020804@gmail.com>
Date: Sat, 10 Nov 2012 14:39:10 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 04/11] ARM: set arch_gettimeoffset directly
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org> <1352408516-21988-6-git-send-email-swarren@wwwdotorg.org> <509C3AE7.7030703@gmail.com> <509D708E.6080703@wwwdotorg.org>
In-Reply-To: <509D708E.6080703@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/12 08:07, Stephen Warren wrote:

> On 11/08/2012 04:06 PM, Ryan Mallon wrote:
>> On 09/11/12 08:01, Stephen Warren wrote:
>>> remove ARM's struct sys_timer .offset function pointer, and instead
>>> directly set the arch_gettimeoffset function pointer when the timer
>>> driver is initialized. This requires multiplying all function results
>>> by 1000, since the removed arm_gettimeoffset() did this. Also,
>>> s/unsigned long/u32/ just to make the function prototypes exactly
>>> match that of arch_gettimeoffset.
> 
>>> +static u32 ep93xx_gettimeoffset(void)
>>> +{
>>> +	int offset;
>>> +
>>> +	offset = __raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time;
>>> +
>>> +	/* Calculate (1000000 / 983040) * offset.  */
>>
>> This comment is now incorrect, it should say:
>>
>> 	/* Calculate (1000000000 / 983040) * offset */
>>
>> or perhaps to better explain what is being done:
>>
>> 	/*
>> 	 * Timer 4 is based on a 983.04 kHz reference clock,
>> 	 * so dividing by 983040 gives a milli-second value.
>> 	 * Refactor the calculation to avoid overflow.
>> 	 */
>>
>>> +	return (offset + (53 * offset / 3072)) * 1000;
> 
> Thanks. I expanded on that slightly and went for:
> 
> 	/*
> 	 * Timer 4 is based on a 983.04 kHz reference clock,
> 	 * so dividing by 983040 gives the fraction of a second,
> 	 * so dividing by 0.983040 converts to uS.
> 	 * Refactor the calculation to avoid overflow.
> 	 * Finally, multiply by 1000 to give nS.
> 	 */
> 


Looks good, thanks.

~Ryan

