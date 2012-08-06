Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2HFOKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:10:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23339 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2HFOKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:10:34 -0400
Date: Mon, 6 Aug 2012 17:05:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers/mfd: drop frees of devm allocated data
Message-ID: <20120806140515.GM4352@mwanda>
References: <1344099049-15212-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344099049-15212-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 06:50:45PM +0200, Julia Lawall wrote:
> diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
> index cd0bf52..2bd090e 100644
> --- a/drivers/mfd/88pm80x.c
> +++ b/drivers/mfd/88pm80x.c
> @@ -45,17 +45,14 @@ int __devinit pm80x_init(struct i2c_client *client,
>  
>  	map = devm_regmap_init_i2c(client, &pm80x_regmap_config);
>  	if (IS_ERR(map)) {
> -		ret = PTR_ERR(map);
>  		dev_err(&client->dev, "Failed to allocate register map: %d\n",
>  			ret);
                        ^^^
The ret = PTR_ERR(map); is still needed for the error message.

> -		goto err_regmap_init;
> +		return PTR_ERR(map);
>  	}

regards,
dan carpenter

