Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1LJAZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 19:25:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40241 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab1LJAZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 19:25:57 -0500
Date: Sat, 10 Dec 2011 00:25:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5 v2] ARM: OMAP1: recalculate loops per jiffy after
	dpll1 reprogram
Message-ID: <20111210002503.GA6018@n2100.arm.linux.org.uk>
References: <1322364751-29980-6-git-send-email-jkrzyszt@tis.icnet.pl> <1322526332-14088-1-git-send-email-jkrzyszt@tis.icnet.pl> <20111209084245.GB14547@n2100.arm.linux.org.uk> <201112091100.01690.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112091100.01690.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 11:00:01AM +0100, Janusz Krzysztofik wrote:
> On Friday 09 of December 2011 at 09:42:45, Russell King - ARM Linux wrote:
> > On Tue, Nov 29, 2011 at 01:25:32AM +0100, Janusz Krzysztofik wrote:
> > > However, the result of cpufreq_scale() differs from that of
> > > (re)calibrate_delay() by ca. 6%, i.e., 70.40 vs. 74.54. Please advise if
> > > this approximation is acceptable.
> > 
> > You don't say which figure is what.
> 
> Hi,
> Those were BogoMIPS, which you were talking about in your comment 
> (http://www.spinics.net/lists/linux-omap/msg60811.html).

I realise that.  But which is which - is 70.40 from recalibrate_delay
or is it 74.54?  Your message is too vague to be able to interpret your
results because it's impossible to work out what figure refers to which
method.

> > Note that calibrate_delay() is itself inaccurate - the loops_per_jiffy
> > is the number of loops which can be executed between two timer ticks
> > _minus_ the time to process the timer interrupt itself.  So, it's
> > actually always a little less than the theoretical number of loops
> > within that time period.
> 
> I see. Then, in case of a machine always booting at, let's say, 12 and
> then reprogrammed to 150 MHz, we actually scale up that less then the
> theoretical number, with a side effect of scaling up its error as well.
> Perhaps in this case, when the machine is going to run at that target
> rate until rebooted, we should rather decide to recalibrate to keep
> that error proportionally small compared to the target loops per
> jiffy value, like it worked in my initial proposal? I think that
> your argument about unnecessarily wasting 10s of milliseconds has
> marginal importance here because we will be redoing that calibration
> only once, at boot time, and never later until next reboot.

It really doesn't matter - udelay() etc is not designed to be mega
accurate but good enough.  The fact is that it has always produced a
delay of approximately the value requested of it (and normally it
would produce a slightly shorter delay) and that's a fact of life
that driver authors should already be dealing with.

So, your patch is fine.
