Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2IQU4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:56:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46531 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab2IQU4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:56:31 -0400
Date: Mon, 17 Sep 2012 13:55:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
        "3.2.x.." <stable@kernel.org>, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>
Subject: Re: [PATCH 00/10] rcu: Add missing RCU idle APIs on idle loop
Message-ID: <20120917205519.GB2467@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
 <CAMuHMdUt62GsYsPMAPbUWZUtFL=c2VmYFintpDAQmSwQrWriuA@mail.gmail.com>
 <20120823110157.GC18835@somewhere.redhat.com>
 <CAMuHMdX5R_7EBGDu00zdy_P3q65BzKJbNeRwFcuwij8eHavTYQ@mail.gmail.com>
 <20120823215052.GC19305@somewhere.redhat.com>
 <CAMuHMdURT2vdF8uGZbMO09iGbLeSaVzwNthKEA1WwOtH6dQN_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdURT2vdF8uGZbMO09iGbLeSaVzwNthKEA1WwOtH6dQN_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091720-7606-0000-0000-000003C08A4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:31:24PM +0200, Geert Uytterhoeven wrote:
> Hi Frederic, Paul,
> 
> On Thu, Aug 23, 2012 at 11:50 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > On Thu, Aug 23, 2012 at 10:23:22PM +0200, Geert Uytterhoeven wrote:
> >> On Thu, Aug 23, 2012 at 1:02 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> > On Wed, Aug 22, 2012 at 07:18:04PM +0200, Geert Uytterhoeven wrote:
> >> >> On Wed, Aug 22, 2012 at 6:23 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> >> > So this fixes some potential RCU stalls in a bunch of architectures.
> >> >> > When rcu_idle_enter()/rcu_idle_exit() became a requirement, we forgot
> >> >> > to handle the architectures that don't support CONFIG_NO_HZ.
> >> >> >
> >> >> > I guess the set should be dispatched into arch maintainer trees.
> >> >>
> >> >> I can take the m68k version, but are you sure you want it this way?
> >> >> Each of them must be in mainline before they can enter stable.
> >> >
> >> > Yeah, I was thinking the right route is for these patches to be
> >> > carried by arch maintainer who then push to Linus and then this goes
> >> > to stable.
> >> >
> >> > Is that ok for you?
> >> >
> >> > Otherwise I can carry the patches myself. In a tree of my own, or
> >> > Paul's or mmotm. As long as I have your ack.
> >>
> >> I applied your patch to the m68k for-3.6/for-linus branch.
> >> I'll ask Linus to pull later in the rc cycle (right now I don't have
> >> anything else
> >> queued for 3.6).
> >> Still, I think it's better to just collect acks and send it to Linus
> >> in one shot,
> >> so it can go into stable in one shot too.
> >
> > Sure I can do that if you prefer.
> 
> What's the conclusion on this one? I saw it entered tip.

I don't see it at tip/master, but perhaps I am looking at the wrong branch.

> I still have it (as the only commit) on my for-3.6 branch, but I don't
> think m68k
> is important enough to be the only architecture to have this fix in 3.6 ;-)

I got only two acks in addition to yours, plus one Tested-by.  So, no,
there does not appear to be a large groundswell of support for pushing
this into 3.6.  If it doesn't go in by some other path, I will be pushing
it into 3.7.

							Thanx, Paul

