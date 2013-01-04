Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3ADUCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:02:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49849 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3ADUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:02:36 -0500
Message-ID: <50E73559.60508@wwwdotorg.org>
Date: Fri, 04 Jan 2013 13:02:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl/nomadik: Add "ste,config" property
References: <1357316010-677-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1357316010-677-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 09:13 AM, Linus Walleij wrote:
> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> 
> The "ste,config" property will contain the pin config node.
> It will be easier to define a pin configuration and use it by
> reference without duplicating lines tedious.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

> diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt

> -- ste,input : <0/1/2/3>
> +- ste,config: Handle of pin configuration node (ste,config = <&in_pu>)
> +
> +- ste,input : <0/1/2>

The changes to ste,input and ste,sleep-output look like some unrelated
change.

I guess the idea of ste,input is quite neat, but ...

>  Example board file extract:
>  
> +	in_pu: input_pull_up {
> +		ste,input = <1>;
> +	};

... these nodes shouldn't be placed at the top-level of the device tree;
housing them inside the pin controller node itself makes much more sense
since the pin controller binding is able/allowed to define what goes
inside the pin controller node, but shouldn't influence the top-level of
the device tree.

> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c

> +	np_config = of_parse_phandle(np, "ste,config", 0);
> +	if (np_config) {
> +		for (i = 0; i < ARRAY_SIZE(nmk_cfg_params); i++) {
> +			unsigned long cfg = 0;
> +			int val;

Is it worth making ste,config optional, so that config properties can be
placed either into the node directly, or into a node referenced by
ste,config? That might make doing one-off unusual configurations easier
- no need to create a separate node that's only used once. Still, if
that's unlikely on your HW, it's probably no big deal.
