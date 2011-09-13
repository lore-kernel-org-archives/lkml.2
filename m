Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1IMOUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:20:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47588 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1IMOUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:20:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5umyjWx7ZvT+F_XhOZt_utr=mS-0p5tDpJ1ioWNiDAJLNXwQ@mail.gmail.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
	<CAC5umyjWx7ZvT+F_XhOZt_utr=mS-0p5tDpJ1ioWNiDAJLNXwQ@mail.gmail.com>
Date: Tue, 13 Sep 2011 16:19:59 +0200
Message-ID: <CAJ0pr18dn3CtBsXk9MG3Zn9zSwAiNoxB3b-62aMO3+8H+kUX3A@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: core: add random fault injection
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2011 15:12, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2011/8/19 Per Forlin <per.forlin@stericsson.com>:
>
>> +#ifdef KERNEL
>> +/*
>> + * Internal function. Pass the boot param fail_mmc_request to
>> + * the setup fault injection attributes routine.
>> + */
>> +static int __init setup_fail_mmc_request(char *str)
>> +{
>> +       return setup_fault_attr(&fail_mmc_request, str);
>> +}
>> +__setup("fail_mmc_request=", setup_fail_mmc_request);
>> +#endif /* KERNEL */
>
> You attempt to enable __setup() only when mmc_core is built into
> the kernel.  Does it really work? I cannot find any drivers using
> "KERNEL" macro.
>
Your right it doesn't work. I think I change from ifndef MODULE to
ifdef KERNEL at one point.
It should be "ifndef MODULE"

> You can use module_param_cb() instead of __setup() without #ifdef KERNEL.
> When mmc_core is built into the kernel, you can specify the parameter
> with "mmc_core.fail_mmc_request=..."
>
Thanks, this is the proper way to do it.

> Sorry for pointing that out too late.
>
I think this patch is queued for 3.2 so there should be time to fix it still.

Thanks again,
Per
