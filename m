Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0FGFVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:21:09 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:52105 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab0FGFVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:21:07 -0400
Date: Mon, 7 Jun 2010 08:20:28 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH] rtc: driver for the DryIce block found in
 i.MX25 chips
Message-ID: <20100607052027.GG14583@jasper.tkos.co.il>
References: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
 <AANLkTimzq5zBEqrxzkm_D7trn7ikJX8yqny_6SogdIO6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimzq5zBEqrxzkm_D7trn7ikJX8yqny_6SogdIO6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

On Sat, Jun 05, 2010 at 11:08:46PM +0800, Wan ZongShun wrote:
> Some minor comments below:

One question though.

> > +/*
> > + * read the seconds portion of the current time from the dryice time counter
> > + */
> > +static int dryice_rtc_read_time(struct device *dev, struct rtc_time *tm)
> > +{
> > +       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
> > +       unsigned long now;
> > +
> > +       now = __raw_readl(imxdi->ioaddr + DTCMR);
> > +       rtc_time_to_tm(now, tm);
> > +
> 
> When we want to return a tm value, call rtc_valid_tm() to check the tm
> that is a good habit.

Isn't rtc_time_to_tm() guaranteed to produce a valid tm value?

> 
> > +       return 0;
> > +}

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
