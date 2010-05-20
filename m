Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0ETWR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:17:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab0ETWR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:17:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Date: Fri, 21 May 2010 00:18:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
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
References: <1273810273-3039-1-git-send-email-arve@android.com> <20100520111111.333beb73@schatten.dmk.lab> <20100520112642.74d93d26@schatten.dmk.lab>
In-Reply-To: <20100520112642.74d93d26@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005210018.43576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 May 2010, Florian Mickler wrote:
> On Thu, 20 May 2010 11:11:11 +0200
> Florian Mickler <florian@mickler.org> wrote:
> 
> > On Tue, 18 May 2010 15:11:11 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > On Thu 2010-05-13 21:11:06, Arve Hj??nnev??g wrote:
> > > > Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> > > > After setting the policy to opportunistic, writes to /sys/power/state
> > > > become non-blocking requests that specify which suspend state to
> > > > enter
> > > 
> > > Yeah, one file selects behavior of another file, and to read available
> > > states for opportunistic, you have to write to file first.
> > > 
> > > I still don't like the interface.
> > > 
> > 
> > Actually, what would be a better interface? 
> > 
> > I wonder why it is not like this:

Because I think the "forced" and "opportunistic" suspend "modes" are mutually
exclusive in practice and the interface as proposed reflects that quite well.

> > /sys/power/state 
> > 	no change, works with and without opportunistic suspend the
> > 	same. Ignores suspend blockers. Really no change. (From user
> > 	perspective)
> > 
> > /sys/power/opportunistic
> > 	On / Off
> > 	While Off the opportunistic suspend is off.
> > 	While On, the opportunistic suspend is on and if there are no
> > 	suspend blockers the system goes to suspend. 
> > 
> 
> I forgot, of course there needs to be another knob to implement the
> "on" behaviour  in the opportunistic mode
> 
>  /sys/power/block_opportunistic_suspend
> 
> There you have it. One file, one purpose. 

That's getting messy IMHO.

In addition to that you get a nice race when the user writes "mem"
to /sys/power/state and opportunistic suspend happens at the same time.
If the latter wins the race, the system will suspend again immediately after
being woken up, which probably is not the result you'd like to get.

Thanks,
Rafael
