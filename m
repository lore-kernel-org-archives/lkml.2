Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030538Ab2GKXzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:55:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51945 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485Ab2GKXzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:55:54 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-63-4ffe1288c426
Message-id: <4FFE1287.90403@samsung.com>
Date: Thu, 12 Jul 2012 08:55:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Extcon: Arizona: unlock on an error in arizona_micdet()
References: <20120711063602.GG11812@elgon.mountain>
In-reply-to: <20120711063602.GG11812@elgon.mountain>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jQd0OoX/+Bo2dIhZbb0lbXN41h82B
	yePzJrkAxigum5TUnMyy1CJ9uwSujOsPvjIX7GKraDxxkLGBcTFrFyMHh4SAicS+C/xdjJxA
	ppjEhXvr2UBsIYHpjBLH/0R2MXIB2S8ZJR4dmQ6W4BXQkFhy5zkriM0ioCrxfPUBMJtNQEti
	/4sbbCAzRQUiJH71c0CUC0r8mHyPBcQWEdCRuNz5gx1kJrPAAkaJSxdesYPUCwv4SEyd7wCx
	11ji49IFYCM5gU67cXkPWC8zUO/+1mlsELa8xOY1b5knMArMQrJiFpKyWUjKFjAyr2IUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIDsJn0jsYVzVYHGIU4GBU4uH98eyvvxBrYllxZe4hRgkO
	ZiUR3oMvgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5Tby/+gsJpCeWpGanphakFsFkmTg4pRoY
	k2ySC5eFzr7hoHb1jAw3T7rC60VTQm+7znR9IaC9p1QnecN3uTVH9FOeNjIfnV95VuNsgaYM
	R972j3mS9TKauq5njheX3tspq9O9cGqqQKvB8Rc7rpnPv+u2IOnff22ujzX3Wpf2nUr3C9uq
	vb6s9pJbZ3Xy9WUGTBY7WRbPCWWd8UchkFtYiaU4I9FQi7moOBEAogtKLz4CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 07/11/2012 03:36 PM, Dan Carpenter wrote:

> Smatch complains about this.  I don't have a way to test this, but it
> does look like we should unlock on error here.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index b068bc9..4782884 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -154,6 +154,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
>  	ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
>  	if (ret != 0) {
>  		dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
> +		mutex_unlock(&info->lock);
>  		return IRQ_NONE;
>  	}
>  

This patch is right.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
