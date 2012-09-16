Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab2IPWW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:22:29 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:38619 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2IPWW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:22:28 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvNJAHZQVlBV5h1yPGdsb2JhbABFhR6FI7FQGQEBAQE3NIIgAQEEATocIwULCAMYLhQlChqIDQq5axSLDYYIYAOVYYVwjRo
X-IronPort-AV: E=Sophos;i="4.80,432,1344204000"; 
   d="scan'208";a="189552700"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 17 Sep 2012 00:30:03 +0200
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120916223003.GA2160@polaris.bitmath.org>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu>
 <20120915225841.GA3816@roeck-us.net>
 <alpine.DEB.2.02.1209151918210.2271@ubuntu>
 <alpine.DEB.2.02.1209152323490.2088@ubuntu>
 <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209161712070.14838@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Parag,

> > On Sat, Sep 15, 2012 at 09:31:16PM -0700, Guenter Roeck wrote:
> > > That looks terribly complicated. Better keep the loop, and just replace
> > > 	udelay(us);
> > > with something like
> > > 	usleep_range(us, us << 1);
> > > 
> > > Alternatively, just use a constant such as
> > > 	usleep_range(us, us + APPLESMC_MIN_WAIT);
> > 
> Well I don't think there is anything terribly complicated there - but I 
> tried to make it simpler. Below patch seems to work better for me for my 
> normal workload - I got no failures or other oddities with the default 
> 32ms timeout. I haven't tried very hard to get to the corner cases which 
> earlier required a higher timeout.

What exact model is this?

In addition to Guenter's comments, it is not clear what part of this
patch makes things work for you. Is it a) the doubling of the wait
time, or b) the zero initial wait? Or c) just randomly a little bit
better?

If a), that is very valuable information, and the patch can be
simplified further. If b), just crank up the wait time and be done
with it. If c), well, then we don't have a case for a patch.

Also, it is not enough to test this on one machine, for fairly obvious
reasons. I don't mind testing on a couple of machines close by (MBA3,1
MBP10,1), once the comments have been addressed. However, a machine
from around 2008 should be tested as well, since they behave
differently.

> Henrik - if the below patch still results in failures we can 
> revisit the long  wait cases. For now I am satisfied that there aren't any 
> normal case failures like before.

Well, I am satisfied once I know the patch will work on all supported
models.

Thanks.
Henrik
