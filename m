Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1INKFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 06:05:47 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41594 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1INKFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 06:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <1315990017-16912-3-git-send-email-per.forlin@linaro.org>
References: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
	<1315990017-16912-3-git-send-email-per.forlin@linaro.org>
Date: Wed, 14 Sep 2011 19:05:44 +0900
Message-ID: <CAC5umygS+viGcG2wAi=7vbjmiQB1jVgwKNAeZxDxB4WMC-teGg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mmc: add module param to set fault injection attributes
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/14 Per Forlin <per.forlin@linaro.org>:

> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +
> +static DECLARE_FAULT_ATTR(fail_default_attr);
> +static char *fail_request;

This is not used anymore and ...

> +static int fail_mmc_request_param_set(const char *val,
> +                                     const struct kernel_param *kp)
> +{
> +       setup_fault_attr(&fail_default_attr, (char *) val);
> +       return 0;
> +}
> +
> +static const struct kernel_param_ops fail_mmc_request_param_ops = {
> +       .set = fail_mmc_request_param_set
> +};
> +module_param_cb(fail_request, &fail_mmc_request_param_ops,
> +               &fail_request, 0);

you can change this third parameter to NULL.

> +
> +#endif /* CONFIG_FAIL_MMC_REQUEST */
