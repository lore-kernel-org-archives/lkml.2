Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030716Ab2CVJJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:09:15 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:42031 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964968Ab2CVJJL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:09:11 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] regulator: gpio-regulator: Set the smallest voltage/current in the specified range
Date: Thu, 22 Mar 2012 10:08:58 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1332396484.3842.2.camel@phoenix>
In-Reply-To: <1332396484.3842.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203221009.05902.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 22. März 2012, 07:08:04 schrieb Axel Lin:
> Do not assume the gpio regulator states map is sorted in any order.
> This patch ensures we always set the smallest voltage/current that falls
> within the specified range.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

nice addition, thanks

Acked-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  drivers/regulator/gpio-regulator.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/gpio-regulator.c
> b/drivers/regulator/gpio-regulator.c index 42e1cb1..b728b36 100644
> --- a/drivers/regulator/gpio-regulator.c
> +++ b/drivers/regulator/gpio-regulator.c
> @@ -105,15 +105,15 @@ static int gpio_regulator_set_value(struct
> regulator_dev *dev, int min, int max)
>  {
>  	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
> -	int ptr, target, state;
> +	int ptr, target, state, best_val = INT_MAX;
> 
> -	target = -1;
>  	for (ptr = 0; ptr < data->nr_states; ptr++)
> -		if (data->states[ptr].value >= min &&
> +		if (data->states[ptr].value < best_val &&
> +		    data->states[ptr].value >= min &&
>  		    data->states[ptr].value <= max)
>  			target = data->states[ptr].gpios;
> 
> -	if (target < 0)
> +	if (best_val == INT_MAX)
>  		return -EINVAL;
> 
>  	for (ptr = 0; ptr < data->nr_gpios; ptr++) {

