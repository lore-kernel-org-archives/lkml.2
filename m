Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1AETEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:04:55 -0500
Received: from 63.mail-out.ovh.net ([91.121.185.56]:50494 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751353Ab1AETEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:04:54 -0500
Date: Wed, 5 Jan 2011 19:59:17 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 251/260] USB: atmel_usba_udc: force vbus_pin at
 -EINVAL when gpio_request failled
Message-ID: <20110105185917.GI2965@game.jcrosoft.org>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
 <1293952756-15010-252-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293952756-15010-252-git-send-email-paul.gortmaker@windriver.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13894167802447047668
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02:19 Sun 02 Jan     , Paul Gortmaker wrote:
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> commit 969affff54702785330de553b790372e261e93f9 upstream.
> 
> to ensure gpio_is_valid return false
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  drivers/usb/gadget/atmel_usba_udc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 75a256f..8fd88e1 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -2015,6 +2015,9 @@ static int __init usba_udc_probe(struct platform_device *pdev)
>  			} else {
>  				disable_irq(gpio_to_irq(udc->vbus_pin));
>  			}
> +		} else {
> +			/* gpio_request fail so use -EINVAL for gpio_is_valid */
> +			ubc->vbus_pin = -EINVAL;
there is a typo here
please change to 
			udc->vbus_pin = -EINVAL;

Best Regards,
J.
