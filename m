Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0JKMQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:16:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58816 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab0JKMQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SoQQv6FBuDfMH6UlpHLmUyAJ8KEGJTIrU1AOl/3pfJnFzHxa9W0OgcTfJQxihoyx6W
         ZahvdirXBv+mrKagmbQAtj5QdMbDC6TZVDDbyVsRqcFkBQfxK/qu2a5as3/8Zg+a6vBI
         Djz3z8xgIOK0VgLJpAQRhVjNM3wDuJeeYg4lo=
Date: Mon, 11 Oct 2010 16:15:55 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: kernel-janitors@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8804: fix error handling code
Message-ID: <20101011121555.GA32652@albatros>
References: <1286731745-18169-1-git-send-email-segooon@gmail.com>
 <20101011120014.GJ9231@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011120014.GJ9231@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Oct 11, 2010 at 13:00 +0100, Mark Brown wrote:
> On Sun, Oct 10, 2010 at 09:29:04PM +0400, Vasiliy Kulikov wrote:
> > kzalloc() returns NULL on error, not ERR_PTR().
> > Also wm8804_modinit() didn't called i2c_del_driver() if
> > spi_register_driver() failed.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> 
> Please try to follow Documentation/SubmittingPatches - in particular,
> you should always split unrelated changes into separate patches.  In
> this case your I2C and kzalloc() changes have nothing to do with each
> other and so should be in separate patches,

Agreed, thanks.

> and the kzalloc() changes
> were already applied from a patch by someone else.

Yes, it was sent by Dan just one day before my patch ;)

> For the registration
> changes...

> > @@ -804,6 +804,7 @@ static int __init wm8804_modinit(void)
> >  	if (ret) {
> >  		printk(KERN_ERR "Failed to register wm8804 I2C driver: %d\n",
> >  		       ret);
> > +		goto err;
> >  	}
> >  #endif
> >  #if defined(CONFIG_SPI_MASTER)
> 
> ...it's not clear to me that this change is an improvement - it'll make
> the driver more fragile in the face of errors, I don't see a benefit in
> refusing to register the variant for one bus if the other fails?

I tried to implement your variant with depca driver in past, but it was
rejected by David Miller:
http://lists.openwall.net/netdev/2010/07/12/9


Thanks,

-- 
Vasiliy
