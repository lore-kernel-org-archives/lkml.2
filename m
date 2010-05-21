Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0EUGFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:05:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60026 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758066Ab0EUGE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:04:56 -0400
Date: Fri, 21 May 2010 08:04:17 +0200
From: Florian Mickler <florian@mickler.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, "Arve Hj??nnev??g" <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100521080417.7c8561a5@schatten.dmk.lab>
In-Reply-To: <201005210018.43576.rjw@sisk.pl>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	<20100520111111.333beb73@schatten.dmk.lab>
	<20100520112642.74d93d26@schatten.dmk.lab>
	<201005210018.43576.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 00:18:43 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > > Actually, what would be a better interface? 
> > > 
> > > I wonder why it is not like this:
> 
> Because I think the "forced" and "opportunistic" suspend "modes" are mutually
> exclusive in practice and the interface as proposed reflects that quite well.
> 
> > > /sys/power/state 
> > > 	no change, works with and without opportunistic suspend the
> > > 	same. Ignores suspend blockers. Really no change. (From user
> > > 	perspective)
> > > 
> > > /sys/power/opportunistic
> > > 	On / Off
> > > 	While Off the opportunistic suspend is off.
> > > 	While On, the opportunistic suspend is on and if there are no
> > > 	suspend blockers the system goes to suspend. 
> > > 
> > 
> > I forgot, of course there needs to be another knob to implement the
> > "on" behaviour  in the opportunistic mode
> > 
> >  /sys/power/block_opportunistic_suspend
> > 
> > There you have it. One file, one purpose. 
> 
> That's getting messy IMHO.
> 
> In addition to that you get a nice race when the user writes "mem"
> to /sys/power/state and opportunistic suspend happens at the same time.
> If the latter wins the race, the system will suspend again immediately after
> being woken up, which probably is not the result you'd like to get.

But I don't think there is a problem with that. If the system is
'awake' (suspend blocked) and you hit it with forced 'mem', the system
_has_ to suspend. as that is what forced "mem"  means. And if
opportunistic won the race you would _expect_ the machine to suspend
again after the wakeup (and this time for good).

But perhaps this only makes sense if you can specify different
wake-events for opportunistic and forced suspend.

This is probably some kind of bikeshed by now. I'm alright with the
status quo. For what it's worth (not much): You can add my Reviewed-By.

Cheers,
Flo

