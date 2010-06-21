Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0FUTvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:51:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45797 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab0FUTvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EH0SdOwIZ7c2/pKv1rpktd0tppxp5rBoeA0q7YBN1KUVVEOoY5pxVpVLhrZDN5cwU3
         +Jd6dNTGJbVSujMi/7/afc7hkI0T10XWi+08juFa+NSVoCUUh+ModnpNHF05qp4pmjkd
         dP/FcHZGeAQE2bsIUWYMx1vwAFkY4DjPuauHk=
Subject: Re: [PATCH] Two fixes for my mmc/sd cardreader
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <20100621123921.045e245f.akpm@linux-foundation.org>
References: <1276809695.28201.13.camel@maxim-laptop>
	 <1277148104.4241.1.camel@maxim-laptop>
	 <20100621123921.045e245f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 22:50:55 +0300
Message-ID: <1277149855.5409.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 12:39 -0700, Andrew Morton wrote: 
> On Mon, 21 Jun 2010 22:21:44 +0300
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Fri, 2010-06-18 at 00:21 +0300, Maxim Levitsky wrote: 
> > > Hi,
> > > 
> > > These are 2 fixes for my card reader.
> > > 
> > > 
> > > First patch fixes old issue with system hand on suspend to disk/ram with
> > > mmc card inserted.
> > > I updated description, and pm notification registration order.
> > > I think this patch can an should go to 2.6.35, because it fixes long
> > > standing and nasty regression.
> > > 
> > > The second patch is a result of my work trying to understand why my card
> > > reader sometimes dies on resume.
> > > This reader has a special MMC function which steals MMC cards, and until
> > > now had no driver. A way to disable it was found, and while it works, it
> > > has (at least here) a side effect of killing the controller on resume
> > > from ram/disk (and it happens often, and doesn't depend of whether card
> > > was in slot or not during suspend).
> > > 
> > > Fortunately it turned out that MMC part is _almost_ standard SDHCI
> > > controller.
> > > This patch adds support for this device to standard sdhci driver.
> > > Unfortunately, this support still contais small hack.
> > > It waits 1/2 of a second on resume before initializing the controller.
> > > Not doing so, and resuming with MMC card present results in confused
> > > controller. It is not dead though. A card reinsert makes it work again
> > > with all cards.
> > > Yet the 1st patch is must for this because otherwise mmc core seeing
> > > that controller doesn't respond, removes the card, therefore hangs the
> > > system.
> > > It doesn't happen when I wait these 1/2 of second though.
> > > 
> > > I think that this patch is also ok for 2.6.35, because it only adds new
> > > functionality.
> > > You are free to disable MMC controller using the same
> > > CONFIG_MMC_RICOH_MMC.
> > > 
> > > If you don't disable it though, instead of full lack of functionality
> > > you will get full featured MMC controller.
> > > 
> > > Best regards,
> > > Maxim Levitsky
> > > 
> > > 
> > > 
> > ping
> 
> hey, that was only three days.  I commonly leave things to bake on the
> mailing list for a while, see what people have to say about it. 
> Particularly with subsystems like MMC.

Sure.

I just posted the patches on weekend, thought they weren't noticed...
Anyway confirm again that I didn't yet seen any problem with my card
reader.
(I test it regularly)

Best regards,
Maxim Levitsky

