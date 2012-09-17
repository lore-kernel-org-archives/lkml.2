Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab2IQTGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:06:40 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:53911 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab2IQTGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:06:39 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am9RAGxzV1BV5h1yPGdsb2JhbABEhR6FI64ggz8ZAQEBATc0giABAQQBOhwjBQsIAxguFCUKGogNCrpMFIsNhghgA5IxgzCFcI0a
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="116772648"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 17 Sep 2012 21:14:16 +0200
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120917191416.GA598@polaris.bitmath.org>
References: <alpine.DEB.2.02.1209152323490.2088@ubuntu>
 <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu>
 <20120916223003.GA2160@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161957490.2808@ubuntu>
 <20120917162705.GA2854@polaris.bitmath.org>
 <alpine.DEB.2.02.1209171356340.3412@ubuntu>
 <20120917184954.GA349@polaris.bitmath.org>
 <alpine.DEB.2.02.1209171446390.1963@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209171446390.1963@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 02:54:25PM -0400, Parag Warudkar wrote:
> 
> 
> On Mon, 17 Sep 2012, Henrik Rydberg wrote:
> 
> > So the question is, does this patch work equally well for you?
> > 
> > 
> > diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> > index 2827088..8bf9011 100644
> > --- a/drivers/hwmon/applesmc.c
> > +++ b/drivers/hwmon/applesmc.c
> > @@ -56,7 +56,7 @@
> >  /* wait up to 32 ms for a status change. */
> >  #define APPLESMC_MIN_WAIT      0x0010
> >  #define APPLESMC_RETRY_WAIT    0x0100
> > -#define APPLESMC_MAX_WAIT      0x8000
> > +#define APPLESMC_MAX_WAIT      0x10000
> >  
> >  #define APPLESMC_READ_CMD      0x10
> >  #define APPLESMC_WRITE_CMD     0x11
> > 
> 
> That was something that I tried originally and it still resulted in 
> failures - albeit lesser in number.

Good, just wanted to touch base here, so we know what we are doing.

> I had to bump it to 0x20000 (effective wait of 65536) with the original 
> loop termination logic and  udelay() in order to get it to reduce to 
> zero.
> 
> Note that with usleep_range - each sleep is potentially more than the 
> minimum - that's may be why 32ms works with usleep_range but not with 
> udelay which is precise.

Yes, so if you also change APPLESMC_MIN_WAIT to 0x0020, what happens?

> So bottomline, I suspect we will need to bump to 0x20000 if you want to 
> keep the current loop termination and udelay().

That is just crazy, since your code works with a 32ms maximum.

Thanks,
Henrik
