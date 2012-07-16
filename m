Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2GPLP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:15:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:52776 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2GPLPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:15:52 -0400
Date: Mon, 16 Jul 2012 13:15:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [Regression][Revert request] Excessive delay or hang during
 resume from system suspend due to a hrtimer commit
In-Reply-To: <201207161316.28875.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.02.1207161315050.32033@ionos>
References: <201207152240.50129.rjw@sisk.pl> <alpine.LFD.2.02.1207161035500.32033@ionos> <201207161316.28875.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Rafael J. Wysocki wrote:

> On Monday, July 16, 2012, Thomas Gleixner wrote:
> > On Sun, 15 Jul 2012, Rafael J. Wysocki wrote:
> > > To everyone involved: the fact that this change, which was likely to introduce
> > > regressions from the look of it alone, has been pushed to Linus (an to -stable
> > > at the same time!) so late in the cycle, is seriuosly disappointing.
> > 
> > Well, we spent an massive amount of time in testing, reviewing and
> > discussion and it definitely did not break suspend/resume here.
> 
> I'm not saying that you didn't consider it thoroughly, but unfortunately you
> did overlook this particular issue, didn't you?
> 
> > This was not pushed without a lot of thoughts and in fact what you are
> > seing is another long standing bug in the timekeeping resume code,
> > which was just papered over by the incorrect handling of the clock was
> > set cases in the other parts of the system.
> > 
> > Does the following patch fix the problem for you ?
> 
> Yes, it does, thanks!
> 
> > @John: Should that clear ntp as well or is it enough to set ntp_error
> >        to 0 ?
> > 
> > /me really goes on vacation now.
> 
> So who's going to take care of the patch? :-)

I'm still packing gear. So i'll push it into timers/urgent.

