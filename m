Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525Ab2CTLtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:49:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43011 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030322Ab2CTLtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:49:49 -0400
Date: Tue, 20 Mar 2012 12:49:43 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] block: remove ioc_*_changed()
Message-ID: <20120320114943.GM7505@kernel.dk>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332195059-2750-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19 2012, Tejun Heo wrote:
> Hello, guys.
> 
> The changed notification used by cfq is rather odd.  cfq caches the
> associated cfqqs per cic and uses the changed notification to expire
> those lookup caches.
> 
> The explicit notification mechanism might make sense if determining
> whether the current cache is up-to-date is difficult or expensive;
> however, that isn't the case here.  Determining whether ioprio or
> cgroup has changed is straight-forward and inexpensive.
> 
> This patchset updates cfq to so that it remembers the current ioprio
> and blkcg in the cic and determines whether cfqq's need to be reset
> without using the changed notification and drops the changed
> notification code.
> 
>  0001-blkcg-add-blkcg-id.patch
>  0002-cfq-pass-around-cfq_io_cq-instead-of-io_context.patch
>  0003-cfq-don-t-use-icq_get_changed.patch
>  0004-block-remove-ioc_-_changed.patch
> 
> 0001 adds unique u64 id to each blkcg so that policies can tell
> whether the associated blkcg has changed.
> 
> 0002 makes cfq pass around cic internally instead of ioc.  This is a
> cleanup in itself and necessary for the next patch.
> 
> 0003 updates cfq to not use changed notification.
> 
> 0004 removes code implementing changed notification.
> 
> This patchset is on top of
> 
>   block/for-3.4/core 671058fb2a2aac4e70f01b316b06bc59b98bd138
> + [1] blkcg: fix percpu stat allocation and remove stats_lock, take#2
> 
> and available in the following git branch
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-ioc-remove-changed

Thanks Tejun, applied [1] and this one to for-3.4/core.

-- 
Jens Axboe

