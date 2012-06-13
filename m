Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2FMDfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:35:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34675 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751069Ab2FMDfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:35:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+g9kcwWgygWhvD6e4rrcApLYdkrogWeVYqQaklCU
	lYU8y7HpaZrfRA
Message-ID: <1339558508.7472.26.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Hugh Dickins <hughd@google.com>
Date: Wed, 13 Jun 2012 05:35:08 +0200
In-Reply-To: <1339438242.7358.62.camel@marge.simpson.net>
References: <1339409176.7350.26.camel@marge.simpson.net>
	 <20120611133953.GI2425@linux.vnet.ibm.com>
	 <1339424543.7350.101.camel@marge.simpson.net>
	 <1339435214.7358.43.camel@marge.simpson.net>
	 <20120611180112.GD2521@linux.vnet.ibm.com>
	 <1339438242.7358.62.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 20:10 +0200, Mike Galbraith wrote: 
> On Mon, 2012-06-11 at 11:01 -0700, Paul E. McKenney wrote: 

> > > 2aa15890 - mm: prevent concurrent unmap_mapping_range() on the same inode
> > 
> > I confess, you lost me on this one.  You believe that this commit is
> > the cause of the RCU CPU stall warnings?
> 
> 4096 tasks on 4096 CPUs exit (well, try to) simultaneously.
> 
> Call Trace:
>                 __mutex_lock_slowpath+0x94/0x150
>                 mutex_lock+0x1a/0x40
>                 unlink_file_vma+0x3f/0xf0
>                 free_pgtables+0x40/0x100
>                 exit_mmap+0xb0/0x120
>                 mmput+0x49/0x120
>                 exit_mm+0x122/0x160
>                 do_exit+0x179/0x8d0
>                 do_group_exit+0x3d/0xb0
>                 sys_exit_group+0x12/0x20
> 
> Monster box dies screaming.

That commit landed in stable, box with way too many cores (NR_CPUS=0!!)
chokes instantly with loads of spinners.  Ok, so zillion CPUs grabbing a
mutex in lockstep is a bad idea (_having_ zillion?), but is there pilot
error involved in a logjam like this?

-Mike

