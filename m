Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1IMNMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:12:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40966 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1IMNMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
Date: Tue, 13 Sep 2011 22:12:04 +0900
Message-ID: <CAC5umyjWx7ZvT+F_XhOZt_utr=mS-0p5tDpJ1ioWNiDAJLNXwQ@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: core: add random fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Per Forlin <per.forlin@stericsson.com>:

> +#ifdef KERNEL
> +/*
> + * Internal function. Pass the boot param fail_mmc_request to
> + * the setup fault injection attributes routine.
> + */
> +static int __init setup_fail_mmc_request(char *str)
> +{
> +       return setup_fault_attr(&fail_mmc_request, str);
> +}
> +__setup("fail_mmc_request=", setup_fail_mmc_request);
> +#endif /* KERNEL */

You attempt to enable __setup() only when mmc_core is built into
the kernel.  Does it really work? I cannot find any drivers using
"KERNEL" macro.

You can use module_param_cb() instead of __setup() without #ifdef KERNEL.
When mmc_core is built into the kernel, you can specify the parameter
with "mmc_core.fail_mmc_request=..."

Sorry for pointing that out too late.
