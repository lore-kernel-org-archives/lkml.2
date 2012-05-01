Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2EATIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758380Ab2EATI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:08:29 -0400
Date: Tue, 1 May 2012 15:08:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be
 initialized to one
Message-ID: <20120501190826.GF18239@redhat.com>
References: <1335873936.16988.148.camel@lappy>
 <20120501161729.GV26595@google.com>
 <4FA0253F.4000302@fusionio.com>
 <20120501180906.GX26595@google.com>
 <4FA028EE.7020208@fusionio.com>
 <x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
 <20120501183610.GD18239@redhat.com>
 <x49sjfjloty.fsf@segfault.boston.devel.redhat.com>
 <20120501185906.GE18239@redhat.com>
 <x49k40vlo32.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49k40vlo32.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 03:04:49PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, May 01, 2012 at 02:48:41PM -0400, Jeff Moyer wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >> 
> >> > On Tue, May 01, 2012 at 02:31:07PM -0400, Jeff Moyer wrote:
> >> >
> >> > [..]
> >> >> > But as to actual users, I really don't know. I agree it's probably not
> >> >> > that widely used. If google still had that code search, we could get a
> >> >> > better idea :-)
> >> >> 
> >> >> I know of one project: the venerable dump/restore utility uses CLONE_IO.
> >> >
> >> > I thought you wrote cooperating queue logic to fix dump as it was not
> >> > using CLONE_IO and IO from multiple threads was going in separate 
> >> > queues.
> >> 
> >> That's correct.  I believe I sent the patch for dump before the kernel
> >> patch was accepted.  Plus, it can't hurt, right?
> >
> > Ok, so now you have fixed dump to use CLONE_IO.
> >
> > So only other user of coop thing remaining potentially is qemu. I was
> 
> No, that's not the *only* other potential user.  ;-)  I wouldn't be
> surprised if nfsd benefitted from the merging.  I also wouldn't be
> surprised if other 3rd party apps did.  Are you trying to make a case to
> get rid of the queue merging logic?

No, just counting who benefits from coop logic.

> 
> > doing some qemu testing where threads were doing IO to nearby area
> > but no coop merging was taking place. So not sure in practice how well
> > does it work.
> 
> Well, that sounds like it warrants further investigation.
> 
> > Thought, that's irrlevant for this discussion. Thought of mentioning
> > this observation.
> 
> If you can provide a reproducer, I'll be happy to take a look.

I will dig. This was in the context of trying to solve qemu related
IO slowdown with CFQ. Will let you know if I find a concrete reproducer.

Thanks
Vivek
