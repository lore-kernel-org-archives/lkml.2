Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1EMTh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 15:37:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38269 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1EMTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 15:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KQKgerSSTmi766lTGYbbufIRPQxp1N79T5UyYcaycJI077R5ygK00/IP22iXCgwTrH
         2uit6WE1/SKPT7UHG11oFU5oS4fe9lqHUtSU+OPQ9dzz6AUhu6lhW295KYJwbfPD58NT
         8eounCWz2+HYcpMjT4kA4vkw9b9nCmDbSBmeU=
Date: Fri, 13 May 2011 23:37:18 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110513193718.GA5803@oksana.dev.rtsoft.ru>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110504150234.GA32670@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
> 
> Otherwise this looks great. Feel free to add my
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

What happened w/ this patch? Jamie, would you resend it so that
Grant could apply it?

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
