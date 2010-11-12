Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0KLLJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:09:22 -0500
Received: from www.tglx.de ([62.245.132.106]:56616 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab0KLLJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:09:21 -0500
Date: Fri, 12 Nov 2010 12:08:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@stericsson.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        john stultz <johnstul@us.ibm.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
In-Reply-To: <4CDD18F9.5090005@stericsson.com>
Message-ID: <alpine.LFD.2.00.1011121141040.2900@localhost6.localdomain6>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com> <20101112095739.GH18358@pengutronix.de> <4CDD120A.2050401@stericsson.com> <alpine.LFD.2.00.1011121130350.2900@localhost6.localdomain6>
 <4CDD18F9.5090005@stericsson.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1303247758-1289560133=:2900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1303247758-1289560133=:2900
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

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

I still don't like the special flag approach. It's mixing
concepts. clock->read() != sched_clock().

I can understand that you want to reuse the conversion factors etc in
struct clocksource, but we have to be more clever than special flags
and magic functions to install sched_clock.

I could accept a solution where we have generic infrastructure which
uses clock->read() and does the magic 63 bit expansion and you'd
simply do sched_clock_install(struct clocksource *) to explicitely
assign that clocksource as sched_clock. No magic, straight forward and
simple.

> Incidentally the dual use of a single free-running timer as both
> single clocksource and sched_clock() baseline seem to creep up in
> a lot of embedded platforms...

No argument about that.

Thanks,

	tglx
---1463795968-1303247758-1289560133=:2900--
