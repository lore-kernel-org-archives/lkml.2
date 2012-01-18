Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2ARGSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 01:18:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab2ARGSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 01:18:20 -0500
Date: Wed, 18 Jan 2012 06:18:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: N?meth M?rton <nm127@freemail.hu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH] use void __iomem * pointers for ioread32()/iowrite32()
Message-ID: <20120118061815.GY23916@ZenIV.linux.org.uk>
References: <4F12AB38.5040009@freemail.hu>
 <CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com>
 <4F153221.3080509@freemail.hu>
 <CACRpkdZEZ6X20mtP5reAq2UaG5f0DS_hMBN9L8LpV1O0tBkb-w@mail.gmail.com>
 <CACxGe6t2xtm-T43cBcbaqTrnPST9+R8E7dhq1rJnC+4P2__JRQ@mail.gmail.com>
 <4F16611E.3050303@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F16611E.3050303@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 07:05:18AM +0100, N?meth M?rton wrote:
> From: M?rton N?meth <nm127@freemail.hu>
> 
> The address pointer of ioread32()/iowrite32() functions are
> of type "void __iomem *". Use matching variable type.

> diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
> index 68fa55e..84b7f28 100644
> --- a/drivers/gpio/gpio-pch.c
> +++ b/drivers/gpio/gpio-pch.c
> @@ -231,7 +231,7 @@ static void pch_gpio_setup(struct pch_gpio *chip)
>  static int pch_irq_type(struct irq_data *d, unsigned int type)
>  {
>  	u32 im;
> -	u32 __iomem *im_reg;
> +	void __iomem *im_reg;

NAK.  Please, learn what "function with pointer to (possibly qualified) void"
means.  It's fairly basic C, so any (post-K&R) textbook would do.
