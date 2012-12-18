Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2LRTOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:14:32 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:56282 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab2LRTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:14:30 -0500
Date: Tue, 18 Dec 2012 11:14:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 12/12] cfq-iosched: add hierarchical cfq_group statistics
Message-ID: <20121218191425.GO1844@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-13-git-send-email-tj@kernel.org>
 <20121218191117.GD24050@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218191117.GD24050@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Dec 18, 2012 at 02:11:17PM -0500, Vivek Goyal wrote:
> All these stats needs to be mentioned in blkio-controller.txt file to 
> keep that file uptodate.
> 
> I think it also needs another word about nature of hierarchical stats.
> That is they represent current view of the system and don't store the
> history. So if a cgroup was created, did some IO and it was removed, we
> lost that history. Deleted cgroup's parent will have no history of
> stats of deleted cgroup.

Haven't thought about that.  That's nasty.

> Hence these stats can't be used for things like billing purposes.
> 
> IIRC, this is different from the way we collect hierarhical stats for
> memory controller.
> 
> But I kind of like this because stat update overhead does not increase
> with depth of hierarchy. Primarily stat reader pays the price of
> traversing through all the stats.

Yeah, hmmm, maybe we should add another set of counters to carry stats
from dead ones?  Avoiding hierarchical accounting overhead in hot path
while remembering by-gones shouldn't be that hard.  Will work on that.

Thanks.

-- 
tejun
