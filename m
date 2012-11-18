Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2KRXHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 18:07:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45580 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2KRXHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 18:07:07 -0500
Date: Sun, 18 Nov 2012 15:03:46 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] max17042: missing assignment
Message-ID: <20121118230345.GB29066@lizard.sbx05977.paloaca.wayport.net>
References: <20121025141638.16300.43943.stgit@localhost.localdomain>
 <D854C92F57B1B347B57E531E78D05EAD24510D25@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD24510D25@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:28:03PM +0000, Pallala, Ramakrishna wrote:
> 
> Thanks Alan.
> 
> > The second error check is unreachable because the lock function isn't assigned
> > to ret
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> Acked-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>

For some reason I don't have the original patch in my mailbox. I wonder if
I have not been Cc'ed on this one or it got lost...

Anyway, I reconstructed it by hand and applied, thanks a lot!

Anton.

> > ---
> > 
> >  drivers/power/max17042_battery.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/power/max17042_battery.c
> > b/drivers/power/max17042_battery.c
> > index 74abc6c..73b432d 100644
> > --- a/drivers/power/max17042_battery.c
> > +++ b/drivers/power/max17042_battery.c
> > @@ -572,7 +572,7 @@ static int max17042_init_chip(struct max17042_chip
> > *chip)
> >  			__func__);
> >  		return -EIO;
> >  	}
> > -	max17042_verify_model_lock(chip);
> > +	ret = max17042_verify_model_lock(chip);
> >  	if (ret) {
> >  		dev_err(&chip->client->dev, "%s lock verify failed\n",
> >  			__func__);
> 
