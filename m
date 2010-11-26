Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0KZKXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:23:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:14746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab0KZKXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:23:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,260,1288594800"; 
   d="scan'208";a="630488234"
Date: Fri, 26 Nov 2010 11:23:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Fabio Estevam <fabioestevam@yahoo.com>, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de
Subject: Re: [PATCH] mfd: check for NULL platform data
Message-ID: <20101126102339.GD5520@sortiz-mobl>
References: <805862.49452.qm@web51006.mail.re2.yahoo.com>
 <20101111154407.GC18358@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101111154407.GC18358@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, Nov 11, 2010 at 04:44:07PM +0100, Uwe Kleine-König wrote:
> Hi Fabio,
> 
> On Thu, Nov 11, 2010 at 06:58:14AM -0800, Fabio Estevam wrote:
> > Avoid kernel crash if platform data is NULL.
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > ---
> >  drivers/mfd/mc13xxx-core.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> > index a2ac2ed..b4d6bb1 100644
> > --- a/drivers/mfd/mc13xxx-core.c
> > +++ b/drivers/mfd/mc13xxx-core.c
> > @@ -757,6 +757,9 @@ err_revision:
> >  
> >  	mc13xxx_unlock(mc13xxx);
> >  
> > +	if (pdata == NULL)
> > +		return 0;
> > +
> I'm not sure it's really needed to catch this error.  Not passing pdata
> isn't sensible and then maybe failing with a bang is better than
> handling silently.
> 
> And if you want to break probing, do you really want to return 0, i.e.
> let the binding succeed?  IMHO (if you really want to handle pdata ==
> NULL) you should fail before allocating the private data with
> -ESOMETHINGSENSIBLE.
Agreed. Besides failing silently, Fabio's patch leaks the mc13xxx pointer and
doesn't free the requested IRQ line.
So NAK for now, although I wouldn't be against checking for a NULL pdata at
the very begining of the probe routine.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
