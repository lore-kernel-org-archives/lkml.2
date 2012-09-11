Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2IKMfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 08:35:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40791 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2IKMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 08:35:52 -0400
Date: Tue, 11 Sep 2012 14:35:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, "3.2.x.." <stable@vger.kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>
Subject: Re: [PATCH 00/11] rcu: Add missing RCU idle APIs on idle loop v2
Message-ID: <20120911123528.GG21277@somewhere.redhat.com>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
 <20120824212647.GU2472@linux.vnet.ibm.com>
 <1345857554.4840.43.camel@deadeye.wl.decadent.org.uk>
 <20120910215541.GE21277@somewhere.redhat.com>
 <20120910225845.GC4257@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910225845.GC4257@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:58:45PM -0700, Paul E. McKenney wrote:
> > Anyway, should I resend the patchset with this thing fixed?
> 
> Please feel free to do so.  ;-)
> 
> 							Thanx, Paul
> 

So here it is.

On the menu for the updated branch:

- fixed stable tags (use # 3.3+)
- not sure what to do with "alpha: Fix preemption handling in idle loop",
  tag as stable or not?
- added tested-by Michael Cree <mcree@orcon.net.nz> for alpha patches
- propagate rename to rcu_user_*_after_irq() in the commit changelog
- remove trailing #endif in "rcu: New rcu_user_enter_after_irq() and rcu_user_exit_after_irq() APIs"
  and early rcu_user_hooks_switch() header as well (reported by WU Fenguang).
- add rcu_user_hooks_switch() header in "rcu: Switch task's syscall hooks on context switch"

I believe this all should also fix what WU Fenguang reported:

	[rcu:rcu:next 54/82] include/linux/rcupdate.h:202:20: error: redefinition of 'rcu_user_exit'
	[rcu:rcu:next 54/82] include/linux/rcupdate.h:401:19: error: redefinition of 'rcu_read_lock_bh_held'
	[rcu:rcu:idle 2/27] include/linux/rcupdate.h:969:2: error: #endif without #if

I'm not reposting the patches because few things have actually changed, except a few neats and some stuff
that have been moved from a patch to another to unbreak bisection. But the end result is about the same.
You can check the difference with a git diff between our branches.

If you want to, though, I can repost the patches.

This is pullable from:

git://github.com/fweisbec/linux-dynticks.git
	rcu/idle-for-v3.7

Thanks.
