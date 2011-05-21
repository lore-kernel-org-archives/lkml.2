Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab1EUPkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:40:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:22844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160Ab1EUPkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:40:22 -0400
Message-Id: <aefc95$1usaq@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,247,1304319600"; 
   d="scan'208";a="2060634"
Date: Sat, 21 May 2011 16:40:17 +0100
To: Luke-Jr <luke@dashjr.org>
Subject: Re: Major 2.6.38 regression ignored?
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201105211123.56053.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 May 2011 11:23:53 -0400, "Luke-Jr" <luke@dashjr.org> wrote:
> On Saturday, May 21, 2011 4:41:45 AM Chris Wilson wrote:
> > On Fri, 20 May 2011 11:08:56 -0700, Ray Lee <ray-lk@madrabbit.org> wrote:
> > > [ Adding Chris Wilson (author of the problematic patch) and Rafael
> > > Wysocki to the message ]
> > > 
> > > On Fri, May 20, 2011 at 10:06 AM, Luke-Jr <luke@dashjr.org> wrote:
> > > > I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month
> > > > ago against 2.6.38. Now 2.6.39 was just released without the
> > > > regression being addressed. This bug makes the system unusable... Some
> > > > guys on IRC suggested I
> > > > email, so here it is.
> > > 
> > > See the bugzilla entry for the bisection history.
> > 
> > Which has nothing to do with Luke's bug. Considering the thousand things
> > that can go wrong during X starting, without a hint as to which it is nigh
> > on impossible to debug except by trial and error. If you set up
> > netconsole, does the kernel emit an OOPS with it's last dying breath?
> 
> Why assume it's a different bug? I would almost wonder if it might affect 
> all Sandy Bridge GPUs. In any case, I no longer have the original 
> motherboard (it was recalled, as I said in the first post), nor even the 
> revision of it (it had other issues that weren't being fixed). I *assume* I 
> will have the same problem with my new motherboard (Intel DQ67SW), but I 
> haven't verified that yet. I'll be sure to try a netconsole when I have to 
> reboot next and get a chance to try the most recent 2.6.38 and .39 kernels, 
> but at the moment it seems reasonable to address the problem bisected in the 
> bug, even if it turns out to be different.

The bisection is into an old DRI1 bug on 945GM. That DRI has inadequate
locking between release and IRQ and so is prone to such races as befell
Kirill should not surprise anyone. As neither UMS nor DRI supported SNB,
I can quite confidently state they are separate bugs.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
