Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3ABUoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:44:00 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47070 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3ABUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:43:58 -0500
Date: Wed, 2 Jan 2013 15:43:55 -0500
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 20/24] block: RCU free request_queue
Message-ID: <20130102204355.GF11220@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-21-git-send-email-tj@kernel.org>
 <20130102184814.GD4306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102184814.GD4306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 01:48:15PM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2012 at 12:35:42PM -0800, Tejun Heo wrote:
> > RCU free request_queue so that blkcg_gq->q can be dereferenced under
> > RCU lock.  This will be used to implement hierarchical stats.
> 
> Can we just take a blkg reference on ->q in blkg_alloc() and drop that
> reference in blkg_free(), instead of RCU freeing up queue.

I don't think we can invoke blk_release_queue() from RCU free contxt,
so we can't put request_queue from blkg_rcu_free().  Maybe we can go
through a work item but that's uglier.

Thanks.

-- 
tejun
