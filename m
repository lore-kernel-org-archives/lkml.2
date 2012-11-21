Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2KUNml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:42:41 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57517 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2KUNmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:42:40 -0500
Message-ID: <50ACDA4C.2030900@gmail.com>
Date: Wed, 21 Nov 2012 07:42:36 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Bongkyu Kim <bongkyu.kim@lge.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/i2c: check status property for i2c client
References: <1353488270-14723-1-git-send-email-bongkyu.kim@lge.com>
In-Reply-To: <1353488270-14723-1-git-send-email-bongkyu.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 02:57 AM, Bongkyu Kim wrote:
> Because of_i2c_register_devices() do not check status property,
> all i2c clients are registered.
> 
> This patch add checking status property for i2c client.
> After this patch, if status property is absent or "okay" or "ok",
> i2c client will be registered.
> 
> Signed-off-by: Bongkyu Kim <bongkyu.kim@lge.com>

Applied.

> ---
>  drivers/of/of_i2c.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
> index 3550f3b..2552fc5 100644
> --- a/drivers/of/of_i2c.c
> +++ b/drivers/of/of_i2c.c
> @@ -37,6 +37,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  
>  		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
>  
> +		if (!of_device_is_available(node))
> +			continue;
> +
>  		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
>  			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
>  				node->full_name);
> 
