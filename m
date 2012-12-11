Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2LKNCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:02:17 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36255 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2LKNCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:02:16 -0500
Message-ID: <50C72E75.8030706@mvista.com>
Date: Tue, 11 Dec 2012 17:00:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers/pinctrl/pinctrl-at91.c: convert kfree to devm_kfree
References: <1355223525-19165-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1355223525-19165-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-12-2012 14:58, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> The function at91_dt_node_to_map is ultimately called by the function
> pinctrl_get, which is an exported function.  Since it is possible that this
> function is not called from within a probe function, for safety, the kfree
> is converted to a devm_kfree, to both free the data and remove it from the
> device in a failure situation.

> A newline is added in the call to devm_kfree to avoid exceeding the 80

    devm_kzalloc() you mean?

> character limit.

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
>   drivers/pinctrl/pinctrl-at91.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index c5e7571..0da8a5f 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -255,7 +255,8 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
>   	}
>
>   	map_num += grp->npins;
> -	new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num, GFP_KERNEL);
> +	new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num,
> +			       GFP_KERNEL);

WBR, Sergei


