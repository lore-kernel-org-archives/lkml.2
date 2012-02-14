Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940Ab2BNJzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:55:39 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:36988 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab2BNJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:55:36 -0500
Message-ID: <1329213331.3032.62.camel@cumari>
Subject: Re: [PATCH 3.3 v2] I2C: OMAP: fix build breakage when CONFIG_OF is
 not set
From: Luciano Coelho <coelho@ti.com>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Date: Tue, 14 Feb 2012 11:55:31 +0200
In-Reply-To: <20120213232707.GH2999@freya.fluff.org>
References: <1328699901-19488-1-git-send-email-coelho@ti.com>
	 <20120213232707.GH2999@freya.fluff.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, 2012-02-13 at 23:27 +0000, Ben Dooks wrote: 
> On Wed, Feb 08, 2012 at 01:18:21PM +0200, Luciano Coelho wrote:
> > diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> > index f713eac..fd200eb 100644
> > --- a/drivers/i2c/busses/i2c-omap.c
> > +++ b/drivers/i2c/busses/i2c-omap.c
> > @@ -979,6 +979,8 @@ static const struct of_device_id omap_i2c_of_match[] = {
> >  	{ },
> >  };
> >  MODULE_DEVICE_TABLE(of, omap_i2c_of_match);
> > +#else
> > +static const struct of_device_id *omap_i2c_of_match = NULL;
> >  #endif
> 
> of_match_ptr(_ptr) will go to NULL if CONFIG_OF is not set, use that please.

Yes, you're right.  But this patch can be ignored, since there was
already an equivalent one queued up (which I missed).  And it uses
of_match_ptr() ;)

Thanks for your comment anyway!

-- 
Cheers,
Luca.

