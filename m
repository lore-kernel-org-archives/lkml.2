Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab1CST71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 15:59:27 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44718 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab1CST7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 15:59:25 -0400
Date: Sat, 19 Mar 2011 12:59:20 -0700
From: Andres Salomon <dilinger@queued.net>
To: kernel@wildgooses.com
Cc: lists@wildgooses.com, grant.likely@secretlab.ca,
        linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Show explicit dependency between GPIO_CS5535 and
 MFD_CS5535
Message-ID: <20110319125920.7b625e9b@queued.net>
In-Reply-To: <1300556785-30368-1-git-send-email-kernel@wildgooses.com>
References: <AANLkTinJNFZ-c_+Cuan5ebuRadrOvdfivxQjnN9GZPt=@mail.gmail.com>
	<1300556785-30368-1-git-send-email-kernel@wildgooses.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Mar 2011 17:46:25 +0000
kernel@wildgooses.com wrote:

> From: Ed Wildgoose <kernel@wildgooses.com>
> 
> cs5535-gpio.c has been split into two, with various setup moved
> into cs5535-mfd.c.  Given that cs5535-gpio will not load without
> the -mfd part, lets make that dependency explicit in Kconfig

Thanks!

Acked-by: Andres Salomon <dilinger@queued.net>

> 
> Signed-off-by: Ed Wildgoose <kernel@wildgooses.com>
> ---
> :100644 100644 664660e... 3246ad4... M	drivers/gpio/Kconfig
>  drivers/gpio/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 664660e..3246ad4 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -295,7 +295,7 @@ comment "PCI GPIO expanders:"
>  
>  config GPIO_CS5535
>  	tristate "AMD CS5535/CS5536 GPIO support"
> -	depends on PCI && X86 && !CS5535_GPIO
> +	depends on PCI && X86 && !CS5535_GPIO && MFD_CS5535
>  	help
>  	  The AMD CS5535 and CS5536 southbridges support 28 GPIO
> pins that can be used for quite a number of things.  The CS5535/6 is
> found on
