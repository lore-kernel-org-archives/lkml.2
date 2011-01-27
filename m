Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1A0OrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:47:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57260 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1A0OrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:47:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Vrms3eRhbSkFP/F+RVKYJjg4y15sMHd7uqsNAX6z4WeRfW1RJTwdlzRDWJL0z1MCyi
         56c3331PoGDRVq3J3aoJ+xB9peDvC5N51QCLAgYVaIswu3CFYtVqT6chGUNIv/Cxd9BN
         lD8kbH8SWUl9TfYZoELOfKkeOGlJ2M5X673V8=
MIME-Version: 1.0
In-Reply-To: <1296029447.2013.8.camel@sven>
References: <20110124101701.GE16202@n2100.arm.linux.org.uk>
 <1295864750-1238-1-git-send-email-s.neumann@raumfeld.com> <AANLkTinrxiHx6jX9jFzVzjq5FH-W=MLoDThAtRq2a1zZ@mail.gmail.com>
 <1296029447.2013.8.camel@sven>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 27 Jan 2011 22:46:54 +0800
Message-ID: <AANLkTimUg=y49H6THn5s7f7v418W68fhAsMLZGnDqabF@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: fix suspend on PXA3XX
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 4:10 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> On Wed, 2011-01-26 at 05:06 +0800, Eric Miao wrote:
>> How about this instead?
>>
>> diff --git a/arch/arm/mach-pxa/pm.c b/arch/arm/mach-pxa/pm.c
>> index 978e1b2..1807c9a 100644
>> --- a/arch/arm/mach-pxa/pm.c
>> +++ b/arch/arm/mach-pxa/pm.c
>> @@ -33,7 +33,7 @@ int pxa_pm_enter(suspend_state_t state)
>>  #endif
>>
>>       /* skip registers saving for standby */
>> -     if (state != PM_SUSPEND_STANDBY) {
>> +     if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->save) {
>>               pxa_cpu_pm_fns->save(sleep_save);
>>               /* before sleeping, calculate and save a checksum */
>>               for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
>> @@ -44,7 +44,7 @@ int pxa_pm_enter(suspend_state_t state)
>>       pxa_cpu_pm_fns->enter(state);
>>       cpu_init();
>>
>> -     if (state != PM_SUSPEND_STANDBY) {
>> +     if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->restore) {
>>               /* after sleeping, validate the checksum */
>>               for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
>>                       checksum += sleep_save[i];
>>
>
> Not sure if that will work as well. With this change the code is
> skipping more than just the calls to pxa_cpu_pm_fns->save() and
> pxa_cpu_pm_fns->restore(). In particular it doesn't call
> pxa_cpu_pm_fns->enter(state).
>

Nah, that ->enable() is called if the checksum is incorrect. Please compare
with the original code?

>
> Thanks,
> Sven
>
>
>
