Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0KIKDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:03:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KIKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=msmAH3SqGz0d6yVhL6s5LgV8G7Kr9Ff2dbnzTHZIWx+IOio85qXrqcWs3lASoH7OMH
         75JL6OJtbvT0fL4KamL4gAT3FSfCsSgXKy8NBh7blPqqEgncnIhQhMpqX+LKYwPiWxln
         lwt7jUIeyLRFGng9RaftTnscuGz9PamR7B/jA=
Subject: Re: [PATCH] mxcmmc: Add the ability to bind a regulator to manage
 the MMC card voltage
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Daniel Mack <daniel@caiaq.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
In-Reply-To: <AANLkTi=oKHTmLS=xiNi9CJKttBGzMHjhZ3q_KWvi+xta@mail.gmail.com>
References: <1288656337.29881.13.camel@realization>
	 <AANLkTi=oKHTmLS=xiNi9CJKttBGzMHjhZ3q_KWvi+xta@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 11:03:08 +0100
Message-ID: <1289296988.3020.19.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lun, 2010-11-08 at 23:12 +0100, Linus Walleij wrote:
> 2010/11/2 Alberto Panizzo <maramaopercheseimorto@gmail.com>:
> 
> > +static inline void mxcmci_init_ocr(struct mxcmci_host *host)
> > +{
> > +#ifdef CONFIG_REGULATOR
> > +       host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
> > +
> > +       if (IS_ERR(host->vcc)) {
> > +               host->vcc = NULL;
> > +       } else {
> > +               host->mmc->ocr_avail = mmc_regulator_get_ocrmask(host->vcc);
> > +               if (host->pdata && host->pdata->ocr_avail)
> > +                       dev_warn(mmc_dev(host->mmc),
> > +                               "pdata->ocr_avail will not be used\n");
> > +       }
> > +#endif
> 
> You don't need these #ifdef CONFIG_REGULATOR guardposts
> anymore. I implemented stub functions for the ocrmask functions
> for 2.6.37.

Ehm.. thank you really for pointing me this, because I've also used the
old API breaking the build in the -next branch..

A Fix will be posted as soon as possible!

Thanks Linus!
Best regards,

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

