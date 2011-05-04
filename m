Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1EDPEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:04:44 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38184 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1EDPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:04:42 -0400
Date: Wed, 4 May 2011 16:04:38 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, arnd@arndb.de, nico@fluxnic.net,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504150438.GE15967@pulham.picochip.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru>
 <20110504110939.GB13514@pulham.picochip.com>
 <20110504113131.GA639@oksana.dev.rtsoft.ru>
 <20110504143757.GB15967@pulham.picochip.com>
 <20110504150234.GA32670@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504150234.GA32670@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 07:02:34PM +0400, Anton Vorontsov wrote:
> On Wed, May 04, 2011 at 03:37:57PM +0100, Jamie Iles wrote:
> [...]
> > +	err = bgpio_init(bgc, dev, sz, dat, set, clr, dirout, dirin, be);
> > +	if (err)
> > +		return err;
> > +
> > +	if (pdata) {
> > +		bgc->gc.base = pdata->base;
> > +		if (pdata->ngpio > 0)
> > +			bgc->gc.ngpio = pdata->ngpio;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, bgc);
> > +
> > +	return 0;
> 
> return gpio_chip_add(&bgc->gc)? Or bgpio_chip_add(bgc);

Yes, this got lost in the move from bgpio_probe() to bgpio_init().  
Thanks!

Jamie
