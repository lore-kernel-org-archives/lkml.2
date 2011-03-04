Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab1CDLGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:06:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58291 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752084Ab1CDLGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:06:10 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19603k5/8t6s3zlk5OgDTbIWtNVie39b1qMwwOoDc
	Xb0xXMftPwSf05
Date: Fri, 4 Mar 2011 12:06:06 +0100
From: torbenh <torbenh@gmx.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, tglx@linutronix.de
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110304110606.GB3237@siel.b>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
	richard.cochran@omicron.at, tglx@linutronix.de
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
 <1299180844.28285.111.camel@work-vm>
 <20110304064639.GD3824@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304064639.GD3824@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 07:46:39AM +0100, Richard Cochran wrote:
> On Thu, Mar 03, 2011 at 11:34:04AM -0800, john stultz wrote:
> > On Thu, 2011-03-03 at 18:26 +0100, Torben Hohn wrote:
> > > First version of a software clock. Not very useful yet,
> > > as it doesnt generate events, but at least it allows
> > > for testing the ptp framework without special hardware.
> > 
> > So in the past, I pushed back on Richard for having something similar,
> > as I'm not psyched about duplicating interfaces. However, your
> > implementation is CLOCK_MONOTONIC_RAW instead of CLOCK_REALTIME and it
> > keeps the adjustments internal, I'm not as opposed.
> 
> (Aha! So it is okay after all ;)
> 
> I do think a software only PHC will make it easier for people to get
> started with the new interface. I have been carrying along such a
> patch privately for my own testing.

can you post your patch then ?
if john likes somthing better in my implementation, we should merge
them.

i will be away for the next week, so its probably up to you.

i am still trying to find out, whether 802.1AS will spec accurate ptp
clocks. i have the feeling that they wont.
the main concern is synchronicity of the clock inside all devices of the
timing domain. that this clock i running at the same frequency as the
wallclock is not important.

here is a pretty confused mail about this:
http://article.gmane.org/gmane.comp.audio.jackit/23606

i hope this thread will yield more useful information as it develops.

i am currently acting under the assumption, that a device like this:
http://www.xmos.com/products/reference-designs/avbl2
would need to be the ptp master when the computer doesnt have h/w
timestamping in its NIC.
i am also assuming that the clock in that device would be crappy.

so we wouldnt want to servo CLOCK_REALTIME after that crappy clock.
but we want an instance of that clock as accurate as possible inside 
the computer. so that we can bind streaming apps to this clock.

-- 
torben Hohn
