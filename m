Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2IJVxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:53:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37086 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2IJVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:53:08 -0400
Date: Mon, 10 Sep 2012 23:53:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Cree <mcree@orcon.net.nz>, Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
        "3.2.x.." <stable@vger.kernel.org>,
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
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>
Subject: Re: [PATCH 00/11] rcu: Add missing RCU idle APIs on idle loop v2
Message-ID: <20120910215244.GD21277@somewhere.redhat.com>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
 <20120824212647.GU2472@linux.vnet.ibm.com>
 <1345857554.4840.43.camel@deadeye.wl.decadent.org.uk>
 <20120825035047.GB3436@linux.vnet.ibm.com>
 <20120825131647.GA1994@somewhere>
 <20120825161806.GD3436@linux.vnet.ibm.com>
 <5039406F.9040604@orcon.net.nz>
 <20120826001233.GH3436@linux.vnet.ibm.com>
 <20120826092137.GA50543@kaini.schwarzvogel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826092137.GA50543@kaini.schwarzvogel.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 11:21:37AM +0200, Tobias Klausmann wrote:
> Hi! 
> 
> On Sat, 25 Aug 2012, Paul E. McKenney wrote:
> > Both Alpha patches should apply as-is back to 3.3, and should also fix
> > the problem.  Could you please check this on the versions of interest?
> 
> I just now tried them on top of 3.3.8 from linux-stable.git.
> While they apply cleanly, I get a compile failure:
> 
>   CC      arch/alpha/kernel/process.o
> arch/alpha/kernel/process.c: In function 'cpu_idle':
> arch/alpha/kernel/process.c:64: error: implicit declaration of function 'schedule_preempt_disabled'
> make[1]: *** [arch/alpha/kernel/process.o] Error 1
> make: *** [arch/alpha/kernel] Error 2
> 
> AFAICT, schedule_preempt_disabled() was only introduced in 3.4
> and thus needs to be backported for 3.3.

Please try with this instead:

	preempt_enable_no_resched();
	schedule();
	preempt_disable();

Thanks.

> 
> Regards,
> Tobias
> 
> -- 
> panic("%s: CORRUPTED BTREE OR SOMETHING", __FUNCTION__);
>         linux-2.6.6/fs/xfs/xfs_bmap.c
