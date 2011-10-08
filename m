Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1JHDWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 23:22:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41195 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1JHDWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 23:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1soZw-eB5WxY5YWjfd=_q5w8wSu09mRTcmOEN_SDq9Zuz7eg@mail.gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <1317499438-14058-18-git-send-email-arnd@arndb.de> <CAN1soZw-eB5WxY5YWjfd=_q5w8wSu09mRTcmOEN_SDq9Zuz7eg@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 11:21:41 +0800
Message-ID: <CAMPhdO_L-g4vSj3fC-1ckqnHGAPhWOy6Hm4VL5iUbZbbdjRkNQ@mail.gmail.com>
Subject: Re: [PATCH 17/26] ARM: pxa: pxa95x is incompatible with earlier pxa
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 10:57 AM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> We cannot support ARMv5 and ARMv7 based boards in a single kernel,
>> so introduce a new option in mach-pxa to select between the two.
>>
>> The PJ4 (ARMv7) based boards are now only visible when
>> CONFIG_ARCH_PXA_V7 is set, the other boards are only visible
>> when it's not set.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  arch/arm/mach-pxa/Kconfig |   31 ++++++++++++++++++++++---------
>>  1 files changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
>> index cd19309..bb310d0 100644
>> --- a/arch/arm/mach-pxa/Kconfig
>> +++ b/arch/arm/mach-pxa/Kconfig
>> @@ -2,6 +2,27 @@ if ARCH_PXA
>>
>>  menu "Intel PXA2xx/PXA3xx Implementations"
>>
>> +config ARCH_PXA_V7
>> +       bool "ARMv7 (PXA95x) based systems"
>> +
>> +if ARCH_PXA_V7
>> +comment "Marvell Dev Platforms (sorted by hardware release time)"
>> +config MACH_TAVOREVB3
>> +       bool "PXA95x Development Platform (aka TavorEVB III)"
>> +       select CPU_PXA955
>> +
>> +config MACH_SAARB
>> +       bool "PXA955 Handheld Platform (aka SAARB)"
>> +       select CPU_PXA955
>> +endif
>> +
>> +config PXA_V7_MACH_AUTO
>> +       def_bool y
>> +       depends on ARCH_PXA_V7
>> +       depends on !MACH_SAARB
>> +       select MACH_TAVOREVB3
>> +
> Could we avoid to use PXA_V7_MACH_AUTO? I think the better way is
> defining a new ARCH (ARCH_PXA95X or something else), and sharing the
> code in arch/arm/mach-pxa. I think that it's easy to implement.
>
> How about you, Russell & Eric?

Haojian,

The patch here is to fix the issue of V5 boards and V7 boards being
built together yet it's not supported (there will be building errors).
And this could be easily spotted with auto/random configurations.

I generally think the patch is fine before we'll allow building of both
v5 and v7 code together (which Nico will be definitely interested in)


>
>> +if !ARCH_PXA_V7
>>  comment "Intel/Marvell Dev Platforms (sorted by hardware release time)"
>>
>>  config ARCH_LUBBOCK
>> @@ -41,19 +62,11 @@ config MACH_TAVOREVB
>>        select PXA3xx
>>        select CPU_PXA930
>>
>> -config MACH_TAVOREVB3
>> -       bool "PXA95x Development Platform (aka TavorEVB III)"
>> -       select CPU_PXA950
>> -
>>  config MACH_SAAR
>>        bool "PXA930 Handheld Platform (aka SAAR)"
>>        select PXA3xx
>>        select CPU_PXA930
>>
>> -config MACH_SAARB
>> -       bool "PXA955 Handheld Platform (aka SAARB)"
>> -       select CPU_PXA955
>> -
>>  comment "Third Party Dev Platforms (sorted by vendor name)"
>>
>>  config ARCH_PXA_IDP
>> @@ -598,7 +611,7 @@ config MACH_ZIPIT2
>>        bool "Zipit Z2 Handheld"
>>        select PXA27x
>>        select HAVE_PWM
>> -
>> +endif
>>  endmenu
>>
>>  config PXA25x
>> --
>> 1.7.5.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
