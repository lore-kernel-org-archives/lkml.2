Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2LJXYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:24:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49362 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2LJXXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:23:48 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 3/4] pwm: core: Export of_pwm_request() so client drivers can also use it
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
In-Reply-To: <1355133637-2784-4-git-send-email-peter.ujfalusi@ti.com>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com> <1355133637-2784-4-git-send-email-peter.ujfalusi@ti.com>
Date: Mon, 10 Dec 2012 23:22:49 +0000
Message-Id: <20121210232249.7356F3E081F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 11:00:36 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Allow client driver to use of_pwm_request() to get the pwm they need. This
> is needed for drivers which handle more than one pwm separately, like
> leds-pwm driver which have:
> 
> pwmleds {
> 	compatible = "pwm-leds";
> 	kpad {
> 		label = "omap4::keypad";
> 		pwms = <&twl_pwm 0 7812500>;
> 		max-brightness = <127>;
> 	};
> 
> 	charging {
> 		label = "omap4:green:chrg";
> 		pwms = <&twl_pwmled 0 7812500>;
> 		max-brightness = <255>;
> 	};
> };
> 
> in the dts files.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/pwm/core.c  | 2 +-
>  include/linux/pwm.h | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index 903138b..3a7ebcc 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -486,7 +486,7 @@ static struct pwm_chip *of_node_to_pwmchip(struct device_node *np)
>   * becomes mandatory for devices that look up the PWM device via the con_id
>   * parameter.
>   */
> -static struct pwm_device *of_pwm_request(struct device_node *np,
> +struct pwm_device *of_pwm_request(struct device_node *np,
>  					 const char *con_id)
>  {
>  	struct pwm_device *pwm = NULL;
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 6d661f3..d70ffe3 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -175,6 +175,7 @@ struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
>  		const struct of_phandle_args *args);
>  
>  struct pwm_device *pwm_get(struct device *dev, const char *consumer);
> +struct pwm_device *of_pwm_request(struct device_node *np, const char *con_id);
>  void pwm_put(struct pwm_device *pwm);
>  
>  struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer);
> @@ -213,6 +214,12 @@ static inline struct pwm_device *pwm_get(struct device *dev,
>  	return ERR_PTR(-ENODEV);
>  }
>  
> +static inline struct pwm_device *of_pwm_request(struct device_node *np,
> +						const char *con_id)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +
>  static inline void pwm_put(struct pwm_device *pwm)
>  {
>  }
> -- 
> 1.8.0
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
