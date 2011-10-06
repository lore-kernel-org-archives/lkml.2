Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab1JFCrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 22:47:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45736 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1JFCrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 22:47:17 -0400
Date: Wed, 5 Oct 2011 18:58:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: greg@kroah.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver
 boilerplate
Message-ID: <20111006005831.GA18276@ponder.secretlab.ca>
References: <20111004232403.10364.22050.stgit@ponder>
 <4E8CCE22.9050205@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8CCE22.9050205@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 02:37:38PM -0700, Stephen Boyd wrote:
> On 10/04/11 16:26, Grant Likely wrote:
> > diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> > index 27bb05a..991a678 100644
> > --- a/include/linux/platform_device.h
> > +++ b/include/linux/platform_device.h
> > @@ -146,6 +146,21 @@ static inline void platform_set_drvdata(struct platform_device *pdev, void *data
> >  	dev_set_drvdata(&pdev->dev, data);
> >  }
> >  
> > +/* Helper macro for drivers that don't do anything special in module
> > + * init/exit.  This eliminates a lot of boilerplate */
> > +#define module_platform_driver(__platform_driver) \
> > +int __platform_driver##_init(void) \
> > +{ \
> > +	return platform_driver_register(&(__platform_driver)); \
> > +} \
> > +module_init(__platform_driver##_init); \
> > +void __platform_driver##_exit(void) \
> > +{ \
> > +	platform_driver_unregister(&(__platform_driver)); \
> > +} \
> > +module_exit(__platform_driver##_exit);
> > +
> > +
> >
> 
> Can you add __init, __exit, and static as well?

Done, thanks for the review.

g.

