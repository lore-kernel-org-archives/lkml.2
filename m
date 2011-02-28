Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1B1TLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:11:14 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40437 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752852Ab1B1TLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:11:13 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+Y+C0TujKY+Il2gqyUf2vXHX+QnqixhQPEeCI1Na
	d+unIaRbBIeOaU
Date: Mon, 28 Feb 2011 20:10:58 +0100
From: torbenh <torbenh@gmx.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-audio-user@lists.linuxaudio.org,
        linux-audio-dev@lists.linuxaudio.org
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110228191058.GL2977@siel.b>
Mail-Followup-To: Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, linux-audio-user@lists.linuxaudio.org,
	linux-audio-dev@lists.linuxaudio.org
References: <1294890890.8089.39.camel@marge.simson.net>
 <1295270160.30950.96.camel@laptop>
 <20110215154612.GI3055@siel.b>
 <1297788210.15382.51.camel@marge.simson.net>
 <20110218110955.GA3124@siel.b>
 <1298033412.8735.30.camel@marge.simson.net>
 <20110222122449.GC11548@siel.b>
 <1298386073.8036.49.camel@marge.simson.net>
 <20110228175303.GG2977@siel.b>
 <1298917794.9387.31.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298917794.9387.31.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry... i cced the old ML addresses :S
fixing the CC now.


On Mon, Feb 28, 2011 at 07:29:54PM +0100, Mike Galbraith wrote:
> On Mon, 2011-02-28 at 18:53 +0100, torbenh wrote:
> > 
> > On Tue, Feb 22, 2011 at 03:47:53PM +0100, Mike Galbraith wrote:
> > > On Tue, 2011-02-22 at 13:24 +0100, torbenh wrote:
> > > > On Fri, Feb 18, 2011 at 01:50:12PM +0100, Mike Galbraith wrote:
> >  
> > > > > Sounds like you just want to turn CONFIG_RT_GROUP_SCHED off.
> > > > 
> > > > but distros turn it on.
> > > > we could prevent debian from turning it on. 
> > > > now opensuse 11.4 has turned it on.
> > > 
> > > If you or anyone else turns on RT_GROUP_SCHED, you will count your
> > > beans, and pay up front, or you will not play.  That's a very sensible
> > > policy for realtime.
> > 
> > this probably means that generic computer distros should not turn this
> > option on ?
> 
> Yeah, agreed, not for a great default config, but only because
> newfangled automation thingies can't (possibly?) deal with it sanely.

but this is excactly the reason, why i would advocate rt_runtime to be
in a separate cgroups system.
any admin who wants to limit RT runtime could still do it.
people who dont care, and just want their cfs slices configured, can
still do it.

>  
> > > If systemd deals with it at all, seems to me it can only make a mess of
> > > it.  But who knows, maybe they made a clever allocator.  If they didn't,
> > > they'll need an escape hatch methinks.
> > 
> > the problem is that audio applications can not really pre allocate their
> > cpu needs. user can add processing plugins until he pushes his machine
> > to the limit. (or the cgroup where his process is running in)
> > 
> > we dont really have a mechanism for plugins to publish their needed
> > cycles.
> 
> I can't see how it could matter what any individual group of arbitrary
> groups N (who can appear/disappear in the blink of an eye) advertises as
> it's wish of the instant.  "Hard" + "Arbitrary" doesn't compute for me.

i dont really understnad this statement.

> 
> 	-Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
torben Hohn
