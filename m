Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0LGJsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:48:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:24130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0LGJso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:48:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,310,1288594800"; 
   d="scan'208";a="684660210"
Date: Tue, 7 Dec 2010 10:48:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] MFD: TWL/TPS: fix twl_probe section mismatch warning
 in mfd/twl-core.c
Message-ID: <20101207094841.GA4772@sortiz-mobl>
References: <alpine.DEB.2.00.1012061734590.13430@utopia.booyaka.com>
 <AANLkTimXPFROMQ_fF4Od-jw3aDY0WZQgc=x14=VcFM3d@mail.gmail.com>
 <alpine.DEB.2.00.1012061839170.13430@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1012061839170.13430@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Dec 06, 2010 at 06:40:38PM -0700, Paul Walmsley wrote:
> On Tue, 7 Dec 2010, Bryan Wu wrote:
> 
> > On Tue, Dec 7, 2010 at 8:35 AM, Paul Walmsley <paul@pwsan.com> wrote:
> > >
> > > Fix the following section mismatch warning when building omap2plus_defconfig:
> > >
> > > WARNING: vmlinux.o(.data+0x47d7c): Section mismatch in reference from the variable twl_driver to the function .init.text:twl_probe()
> > >
> > > Signed-off-by: Paul Walmsley <paul@pwsan.com>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > ---
> > >  drivers/mfd/twl-core.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> > > index 35275ba..615cf38 100644
> > > --- a/drivers/mfd/twl-core.c
> > > +++ b/drivers/mfd/twl-core.c
> > > @@ -969,7 +969,7 @@ static int twl_remove(struct i2c_client *client)
> > >  }
> > >
> > >  /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
> > > -static int __init
> > > +static int
> > 
> > I think we might change __init to __devinit.
> > 
> > >  twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
> > >  {
> > >        int                             status;
> > > --
> 
> That's fine with me.  Samuel et al, Bryan's already done a patch 
> for this stuff:
> 
> https://patchwork.kernel.org/patch/367011/
> 
> so we should use that instead, if you're happy with it.  Samuel, maybe we 
> could get an ack from you on it?
The twl driver is not OMAP specific, so this should be a separate patch thatI
will merge to my mfd tree.
If you really insist in pushing this through Tony's tree, then please add my
Acked-by for the mfd part.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
