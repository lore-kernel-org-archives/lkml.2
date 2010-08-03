Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0HCHqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:46:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39333 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0HCHqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:46:08 -0400
Message-ID: <4C57C93D.5060900@kernel.dk>
Date: Tue, 03 Aug 2010 09:46:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Yehuda Sadeh <yehuda@hq.newdream.net>,
        Sage Weil <sage@newdream.net>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20100803131202.422af85f.sfr@canb.auug.org.au>
In-Reply-To: <20100803131202.422af85f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-03 05:12, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> fs/ceph/rbd.c: In function 'rbd_rq_fn':
> fs/ceph/rbd.c:1101: error: implicit declaration of function 'blk_fs_request'
> fs/ceph/rbd.c:1101: error: implicit declaration of function 'blk_barrier_rq'
> 
> Caused by commit fc734ac98dbce1e3d3e1e1359524c279a336ac49 ("block: remove
> wrappers for request type/flags") interacting with commit
> e7fdb915217126d23ff2aafb2d5fdce21b763df1 ("ceph-rbd: rados block device")
> from the ceph tree.
> 
> I applied the following merge fix patch (Christoph, I assume that this
> should be directly applicable to the ceph tree, right?):

Yep, that'll work and should be applicable to ceph even when run outside
of the block tree merge.

-- 
Jens Axboe

