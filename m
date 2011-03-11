Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1CKLN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:13:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48043 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752069Ab1CKLNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:13:25 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18e6wolDtAeZ51YadMhsP5kpWce2I/c+rqEL0bx4Z
	sxzHzGBbADeBeG
Date: Fri, 11 Mar 2011 12:13:21 +0100
From: torbenh <torbenh@gmx.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, tglx@linutronix.de
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110311111321.GA5553@siel.b>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
	richard.cochran@omicron.at, tglx@linutronix.de
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
 <1299180844.28285.111.camel@work-vm>
 <20110304064639.GD3824@riccoc20.at.omicron.at>
 <1299355687.28285.130.camel@work-vm>
 <20110306132834.GA11790@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110306132834.GA11790@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 02:28:36PM +0100, Richard Cochran wrote:
> On Sat, Mar 05, 2011 at 12:08:07PM -0800, john stultz wrote:
> > On Fri, 2011-03-04 at 07:46 +0100, Richard Cochran wrote:
> > > I do think a software only PHC will make it easier for people to get
> > > started with the new interface. I have been carrying along such a
> > > patch privately for my own testing.
> > 
> > Consistency is but a hobgoblin... :)
> > 
> > But seriously, do forgive me if I misunderstood your earlier patches
> > with this respect. I thought it was just exporting CLOCK_REALTIME
> > directly through a new interface/clockid (which would be duplicative).
> 
> You are right, I was doing that, but the purpose was for testing.
> 
> I am not sure where Torben is going with his idea. In order to figure
> out meaningful clock adjustments, you need the clock's timestamps on
> the PTP packet tx/rx events. Implementing an internal clock correction
> with no connection to the network stack might still be interesting,
> but I think having the timestamps is much more useful.

I am planning to enable the networking stack to timestamp using
arbitrary clock id. 
But that means adding an ioctl. So there is going to be a lot of
critical review, and questions asked. 

On the audio lists, we have a guy now claiming that software ptp would
confuse the whole h/w ptp infrastructure. His main agenda seems to be to
prevent a software only ptp/avb implementatation.
I cant imagine how a slave clock can confuse a master clock.
And emission of audio stream packets does not need to be accurate to the
nanosecond.

I am a bit confused now, because i initially thought, i could quote that
guy to prove that an avb master clock might not necessarily be suitable
to become CLOCK_REALTIME. 

I am still assuming this. But i dont really have proof.
This might block this.

> 
> Let's wait and see what Torben says once he come back from travel.
> 
> Thanks,
> 
> Richard

-- 
torben Hohn
