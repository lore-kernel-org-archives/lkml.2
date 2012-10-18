Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2JRVVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:21:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2JRVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:21:37 -0400
Date: Thu, 18 Oct 2012 14:21:33 -0700
From: Tejun Heo <tj@kernel.org>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkcg: Fix use-after-free of q->root_blkg and
 q->root_rl.blkg
Message-ID: <20121018212133.GL13370@google.com>
References: <50750367.2070508@ce.jp.nec.com>
 <20121010155929.GA18733@redhat.com>
 <50762182.5090806@ce.jp.nec.com>
 <20121016232040.GH16166@google.com>
 <507DF58E.8060804@ce.jp.nec.com>
 <507E7030.9070607@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507E7030.9070607@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:45:36PM +0900, Jun'ichi Nomura wrote:
> blk_put_rl() does not call blkg_put() for q->root_rl because we
> don't take request list reference on q->root_blkg.
> However, if root_blkg is once attached then detached (freed),
> blk_put_rl() is confused by the bogus pointer in q->root_blkg.
> 
> For example, with !CONFIG_BLK_DEV_THROTTLING &&
> CONFIG_CFQ_GROUP_IOSCHED,
> switching IO scheduler from cfq to deadline will cause system stall
> after the following warning with 3.6:
...
> This patch clears q->root_blkg and q->root_rl.blkg when root blkg
> is destroyed.
> 
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>

Acked-by: Tejun Heo <tj@kernel.org>

Jens, this one needs Cc: stable.

Thanks.

-- 
tejun
