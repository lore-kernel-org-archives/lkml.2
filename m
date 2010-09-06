Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0IFFht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:37:49 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52428 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0IFFhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:37:47 -0400
Date: Sun, 5 Sep 2010 22:37:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the rcu tree
Message-ID: <20100906053743.GD2463@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100906121408.33946fbe.sfr@canb.auug.org.au>
 <20100906123255.3eef4311@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906123255.3eef4311@notabene>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 12:32:55PM +1000, Neil Brown wrote:
> On Mon, 6 Sep 2010 12:14:08 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Paul,
> > 
> > After merging the rcu tree, today's linux-next build
> > (powerpc ppc64_defconfig) produced this warning:
> > 
> > drivers/md/raid1.c: In function 'read_balance':
> > drivers/md/raid1.c:445: warning: operation on 'new_disk' may be undefined
> > 
> > I am picking on the rcu tree because the line above has not changed since
> > 2005.  The line is:
> > 
> >                 for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
> >                      r1_bio->bios[new_disk] == IO_BLOCKED ||
> >                      !rdev || !test_bit(In_sync, &rdev->flags)
> >                              || test_bit(WriteMostly, &rdev->flags);
> >                      rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
> > 
> > Where new_disk is being updated in the parameter to the last
> > rcu_dereference.
> > 
> 
> Hi Stephen,
> 
>  There is a patch in linux-kernel
>     "PATCH] md: do not use ++ in rcu_dereference() argument"
> 
>  that addresses this - it is a problem in md: I guess rcu as become more
>  helpful in finding these problems.

Indeed, the sparse-based checking is a bit more picky about things,
even when you are not using sparse...

							Thanx, Paul

>  I'll probably fix it a little differently, but I'll have something in my
>  for-next for tomorrow.
> 
> Thanks,
> NeilBrown
