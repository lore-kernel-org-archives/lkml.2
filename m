Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1DAEtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:49:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16423 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1DAEtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:49:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6302"; a="83342072"
From: David Brown <davidb@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
	<AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
	<alpine.LFD.2.00.1103301814250.28032@xanadu.home>
	<alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
	<alpine.LFD.2.00.1103302255280.28032@xanadu.home>
	<alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
	<alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	<20110331080634.GA18022@elte.hu>
	<20110331083044.GB14323@n2100.arm.linux.org.uk>
	<alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
	<20110331164539.GB19452@n2100.arm.linux.org.uk>
	<AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com>
	<alpine.LFD.2.00.1103311429590.28032@xanadu.home>
	<AANLkTi=kbozPcWEk9wVZb7emSWx48BJQS=7Uzaya9Lor@mail.gmail.com>
	<alpine.LFD.2.00.1103311649450.28032@xanadu.home>
Date: Thu, 31 Mar 2011 21:50:58 -0700
In-Reply-To: <alpine.LFD.2.00.1103311649450.28032@xanadu.home> (Nicolas
	Pitre's message of "Thu, 31 Mar 2011 18:49:11 -0400 (EDT)")
Message-ID: <8ya39m2mv65.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31 2011, Nicolas Pitre wrote:

> Leaf nodes on ARM are people coming from corporate background with the 
> old school software development methodologies.  They do it as a _job_ 
> first and foremost.  They only work on Linux because that's what their 
> boss assigned them to. Don't get me wrong: that doesn't mean they are 
> bad people.  Simply that they are not into it for the public recognition 
> (or flaming) from their peers.  Once their code works they lose interest 
> and move on.  That mindset is extremely hard to change and take time, on 
> a scale of years.  Much more time than required to produce the code 
> needed to support that new SOC out of the pipeline.  There are notable 
> exceptions obviously.  But this is still a scalability problem in 
> itself.  So we need men-in-the-middle attacks.

An additional mindset that is difficult to work with in this environment
is that the corporate development methodology has a focus on schedules
and deliverables.  Even people who would otherwise like to contribute
will have pressure to get something done.  Many think of "submit to
mainline" is kind of a last step in a development process, instead of
even a goal to accomplish.

When we push back, there is a good chance they just won't bother, not
because they don't want to do it, but because it doesn't fit a schedule,
and there is already something else for them to work on.

So what's the right answer here.  Practically, someone just sent out a
fairly complete DMA driver for a new MSM device.  Naturally, this
hardware is nothing like anyone else's DMA, but the driver itself pretty
much independent from other kernel APIs.  It isn't even similar to the
existing DMA driver in the MSM.  With it are patches to ifdef-up various
drivers to use the appropriate DMA.

The DMA code, by itself, seems reasonably well written (with some
cleanup and such needed), but it makes everything that uses it messy.
In this particular case, DMA engine will probably need some work to
either incorporate the unique capabilities of this hardware, or at least
allow them to be used.  The author probably won't be able to do this on
their own.

I could pull the driver into the tree, and now we have yet another
driver with yet another API.  If I push back, realistically, it will
probably end up out-of-tree, along with everything that depends on it.

Up until now, it seems that attitude has been that it is better to be
in-tree than out of tree, but are we getting too much stuff to continue
that?

Today, most of the MSM code lives out of tree.  The QuIC tree for MSM
(currently based off of 2.6.35):

  git diff --stat v2.6.35..HEAD | tail -1
   3432 files changed, 1144473 insertions(+), 17315 deletions(-)
  git diff --stat v2.6.35..HEAD arch/arm/mach-msm | tail -1
   595 files changed, 286054 insertions(+), 1928 deletions(-)

There's a large amount of work just to get the code up to kernel
standards (the coding style has been fairly well enforced), and there is
constant development for new hardware.

Thanks,
David Brown

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
