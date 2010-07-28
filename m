Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0G1WcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:32:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab0G1WcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:32:00 -0400
Date: Wed, 28 Jul 2010 15:31:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>, InKi Dae <inki.dae@samsung.com>
Subject: Re: [PATCH 2/2] s6e63m0: fix section mismatch
Message-Id: <20100728153116.634dc64b.akpm@linux-foundation.org>
In-Reply-To: <1280286456.19065.4.camel@mola>
References: <1280286456.19065.4.camel@mola>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 11:07:36 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Eliminate section mismatch warning by marking s6e63m0_probe() as __devinit.
> 

Please aways quote the error messages or warnings when fixing build
errors or warnings.  It helps with the review quite a lot.

> 
> diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
> index b27ccf9..1757379 100644
> --- a/drivers/video/backlight/s6e63m0.c
> +++ b/drivers/video/backlight/s6e63m0.c
> @@ -732,7 +732,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_table(struct device *dev,
>  static DEVICE_ATTR(gamma_table, 0644,
>  		s6e63m0_sysfs_show_gamma_table, NULL);
>  
> -static int __init s6e63m0_probe(struct spi_device *spi)
> +static int __devinit s6e63m0_probe(struct spi_device *spi)
>  {
>  	int ret = 0;
>  	struct s6e63m0 *lcd = NULL;

Many drivers/video/backlight/*.c drivers use __devinit for the
platform_driver.probe handler.  Quite a lot use nothing (ie: .text). 
Some still use __init.  About half of them use __devexit_p for .remove
and half don't.  It looks like it all needs a bit of loving care.

