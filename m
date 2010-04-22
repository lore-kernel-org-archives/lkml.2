Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0DVLFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:05:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46006 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab0DVLFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:05:52 -0400
Date: Thu, 22 Apr 2010 13:05:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100422110551.GD27497@kernel.dk>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422090303.GA27497@kernel.dk> <20100422103953.GB27497@kernel.dk> <1271933891.11751.1508.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271933891.11751.1508.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22 2010, David Woodhouse wrote:
> On Thu, 2010-04-22 at 12:39 +0200, Jens Axboe wrote:
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
> Do you want to include Jörn's addition of same to get_sb_mtd_set(), with
> my Acked-By: David Woodhouse <David.Woodhouse@intel.com> ? 

Yeah will do. I also really wanted to provide a WARN and mount fail if
we get it wrong, but I don't see an easy way to do that. Basically I'd
want to check whether the storage backing is volatile or not.

-- 
Jens Axboe

