Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1AGVeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:34:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:37556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab1AGVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:34:18 -0500
Date: Fri, 7 Jan 2011 13:23:33 -0800
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?Fran=E7ois?= Valenduc 
	<francois.valenduc@tvcablenet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [132/152] drm/i915/bios: Reverse order of 100/120 Mhz SSC
 clocks
Message-ID: <20110107212333.GA19958@suse.de>
References: <20110106002500.GA3172@kroah.com>
 <20110106002309.150359580@clark.site>
 <4D277520.80006@tvcablenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D277520.80006@tvcablenet.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 09:18:40PM +0100, François Valenduc wrote:
> Le 06/01/11 01:23, Greg KH a écrit :
> > 2.6.36-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> > 
> > commit 448f53a1ede54eb854d036abf54573281412d650 upstream.
> > 
> > Fixes the lack of output on the LVDS panel of the Lenovo U160.
> > 
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=31596
> > Reported-and-tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/gpu/drm/i915/intel_bios.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/drivers/gpu/drm/i915/intel_bios.c
> > +++ b/drivers/gpu/drm/i915/intel_bios.c
> > @@ -276,7 +276,7 @@ parse_general_features(struct drm_i915_p
> >  					general->ssc_freq ? 66 : 48;
> >  			else if (IS_IRONLAKE(dev_priv->dev) || IS_GEN6(dev))
> >  				dev_priv->lvds_ssc_freq =
> > -					general->ssc_freq ? 100 : 120;
> > +					general->ssc_freq ? 120 : 100;
> >  			else
> >  				dev_priv->lvds_ssc_freq =
> >  					general->ssc_freq ? 100 : 96;
> > 
> > 
> 
> This commit gives a black screen on many computers and has been reverted
> between 2.6.37-rc8 and 2.6.37. Why has this been added to this review ?

Because it was marked as a -stable patch.

If it's been reverted (and I now see that it has), I should drop it from
this tree.  I'll go do that right now.

Thanks for pointing it out.

greg k-h
