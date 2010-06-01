Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0FAMSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:18:08 -0400
Received: from www.tglx.de ([62.245.132.106]:48672 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab0FAMSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:18:04 -0400
Date: Tue, 1 Jun 2010 14:17:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Florian Mickler <florian@mickler.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <201005302202.39511.rjw@sisk.pl> <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com> <201005312347.24251.rjw@sisk.pl>
 <AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1710233220-1275394626=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1710233220-1275394626=:2933
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 31 May 2010, Arve Hjønnevåg wrote:

> 2010/5/31 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday 31 May 2010, Arve Hjønnevåg wrote:
> >> 2010/5/30 Rafael J. Wysocki <rjw@sisk.pl>:
> > ...
> >>
> >> I think it makes more sense to block suspend while wakeup events are
> >> pending than blocking it everywhere timers are used by code that could
> >> be called while handling wakeup events or other critical work. Also,
> >> even if you did block suspend everywhere timers where used you still
> >> have the race where a wakeup interrupt happens right after you decided
> >> to suspend. In other words, you still need to block suspend in all the
> >> same places as with the current opportunistic suspend code, so what is
> >> the benefit of delaying suspend until idle?
> >
> > Assume for a while that you don't use suspend blockers, OK?  I realize you
> > think that anything else doesn't make sense, but evidently some other people
> > have that opinion about suspend blockers.
> >
> 
> It sounded like you were suggesting that initiating suspend from idle
> would somehow avoid the race condition with wakeup events. All I'm
> saying is that you would need to block suspend in all the same places.
> If you don't care about ignoring wakeup events, then sure you can
> initiate suspend from idle.

And why should you miss a wakeup there ? If you get an interrupt in
the transition, then you are not longer idle.

Thanks,

	tglx
--8323328-1710233220-1275394626=:2933--
