Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1EKTLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:11:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1EKTLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:11:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 3/5] PM: Support for system-wide power transitions in generic power domains
Date: Wed, 11 May 2011 21:11:50 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201104290154.12966.rjw@sisk.pl> <201105082324.19674.rjw@sisk.pl> <20110511111732.2f75713a@bike.lwn.net>
In-Reply-To: <20110511111732.2f75713a@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112111.50740.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 11, 2011, Jonathan Corbet wrote:
> Hi, Rafael,
> 
> One small question that came to mind as I was looking at this patch:
> 
> > +/**
> > + * pm_genpd_powered_down - Check if power has been removed from a power domain.
> > + * @genpd: Power domain to check.
> > + */
> > +static bool pm_genpd_powered_down(struct generic_power_domain *genpd)
> > +{
> > +	bool ret;
> > +
> > +	mutex_lock(&genpd->lock);
> > +	ret = genpd->power_is_off;
> > +	mutex_unlock(&genpd->lock);
> > +
> > +	return ret;
> 
> I'm not quite sure why this function exists?  The lock doesn't really
> change anything, since the power state can change before or after this
> check regardless.  If you need the power state to be stable, it seems like
> the lock needs to be taken further up the stack; otherwise simply checking
> genpd->power_is_off directly would seem to be sufficient. Am I missing
> something?

No, you aren't. :-)

In fact, the function doesn't exist any more in the most recent version
of the patch: https://patchwork.kernel.org/patch/775412/

Thanks,
Rafael
