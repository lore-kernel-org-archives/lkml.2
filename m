Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab1J2XtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:49:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44941 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab1J2XtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:11 -0400
Date: Sat, 29 Oct 2011 13:49:05 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] dt: add empty of_alias_get_id() for non-dt builds
Message-ID: <20111029114905.GA22592@ponder.secretlab.ca>
References: <1319706448-1664-1-git-send-email-nicolas.ferre@atmel.com>
 <4EAAABF6.50803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAAABF6.50803@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 08:19:50AM -0500, Rob Herring wrote:
> On 10/27/2011 04:07 AM, Nicolas Ferre wrote:
> > Add function of_alias_get_id() reporting -ENOSYS
> > for non-dt builds, so that drivers migrating to dt
> > can save some '#ifdef CONFIG_OF'.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Merged, thanks

Rob, for stuff like this, please do pick it up into your git tree and
reply saying that you've done so.  Then I know I can ignore it because
I'll be receiving a pull req from you in short order.

Similarly, I reply whenever I pick up a patch, so you'll know if I've
already delt with it.

g.

> 
> > ---
> > Hi Grant,
> > 
> > Another empty function for non-dt builds. Can we consider
> > queuing it for 3.1?
> > 
> > Best regards,
> > 
> >  include/linux/of.h |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/of.h b/include/linux/of.h
> > index 92c40a1..34d8338 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -302,6 +302,11 @@ static inline struct device_node *of_parse_phandle(struct device_node *np,
> >  	return NULL;
> >  }
> >  
> > +static inline int of_alias_get_id(struct device_node *np, const char *stem)
> > +{
> > +	return -ENOSYS;
> > +}
> > +
> >  #define of_match_ptr(_ptr)	NULL
> >  #define of_match_node(_matches, _node)	NULL
> >  #endif /* CONFIG_OF */
> 
