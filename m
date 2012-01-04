Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2ADTGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:06:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51347 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2ADTGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:06:25 -0500
Date: Wed, 4 Jan 2012 11:49:43 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [REPOST RFC PATCH 2/3] of_gpio: Add new helpers for easily
 requesting lots of GPIOs
Message-ID: <20120104184943.GW15503@ponder.secretlab.ca>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1323800614-12642-3-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323800614-12642-3-git-send-email-Kyle.D.Moffett@boeing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 01:23:33PM -0500, Kyle Moffett wrote:
> Mirroring the new gpio_request_array() interface, we add several a few
> helper functions for operating on entire arrays of GPIOs.
> 
> Also, to make it easier to write various combinations of "of_get_gpio()"
> followed by "gpio_request()", add several other new inline wrappers.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
>  drivers/of/gpio.c       |   96 +++++++++++++++++++++++++++++
>  include/linux/of_gpio.h |  154 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 250 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
> index f349aaf..4c04f2f 100644
> --- a/drivers/of/gpio.c
> +++ b/drivers/of/gpio.c
> @@ -83,6 +83,47 @@ err0:
>  EXPORT_SYMBOL(of_get_named_gpio_flags);
>  
>  /**
> + * of_get_gpio_array_flags() - Get array of gpios to use with GPIO API
> + * @np:		device node to get GPIOs from
> + * @of_gpios:	array of "struct of_gpio" to select which GPIOs to look up
> + * @of_flags:	array of "enum of_gpio_flags" to be filled in (may be NULL)
> + * @gpios:	array of "struct gpio" to be filled in
> + * @num:	the number of GPIOs to look up
> + *
> + * Takes a constant array of "struct of_gpio" and looks up each item in the
> + * indicated device-node.  The results are stored into the @gpios array,
> + * along with the optional GPIO "label" and "flags" values from the "of_gpio"
> + * structure.
> + *
> + * If an array of @of_flags is provided then any flags from the translate
> + * function will be stored into the corresponding element there.
> + */

That seems overly complex to me.  How many gpios are you expecting to
request?  If it is less than a handful, then I think letting the
driver call of_get_request() multiple times would still be simpler.

g.

