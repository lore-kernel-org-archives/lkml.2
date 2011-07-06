Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1GFGRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:17:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab1GFGRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:17:16 -0400
Date: Tue, 5 Jul 2011 23:15:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Willy Tarreau <w@1wt.eu>, Randy Dunlap <rdunlap@xenotime.net>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-Id: <20110705231515.95bc758f.akpm@linux-foundation.org>
In-Reply-To: <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	<20110428183434.GG30645@1wt.eu>
	<20110429100200.GB23293@pcnci.linuxbox.cz>
	<20110430093605.GA10529@1wt.eu>
	<20110430173905.GA25641@tty.gr>
	<BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 19:25:31 -0700 john stultz <johnstul@us.ibm.com> wrote:

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
> 

https://bugzilla.kernel.org/show_bug.cgi?id=37382 is similar - a
divide-by-zero in update_sg_lb_stats() after 209 days uptime.

Can we change this stuff so that the timers wrap after 10 minutes
uptime, like INITIAL_JIFFIES?
