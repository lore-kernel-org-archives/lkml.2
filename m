Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0GGRMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0GGRM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:12:28 -0400
Date: Wed, 7 Jul 2010 13:12:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
Message-ID: <20100707171219.GL2474@redhat.com>
References: <1278516227-1643-1-git-send-email-czoccolo@gmail.com>
 <1278516227-1643-2-git-send-email-czoccolo@gmail.com>
 <20100707154631.GG2474@redhat.com>
 <20100707161308.GA12991@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707161308.GA12991@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 12:13:08PM -0400, Christoph Hellwig wrote:
> On Wed, Jul 07, 2010 at 11:46:31AM -0400, Vivek Goyal wrote:
> > Whether to idle on WRITE_SYNC or not, I will leave it to Jens (I just
> > don't know the answer to that question. :-)). But in general I want to
> > get rid of idling as much as possible otherwise it becomes a serious
> > bottleneck in any kind of performance testing on higher end storage.
> 
> After I've been thinking about this for a while I think the major
> problems is that we use WRITE_SYNC for two very different I/O patterns.
> 
> One is synchronous data I/O (O_SYNC/O_DIRECT/fsync).  While this is a
> high-level synchronous workload in the sense that someone waits for the
> I/O to finish, the I/O can still be batched as we're doing relatively
> large amounts of bios.
> 
> The other one is synchronous writeout of metadata or the journal.

Jeff Moyer had mentioned that in his testing journal writes from jbd
threads were appearing as asynchronous (WRITES) in CFQ and we don't do any
kind of idling in CFQ on asynchronous WRITES. So this is probably already
a non issue.

Thanks
Vivek
 
> Here
> we typically wait on that single I/O we're just submitting (or at most a
> handfull), and there is absolutely no point in idling.
> 
> We already have the REQ_NOIDLE flag to distinguish between the two, so
> instead of second guessing we should actually make use of it.
