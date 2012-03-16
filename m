Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2CPEV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:21:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:40960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab2CPEV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:21:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="118211861"
Date: Fri, 16 Mar 2012 12:20:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH block/for-3.4/core] cfq: fix cfqg ref handling when
 BLK_CGROUP && !CFQ_GROUP_IOSCHED
Message-ID: <20120316042036.GA32728@localhost>
References: <20120315094945.GA3205@localhost>
 <20120315163546.GA32137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315163546.GA32137@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:35:46AM -0700, Tejun Heo wrote:
> When BLK_CGROUP is enabled but CFQ_GROUP_IOSCHED is, cfq ends up
> calling blkg_get/put() on dummy cfqg leading to the following crash.
> 
>   BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
>   IP: [<ffffffff813d44d8>] cfq_init_queue+0x258/0x430

> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks for the quick fix!

> ---
> Yeap, forgot to test that config combination.  Fengguang, can you
> please test this patch?  Jens, once Fengguang confirms the fix, can
> you please apply this on top of for-3.4/core along with the pending
> stats updates?
