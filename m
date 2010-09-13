Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0IMT47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:56:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48495 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab0IMT46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:56:58 -0400
Date: Mon, 13 Sep 2010 20:56:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/25] drivers/i2c: Use static const char arrays
Message-ID: <20100913195644.GC3819@n2100.arm.linux.org.uk>
References: <cover.1284406638.git.joe@perches.com> <b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

If people would implement the clk API correctly (matching by struct device
rather than giving every clock a name and trying to use the const char *
as the sole matching token), stuff like this would not be necessary.
The second argument to clk_get() is supposed to be a _consumer_ name
(iow, something to determine which clock for the struct device you want)
rather than a producer name.
