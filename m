Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2ARBHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:07:14 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59694 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2ARBHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:07:12 -0500
Date: Tue, 17 Jan 2012 20:06:52 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs/mmap lockdep report from 3.2
Message-ID: <20120118010652.GM3658@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120110010331.GA15942@redhat.com>
 <20120110014432.GC26546@shiny>
 <20120117232550.GB9457@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117232550.GB9457@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F161B30.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:25:50AM +0100, Jan Kara wrote:
> On Mon 09-01-12 20:44:32, Chris Mason wrote:
> > On Mon, Jan 09, 2012 at 08:03:32PM -0500, Dave Jones wrote:
> > > Just hit this with Linus' tree as of 37cfc3f67db9f2d907f6bfcfae590cdbbef623e8
> > > 
> > > 	Dave
> > > 
> > > [  130.932837] ======================================================
> > > [  130.933032] [ INFO: possible circular locking dependency detected ]
> > > [  130.933032] 3.2.0+ #19 Not tainted
> > > [  130.933032] -------------------------------------------------------
> > > [  130.933032] firefox/1630 is trying to acquire lock:
> > > [  130.933032]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffffa011fd5b>] btrfs_page_mkwrite+0x5b/0x310 [btrfs]
> > > [  130.933032] 
> > > [  130.933032] but task is already holding lock:
> > > [  130.933032]  (&mm->mmap_sem){++++++}, at: [<ffffffff816a38c8>] do_page_fault+0xe8/0x5d0
> > > [  130.933032] 
> > > [  130.933032] which lock already depends on the new lock.
> > 
> > From a lockdep point of view, this is real.  But the page_mkwrite
> > code is never called on directories so it is actually safe.  We'll fix
> > it up.
>   Well, but hitting a fault (and thus acquiring mmap_sem) while holding
> i_mutex can happen also for normal files when we copy data from userspace.
> So I believe the deadlock is real...

Al mentioned this as well.  Josef patched it up (its in my pull request)
and I'll send a fix to -stable.

-chris

