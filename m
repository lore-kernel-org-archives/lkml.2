Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1FWTDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:03:50 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41130 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759745Ab1FWTDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:03:48 -0400
Date: Thu, 23 Jun 2011 19:03:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>,
        PaulMundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-ID: <20110623190327.GA607@localhost.ucw.cz>
References: <20110609130647.937204592@chello.nl> <20110609131307.493181962@chello.nl> <20110609130617.f8aca966.akpm@linux-foundation.org> <20110609202707.GA28951@elte.hu> <1307652883.2497.1028.camel@laptop> <20110609140714.fc9ea187.akpm@linux-foundation.org> <alpine.LSU.2.00.1106091655560.2710@sister.anvils> <1307705311.3941.118.camel@twins> <1307709030.3941.134.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307709030.3941.134.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vvOn Fri 2011-06-10 14:30:30, Peter Zijlstra wrote:
>On Fri, 2011-06-10 at 13:28 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-06-09 at 16:57 -0700, Hugh Dickins wrote:
> > > 
> > > All console-related activity curently happens under spin_lock_irqsave(&console_lock). 
> > > This causes interrutps to be blocked for 1-2 milliseconds with vgacon, and for
> > > hundreds of milliseconds with fbdevs.  This results in network overruns, audio
> > > dropouts, dropped characters on serial ports and other such nice things.
> > 
> > Hmm, with these proposed patches we're actually back to that. I wonder
> > if fbdev is still that crappy..
> 
> So I tried adding a fbcon to my test box (not that it actually has a
> display, but who cares) and disabled lockdep (otherwise that's all I can
> catch on the latency tracer) to see if I could see whopping horrid
> latencies there, but I'm afraid I either failed to set things up
> properly or my fbcon isn't sucky enough.
> 
> What I did was enable:
> 
> CONFIG_FB=y
> CONFIG_FB_SIS=y
> CONFIG_FB_SIS_315=y (the board has XGI z7)

sis will be accelerated. Try vesafb; scrolling should be horrible.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
