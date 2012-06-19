Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2FSVCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:02:17 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:38035 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab2FSVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:02:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAPnn4E95LJ3s/2dsb2JhbABFtDsDgS2BCIIYAQEFOhwjEAgDDgouFCUDIROICrlfFIsbgQ6FCwOVJIklhlmCcg
Date: Wed, 20 Jun 2012 07:02:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120619210212.GN25389@dastard>
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
 <x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
 <20120613144840.GA3055@localhost>
 <x49lijr8bur.fsf@segfault.boston.devel.redhat.com>
 <20120614133600.GB14883@localhost>
 <x491ulbjbzb.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491ulbjbzb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 04:14:16PM -0400, Jeff Moyer wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> > Good idea! Yes we can do some estimation and adaptively extend the
> > hang timeout for the current writeback_inodes_sb_nr()/sync_inodes_sb()
> > call.
> >
> > Note that it's not going to reliably get rid of false warnings due to
> > estimation errors, which could be pretty large and unavoidable on
> > change of workload. But still, it would be a net improvement and
> > perhaps enough to get rid of most false warnings, while still being
> > able to catch livelock or other kind of task hang.
> 
> Hi, Fengguang,
> 
> I didn't see a patch from you for this, so I went ahead and threw
> something together.  Let me know what you think of it.  I wasn't sure
> how to estimate the total I/O that will be issued for syncing out an
> entire superblock, though, so I didn't do that part.

As I said to the original patch - having a hang check timeout on a
system that is overloaded w.r.t. IO is an important piece of
information when it comes to debugging problems. Often the hangcheck
timer is the first piece of information that we will get that
indicates a problem somewhere in a production system.

Removing it does not magically fix the underlying problem - it
simply means that we don't hear about them until someone complains
that unmount is taking hours....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
