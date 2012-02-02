Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2BBE7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 23:59:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38338 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2BBE7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 23:59:50 -0500
Date: Wed, 1 Feb 2012 21:59:49 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2 RESEND] gpio: Add missing spin_lock_init in
 gpio-ml-ioh driver
Message-ID: <20120202045949.GL15343@ponder.secretlab.ca>
References: <1328064605.3533.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328064605.3533.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 10:50:05AM +0800, Axel Lin wrote:
> This bug was introduced by commit 54be5663
> "gpio-ml-ioh: Support interrupt function" which adds a spinlock to struct
> ioh_gpio but never init the spinlock.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied both, thanks.

g.

> ---
>  drivers/gpio/gpio-ml-ioh.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index 461958f..271fd49 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -448,6 +448,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
>  		chip->reg = chip->base;
>  		chip->ch = i;
>  		mutex_init(&chip->lock);
> +		spin_lock_init(&chip->spinlock);
>  		ioh_gpio_setup(chip, num_ports[i]);
>  		ret = gpiochip_add(&chip->gpio);
>  		if (ret) {
> -- 
> 1.7.5.4
> 
> 
> 
