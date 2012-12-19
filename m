Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2LSKhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:37:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54110 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LSKhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:37:12 -0500
Date: Wed, 19 Dec 2012 10:37:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [RFC PATCH 4/5] clockevents: Add generic timer broadcast
 function
Message-ID: <20121219103708.GE32484@e106331-lin.cambridge.arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
 <1355832418-31692-5-git-send-email-mark.rutland@arm.com>
 <50D0EB69.10901@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <50D0EB69.10901@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Dec 2012 10:37:09.0179 (UTC) FILETIME=[CC2B08B0:01CDDDD4]
X-MC-Unique: 112121910371006101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:17:13PM +0000, Stephen Boyd wrote:
> Minor nit
> 
> On 12/18/12 04:06, Mark Rutland wrote:
> > diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> > index c2dd022..ec22a80 100644
> > --- a/kernel/time/tick-broadcast.c
> > +++ b/kernel/time/tick-broadcast.c
> > @@ -86,6 +87,12 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
> >  	return (dev && tick_broadcast_device.evtdev == dev);
> >  }
> >  
> > +static void err_broadcast(const struct cpumask *mask)
> > +{
> > +	pr_crit_once("Attempted to broadcast tick, but no broadcast mechanism "
> > +		     "present. Some CPUs may be unresponsive.");
> 
> This is missing a newline. You may also want to put the string on a
> single line so we can easily grep for it in the sources.

Whoops, fixed. I'll change both strings to be single line.

> > @@ -105,6 +112,14 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
> >  	 */
> >  	if (!tick_device_is_functional(dev)) {
> >  		dev->event_handler = tick_handle_periodic;
> > +		if (!dev->broadcast)
> > +			dev->broadcast = tick_broadcast;
> > +		if (!dev->broadcast) {
> > +			pr_warn_once("%s depends on broadcast, but no "
> > +				     "broadcast function available\n",
> 
> Same one line comment here. I thought checkpatch didn't complain anymore.

In fact it actively warns. Not sure how I missed that.

Thanks,
Mark.


