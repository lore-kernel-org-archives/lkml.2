Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0IPWPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0IPWPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:07 -0400
Date: Fri, 17 Sep 2010 00:14:16 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH] block: Fix race during disk initialization
Message-ID: <20100916221416.GA28059@quack.suse.cz>
References: <1284661217-22783-1-git-send-email-jack@suse.cz>
 <4C926303.9090206@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C926303.9090206@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-09-10 20:33:39, Jens Axboe wrote:
> On 2010-09-16 20:20, Jan Kara wrote:
> > When a new disk is being discovered, add_disk() first ties the bdev to gendisk
> > (via register_disk()->blkdev_get()) and only after that calls
> > bdi_register_bdev(). Because register_disk() also creates disk's kobject, it
> > can happen that userspace manages to open and modify the device's data (or
> > inode) before its BDI is properly initialized leading to a warning in
> > __mark_inode_dirty().
> > 
> > Fix the problem by registering BDI early enough.
> > 
> > This patch addresses https://bugzilla.kernel.org/show_bug.cgi?id=16312
> > 
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  block/genhd.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> >  Jens, would you consider merging this fix? The kernel boots with it but
> > I'm not too familiar with this area of kernel so there can be something subtle
> > I've missed. So please review. Thanks.
> 
> It looks sane. How about we add it to the .37 lineup and mark it for
> stable backport?
  OK with me. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
