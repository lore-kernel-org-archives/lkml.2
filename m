Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2JTW5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:57:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38732 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab2JTW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:57:42 -0400
Date: Sat, 20 Oct 2012 15:57:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] workqueue: remove unused argument of
 wq_worker_waking_up()
Message-ID: <20121020225738.GB11442@htj.dyndns.org>
References: <Yes>
 <1350750607-2051-1-git-send-email-js1304@gmail.com>
 <1350750607-2051-4-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350750607-2051-4-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 01:30:07AM +0900, Joonsoo Kim wrote:
> Commit 63d95a91 ('workqueue: use @pool instead of @gcwq or @cpu where
> applicable') changes an approach to access nr_running.
> Thus, wq_worker_waking_up() doesn't use @cpu anymore.
> Remove it and remove comment related to it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

I'm not sure whether I wanna remove or add WARN_ON_ONCE() on it.  That
part has gone through some changes and seen some bugs.  Can we please
do the following instead at least for now?

	if (!(worker->flags & WORKER_NOT_RUNNING)) {
		WARN_ON_ONCE(worker->pool->gcwq->cpu != cpu);
		atomic_inc(get_pool_nr_running(worker->pool));
	}

Thanks.

-- 
tejun
