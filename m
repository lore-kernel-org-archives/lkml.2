Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0FHO4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:56:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab0FHO4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:56:31 -0400
Date: Tue, 8 Jun 2010 10:56:22 -0400
From: Josef Bacik <josef@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, Jeffrey Merkey <jeffmerkey@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite
	unfreeze/Thaw event
Message-ID: <20100608145621.GD2334@localhost.localdomain>
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com> <20100607010542.GB27325@dastard> <20100607213631.GE2336@localhost.localdomain> <20100607215925.GF2336@localhost.localdomain> <20100607232350.GA6965@dastard> <20100608020741.GG2336@localhost.localdomain> <20100608022652.GC6965@dastard> <20100608125852.GD7869@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608125852.GD7869@dastard>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:58:52PM +1000, Dave Chinner wrote:
> On Tue, Jun 08, 2010 at 12:26:52PM +1000, Dave Chinner wrote:
> > On Mon, Jun 07, 2010 at 10:07:41PM -0400, Josef Bacik wrote:
> > > Well damnit.  I guess what we need to do is get rid of the freeze_bdev/thaw_bdev
> > > interface altogether, and move the count stuff down to the super.  Anybody who
> > > calls freeze_bdev/thaw_bdev knows the sb anyway, so if we get rid of
> > > bd_fsfreeze_count and move it to sb->s_fsfreeze_count and do the same with
> > > bd_fsfreeze_mutex then we could solve this altogether and simplify the
> > > interface.  It grows the sb struct, but hey it shrinks the bdev struct :).  How
> > > horrible of an idea is that?  Thanks,
> > 
> > Kind of what I was thinking of. I wasn't sure about what btrfs
> > required, but you've cleared that up. I'll put a patch together and
> > see how it looks.
> 
> Not too bad:
> 
>  8 files changed, 137 insertions(+), 190 deletions(-)
> 
> It really needs to be split up into multiple commits and the test
> case needs to exercise dmsetup suspend/resume as well, but I think
> this works well enough for comments at this point. I've only tested
> it on XFS so far.
> 

I like it.  Everything seems in order, course now I realize that dm trying to
freeze a bdev with btrfs on it will not work, but thats a seperate, horrible
situation that can wait till later :).  Thanks,

Josef
