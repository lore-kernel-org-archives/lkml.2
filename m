Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1ANVoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:44:12 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:35495 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab1ANVoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:44:08 -0500
Date: Fri, 14 Jan 2011 13:43:45 -0800
From: Andres Salomon <dilinger@queued.net>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com,
        dsd@laptop.org
Subject: Re: [PATCH v2 01/15] x86/e820: remove conditional early mapping in
 parse_e820_ext
Message-ID: <20110114134345.712e2e29@queued.net>
In-Reply-To: <20110114105709.GA7562@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>
	<20101230083745.GC11721@angua.secretlab.ca>
	<20110104130839.GA21359@www.tglx.de>
	<20110114081446.GC21832@angua.secretlab.ca>
	<20110114105709.GA7562@www.tglx.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011 11:57:09 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> * Grant Likely | 2011-01-14 01:14:46 [-0700]:
> 
> >Hey Sebastian,
> Hi Grant,
> 
> thanks for doing this.
> 
> >Can you please repost this series after the merge window closes?
> >Some of the patches have been reworked and reposted, but I've kind
> >of lost track of which ones need my attention.  Also, some of the
> >patches have
> Yes, this was my secret plan :) I also had to rework patches because
> of other patches either because they no longer applied or because the
> code had to change in order to work again.
> 
> In case "[v2,13/15] x86/rtc: don't register rtc if we the DT blob" [0]
> goes into the category "lost track" and not "had no time to reply"
> could please take a look? The important part is where it could change
> behavior for OLPC and it migh end up without a RTC. I Cc Andres
> Salomon as might know where the RTC on OLPC is comming from.

The RTC that OLPC uses for XO-1 was interspersed w/ the power management
stuff, so it hasn't gone upstream yet (dsd is still working on the pm
stuff). Thus, for Linus kernels the XO-1 uses rtc_cmos; so yes, this
could break things.

On OLPC kernels on the XO-1, we read RTC information from the
CS5536's MSRs (note that there's nothing there that's OLPC-specific, so
this should probably become a generic geode RTC driver).  I'm unfamiliar
with the XO-1.5, but it appears we use the VX855 RTC (at least for
wakeups). I don't see a specific RTC driver for it, so I suspect it
relies on rtc_cmos.


> 
> >gone in via the tip tree, so it would be useful to regroup and figure
> >out which ones are no longer needed.
> I try to regroup and a add TIP or OF prefix.
> 
> >I'll be able to take a fresh look and pick up the ones that are ready
> >after the merge window closes.
> Okay.
> 
> >Thanks,
> >g.
> 
> [0] https://patchwork.kernel.org/patch/450681/
> 
> Sebastian
