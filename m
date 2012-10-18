Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2JRIov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:44:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43476 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2JRIoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:44:10 -0400
Message-ID: <507FC149.9030505@ahsoftware.de>
Date: Thu, 18 Oct 2012 10:43:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jonathan Austin <jonathan.austin@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 4/9] ARM: export default read_current_timer
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-5-git-send-email-arnd@arndb.de> <50744586.6010806@arm.com> <20121009160647.GG4625@n2100.arm.linux.org.uk>
In-Reply-To: <20121009160647.GG4625@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.10.2012 18:06, schrieb Russell King - ARM Linux:
> On Tue, Oct 09, 2012 at 04:40:54PM +0100, Jonathan Austin wrote:
>> Hi Arnd,
>>
>> On 09/10/12 16:22, Arnd Bergmann wrote:
>>> diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
>>> index 9d0a300..0dc5385 100644
>>> --- a/arch/arm/lib/delay.c
>>> +++ b/arch/arm/lib/delay.c
>>> @@ -45,6 +45,7 @@ int read_current_timer(unsigned long *timer_val)
>>>   	*timer_val = delay_timer->read_current_timer();
>>>   	return 0;
>>>   }
>>> +EXPORT_SYMBOL_GPL(read_current_timer);
>>
>>
>> Perhaps this fits better in armksyms.c? That way it lives with
>> arm_delay_ops and friends.
>
> It's always much better to put things next to where they're defined
> rather than spreading them around.
>
> armksyms.c is a reminant of the 1.x days of doing things... but still
> remains to allow what are mostly assembly symbols to be exported.

I needed that to build udlfb as a module.

For the 3.6 stable kernels this has to be done in
arch/arm/kernel/arch_timer.c (along with an #include <linux/export.h>)

So I'm not sure if an Cc: <stable@vger.kernel.org> can be used here, but 
a patch should be submitted for inclusion into the 3.6 stable series too.

Regards,

Alexander

