Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0C3TVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:21:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62913 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0C3TVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Iw2cC78/UV0bLU/asmT3HFjsbhwFoN380KyL3PJHfpXJAQZ1FDVeN6hRYa+GKGiUGs
         ZIJka87k9GGEbiNe1+5mtEvRLsLuNWIX0SN9H9nLnGbS6tQ1wJ9HMWov2/GQsBJStStS
         xvVxr9r3UChnvlnRkYUBQUb98jmoiQwODID4Q=
Date: Tue, 30 Mar 2010 21:21:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/6] procfs: Push down the bkl from ioctl
Message-ID: <20100330192110.GI5078@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003301237.28083.arnd@arndb.de> <20100330182710.GC5078@nowhere> <201003302054.11962.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003302054.11962.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 08:54:11PM +0200, Arnd Bergmann wrote:
> On Tuesday 30 March 2010 20:27:12 Frederic Weisbecker wrote:
> > On Tue, Mar 30, 2010 at 11:37:27AM +0100, Arnd Bergmann wrote:
> > > On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> > > > Push down the bkl from procfs's ioctl main handler to its users.
> > > > Only three procfs users implement an ioctl (non unlocked) handler.
> > > > Turn them into unlocked_ioctl and push down the Devil inside.
> > > 
> > > Looks good to me. I would have used a single unlock and return statement
> > > in i8k_ioctl and isdn_divert_ioctl, with goto instead of adding an
> > > unlock to each return, but it doesn't matter much.
> > 
> > 
> > I did that first, but actually that didn't make much difference:
> > 
> > ret = foo;            unlock_kernel()
> > goto end;      VS     return foo;
> 
> Yes, the amount of code needed is comparable, but it is much easier
> to validate that you did not miss an unlock when you know that there
> is a single return statement in the function. It also helps the next
> person that may want to replace the BKL with a different lock.


Ah you're right!

