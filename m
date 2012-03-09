Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab2CIR4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:56:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2CIR4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:56:11 -0500
Date: Fri, 9 Mar 2012 12:15:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 5/5] blkcg: remove blkio_group->stats_lock
Message-ID: <20120309171523.GB7746@redhat.com>
References: <1331232840-16044-1-git-send-email-tj@kernel.org>
 <1331232840-16044-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331232840-16044-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:54:00AM -0800, Tejun Heo wrote:
> With recent plug merge updates, all non-percpu stat updates happen
> under queue_lock making stats_lock unnecessary to synchronize stat
> updates.  The only synchronization necessary is stat reading, which
> can be done using u64_stats_sync instead.
> 
> This patch removes blkio_group->stats_lock and adds
> blkio_group_stats->syncp for reader synchronization.
> 

Good to see stat_lock going away. That lock was confusing as we were doing
updates under queue_lock anyway. One less lock to think about now.

This stat code is messy though. All time related stat, maintaining flags,
dividing stats between read/write, sync/async. I think we are maintaining
way too much of stat. (/me wished there was a way to get rid of some of
the stats and make code simpler).

Thanks
Vivek
