Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1DDN5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:57:15 -0400
Received: from service87.mimecast.com ([94.185.240.25]:53802 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751670Ab1DDN5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:57:14 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: david@lang.hm, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, Detlef Vollmann <dv@vollmann.ch>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
In-Reply-To: <20110404133104.GA23266@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	 <201104031726.37420.arnd@arndb.de>
	 <20110403160324.GA8050@n2100.arm.linux.org.uk>
	 <201104040259.26601.arnd@arndb.de>
	 <1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
	 <20110404112104.GB19854@n2100.arm.linux.org.uk>
	 <1301923457.417.34.camel@e102391-lin.cambridge.arm.com>
	 <20110404133104.GA23266@n2100.arm.linux.org.uk>
Organization: ARM Ltd
Date: Mon, 04 Apr 2011 14:57:25 +0100
Message-ID: <1301925445.417.54.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 04 Apr 2011 13:56:59.0667 (UTC) FILETIME=[2AE08E30:01CBF2D0]
X-MC-Unique: 111040414570402501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 14:31 +0100, Russell King - ARM Linux wrote:
> On Mon, Apr 04, 2011 at 02:24:17PM +0100, Marc Zyngier wrote:
> > On Mon, 2011-04-04 at 12:21 +0100, Russell King - ARM Linux wrote:
> > > Whether its worth it or not is questionable - the above is more lines
> > > of code than many of the existing implementations, and we're not going
> > > to shrink the existing implementations by much (maybe one to three
> > > lines.)  The only thing we gain is the ability to select an implementation
> > > at runtime.
> > 
> > I believe this last point to be rather important if we plan to have this
> > mythical single kernel covering several architectures. It's also nice
> > for the A15 to be able to use some default sched_clock() implementation
> > as a fallback if the generic timers are not available for some reason.
> 
> If ARM are going to architect a set of timers into the hardware, let's
> make sure that all such hardware has them so we can dig ourselves out
> of this crappy mess that we find ourselves in today.

As far as I know, A15 always has a set of generic timers.

It may be that they are not available (frequency not programmed into the
CNTFREQ register), or that someone decided to use a better alternative
(for some particular interpretation of "better").

Overall, it seems like we need some degree of flexibility to have
several sched_clock() implementations within a single image, whether it
is to support multiple platforms, or to allow a single architecture to
pick the best alternative given a set of initial conditions.

	M.
-- 
Reality is an implementation detail.


