Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1EDLbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:31:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46196 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab1EDLbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pIdnuDMMnMdoYGxs527jOWILCiAHsizLvWvdoaXjAMIwDCIa3OolrfyfY1MAh91FOr
         5gPwf0tjZjGq8HGs+EG71dPp3XS8UjwYvjwIw4LMqSHe4OgGBagGH3hYE9xm5M3BVGnD
         4n6zl34rTkkOoyOo9nQ0FFYTOyGfzmEJDk6LM=
Date: Wed, 4 May 2011 15:31:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504113131.GA639@oksana.dev.rtsoft.ru>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru>
 <20110504110939.GB13514@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110504110939.GB13514@pulham.picochip.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 12:09:39PM +0100, Jamie Iles wrote:
> On Wed, May 04, 2011 at 02:34:15AM +0400, Anton Vorontsov wrote:
> > On Tue, May 03, 2011 at 11:04:08PM +0100, Jamie Iles wrote:
> > [...]
> > > The advantage that Grant's proposal has though is that the user can 
> > > override the gpio_chip callbacks.  When I tried porting over some 
> > > existing ARM platforms, one of the blocking issues was that lots of 
> > > platforms had some annoying small detail that was slightly different 
> > > (such as doing muxing in the _get() callback or needing a to_irq 
> > > callback).
> > > 
> > > If we make bgpio_chip public and return that from bgpio_probe 
> > > unregistered then the calling code can override some of the methods then 
> > > register the gpio_chip.
> > 
> > Oh, that makes sense, right.
> 
> I've just given this a try and it largely works, but it's probably 
> better if we allow bgpio_chip to be embedded in other structures.  For 
> example, the langwell driver has a gpio_to_irq callback that we would 
> need to get the IRQ base for the bank.  We could add a void *priv member 
> to bgpio_chip but that doesn't feel quite right.
> 
> So,
> 	int bgpio_init(struct bgpio_chip *bgc, struct device *dev, 
> 		       unsigned long sz, void __iomem *dat, ...)
> 
> rather than a probe() that returns the bgpio_chip?

Sounds good to me.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
