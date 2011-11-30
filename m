Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1K3Ngd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:36:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1K3Ngc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:36:32 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2 v3] pinctrl: make a copy of pinmux map
Date: Wed, 30 Nov 2011 13:30:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1322656361-6463-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322656361-6463-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301330.09043.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:aE5uaNUuBqTQP40tFz0AaDk+vPiEWvS30+5ed1ay3Lx
 rZhf6Md10CVnVk3VnMvoqpk1uvHp5mLJaaTaZo7Mlmt6Pje/DJ
 /tWihQtZcQPh6hclbPe9CCpX8nej6xhmCES2jUJ4iH/6xDudnb
 k7+hW4YxIfursy9I8EJR1CDLHpR90I90sttuz7EZZfeAQtUJnw
 NXiQrU00Uu9Lb5f7leiG8UddDNSwRaEpifUvMWi8t/TDtoz0jF
 ZY5RTXJX6JwFQfmUqOl1NCwHzTRg26zJeRpaBMWyee50ANNMHL
 wwS+s+YYkzzw4gj3MKVypvfie1gZ6nAptYkMc9r4ZQStokgpdA
 iRhwsJ88OpKKG7xd0KVVpoO8ZH9nSYkEQpp40df+1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This makes a deep copy of the pinmux function map instead of
> keeping the copy supplied from the platform around. This makes
> it possible to tag the platforms map with __initdata as is also
> done as part of this patch.
> 
> Rationale: a certain target platform (PXA) has numerous
> pinmux maps, many of which will be lying around unused after
> boot in a multi-platform binary. Instead, deep-copy the one
> we're going to use and tag them all __initdata so they go away
> after boot.
> 
> Suggested-by: Arnd Bergmann <arnd.bergmann@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Arnd Bergmann <arnd@linaro.org>

> @@ -348,32 +351,48 @@ EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
>  int __init pinmux_register_mappings(struct pinmux_map const *maps,
>  				    unsigned num_maps)
>  {
> +	int ret = 0;
>  	int i;
>  
> -	if (pinmux_maps != NULL) {
> +	if (pinmux_maps_num != 0) {
>  		pr_err("pinmux mappings already registered, you can only "
>  		       "register one set of maps\n");
>  		return -EINVAL;
>  	}

A trick pointed out by Rusty Russell in a recent blog post [1] is to
not initialize the return value initially, but always set it only
in the error path so that the compiler can warn you when you ever
forget setting it in one path.

	Arnd

[1] http://rusty.ozlabs.org/?p=232
