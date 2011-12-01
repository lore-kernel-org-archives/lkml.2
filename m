Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1LAIis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:38:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12505 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab1LAIir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:38:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Dec 2011 00:38:46 -0800
Message-ID: <4ED73CFA.7050308@nvidia.com>
Date: Thu, 1 Dec 2011 17:38:18 +0900
From: Jinyoung Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/4] mfd: aat2870-core: Use gpio_request_one
References: <1322704074.11560.3.camel@phoenix>
In-Reply-To: <1322704074.11560.3.camel@phoenix>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jin Park <jinyoungp@nvidia.com>

On 2011-12-01 오전 10:47, Axel Lin wrote:
> Use gpio_request_one() instead of multiple gpiolib calls.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/mfd/aat2870-core.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
> index 02c4201..7620617 100644
> --- a/drivers/mfd/aat2870-core.c
> +++ b/drivers/mfd/aat2870-core.c
> @@ -407,13 +407,13 @@ static int aat2870_i2c_probe(struct i2c_client *client,
>   		aat2870->init(aat2870);
>
>   	if (aat2870->en_pin>= 0) {
> -		ret = gpio_request(aat2870->en_pin, "aat2870-en");
> +		ret = gpio_request_one(aat2870->en_pin, GPIOF_OUT_INIT_HIGH,
> +				       "aat2870-en");
>   		if (ret<  0) {
>   			dev_err(&client->dev,
>   				"Failed to request GPIO %d\n", aat2870->en_pin);
>   			goto out_kfree;
>   		}
> -		gpio_direction_output(aat2870->en_pin, 1);
>   	}
>
>   	aat2870_enable(aat2870);
