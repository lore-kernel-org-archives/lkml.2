Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab2HJPVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 11:21:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53346 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab2HJPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 11:20:56 -0400
Message-ID: <502526D5.3080002@wwwdotorg.org>
Date: Fri, 10 Aug 2012 09:20:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Jiri Kosina <trivial@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: pinctrl core: remove extraneous code lines
References: <1344610429-12607-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1344610429-12607-1-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 08:53 AM, Richard Genoud wrote:
> In function pinctrl_get_locked, pointer p is returned on error, and also
> return on no_error.
> So, we just return it with no error test.
> 
> It's pretty the same in function pinctrl_lookup_state_locked: state is
> returned in every case, so we drop the error test and just return state.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/pinctrl/core.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index fb7f3be..7365d46 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -657,11 +657,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev)
>  	if (p != NULL)
>  		return ERR_PTR(-EBUSY);
>  
> -	p = create_pinctrl(dev);
> -	if (IS_ERR(p))
> -		return p;
> -
> -	return p;
> +	return create_pinctrl(dev);
>  }

This makes sense.

>  /**
> @@ -738,10 +734,8 @@ static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
>  			dev_dbg(p->dev, "using pinctrl dummy state (%s)\n",
>  				name);
>  			state = create_state(p, name);
> -			if (IS_ERR(state))
> -				return state;
>  		} else {
> -			return ERR_PTR(-ENODEV);
> +			state = ERR_PTR(-ENODEV);
>  		}
>  	}

Personally I find the code much clearer as it is, but the result of this
patch still looks correct.

