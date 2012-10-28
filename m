Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab2J1KZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 06:25:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58820 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2J1KZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 06:25:25 -0400
Date: Sun, 28 Oct 2012 11:25:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched, autogroup: fix crash on reboot when autogroup is
 disabled
Message-ID: <20121028102520.GA7711@gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
 <1350654126.2768.5.camel@twins>
 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
 <1350736696.5123.24.camel@maggy.simpson.net>
 <1351283371.16639.111.camel@maggy.simpson.net>
 <1351362370.4503.3.camel@maggy.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351362370.4503.3.camel@maggy.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2012-10-26 at 13:29 -0700, Mike Galbraith wrote: 
> > On Sat, 2012-10-20 at 08:38 -0400, Mike Galbraith wrote:
> > 
> > > So what I would do is either let the user decide once at boot, in which
> > > case if off, creating groups would be stupid), or, just rip autogroup
> > > completely out, since systemd is taking over the known universe anyway.
> > 
> > I'm traveling, but have somewhat functional connectivity ATM, so..
> > 
> > Peter: which would prefer.  Simple noautogroup -> autogroup one time
> > only boottime enable, and autogroup lives on (I like it for my laptop)
> > with backport for stable.
> 
> Like so, with bonus points for extra minus signs.
> 
> sched, autogroup: fix crash on reboot when autogroup is disabled
> 
> Between 8323f26ce and 800d4d30, autogroup is a wreck.  With both
> applied, all you have to do to crash a box is disable autogroup
> during boot up, then reboot.. boom, NULL pointer dereference due
> to 800d4d30 not allowing autogroup to move things, and 8323f26ce
> making that the only way to switch runqueues.
> 
> Remove all of the knobs, and make autogroup only go active if the
> user provides 'autogroup' on the command line.  This allows distros
> to offer it, once the user asks for it, it's on.  If the user then
> fiddles with cgroups, tough, once tasks are moved, autogroup won't
> mess with them again unless they call setsid().
> 
> No knobs, no glitz, nada, just a cute little thing folks can turn
> on if they don't want to muck about with cgroups and/or systemd.

Please also keep the Kconfig switch and reuse it to turn on the 
'autogroups' knob.

That way people with existing .config's don't have to change a 
thing to get this functionality.

Thanks,

	Ingo
