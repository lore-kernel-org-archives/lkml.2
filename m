Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0EZNry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:47:54 -0400
Received: from www.tglx.de ([62.245.132.106]:53568 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab0EZNrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:47:51 -0400
Date: Wed, 26 May 2010 15:46:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Florian Mickler <florian@mickler.org>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1005261521510.2995@localhost.localdomain>
References: <1274482015-30899-1-git-send-email-arve@android.com> <201005242049.18920.rjw@sisk.pl> <87wrusvrqe.fsf@deeprootsystems.com> <201005250138.16293.rjw@sisk.pl> <1274863655.5882.4875.camel@twins> <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
 <1274867106.5882.5090.camel@twins> <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
 <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

On Wed, 26 May 2010, Alan Cox wrote:

> > Really, what are you getting at? Do you deny that there are programs,
> > that prevent a device from sleeping? (Just think of the bouncing
> > cows app)
> > 
> > And if you have two kernels, one with which your device is dead after 1
> > hour and one with which your device is dead after 10 hours. Which would
> > you prefer? I mean really... this is ridiculous. 
> 
> The problem you have is that this is policy. If I have the device wired
> to a big screen and I want cows bouncing on it I'll be most upset if
> instead it suspends. What you are essentially arguing for is for the
> kernel to disobey the userspace. It's as ridiculous (albeit usually less
> damaging) as a file system saying "Ooh thats a rude file name, the app
> can't have meant it, I'll put your document soemwhere else"
> 
> The whole API feels wrong to me. It's breaking rule #1 of technology "You
> cannot solve a social problem with technology". In this case you have a
> social/economic problem which is crap code. You solve it with an
> economics solution - creative incentives not to produce crap code like
> boxes that keep popping up saying "App XYZ is using all your battery" and
> red-amber-green powermeter scores in app stores.

I completely agree. 

We have already proven that the social pressure on crappy applications
works. When NOHZ was merged into the kernel we got no effect at all
because a big percentage of user space applications just used timers
at will and without any thoughts, also it unveiled busy polling and
other horrible coding constructs. So what happened ? Arjan created
powertop which lets the user analyse the worst offenders in his
system. As a result the offending apps got fixed rapidly simply
because no maintainer wanted to be on top of the powertop sh*tlist.

In the mobile app space it's basically the same problem. Users can
influence the app writers simply by voting and setting up public lists
of apps which are crappy or excellent. All it needs is a nice powertop
tool for the phone which allows the users to identify the crap on
their phones. That provides much more incentive - especially for
commercial players - to fix their crappy code.

Adding that sys_try_to_fix_crappy_userspace_code() API to the kernel
is just counter productive as it signals to the app provider: Go
ahead, keep on coding crap!

That's not a solution, that's just capitulation. 

It's absurd that some folks believe that giving up the most efficient
tool to apply pressure to crappy app providers is a good idea.

Thanks,

	tglx
