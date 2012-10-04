Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2JDBeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:34:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35719 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2JDBeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:34:08 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-ef-506ce78521bf
Message-id: <506CE784.8090105@samsung.com>
Date: Thu, 04 Oct 2012 10:33:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] extcon: max77693: Use max77693_update_reg for rmw
 operations
References: <1349193584.14338.3.camel@phoenix>
In-reply-to: <1349193584.14338.3.camel@phoenix>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd3W5zkBBu+nqlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MSRe+Mhbs5ql4cIWlgbGRq4uRk0NCwESi98tmZghbTOLCvfVs
	XYxcHEICixglDl49xQjhdDFJXDn0FqyKV0BLouNzEzuIzSKgKrH37n2wOBtQfP+LG0DdHByi
	AhESv/o5IMoFJX5MvscCYosIKEmsun8ZzGYWKJRY1H2VCcQWFgiW+DDhCxuILSSgJ9HduYkR
	xOYU0Jf42H+aHaJeXWLSvEXMELa8xOY1b5knMArMQrJiFpKyWUjKFjAyr2IUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIDr9n0jsYVzVYHGIU4GBU4uG1mJQTIMSaWFZcmXuIUYKDWUmE13gr
	UIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvs0dKgJBAemJJanZqakFqEUyWiYNTqoGRy7V+9qHE
	1WxO7yVv1Du+KVoel/zk3JRNF57fipu5Zu/bl6Zpegr7XjSJTvxqWy9b+Ytrxf75y1f0e7XM
	P868cdfctWaZ2R/yr5eLn/uieX2Xp+TVSRNZFzKFS9gnRk7dIZqmVhDJ/uJ4Zeq3g6q6bZZn
	Fi3/c7E4/6Ujd3d569+7K9q5Hi8NVWIpzkg01GIuKk4EAMgxxH87AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 12:59 AM, Axel Lin wrote:

> This simplifies the code.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/extcon/extcon-max77693.c |   18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index e21387e..e0ed622 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -239,25 +239,19 @@ const char *max77693_extcon_cable[] = {
>  static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
>  		enum max77693_muic_adc_debounce_time time)
>  {
> -	int ret = 0;
> -	u8 ctrl3;
> +	int ret;
>  
>  	switch (time) {
>  	case ADC_DEBOUNCE_TIME_5MS:
>  	case ADC_DEBOUNCE_TIME_10MS:
>  	case ADC_DEBOUNCE_TIME_25MS:
>  	case ADC_DEBOUNCE_TIME_38_62MS:
> -		ret = max77693_read_reg(info->max77693->regmap_muic,
> -				MAX77693_MUIC_REG_CTRL3, &ctrl3);
> -		ctrl3 &= ~CONTROL3_ADCDBSET_MASK;
> -		ctrl3 |= (time << CONTROL3_ADCDBSET_SHIFT);
> -
> -		ret = max77693_write_reg(info->max77693->regmap_muic,
> -				MAX77693_MUIC_REG_CTRL3, ctrl3);
> -		if (ret) {
> +		ret = max77693_update_reg(info->max77693->regmap_muic,
> +					  MAX77693_MUIC_REG_CTRL3,
> +					  time << CONTROL3_ADCDBSET_SHIFT,
> +					  CONTROL3_ADCDBSET_MASK);
> +		if (ret)
>  			dev_err(info->dev, "failed to set ADC debounce time\n");
> -			ret = -EINVAL;
> -		}
>  		break;
>  	default:
>  		dev_err(info->dev, "invalid ADC debounce time\n");


Applied, thanks.

Cheers,
Chanwoo Choi
