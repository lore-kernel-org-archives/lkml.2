Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2BHIVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 03:21:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53853 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2BHIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 03:21:22 -0500
Message-ID: <4F32303D.9090003@kernel.dk>
Date: Wed, 08 Feb 2012 09:20:13 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Shaohua Li <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-linus 1/2] block: separate out blk_rq_merge_ok()
 and blk_try_merge() from elevator functions
References: <20120207230153.GK21292@google.com>
In-Reply-To: <20120207230153.GK21292@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 12:01 AM, Tejun Heo wrote:
> blk_rq_merge_ok() is the elevator-neutral part of merge eligibility
> test.  blk_try_merge() determines merge direction and expects the
> caller to have tested elv_rq_merge_ok() previously.
> 
> elv_rq_merge_ok() now wraps blk_rq_merge_ok() and then calls
> elv_iosched_allow_merge().  elv_try_merge() is removed and the two
> callers are updated to call elv_rq_merge_ok() explicitly followed by
> blk_try_merge().  While at it, make rq_merge_ok() functions return
> bool.
> 
> This is to prepare for plug merge update and doesn't introduce any
> behavior change.
> 
> This is based on Jens' patch to skip elevator_allow_merge_fn() from
> plug merge.

Thanks for finishing it up and testing, I have applied both patches.

-- 
Jens Axboe

