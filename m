Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1FARzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:55:50 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60407 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1FARzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:55:49 -0400
Subject: Re: [PATCH 6/6] clocksource: tile: convert to use
 clocksource_register_hz
From: john stultz <johnstul@us.ibm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4DE66645.6020406@tilera.com>
References: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
	 <1306913570-9445-7-git-send-email-john.stultz@linaro.org>
	 <4DE66645.6020406@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 10:55:30 -0700
Message-ID: <1306950930.3359.61.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 12:18 -0400, Chris Metcalf wrote:
> On 6/1/2011 3:32 AM, John Stultz wrote:
> > From: John Stultz <johnstul@us.ibm.com>
> >
> > Convert tile to use clocksource_register_hz.
> >
> > Untested. Help from maintainers would be appreciated.
> >
> > CC: Chris Metcalf <cmetcalf@tilera.com>
> 
> This patch boots up fine on tile.  It provides a shift count of 31, with a
> mult value in the billions.  This does mean that clocksource_cyc2ns() will
> only be able to give correct timer conversions for up to about 9 seconds. 
> Is this believed to be adequate for all the uses the cycle counter is put
> to?  I can run our normal regression tests, but I'd like to get a
> high-level sanity check from the clocksource folks.

I believe 9 seconds should be plenty for timekeeping, so I suspect it
should be fine. Although I've not closely checked in this case if the
tile clocksource is used for other purposes, so do let me know if you
see any issues in your testing.

Additionally Thomas has a patch (which I thought already landed in
3.0-rc, but maybe not) which should pick a shift value that gets us
close to 600 second intervals (hardware allowing), allowing for much
longer NOHZ periods.

The important part is that we're centralizing this logic so it can be
properly adjusted without having to tune 30-some clocksources
individually.

Thanks for the testing and review!
-john



