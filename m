Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1EKPtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:49:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:60650 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab1EKPs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,351,1301900400"; 
   d="scan'208";a="190151"
Date: Wed, 11 May 2011 10:23:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 16/19] mfd: Use mfd cell platform_data for tps6105x
 cells platform bits
Message-ID: <20110511082328.GA2637@sortiz-mobl>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-17-git-send-email-sameo@linux.intel.com>
 <BANLkTinHyGv11px+cO_ORL0-83T4c-mbsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinHyGv11px+cO_ORL0-83T4c-mbsQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, May 09, 2011 at 09:05:19AM +0200, Linus Walleij wrote:
> 2011/5/9 Samuel Ortiz <sameo@linux.intel.com>:
> 
> > With the addition of a platform device mfd_cell pointer, MFD drivers
> > can go back to passing platform data back to their sub drivers.
> > This allows for an mfd_cell->mfd_data removal and thus keep the
> > sub drivers MFD agnostic. This is mostly needed for non MFD aware
> > sub drivers.
> >
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> I have some question marks on this one...
> 
> > --- a/drivers/mfd/tps6105x.c
> > +++ b/drivers/mfd/tps6105x.c
> > @@ -183,7 +183,8 @@ static int __devinit tps6105x_probe(struct i2c_client *client,
> >        /* Set up and register the platform devices. */
> >        for (i = 0; i < ARRAY_SIZE(tps6105x_cells); i++) {
> >                /* One state holder for all drivers, this is simple */
> > -               tps6105x_cells[i].mfd_data = tps6105x;
> > +               tps6105x_cells[i].platform_data = tps6105x;
> > +               tps6105x_cells[i].pdata_size = sizeof(*tps6105x);
> 
> ACK
> 
> > --- a/drivers/regulator/tps6105x-regulator.c
> > +++ b/drivers/regulator/tps6105x-regulator.c
> > @@ -137,7 +137,7 @@ static struct regulator_desc tps6105x_regulator_desc = {
> >  */
> >  static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
> >  {
> > -       struct tps6105x *tps6105x = mfd_get_data(pdev);
> > +       struct tps6105x *tps6105x = pdev->dev.platform_data;
> 
> Can you use platform_get_drvdata(pdev); instead?
I suppose you mean dev_get_platdata() ?


> >        struct tps6105x_platform_data *pdata = tps6105x->pdata;
> >        int ret;
> >
> > @@ -164,7 +164,7 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
> >
> >  static int __devexit tps6105x_regulator_remove(struct platform_device *pdev)
> >  {
> > -       struct tps6105x *tps6105x = platform_get_drvdata(pdev);
> > +       struct tps6105x *tps6105x = pdev->dev.platform_data;
> 
> And this is a NO-OP, actually a bug in the present code, just leave it
> as it is and the other changes removing the mfd->mfd_data fixes the bug...
I agree it's a bug in the current code. But I need to fetch the platform_data
pointer, so here again I would have to call dev_get_platdata().

Cheers,
Samuel.


> Yours,
> Linus Walleij

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
