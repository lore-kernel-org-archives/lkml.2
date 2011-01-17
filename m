Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1AQWEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:04:21 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57207 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1AQWET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:04:19 -0500
Date: Mon, 17 Jan 2011 15:04:15 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Thomas Chou <thomas@wytron.com.tw>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Subject: Re: [PATCH] alter_ps2: Add devicetree support
Message-ID: <20110117220415.GB17963@angua.secretlab.ca>
References: <4D040D1C.2020705@home.nl>
 <1295245760-4566-1-git-send-email-thomas@wytron.com.tw>
 <20110117213100.GC27245@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117213100.GC27245@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 01:31:01PM -0800, Dmitry Torokhov wrote:
> On Mon, Jan 17, 2011 at 02:29:20PM +0800, Thomas Chou wrote:
> > From: Walter Goossens <waltergoossens@home.nl>
> > 
> 
> For my education, why is this needed?
> 
> > Signed-off-by: Walter Goossens <waltergoossens@home.nl>
> > Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> > ---
> >  drivers/input/serio/altera_ps2.c |   16 ++++++++++++++++
> >  1 files changed, 16 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
> > index 7998560..93054a1 100644
> > --- a/drivers/input/serio/altera_ps2.c
> > +++ b/drivers/input/serio/altera_ps2.c
> > @@ -19,6 +19,9 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/slab.h>
> > +#ifdef CONFIG_OF
> > +#include <linux/of.h>
> > +#endif
> 
> Does it have to be guarded?

Shouldn't need to be.

> 
> >  
> >  #define DRV_NAME "altera_ps2"
> >  
> > @@ -173,6 +176,16 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_OF
> > +static struct of_device_id altera_ps2_match[] = {
> 
> Not const?
> 
> > +	{ 
> > +		.compatible = "altera,altera_ps2",
> > +	},
> > +	{},
> > +}
> > +MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
> > +#endif /* CONFIG_OF */
> > +
> >  /*
> >   * Our device driver structure
> >   */
> > @@ -182,6 +195,9 @@ static struct platform_driver altera_ps2_driver = {
> >  	.driver	= {
> >  		.name	= DRV_NAME,
> >  		.owner	= THIS_MODULE,
> > +#ifdef CONFIG_OF
> > +		.of_match_table = altera_ps2_match,
> > +#endif
> 
> Can't we spare 4 bytes per driver and have .of_match_table always
> present?

Yeah, probably.  I've been trying to avoid it, but I suppose that is
much ado about a tiny amount of data.  I'll craft a patch.

g.

