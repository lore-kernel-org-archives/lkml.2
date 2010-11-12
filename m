Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab0KLTSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:18:36 -0500
Received: from relais.videotron.ca ([24.201.245.36]:63601 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab0KLTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:18:35 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_d+kCCqQxGLmoueiBThbhAw)"
Date: Fri, 12 Nov 2010 14:18:12 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        john stultz <johnstul@us.ibm.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
In-reply-to: <4CDD18F9.5090005@stericsson.com>
Message-id: <alpine.LFD.2.00.1011121416440.13911@xanadu.home>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
 <20101112095739.GH18358@pengutronix.de> <4CDD120A.2050401@stericsson.com>
 <alpine.LFD.2.00.1011121130350.2900@localhost6.localdomain6>
 <4CDD18F9.5090005@stericsson.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_d+kCCqQxGLmoueiBThbhAw)
Content-type: TEXT/PLAIN; charset=iso-8859-1
Content-transfer-encoding: 8BIT

On Fri, 12 Nov 2010, Linus Walleij wrote:

> Thomas Gleixner wrote:
> > On Fri, 12 Nov 2010, Linus Walleij wrote:
> >> Uwe Kleine-König wrote:
> >>
> >>> Instead of implementing sched_clock for each architecture seperatly,
> >>> wouldn't it be nice to have a generic sched_clock that uses the
> >>> architecture's clocksource?  I tried to implement that some time ago,
> >>> but tglx shoot it down because of locking problems.
> >> I was and still am a big fan of this approach, I am willing to help
> >> testing it if you want to dust off this patch set...
> > 
> > sched_clock is not necessarily the same as the current clocksource.
> 
> IIRC Uwe:s approach was that if and only if you would want to use
> the clocksource for sched_clock() you provide a special flag on
> the clocksource, and it will be attempted to be used for sched_clock().
> 
> Incidentally the dual use of a single free-running timer as both
> single clocksource and sched_clock() baseline seem to creep up in
> a lot of embedded platforms...

Sure, but the computations and associated cost around that free running 
timer are not the same in both cases.


Nicolas

--Boundary_(ID_d+kCCqQxGLmoueiBThbhAw)--
