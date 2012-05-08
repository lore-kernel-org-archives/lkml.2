Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2EHRAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:00:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2EHRAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:00:17 -0400
Message-ID: <4FA9511C.5060007@linaro.org>
Date: Wed, 09 May 2012 01:00:12 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: da9052: fix of_match_node() arguments
References: <1336258968-6423-1-git-send-email-olof@lixom.net>
In-Reply-To: <1336258968-6423-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年05月06日 07:02), Olof Johansson wrote:
> The driver calls of_match_node() with the arguments swapped.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/mfd/da9052-i2c.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
> index d8abdb3..8410065 100644
> --- a/drivers/mfd/da9052-i2c.c
> +++ b/drivers/mfd/da9052-i2c.c
> @@ -104,7 +104,7 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
>  		struct device_node *np = client->dev.of_node;
>  		const struct of_device_id *deviceid;
>  
> -		deviceid = of_match_node(np, dialog_dt_ids);
> +		deviceid = of_match_node(dialog_dt_ids, np);
>  		id = (const struct i2c_device_id *)deviceid->data;
>  	}
>  #endif

Tested-by: Ying-Chun Liu <paul.liu@linaro.org>


Sorry. I don't know how my code works and tested previously.
But your patch is definited correct.
