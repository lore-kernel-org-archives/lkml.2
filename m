Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1KUOSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:18:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44343 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1KUOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:18:22 -0500
Date: Mon, 21 Nov 2011 14:18:17 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 2/2] ARM: amba: Auto-generate AMBA driver module aliases
 during modpost
Message-ID: <20111121141817.GB14679@localhost.localdomain>
References: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
 <1321872510-2562-3-git-send-email-dave.martin@linaro.org>
 <20111121131022.GE30612@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111121131022.GE30612@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 02:10:22PM +0100, Uwe Kleine-König wrote:
> Hello Dave,
> 
> On Mon, Nov 21, 2011 at 10:48:30AM +0000, Dave Martin wrote:
> > --- a/drivers/amba/bus.c
> > +++ b/drivers/amba/bus.c
> > @@ -52,7 +52,14 @@ static int amba_uevent(struct device *dev, struct kobj_uevent_env *env)
> >  	int retval = 0;
> >  
> >  	retval = add_uevent_var(env, "AMBA_ID=%08x", pcdev->periphid);
> > -	return retval;
> > +	if (retval)
> > +		return retval;
> > +
> > +	retval = add_uevent_var(env, "MODALIAS=amba:d%08X", pcdev->periphid);
> > +	if (retval)
> > +		return retval;
> > +
> > +	return 0;
> Just return retval here?

Hmmm, yes -- I'm not sure why I did things that way.
I'll get rid of the final if () and do as you suggest.

Cheers
---Dave
