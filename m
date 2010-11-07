Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab0KGRQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 12:16:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46143 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0KGRQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:16:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OkEkP/mSONtsdkibofMFBMhkbB8EBz1GOVq1lykWs35ntz4jL1SSDi4Ol0LwS2jM/R
         Diu0Hpxaey16wGpGh6CTYbr/Fyb2JPVz3Fbf4Xg5y9IDk/7CIM7skyQ68GbNbpnFUaAt
         fjOHIt4H5C8xmDdJhUfKK3XY5nofUJ+BzTW9s=
MIME-Version: 1.0
In-Reply-To: <20101107170005.GC1759@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<20101107170005.GC1759@n2100.arm.linux.org.uk>
Date: Sun, 7 Nov 2010 20:16:21 +0300
Message-ID: <AANLkTim30K0PQsoQDyPyzoVgxBQnO3KFe8hHnNJOhBSN@mail.gmail.com>
Subject: Re: [PATCH 1/6 v2] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> A couple of other points - sorry, should've been in the last mail.
>
> On Sun, Nov 07, 2010 at 07:28:52PM +0300, Alexey Charkov wrote:
>> diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
>> new file mode 100644
>> index 0000000..e0c6268
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/Kconfig
>> @@ -0,0 +1,65 @@
>> +if ARCH_VT8500
>> +
>> +config VTWM_VERSION_VT8500
>> +     bool
>> +     default n
>
> n is the default anyway, so specifying this is redundant.
>

Great, I'll drop it then.

>> +void __init bv07_init(void)
>> +{
>> +#ifdef CONFIG_FB_VT8500
>> +     void __iomem *gpio_mux_reg = ioremap(wmt_current_regs->gpio
>> +                                          + 0x200, 4);
>
> ioremap() is generally regarded as a function which can fail, and therefore
> needs its return value checked.  There seems to be multiple instances of
> this through this patch.
>

Is it OK to simply skip the code that uses the relevant pointer if
ioremap fails (possibly issuing an error via printk)? The problem is
that these are void functions, so I can't just return -ENODEV on
failure.
