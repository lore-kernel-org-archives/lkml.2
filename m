Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0HaGCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:02:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38785 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0HaGCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AkIzMb3EG/I2kncaKBnFiyXd4Cb40OhxAR+gDHacHrYANgauiZ3IqXkG/ulbgvDN0/
         5DG8oYtysfOaR0aZkING0ylTd5TRz33HIgG7u8s7MExpdbXCn8g0n7s6poo70OlE2vk9
         08czxbHSUWtsGstoi9/Z+R84d1aPqtYzRATgM=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=GZ1p3MzibOEzhyD=Mv6d2x2nRh93D4bmtgcYE@mail.gmail.com>
References: <1282813649-8332-1-git-send-email-mark.brown314@gmail.com>
	<1282813649-8332-2-git-send-email-mark.brown314@gmail.com>
	<AANLkTi=GZ1p3MzibOEzhyD=Mv6d2x2nRh93D4bmtgcYE@mail.gmail.com>
Date: Tue, 31 Aug 2010 02:02:08 -0400
Message-ID: <AANLkTimwU17YS5Yk7y+13Dj9Ww4oPG0g4v5ZbvOVuQV6@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: pxa168: fix corrected reset vector
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 1:48 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Thu, Aug 26, 2010 at 5:07 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
>> ---
>>  arch/arm/mach-mmp/include/mach/system.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-mmp/include/mach/system.h b/arch/arm/mach-mmp/include/mach/system.h
>> index 4f5b0e0..926e9c0 100644
>> --- a/arch/arm/mach-mmp/include/mach/system.h
>> +++ b/arch/arm/mach-mmp/include/mach/system.h
>> @@ -16,6 +16,6 @@ static inline void arch_idle(void)
>>
>>  static inline void arch_reset(char mode, const char *cmd)
>>  {
>> -       cpu_reset(0);
>> +       cpu_reset(0xffff0000);
>
> Not sure if this correct. But normally reset jump happens after we turn
> off the MMU and so on. Ain't the BootROM starts from 0 ?
>
>>  }
>>  #endif /* __ASM_MACH_SYSTEM_H */
>> --
>> 1.7.0.4
>>
>>
>

Eric, the boot-rom for pxa168 starts at 0xffff_0000. I am pretty sure
about that! If you set the reset vector to 0x0 it will crash during
reboot. I will send you xdb snapshots if you need me to.

Regards,
-- Mark
