Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1EDPCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:02:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1EDPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XU17PLK+YpBG3qp8CHaL2FIHHfzqU/7cdU+PBMtOiUn5dC18DOFVfQ+SXpWboNXbGx
         4wYvaBALslZtUq866ImFy38pT+6WZjpXyTXDfgz6SHSiGGTbq3noXODYCz6GzUbwnxFB
         MNkZ06PG7xZ4A5FEfda7JgxPrmlK1AzTZhJLw=
Date: Wed, 4 May 2011 19:02:34 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504150234.GA32670@oksana.dev.rtsoft.ru>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru>
 <20110504110939.GB13514@pulham.picochip.com>
 <20110504113131.GA639@oksana.dev.rtsoft.ru>
 <20110504143757.GB15967@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110504143757.GB15967@pulham.picochip.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 03:37:57PM +0100, Jamie Iles wrote:
[...]
> +	err = bgpio_init(bgc, dev, sz, dat, set, clr, dirout, dirin, be);
> +	if (err)
> +		return err;
> +
> +	if (pdata) {
> +		bgc->gc.base = pdata->base;
> +		if (pdata->ngpio > 0)
> +			bgc->gc.ngpio = pdata->ngpio;
> +	}
> +
> +	platform_set_drvdata(pdev, bgc);
> +
> +	return 0;

return gpio_chip_add(&bgc->gc)? Or bgpio_chip_add(bgc);

Otherwise this looks great. Feel free to add my

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
