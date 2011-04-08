Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1DHOi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:38:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47590 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1DHOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uWDCh39hmrlHWzKdluaZAdHO7bAcT6jEuAvRpdhjNFCFOa8RZKSKdnU7ou93BRFF1N
         uW560ZfeZDbnite+evrHo1qtox05g4SJ/71+aSQX9nE/mWeBslhSlmKWWi01VjjdMdrh
         cNjWJhSEbgMO6rtcsNyf1xKxTHhS8L8d11+lc=
Date: Fri, 8 Apr 2011 18:38:22 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv2 7/7] basic_mmio_gpio: support direction registers
Message-ID: <20110408143822.GB25237@oksana.dev.rtsoft.ru>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
 <1302272211-30242-8-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302272211-30242-8-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 03:16:51PM +0100, Jamie Iles wrote:
[...]
>  static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
>  {
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);

For readability, I would still add an empty line here.

> +	bgc->dir &= ~bgc->pin2mask(bgc, gpio);
> +	bgc->write_reg(bgc->reg_dir, bgc->dir);

And here.

> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +
>  	return 0;
>  }
>  
>  static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
>  {
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	unsigned long flags;
> +
> +	gc->set(gc, gpio, val);
> +
> +	spin_lock_irqsave(&bgc->lock, flags);

Ditto.

> +	bgc->dir |= bgc->pin2mask(bgc, gpio);
> +	bgc->write_reg(bgc->reg_dir, bgc->dir);

Ditto.

> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int bgpio_dir_in_inv(struct gpio_chip *gc, unsigned int gpio)
> +{
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);

etc...

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
