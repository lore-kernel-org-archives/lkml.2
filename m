Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1ERU3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:29:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1ERU32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:29:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 1/3] PM: Introduce DEVFREQ: generic DVFS framework with device-specific OPPs
Date: Wed, 18 May 2011 22:29:38 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: myungjoo.ham@gmail.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Colin Cross <ccross@google.com>, Nishanth Menon <nm@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com> <201105182202.46820.rjw@sisk.pl> <20110518202126.GC8887@elf.ucw.cz>
In-Reply-To: <20110518202126.GC8887@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105182229.39110.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011, Pavel Machek wrote:
> Hi!
> 
> > > >> +#define dev_dbg_once(dev, fmt, ...)                          \
> > > >> +     if (!once) {                                            \
> > > >> +             once = 1;                                       \
> > > >> +             dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
> > > >> +     }
> > > >
> > > > Why do you need this?
> > > >
> > > 
> > > This devfreq_do is going to be called periodically; thus, I want to
> > > print a message if there is an error, but not too many messages with
> > > the repeated calls.
> > > 
> > > Besides, I'd change the macro like this:
> > > 
> > > #define dev_dbg_once(dev, fmt, ...)                          \
> > >      {                                                                \
> > >              static int once;                                   \
> > >              if (!once) {                                            \
> > >                      once = 1;                                       \
> > >                      dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
> > >              }                                                 \
> > >      }
> > > 
> > > so that "static int once;" in functions can be removed.
> > 
> > That's a good change in my opinion, but since there is the dynamic debug
> > feature, I don't think you need to worry too much about that (the user
> > can always disable output from those dev_dbg() statements if they generate
> > too much noise).
> 
> Well... we do print-once in other places, too. And that way, we can
> maybe enable those prints by default...

I'm not sure what you mean?

Rafael
