Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2KZJak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:30:40 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:56907 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2KZJaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:30:39 -0500
Date: Mon, 26 Nov 2012 11:30:34 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Axel Lin <axel.lin@ingics.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] pinctrl: mvebu: make pdma clock on dove mandatory
Message-ID: <20121126093033.GH12673@sapphire.tkos.co.il>
References: <1353921525-25163-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1353921634-25210-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353921634-25210-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Mon, Nov 26, 2012 at 10:20:34AM +0100, Sebastian Hesselbarth wrote:

[...]

> diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c 
> b/drivers/pinctrl/mvebu/pinctrl-dove.c
> index 40c9c3e..90f257d 100644
> --- a/drivers/pinctrl/mvebu/pinctrl-dove.c
> +++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
> @@ -595,8 +595,11 @@ static int __devinit dove_pinctrl_probe(struct platform_device *pdev)
>  	 * grab clk to make sure it is ticking.
>  	 */
>  	clk = devm_clk_get(&pdev->dev, NULL);
> -	if (!IS_ERR(clk))
> -		clk_prepare_enable(clk);
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "Unable to get pdma clock");
> +		return -ENODEV;

Why not propagate the error up using PTR_RET(clk)?

baruch

> +	}
> +	clk_prepare_enable(clk);
>  
>  	return mvebu_pinctrl_probe(pdev);
>  }

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
