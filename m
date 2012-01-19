Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2ASOlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:41:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2ASOls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:41:48 -0500
Date: Thu, 19 Jan 2012 09:41:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] blkcg: use the usual get blkg path for root
 blkio_group
Message-ID: <20120119144136.GB9582@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:11:26PM -0800, Tejun Heo wrote:
> For root blkg, blk_throtl_init() was using throtl_alloc_tg()
> explicitly and cfq_init_queue() was manually initializing embedded
> cfqd->root_group, adding unnecessarily different code paths to blkg
> handling.
> 
> Make both use the usual blkio_group get functions - throtl_get_tg()
> and cfq_get_cfqg() - for the root blkio_group too.  Note that
> blk_throtl_init() callsite is pushed downwards in
> blk_alloc_queue_node() so that @q is sufficiently initialized for
> throtl_get_tg().
> 
> This simplifies root blkg handling noticeably for cfq and will allow
> further modularization of blkcg API.

Does this work if BLK_CGROUP=n?

I am trying to think that why did I keep allocating root cgroup statically
for CFQ. May be the reason was that this group was present even if
CFQ_GROUP_IOSCHED=n. There was other code which assumed a group to be
always present and I did not want to put more #ifdef.

Anyway, if it works well, with BLK_CGROUP=n, then it is fine.

Thanks
Vivek
