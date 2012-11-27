Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab2K0JFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:05:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51214 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab2K0JFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:05:17 -0500
Date: Tue, 27 Nov 2012 09:05:12 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/5] Input: bu21013_ts - Request a regulator that
 actually exists
Message-ID: <20121127090512.GE7897@gmail.com>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-2-git-send-email-lee.jones@linaro.org>
 <20121126121618.GL12782@gmail.com>
 <20121126164708.GB14623@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121126164708.GB14623@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012, Dmitry Torokhov wrote:

> On Mon, Nov 26, 2012 at 12:16:18PM +0000, Lee Jones wrote:
> > On Wed, 14 Nov 2012, Lee Jones wrote:
> > 
> > > Currently the BU21013 Touch Screen driver requests a regulator by the
> > > name of 'V-TOUCH', which doesn't exist anywhere in the kernel. The
> > > correct name, as referenced in platform regulator code is 'avdd'. Here,
> > > when we request a regulator, we use the correct name instead.
> > > 
> > > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Cc: linux-input@vger.kernel.org
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/input/touchscreen/bu21013_ts.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
> > > index 5c487d2..2fae682 100644
> > > --- a/drivers/input/touchscreen/bu21013_ts.c
> > > +++ b/drivers/input/touchscreen/bu21013_ts.c
> > > @@ -461,7 +461,7 @@ static int __devinit bu21013_probe(struct i2c_client *client,
> > >  	bu21013_data->chip = pdata;
> > >  	bu21013_data->client = client;
> > >  
> > > -	bu21013_data->regulator = regulator_get(&client->dev, "V-TOUCH");
> > > +	bu21013_data->regulator = regulator_get(&client->dev, "avdd");
> > >  	if (IS_ERR(bu21013_data->regulator)) {
> > >  		dev_err(&client->dev, "regulator_get failed\n");
> > >  		error = PTR_ERR(bu21013_data->regulator);
> > > -- 
> > > 1.7.9.5
> > 
> > Did you see this one also Dmitry?
> 
> Yes, I have it, I am waiting for the other 2 patches in series to
> settle.

This patch is unrelated to the others and fixes a bug. Would you
be kind enough to take it in right away please?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
