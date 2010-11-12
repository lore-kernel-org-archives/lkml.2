Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0KLTPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:15:09 -0500
Received: from relais.videotron.ca ([24.201.245.36]:34390 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab0KLTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:15:07 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_1yzk1yLOYgi/J579mFm7Iw)"
Date: Fri, 12 Nov 2010 14:15:05 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
In-reply-to: <20101112095739.GH18358@pengutronix.de>
Message-id: <alpine.LFD.2.00.1011121406040.13911@xanadu.home>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
 <20101112095739.GH18358@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_1yzk1yLOYgi/J579mFm7Iw)
Content-type: TEXT/PLAIN; charset=iso-8859-1
Content-transfer-encoding: 8BIT

On Fri, 12 Nov 2010, Uwe Kleine-König wrote:

> On Thu, Nov 11, 2010 at 01:33:41PM -0800, john stultz wrote:
> > Instead, I'd use this extension at the sched_clock level, where it
> > seems reasonable that it will be called frequently enough to not brake
> > the cnt32_to_63 magic.
> Instead of implementing sched_clock for each architecture seperatly,
> wouldn't it be nice to have a generic sched_clock that uses the
> architecture's clocksource?  I tried to implement that some time ago,
> but tglx shoot it down because of locking problems.

They also have different goals.

sched_clock: fast implementation with a moderate 
accuracy.  Used for things like scheduler time slices and printk 
timestamping, and since it is called often it needs to be as lightweight 
as possible and accuracy is secondary.

clocksource: as accurate as possible, used for POSIX timers and the 
like, and is typically more heavyweight than sched_clock().

> Maybe doing that became easier since then?

Maybe having a fallback sched_clock implementation based on clocksource 
might make sense, but the current fallback is based on jiffies which is 
probably good enough as a fallback.


Nicolas

--Boundary_(ID_1yzk1yLOYgi/J579mFm7Iw)--
