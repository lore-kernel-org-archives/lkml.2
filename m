Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3ACWUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:20:50 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57846 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3ACWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:20:48 -0500
Date: Thu, 3 Jan 2013 17:20:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20130103222039.GD2753@mtj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <50DAD696.8050400@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50DAD696.8050400@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Li.

On Wed, Dec 26, 2012 at 06:51:02PM +0800, Li Zefan wrote:
> I created a cpuset which has cpuset.cpus=1, and I forked a few cpu-hog tasks
> and moved them to this cpuset, and the final operations was offlining cpu1.
> It stucked.

This was caused by not rebuilding sched domains synchronously from cpu
offline path.  I looks like scheduler got confused and put tasks on
the dead cpu.  Should be okay in the updated patchset.  Can you please
test / review that one?

Thanks.

-- 
tejun
