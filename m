Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab0E3UIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:08:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36499 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0E3UIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f4aK/H6IEZYP2nxWy4yEcp0PjU+/zIpgVQVQ+02vUxLmtnfUkF7cB10fL9OWelxKDy
         iSij3kC1fFHDBIZRg0n6TlmKSMEDInSMkVFTHp/kg5l+GiycebyB3Hc8Tm9+v6CMMjB/
         xKMvZneHXJchMhcd4Enu0GqenKBcPnzZWDmbw=
Date: Sun, 30 May 2010 13:08:34 -0700
From: mark gross <640e9920@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] complain when users abuse the pm_qos API
Message-ID: <20100530200834.GB25545@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100529045027.GE11600@gvim.org>
 <201005292208.04309.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005292208.04309.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 10:08:04PM +0200, Rafael J. Wysocki wrote:
> On Saturday 29 May 2010, mark gross wrote:
> > The following patch is to help clean up API abusers of pm_qos where
> > they call update_request before registering a request.
> > 
> > --mgross
> > 
> > --Signed-off-by: markgross <markgross@thegnar.org>
> 
> Will there be a big issue if I push this during the next merge window?

No big issue.  it can wait.

--mgross

> 
> Rafael
> 
> 
> > From a0813007ddc7b72cb3da7a533fefba9889aab1d8 Mon Sep 17 00:00:00 2001
> > From: mgross <mgross@mgross-desktop.(none)>
> > Date: Fri, 28 May 2010 21:36:06 -0700
> > Subject: [PATCH] complain when users abuse the pm_qos API by updating a request that
> >  isn't registered yet.
> > 
> > ---
> >  kernel/pm_qos_params.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index f42d3f7..8e55bf1 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -266,6 +266,10 @@ void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
> >  		spin_unlock_irqrestore(&pm_qos_lock, flags);
> >  		if (pending_update)
> >  			update_target(pm_qos_req->pm_qos_class);
> > +	} else {
> > +		WARN(true, "pm_qos: updating an unregistered request "
> > +				"does nothing");
> > +		dump_stack();
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(pm_qos_update_request);
> > 
> 
