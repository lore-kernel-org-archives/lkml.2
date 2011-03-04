Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab1CDLah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:30:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45557 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759294Ab1CDLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:30:36 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+Fc1ZTgXCFgwqfWhDJvAQK/g9k9bmr4yAhtXzDix
	OnNYchlTKSeVNS
Date: Fri, 4 Mar 2011 12:30:32 +0100
From: torbenh <torbenh@gmx.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110304113032.GC3237@siel.b>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
	johnstul@us.ibm.com, tglx@linutronix.de
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
 <20110304064251.GC3824@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304064251.GC3824@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 07:42:51AM +0100, Richard Cochran wrote:
> On Thu, Mar 03, 2011 at 06:26:13PM +0100, Torben Hohn wrote:
> > +config PTP_1588_CLOCK_SOFTWARE
> > +	tristate "software PTP clock"
> > +	depends on PTP_1588_CLOCK
> > +	help
> > +	  This driver adds a software PTP clock. 
> 
> As John said, this needs a longer description. You can look back at
> my V6 as an example.
> 
>   https://lkml.org/lkml/2010/9/23/220
> 
> > +static int ptp_ixp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
> 
> Once again, please rename.

i was planning to rename it.
i just posted my patches early on because i had found the permission
problem, and thought the software clock might be useful to play around
with the whole framework.
iE without the software clock, i wouldnt have found the actual problem,
because i dont have the right h/w.


> 
> Better yet, why not just use the V6 example instead?  If we are going
> to have a testing driver, then I would want the simulated ancillary
> code as well.

well... your example code messes with clock_realtime.
i was planning to emit real timed events, not just some simulation.
but i dont completely understand this part of the code yet.


> 
> > +
> > +static struct ptp_clock_info ptp_ixp_caps = {
> > +	.owner		= THIS_MODULE,
> > +	.name		= "software timer",
> > +	.max_adj	= 66666655,
> 
> You should calculate the actual limit of adjustment and use it here.

yeah. i posted it too early...
gonna fix it in the next iteration.

-- 
torben Hohn
