Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1JXMB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:01:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50625 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1JXMBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:01:25 -0400
Date: Mon, 24 Oct 2011 14:01:20 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Provide a definition of struct gpio for the
 stub gpiolib
Message-ID: <20111024120120.GO8708@ponder.secretlab.ca>
References: <1319455649-4916-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319455649-4916-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 01:27:29PM +0200, Mark Brown wrote:
> This makes the stub gpio_request_array() much more usable as drivers can
> declare struct gpio variables.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Shouldn't this patch remove the definition from
include/asm-generic/gpio.h at the same time?

g.

> ---
>  include/linux/gpio.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 17b5a0d..e885103 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -24,7 +24,6 @@
>  #include <linux/errno.h>
>  
>  struct device;
> -struct gpio;
>  struct gpio_chip;
>  
>  /*
> @@ -36,6 +35,12 @@ struct gpio_chip;
>   * warning when something is wrongly called.
>   */
>  
> +struct gpio {
> +	unsigned	gpio;
> +	unsigned long	flags;
> +	const char	*label;
> +};
> +
>  static inline bool gpio_is_valid(int number)
>  {
>  	return false;
> -- 
> 1.7.6.3
> 
