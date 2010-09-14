Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0INXX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:23:27 -0400
Received: from trinity.fluff.org ([89.16.178.74]:53780 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab0INXX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:23:26 -0400
Date: Wed, 15 Sep 2010 00:23:13 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 05/25] drivers/i2c: Use static const char arrays
Message-ID: <20100914232313.GC7494@trinity.fluff.org>
References: <cover.1284406638.git.joe@perches.com> <b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 12:47:43PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/i2c/busses/i2c-stu300.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
> index 495be45..2f7c09c 100644
> --- a/drivers/i2c/busses/i2c-stu300.c
> +++ b/drivers/i2c/busses/i2c-stu300.c
> @@ -871,7 +871,7 @@ stu300_probe(struct platform_device *pdev)
>  	struct resource *res;
>  	int bus_nr;
>  	int ret = 0;
> -	char clk_name[] = "I2C0";
> +	char clk_name[sizeof("I2Cx")];
>  
>  	dev = kzalloc(sizeof(struct stu300_dev), GFP_KERNEL);
>  	if (!dev) {
> @@ -881,7 +881,7 @@ stu300_probe(struct platform_device *pdev)
>  	}
>  
>  	bus_nr = pdev->id;
> -	clk_name[3] += (char)bus_nr;
> +	sprintf(clk_name, "I2C%c", '0' + bus_nr);
>  	dev->clk = clk_get(&pdev->dev, clk_name);
>  	if (IS_ERR(dev->clk)) {
>  		ret = PTR_ERR(dev->clk);

personally, i'd prefer to see snprintf() used, to ensure that this sort
of thing never goes wrong if people decde to change the string. It is
a pitty there's no good way of temporarily allocating data an having it
freed in C.

As such, apologies to Russell about the abuse of the clk_get() call, but
let's not fix that just now.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

