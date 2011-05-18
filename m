Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1ERUV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:21:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47302 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752824Ab1ERUV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:21:28 -0400
Date: Wed, 18 May 2011 22:21:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: myungjoo.ham@gmail.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Colin Cross <ccross@google.com>, Nishanth Menon <nm@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/3] PM: Introduce DEVFREQ: generic DVFS framework
 with device-specific OPPs
Message-ID: <20110518202126.GC8887@elf.ucw.cz>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
 <201105180036.03836.rjw@sisk.pl>
 <BANLkTi=_1DJPS+6goLA-UvdHJXEoPWBF2w@mail.gmail.com>
 <201105182202.46820.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105182202.46820.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> +#define dev_dbg_once(dev, fmt, ...)                          \
> > >> +     if (!once) {                                            \
> > >> +             once = 1;                                       \
> > >> +             dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
> > >> +     }
> > >
> > > Why do you need this?
> > >
> > 
> > This devfreq_do is going to be called periodically; thus, I want to
> > print a message if there is an error, but not too many messages with
> > the repeated calls.
> > 
> > Besides, I'd change the macro like this:
> > 
> > #define dev_dbg_once(dev, fmt, ...)                          \
> >      {                                                                \
> >              static int once;                                   \
> >              if (!once) {                                            \
> >                      once = 1;                                       \
> >                      dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
> >              }                                                 \
> >      }
> > 
> > so that "static int once;" in functions can be removed.
> 
> That's a good change in my opinion, but since there is the dynamic debug
> feature, I don't think you need to worry too much about that (the user
> can always disable output from those dev_dbg() statements if they generate
> too much noise).

Well... we do print-once in other places, too. And that way, we can
maybe enable those prints by default...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
