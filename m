Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab2JQOLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:11:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab2JQOLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:11:41 -0400
Date: Wed, 17 Oct 2012 16:11:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sasha Levin <levinsasha928@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
In-Reply-To: <1350437371.26833.71.camel@deadeye.wl.decadent.org.uk>
Message-ID: <alpine.LNX.2.00.1210171610220.17129@pobox.suse.cz>
References: <505E2108.2060108@gmail.com>  <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com>  <20121008172207.GB14767@quack.suse.cz>  <alpine.LNX.2.00.1210082340501.19980@pobox.suse.cz>  <507424F7.60801@gmail.com> <50742600.10606@gmail.com>
  <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>  <CA+1xoqcGN1xYP5-N17eZQ=F_JTG-8gr43DAxREa-Wf+n8=P7Og@mail.gmail.com> <1350437371.26833.71.camel@deadeye.wl.decadent.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Ben Hutchings wrote:

> > > 1. redo_fd_request() races with tear-down of the disks, but because
> > > set_next_request() checks disk->queue before doing anything this was
> > > usually harmless.  Now that do_floppy_init() doesn't clear disk->queue,
> > > the race condition is much easier to hit.  This may fix that problem in
> > > do_floppy_init(), though there appear to be worse bugs in tear-down
> > > order in floppy_module_exit():
> [...]
> > > 2. I made a big mistake in using the existing GENHD_FL_UP flag, as it is
> > > cleared by del_gendisk().  Incremental patch below, but it should be
> > > squashed into the previous patch if that branch is still rebase-able.
> [...]
> > I'm now seeing these instead:
> [...]
> 
> Sorry, I'm not going to spend more time in the quagmire of the floppy
> driver.  Whoever has this commit in their tree, please revert or drop it
> as appropriate.

As far as I can tell, Jens has pulled it from me, but it hasn't made it 
into Linus' tree as of today.

I will do it in my tree and send a new pull request to Jens.

-- 
Jiri Kosina
SUSE Labs
