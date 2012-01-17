Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2AQXZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:25:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab2AQXZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:25:53 -0500
Date: Wed, 18 Jan 2012 00:25:50 +0100
From: Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs/mmap lockdep report from 3.2
Message-ID: <20120117232550.GB9457@quack.suse.cz>
References: <20120110010331.GA15942@redhat.com>
 <20120110014432.GC26546@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110014432.GC26546@shiny>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09-01-12 20:44:32, Chris Mason wrote:
> On Mon, Jan 09, 2012 at 08:03:32PM -0500, Dave Jones wrote:
> > Just hit this with Linus' tree as of 37cfc3f67db9f2d907f6bfcfae590cdbbef623e8
> > 
> > 	Dave
> > 
> > [  130.932837] ======================================================
> > [  130.933032] [ INFO: possible circular locking dependency detected ]
> > [  130.933032] 3.2.0+ #19 Not tainted
> > [  130.933032] -------------------------------------------------------
> > [  130.933032] firefox/1630 is trying to acquire lock:
> > [  130.933032]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffffa011fd5b>] btrfs_page_mkwrite+0x5b/0x310 [btrfs]
> > [  130.933032] 
> > [  130.933032] but task is already holding lock:
> > [  130.933032]  (&mm->mmap_sem){++++++}, at: [<ffffffff816a38c8>] do_page_fault+0xe8/0x5d0
> > [  130.933032] 
> > [  130.933032] which lock already depends on the new lock.
> 
> From a lockdep point of view, this is real.  But the page_mkwrite
> code is never called on directories so it is actually safe.  We'll fix
> it up.
  Well, but hitting a fault (and thus acquiring mmap_sem) while holding
i_mutex can happen also for normal files when we copy data from userspace.
So I believe the deadlock is real...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
