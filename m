Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0FSRxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 13:53:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37002 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0FSRxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RaKB5AW0UUI5JTTjUXgLGKL2f6qbH4TS4SV+WTyN5EjZI0R0PlxnSJuYZGOPV2UYL4
         2i//l8oVy+6lw693zJzoow5rOfGF4H1i9cInokCDiDqmdlrwSXRLkO2qwqveMmPei9mp
         sIW9pRm0QthNltJ8fzJyP3qI8hUN6YYnqPWkQ=
MIME-Version: 1.0
In-Reply-To: <4C1D0189.6050803@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
	<201006191243.39793.marek.vasut@gmail.com>
	<4C1CC08E.5050009@metafoo.de>
	<201006191604.25329.marek.vasut@gmail.com>
	<4C1D0189.6050803@metafoo.de>
Date: Sat, 19 Jun 2010 19:53:38 +0200
X-Google-Sender-Auth: _f17mx37Pm0Xnf9P4usEA5Go9gM
Message-ID: <AANLkTim1AEoIAFKq4so7GP6zwxUPJLslWjeIKgNOP8yA@mail.gmail.com>
Subject: Re: [PATCH v2 15/26] RTC: Add JZ4740 RTC driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Marek Vasut <marek.vasut@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Wan ZongShun <mcuos.com@gmail.com>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 19:42, Lars-Peter Clausen <lars@metafoo.de> wrote:
> Marek Vasut wrote:
>> Dne So 19. června 2010 15:05:18 Lars-Peter Clausen napsal(a):
>>> Marek Vasut wrote:
>>>> Dne So 19. června 2010 07:08:20 Lars-Peter Clausen napsal(a):
>>>>> This patch adds support for the RTC unit on JZ4740 SoCs.

>>>>> +static void jz4740_rtc_ctrl_set_bits(struct jz4740_rtc *rtc, uint32_t
>>>>> mask, +    uint32_t val)
>>>>> +{
>>>>> +  unsigned long flags;
>>>>> +  uint32_t ctrl;
>>>>> +
>>>>> +  spin_lock_irqsave(&rtc->lock, flags);
>>>>>
>>>> Can't we use local_irq_save()/local_irq_restore() ?
>>>>
>>> Why would that be preferable? In the non-debug, non-rt case this will
>>> expand to local_irq_{save,restore} anyway, but you'll lose the semantics
>>> of an lock.
>>>
>>
>> I believe on SMP systems, local_irq_save will give you finer locking
>> granularity.
>>
> Hm, not sure about that. But this is on a non SMP system anyway.

If the driver will ever be used on a SMP system, local_irq_save() will
not protect
against concurrent accesses on different CPUs. So it's better to use
spin_lock_irqsave().

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
