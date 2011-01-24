Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1AXMOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:14:34 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39344 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1AXMOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:14:33 -0500
Date: Mon, 24 Jan 2011 13:14:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bernhard Walle <walle@corscience.de>
Cc: ben-linux@fluff.org, ddaney@caviumnetworks.com, ralf@linux-mips.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: octeon: Make the timeout 1*HZ instead of 1 jiffy
Message-ID: <20110124131405.4583a7af@endymion.delvare>
In-Reply-To: <1295870741-19970-1-git-send-email-walle@corscience.de>
References: <1295870741-19970-1-git-send-email-walle@corscience.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernhard,

On Mon, 24 Jan 2011 13:05:41 +0100, Bernhard Walle wrote:
> Since the timeout in the struct i2c_adapter use jiffies as unit and a
> timeout should be independent of CONFIG_HZ and most drivers that specify
> a timeout here use just HZ, change the i2c-octeon driver to use 1*HZ
> (which is a second), too.
> 
> Signed-off-by: Bernhard Walle <walle@corscience.de>
> ---
>  drivers/i2c/busses/i2c-octeon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
> index 0fe1102..537a4ee 100644
> --- a/drivers/i2c/busses/i2c-octeon.c
> +++ b/drivers/i2c/busses/i2c-octeon.c
> @@ -460,7 +460,7 @@ static struct i2c_adapter octeon_i2c_ops = {
>  	.owner = THIS_MODULE,
>  	.name = "OCTEON adapter",
>  	.algo = &octeon_i2c_algo,
> -	.timeout = 2,
> +	.timeout = HZ,
>  };
>  
>  /**

This is a large timeout value, much larger than any value the
i2c-octeon driver was using today for any possible value of HZ.
Wouldn't it make more sense to set it to HZ / 50, which is 2 for HZ =
100, leaving the setting unchanged for this common case at least?

-- 
Jean Delvare
