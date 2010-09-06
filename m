Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0IFCdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 22:33:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab0IFCdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 22:33:05 -0400
Date: Mon, 6 Sep 2010 12:32:55 +1000
From: Neil Brown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the rcu tree
Message-ID: <20100906123255.3eef4311@notabene>
In-Reply-To: <20100906121408.33946fbe.sfr@canb.auug.org.au>
References: <20100906121408.33946fbe.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 12:14:08 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Paul,
> 
> After merging the rcu tree, today's linux-next build
> (powerpc ppc64_defconfig) produced this warning:
> 
> drivers/md/raid1.c: In function 'read_balance':
> drivers/md/raid1.c:445: warning: operation on 'new_disk' may be undefined
> 
> I am picking on the rcu tree because the line above has not changed since
> 2005.  The line is:
> 
>                 for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
>                      r1_bio->bios[new_disk] == IO_BLOCKED ||
>                      !rdev || !test_bit(In_sync, &rdev->flags)
>                              || test_bit(WriteMostly, &rdev->flags);
>                      rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
> 
> Where new_disk is being updated in the parameter to the last
> rcu_dereference.
> 

Hi Stephen,

 There is a patch in linux-kernel
    "PATCH] md: do not use ++ in rcu_dereference() argument"

 that addresses this - it is a problem in md: I guess rcu as become more
 helpful in finding these problems.

 I'll probably fix it a little differently, but I'll have something in my
 for-next for tomorrow.

Thanks,
NeilBrown
