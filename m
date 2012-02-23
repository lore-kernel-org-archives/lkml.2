Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2BWD7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:59:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60409 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2BWD7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:59:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.190.226 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F45B985.1000204@gmail.com>
Date: Thu, 23 Feb 2012 14:59:01 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v2 02/19] ARM: at91/at91x40: remove use of at91_sys_read/write
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1329903206.git.nicolas.ferre@atmel.com> <4F456AAF.3090809@gmail.com> <20120223032503.GA20176@game.jcrosoft.org>
In-Reply-To: <20120223032503.GA20176@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/12 14:25, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 09:22 Thu 23 Feb     , Ryan Mallon wrote:
>> On 22/02/12 20:39, Nicolas Ferre wrote:
>>
>>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>>
>>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> ---
>>>  arch/arm/mach-at91/at91x40.c              |    2 +-
>>>  arch/arm/mach-at91/at91x40_time.c         |   28 +++++++++++++++++-----------
>>>  arch/arm/mach-at91/include/mach/at91x40.h |   18 +++++++++---------
>>>  3 files changed, 27 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
>>> index 0154b7f..5400a1d 100644
>>> --- a/arch/arm/mach-at91/at91x40.c
>>> +++ b/arch/arm/mach-at91/at91x40.c
>>> @@ -44,7 +44,7 @@ static void at91x40_idle(void)
>>>  	 * Disable the processor clock.  The processor will be automatically
>>>  	 * re-enabled by an interrupt or by a reset.
>>>  	 */
>>> -	at91_sys_write(AT91_PS_CR, AT91_PS_CR_CPU);
>>> +	__raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);
>>
>>
>> This doesn't seem to be equivalent, at91_sys_write does:
>>
>>   void __iomem *addr = (void __iomem *)AT91_VA_BASE_SYS;
>>   __raw_writel(value, addr + reg_offset);
>>
>> and this patch doesn't redefine AT91_PS_CR. Was it broken before this
>> patch? What am I missing?
> this is right
> #define AT91_PS_CR      (AT91_PS + 0)   /* PS Control register */


That doesn't answer my question.

The old, at91_sys_write, version was writing to (using __raw_writel):

  AT91_VA_BASE_SYS + AT91_PS_CR

The new version is writing, also using __raw_writel, to:

  AT91_PS_CR

The value of AT91_PS_CR is not changed in this patch. Assuming that
AT91_VA_BASE_SYS for at91x40 (which at a quick glance it is not), then
the old and the new version of the code are not writing to the same
address.

Was it previously incorrect, or is it incorrect now?

~Ryan




