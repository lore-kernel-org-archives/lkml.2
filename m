Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3ABUpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:45:34 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:48041 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3ABUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:45:30 -0500
Date: Wed, 2 Jan 2013 15:45:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 21/24] blkcg: make blkcg_print_blkgs() grab q locks
 instead of blkcg lock
Message-ID: <20130102204527.GG11220@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-22-git-send-email-tj@kernel.org>
 <20130102192700.GA9552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102192700.GA9552@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 02:27:00PM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2012 at 12:35:43PM -0800, Tejun Heo wrote:
> > Instead of holding blkcg->lock while walking ->blkg_list and executing
> > prfill(), RCU walk ->blkg_list and hold the blkg's queue lock while
> > executing prfill().  This makes prfill() implementations easier as
> > stats are mostly protected by queue lock.
> > 
> > This will be used to implement hierarchical stats.
> > 
> 
> Hi Tejun,
> 
> I think dropping blkcg->lock might be a problem. Using RCU we have made
> sure that blkg and q are around. But what about blkg->q.backing_dev_info.dev.
> 
> We can follow bdi->dev pointer in blkg_dev_name(). I am not sure if we
> ever clear it from q or not when device goes away.

If the queue is dead, it wouldn't have policy enabled bit set which is
tested while holding queue lock, so I don't think it's gonna be a
problem.

Thanks.

-- 
tejun
