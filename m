Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2D2VE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 17:04:56 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2D2VEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 17:04:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Subject: Re: [PATCH] PM: devfreq: init performance/powersave governor
Date: Sun, 29 Apr 2012 23:09:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khilman@ti.com" <khilman@ti.com>,
        =?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "mturquette@ti.com" <mturquette@ti.com>
References: <15852322.15281335501548956.JavaMail.weblogic@epml25>
In-Reply-To: <15852322.15281335501548956.JavaMail.weblogic@epml25>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201204292309.36959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 27, 2012, MyungJoo Ham wrote:
> > Performance and powersave governor's get_target_freq
> > is not called if driver chooses one of these two governors.
> > Add init function in governor profile to call update_devfreq
> > which will call get_target_freq subsequently.
> > 
> > Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> Hello Xiaoguang,
> 
> 
> Yes, if we do not call any QoS, min/max, OPP interfaces or enable polling, we need to call this at init. In fact, this is a bugfix patch.
> 
> Thank you!
> 
> Cheers!
> MyungJoo.
> 
> 
> 
> > ---
> >  drivers/devfreq/governor_performance.c |    7 +++++++
> >  drivers/devfreq/governor_powersave.c   |    7 +++++++
> >  2 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
> > index 574a06b..af75ddd 100644
> > --- a/drivers/devfreq/governor_performance.c
> > +++ b/drivers/devfreq/governor_performance.c
> > @@ -10,6 +10,7 @@
> >   */
> >  
> >  #include <linux/devfreq.h>
> > +#include "governor.h"
> >  
> >  static int devfreq_performance_func(struct devfreq *df,
> >  				    unsigned long *freq)
> > @@ -25,8 +26,14 @@ static int devfreq_performance_func(struct devfreq *df,
> >  	return 0;
> >  }
> >  
> > +static int performance_init(struct devfreq *devfreq)
> > +{
> > +	return update_devfreq(devfreq);
> > +}
> > +
> >  const struct devfreq_governor devfreq_performance = {
> >  	.name = "performance",
> > +	.init = performance_init,
> >  	.get_target_freq = devfreq_performance_func,
> >  	.no_central_polling = true,
> >  };
> > diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
> > index d742d4a..fec0cdb 100644
> > --- a/drivers/devfreq/governor_powersave.c
> > +++ b/drivers/devfreq/governor_powersave.c
> > @@ -10,6 +10,7 @@
> >   */
> >  
> >  #include <linux/devfreq.h>
> > +#include "governor.h"
> >  
> >  static int devfreq_powersave_func(struct devfreq *df,
> >  				  unsigned long *freq)
> > @@ -22,8 +23,14 @@ static int devfreq_powersave_func(struct devfreq *df,
> >  	return 0;
> >  }
> >  
> > +static int powersave_init(struct devfreq *devfreq)
> > +{
> > +	return update_devfreq(devfreq);
> > +}
> > +
> >  const struct devfreq_governor devfreq_powersave = {
> >  	.name = "powersave",
> > +	.init = powersave_init,
> >  	.get_target_freq = devfreq_powersave_func,
> >  	.no_central_polling = true,
> >  };
> 

