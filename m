Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0K2XH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:07:59 -0500
Received: from ppp167-251-209.static.internode.on.net ([59.167.251.209]:35669
	"EHLO protos.guarana.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755318Ab0K2XH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:07:56 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 18:07:56 EST
Date: Tue, 30 Nov 2010 09:58:09 +1100
From: Kevin Easton <caf@guarana.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Kees Cook <kees.cook@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <andy@silverblocksystems.net>, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101129225809.GA18106@guarana.org>
References: <1290201154.2116.29.camel@morgan.silverblock.net>
 <AANLkTi=fnFhznMz2bTRSJDrfeDwsVUTyqiKDATPzEjhq@mail.gmail.com>
 <20101120024034.GB4617@outflux.net>
 <20101120194723.GH12640@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120194723.GH12640@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 05:47:23PM -0200, Henrique de Moraes Holschuh wrote:
> On Fri, 19 Nov 2010, Kees Cook wrote:
> > On Fri, Nov 19, 2010 at 03:22:00PM -0800, Linus Torvalds wrote:
> > > In this case, the upside just wasn't big enough to accept _any_
> > > breakage, especially since people and distributions can just do the
> > > "chmod" themselves if they want to. There was a lot of discussion
> > > whether the patch should even go in in the first place. So this time,
> > > the "let's just revert it" was a very easy decision for me.
> > 
> > The downside is that /proc can be remounted multiple times for different
> > containers, etc. Having to patch everything that mounts /proc to do the
> > chmod seems much more painful that fixing a simple userspace bug in an old
> > klog daemon.
> > 
> 
> As an user and sysadmin, I'd rather not have to find out every place that
> mounts /proc in a chroot to chmod all relevant files :(  That's fighting a
> loosing battle, unlike fixing broken tools (which at least will stay fixed).

There's only one set of "kallsyms" permissions.  If you chmod it in one
mount of proc, the permissions apply in *all* mounts of proc, current
or future.

So you don't have to find every place that mounts /proc - you can just
chmod it once at startup and be done.

    - Kevin

