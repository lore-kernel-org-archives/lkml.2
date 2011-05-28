Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1E1Nhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 09:37:35 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:42418 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab1E1Nhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 09:37:34 -0400
X-Greylist: delayed 1042 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 May 2011 09:37:34 EDT
Date: Sat, 28 May 2011 17:19:20 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Luke-Jr <luke@dashjr.org>, Ray Lee <ray-lk@madrabbit.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: Major 2.6.38 / 2.6.39 regression ignored?
Message-ID: <20110528131920.GA10467@tugrik.mns.mnsspb.ru>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefc95$1usaq@orsmga001.jf.intel.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris, everyone,

On Sat, May 21, 2011 at 04:40:17PM +0100, Chris Wilson wrote:
> On Sat, 21 May 2011 11:23:53 -0400, "Luke-Jr" <luke@dashjr.org> wrote:
> > On Saturday, May 21, 2011 4:41:45 AM Chris Wilson wrote:
> > > On Fri, 20 May 2011 11:08:56 -0700, Ray Lee <ray-lk@madrabbit.org> wrote:
> > > > [ Adding Chris Wilson (author of the problematic patch) and Rafael
> > > > Wysocki to the message ]
> > > > 
> > > > On Fri, May 20, 2011 at 10:06 AM, Luke-Jr <luke@dashjr.org> wrote:
> > > > > I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month
> > > > > ago against 2.6.38. Now 2.6.39 was just released without the
> > > > > regression being addressed. This bug makes the system unusable... Some
> > > > > guys on IRC suggested I
> > > > > email, so here it is.
> > > > 
> > > > See the bugzilla entry for the bisection history.
> > > 
> > > Which has nothing to do with Luke's bug. Considering the thousand things
> > > that can go wrong during X starting, without a hint as to which it is nigh
> > > on impossible to debug except by trial and error. If you set up
> > > netconsole, does the kernel emit an OOPS with it's last dying breath?
> > 
> > Why assume it's a different bug? I would almost wonder if it might affect 
> > all Sandy Bridge GPUs. In any case, I no longer have the original 
> > motherboard (it was recalled, as I said in the first post), nor even the 
> > revision of it (it had other issues that weren't being fixed). I *assume* I 
> > will have the same problem with my new motherboard (Intel DQ67SW), but I 
> > haven't verified that yet. I'll be sure to try a netconsole when I have to 
> > reboot next and get a chance to try the most recent 2.6.38 and .39 kernels, 
> > but at the moment it seems reasonable to address the problem bisected in the 
> > bug, even if it turns out to be different.
> 
> The bisection is into an old DRI1 bug on 945GM. That DRI has inadequate
> locking between release and IRQ and so is prone to such races as befell
> Kirill should not surprise anyone. As neither UMS nor DRI supported SNB,
> I can quite confidently state they are separate bugs.
> -Chris

I see DRI1 is maybe buggy and old, but still, pre-kms X used to work ok
on kernels < 2.6.38, and starting from 2.6.38 the system is just
unusable because X either crashes the kernel (2.6.38), or does not start
at all (2.6.39):

https://bugzilla.kernel.org/show_bug.cgi?id=36052


It's a regression. It's blocking me to upgrade to newer kernels. I've
done my homework -- digged it and came with detailed OOPS on netconsole
and bisected to single commit. Could this please be fixed?


Thanks,
Kirill
