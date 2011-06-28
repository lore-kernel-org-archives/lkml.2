Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1F1FTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 01:19:23 -0400
Received: from 1wt.eu ([62.212.114.60]:37269 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab1F1FTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 01:19:13 -0400
Date: Tue, 28 Jun 2011 07:17:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: john stultz <johnstul@us.ibm.com>
Cc: Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110628051732.GB15699@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr> <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 07:25:31PM -0700, john stultz wrote:
> On Sat, Apr 30, 2011 at 10:39 AM, Faidon Liambotis <paravoid@debian.org> wrote:
> > We too experienced problems with just the G6 blades at near 215 days uptime
> > (on the 19th of April), all at the same time. From our investigation, it
> > seems that their cpu_clocks jumped suddenly far in the future and then
> > almost immediately rolled over due to wrapping around 64-bits.
> >
> > Although all of their (G6s) clocks wrapped around *at the same time*, only
> > one
> > of them actually crashed at the time, with a second one crashing just a few
> > days later, on the 28th.
> >
> > Three of them had the following on their logs:
> > Apr 18 20:56:07 hn-05 kernel: [17966378.581971] tap0: no IPv6 routers
> > present
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.365550] BUG: soft lockup - CPU#4
> > stuck for 17163091968s! [kvm:25913]
> 
> So, did this issue ever get any traction or get resolved?

I'm not aware of any news on the subject unfortunately. We asked our customer
to reboot both machines one week apart so that in 6 months they don't crash at
the same time :-/

(...)
> That said, I didn't see from any of the backtraces in this thread why
> the system actually crashed.  The softlockup message on its own
> shouldn't do that, so I suspect there's still a related issue
> somewhere else here.

One of the traces clearly showed that the kernel's uptime had wrapped
or jumped, because the uptime suddenly jumped forwards to something
like 2^32/HZ seconds IIRC.

Thus it is possible that we have two bugs, one on the clock making it
jump forwards and one somewhere else causing an overflow when the clock
jumps too far.

Regards,
Willy

