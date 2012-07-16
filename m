Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2GPNnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:43:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35745 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753371Ab2GPNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:43:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Aq0g+gkcAs9ugARGhILwVnnNlg3VJ9Eg8C5lLw1
	A4pMuWc3HQbJdP
Message-ID: <1342437873.7659.60.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Mon, 16 Jul 2012 13:24:33 +0200
In-Reply-To: <alpine.LFD.2.02.1207161216200.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
	 <1342343673.28142.2.camel@marge.simpson.net>
	 <1342405366.7659.35.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161058550.32033@ionos>
	 <1342432094.7659.39.camel@marge.simpson.net>
	 <1342433303.7659.42.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161216200.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 12:19 +0200, Thomas Gleixner wrote: 
> On Mon, 16 Jul 2012, Mike Galbraith wrote:

> > ---
> >  block/blk-core.c |    1 +
> >  kernel/rtmutex.c |   11 +++++++++--
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -2782,6 +2782,7 @@ void blk_flush_plug_list(struct blk_plug
> >  	if (q)
> >  		queue_unplugged(q, depth, from_schedule);
> >  }
> > +EXPORT_SYMBOL(blk_flush_plug_list);
> 
> You don't need that one. blk-core and rtmutex are builtin

Box disagrees.

Waiting for device /dev/cciss/c0d0p6 to appear:  ok
fsck from util-linux 2.19.1
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/cciss/c0d0p6 
SLES11: clean, 141001/305824 files, 1053733/1222940 blocks
fsck succeeded. Mounting root device read-write.
Mounting root /dev/cciss/c0d0p6
mount -o rw,acl,user_xattr -t [   27.558934] jbd: disagrees about
version of symbol rt_spin_trylock
ext3 /dev/cciss/[   27.558938] jbd: Unknown symbol rt_spin_trylock (err
-22)
c0d0p6 /root
[   27.558959] jbd: disagrees about version of symbol
__rt_spin_lock_init
[   27.558961] jbd: Unknown symbol __rt_spin_lock_init (err -22)
[   27.558986] jbd: disagrees about version of symbol rt_spin_unlock
[   27.558988] jbd: Unknown symbol rt_spin_unlock (err -22)
[   27.558990] jbd: disagrees about version of symbol rt_spin_lock
[   27.558992] jbd: Unknown symbol rt_spin_lock (err -22)
[   27.559004] jbd: disagrees about version of symbol __rt_mutex_init
[   27.559006] jbd: Unknown symbol __rt_mutex_init (err -22)
modprobe: FATAL: Error inserting ext3
(/lib/modules/3.0.35-rt56-rt/extra/ext3.ko): Invalid argument

mount: unknown filesystem type 'ext3'
could not mount root filesystem -- exiting to /bin/sh
$


