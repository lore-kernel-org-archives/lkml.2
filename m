Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2J1OFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 10:05:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64367 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2J1OFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 10:05:49 -0400
Date: Sun, 28 Oct 2012 15:05:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched, autogroup: fix crash on reboot when autogroup is
 disabled
Message-ID: <20121028140544.GA28216@gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
 <1350654126.2768.5.camel@twins>
 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
 <1350736696.5123.24.camel@maggy.simpson.net>
 <1351283371.16639.111.camel@maggy.simpson.net>
 <1351362370.4503.3.camel@maggy.simpson.net>
 <20121028102520.GA7711@gmail.com>
 <1351430004.8685.17.camel@maggy.simpson.net>
 <20121028131950.GA15159@gmail.com>
 <1351431201.8685.22.camel@maggy.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351431201.8685.22.camel@maggy.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sun, 2012-10-28 at 14:19 +0100, Ingo Molnar wrote: 
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Sun, 2012-10-28 at 11:25 +0100, Ingo Molnar wrote: 
> > > > * Mike Galbraith <efault@gmx.de> wrote:
> > > > 
> > > 
> > > > > No knobs, no glitz, nada, just a cute little thing folks can turn
> > > > > on if they don't want to muck about with cgroups and/or systemd.
> > > > 
> > > > Please also keep the Kconfig switch and reuse it to turn on 
> > > > the 'autogroups' knob.
> > > > 
> > > > That way people with existing .config's don't have to change 
> > > > a thing to get this functionality.
> > > 
> > > The Kconfig option is still there.  The noautogroup -> 
> > > autogroup arg change just makes it off by default (since an 
> > > on/off switch would have to be a full move everybody thing 
> > > post 8323f26ce race fix), so distros can make it available in 
> > > their swiss army knife config, but it'll be out of the way 
> > > unless specifically asked for by the user at boot.
> > > 
> > > I can make it default 'on' by removing that arg change if you 
> > > think that's the better way to go, but opt in at boot sounded 
> > > better to me given there is no runtime on/off switch at all 
> > > now.
> > 
> > If I got your patch right then adding a command line option to 
> > turn it on will disable it in essence for pretty much everyone 
> > who has CONFIG_SCHED_AUTOGROUP=y in their .config today.
> 
> With no user intervention, yes.

'No user intervention' is what happens with new kernel 
commandline options, in 99.9999% of the cases.

> > The patch should not change the defaults for existing 
> > .config's.
> > 
> > I.e. if autogroups was off, it should stay off, but if 
> > autogroups was enabled in the .config and the kernel booted 
> > with it enabled, then it should continue to do so in the 
> > future as well.
> > 
> > Adding a boot tweak and removing the runtime knobs is OK - 
> > changing the current default functionality is not.
> 
> Ok, I'll whack the arg change and respin.

Thanks!

I'd also suggest to still expose the state of autosched in 
/proc/sys, read-only, so that its status can be checked.

	Ingo
