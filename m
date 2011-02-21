Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1BUHCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:02:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28466 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1BUHCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:02:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NN80BocCOTzx8oADEko92/qf/fntlYC1RZfbD9mInyZH3jk/j11Zz651bIoSQm1nuS
         ScXpvmqES3+QEOiqMFEg==
MIME-Version: 1.0
In-Reply-To: <AANLkTinWQRmKhorYHQ2rHCArHN89go-2mYVAe5UUZVOV@mail.gmail.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<AANLkTinWQRmKhorYHQ2rHCArHN89go-2mYVAe5UUZVOV@mail.gmail.com>
Date: Sun, 20 Feb 2011 23:02:06 -0800
X-Google-Sender-Auth: QNk5YQFLS-PJhGoiBJJHoz8MHG0
Message-ID: <AANLkTikcqYfC6crtwSUYvSH7dSOQZD8K+fCyOSCVMpnL@mail.gmail.com>
Subject: Re: [PATCH v2 12/21] ARM: tegra: clock: Add shared bus clock type
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, sboyd@codeaurora.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 8:15 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
>> Some clocks may have multiple downstream users that need to request a
>> higher clock rate.  Shared bus clocks provide a unique shared_bus_user
>> clock to each user.  The frequency of the bus is set to the highest
>> enabled shared_bus_user clock, with a minimum value set by the
>> shared bus.  Drivers can use clk_enable and clk_disable to enable
>> or disable their requirement, and clk_set_rate to set the minimum rate.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> [...]
>> diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
>> index a1c86d8..dd53af3 100644
>> --- a/arch/arm/mach-tegra/tegra2_clocks.c
>> +++ b/arch/arm/mach-tegra/tegra2_clocks.c
> [...]
>
>> +       c->u.shared_bus_user.rate = c->parent->max_rate;
>> +       c->state = OFF;
>> +#ifdef CONFIG_DEBUG_FS
>> +       c->set = 1;
>> +#endif
>> +
>> +       spin_lock_irqsave(&c->parent->spinlock, flags);
>
>
> A later patch in the series removes the ifdef. Might as well remove it
> here. Also, should be c->set = true, which that patch also does. :)
At this point in the series c->set is not defined for
CONFIG_DEBUG_FS=n, so dropping the #ifdef would break bisection, and I
left the = 1 in for consistency.

> With that fixed:
>
> Acked-by: Olof Johansson <olof@lixom.net>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
