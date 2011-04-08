Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1DHOqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:46:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60640 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1DHOqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a62bvv3L1xYRDIUb0NZ9R4G5xqA9S8ked4cAvsblqJoUMb+du0LkOxa5i0Ifwhzz5h
         06RO9suFi77UxgBXRYPu5n2VXW3S1N240P468gYF4eowj03dJQri1I3XawKFKtWfMGm3
         c73Q6l51ofGHFmkDo7olpwEwogJ5qw2a7zrCQ=
Date: Fri, 8 Apr 2011 18:46:28 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv2 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110408144628.GC25237@oksana.dev.rtsoft.ru>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
 <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 03:16:50PM +0100, Jamie Iles wrote:
> Some controllers have separate input and output registers.  For these
> controllers, allow a register named "in" to be used for reading the
> value of a GPIO pin.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/gpio/basic_mmio_gpio.c |   31 +++++++++++++++++++++++++++++--
>  1 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index 9be1867..ed4b0c6 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -70,6 +70,7 @@ struct bgpio_chip {
>  	void __iomem *reg_dat;
>  	void __iomem *reg_set;
>  	void __iomem *reg_clr;
> +	void __iomem *reg_in;

Btw, I wonder if it makes sense (and more logical) for separate output/
input registers case to use "reg_dat" for 'input' and 'reg_set' for
output?

I.e. no need for 'reg_in', but instead modify some logic in
bgpio_setup_io(), and implement bgpio_set_set:

	if (res_dat && res_set && !res_clr) {
		bgc->gc.get = bgpio_get_dat;
		bgc->gc.set = bgpio_set_set;
	} else {
		bgc->gc.get = bgpio_get_dat;
		bgc->gc.set = bgpio_set_dat;
	}

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
