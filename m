Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1A3Xhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 18:37:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:56909 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1A3Xhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 18:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,402,1291622400"; 
   d="scan'208";a="381898797"
Date: Mon, 31 Jan 2011 00:37:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] mfd: tps6586x: Invert GPIO and subdevices
 initialization
Message-ID: <20110130233743.GE2565@sortiz-mobl>
References: <1295448729-22821-1-git-send-email-vpalatin@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295448729-22821-1-git-send-email-vpalatin@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Wed, Jan 19, 2011 at 09:52:09AM -0500, Vincent Palatin wrote:
> When using a fixed voltage regulator triggered by a TPS6586x GPIO,
> this allows to declare and initialize it conveniently from the "subdev" list.
> 
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> ---
>  drivers/mfd/tps6586x.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index 627cf57..fdb16ed 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -517,19 +517,25 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
>  		}
>  	}
>  
> +	tps6586x_gpio_init(tps6586x, pdata->gpio_base);
> +
Wouldn't it make sense to have tps6586x_gpio_init() return an int and check it
before adding the subdevs then ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
