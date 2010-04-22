Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0DVMIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 08:08:40 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56866 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab0DVMIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 08:08:39 -0400
Date: Thu, 22 Apr 2010 14:08:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100422120837.GE27497@kernel.dk>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422090303.GA27497@kernel.dk> <20100422103953.GB27497@kernel.dk> <20100422115539.GE27309@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422115539.GE27309@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22 2010, Jörn Engel wrote:
> On Thu, 22 April 2010 12:39:53 +0200, Jens Axboe wrote:
> > 
> > Here's a series for fixing these. At this point they are totally
> > untested except that I did compile them. Note that your analysis
> > appeared correct for all cases but ocfs2, which does use get_sb_bdev()
> > and hence gets ->s_bdi assigned.
> > 
> > You can see them here, I'll post the series soon:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-linus
> > 
> > The first patch is a helper addition, the rest are per-fs fixups.
> 
> Looks good at a cursory glance.  What's still missing is some sort of
> assertion.  You are a smart person and missed this problem, twice even.
> Even if you hadn't, a not so smart person can add a new filesystem and
> miss s_bdi, like I did.  We want some automatism to catch this.

I totally agree, we want some way to catch this problem in the future.
Really the check needs to be something ala:

        if (!sb->s_bdi && mnt_has_storage_backing() && rw_mount)
                yell_and_fail;

but I'm not sure how best to accomplish that. We can check for ->s_bdev
and mtd like you did, but that does not catch network file systems for
instance.

-- 
Jens Axboe

