Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab1JZVGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:06:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48066 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1JZVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:06:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=jCEGnqSJiMFibm2WWWjhcXC2l7OIiuKJIUQcwTVnI2IuGgZrn4UmPyd9KpI7RWfOg
	dQaNrvbCdbdqax28+0uww==
Date: Wed, 26 Oct 2011 14:06:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Marek Belisko <marek.belisko@open-nandra.com>
cc: swarren@nvidia.com, linus.walleij@linaro.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pinmux: Unify pin type from signed to unsigned.
In-Reply-To: <1319662641-28416-2-git-send-email-marek.belisko@open-nandra.com>
Message-ID: <alpine.DEB.2.00.1110261405400.23111@chino.kir.corp.google.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com> <1319662641-28416-2-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Marek Belisko wrote:

> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
> index 3605e94..34c33c7 100644
> --- a/include/linux/pinctrl/pinctrl.h
> +++ b/include/linux/pinctrl/pinctrl.h
> @@ -112,7 +112,7 @@ struct pinctrl_desc {
>  extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
>  				struct device *dev, void *driver_data);
>  extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
> -extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
> +extern bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin);
>  extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
>  				struct pinctrl_gpio_range *range);
>  extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
> @@ -123,7 +123,7 @@ extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
>  
>  
>  /* Sufficiently stupid default function when pinctrl is not in use */
> -static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
> +static inline bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin)
>  {
>  	return pin >= 0;
>  }


So this would just become return true, right?
