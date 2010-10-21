Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0JUITq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:19:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61047 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0JUITo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D1egfKMuKKn6P/kfknIKfPkPriOlzjIcCUuDzSwlgqt5ygNv5N8DQf4Eu9h8Afn/N6
         St1jfzsiiFKWW2uGrVnMnkqA/L60OsTRhw36GH/gY2DvcY/KIriFkbN+FCOVapO50YXS
         liFlLdcQMAZBL6tJ+R7Xk2gBrbhBnYFBmWxAQ=
MIME-Version: 1.0
In-Reply-To: <20101021075401.GC22100@n2100.arm.linux.org.uk>
References: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com>
	<AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com>
	<4CBF8BDB.7090907@gmail.com>
	<20101021075401.GC22100@n2100.arm.linux.org.uk>
Date: Thu, 21 Oct 2010 10:19:42 +0200
Message-ID: <AANLkTikjByC1_BQvPv=Stkdph1cV=a8CwcqrcBv6u0+p@mail.gmail.com>
Subject: Re: [RFC] Removal of dead code from arch/arm/*
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Thu, Oct 21, 2010 at 02:39:55AM +0200, N.P.S. wrote:
>> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
>> index 38c261f..fd30b75 100644
>> --- a/arch/arm/kernel/time.c
>> +++ b/arch/arm/kernel/time.c
>> @@ -37,13 +37,9 @@
>>   */
>>  struct sys_timer *system_timer;
>>
>> -#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
>> +#if defined(CONFIG_RTC_DRV_CMOS)
>>  /* this needs a better home */
>>  DEFINE_SPINLOCK(rtc_lock);
>> -
>> -#ifdef CONFIG_RTC_DRV_CMOS_MODULE
>> -EXPORT_SYMBOL(rtc_lock);
>> -#endif
>>  #endif    /* pc-style 'CMOS' RTC support */
>>
>>  /* change this if you have some constant time drift */
>
> This is wrong, and will break the build if rtc-cmos is built as a module.
>

Indeed, sorry, I checked use of RTC_DRV_CMOS_MODULE and I should check
RTC_DRV_CMOS

I tried to cross compile allyesconfig to test my changes and I hit this
  CC      drivers/gpio/janz-ttl.o
drivers/gpio/janz-ttl.c: In function ‘ttl_set_value’:
drivers/gpio/janz-ttl.c:107: error: implicit declaration of function
‘iowrite16be’

-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
