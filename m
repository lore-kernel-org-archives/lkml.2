Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2KHEph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:45:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59197 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2KHEpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:45:35 -0500
Date: Wed, 7 Nov 2012 20:45:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 7/9] cgroup_freezer: introduce
 CGROUP_FREEZING_[SELF|PARENT]
Message-ID: <20121108044521.GH2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-8-git-send-email-tj@kernel.org>
 <509B382E.4030707@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509B382E.4030707@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 08, 2012 at 01:42:22PM +0900, Kamezawa Hiroyuki wrote:
> (2012/11/03 17:38), Tejun Heo wrote:
> >Introduce FREEZING_SELF and FREEZING_PARENT and make FREEZING OR of
> >the two flags.  This is to prepare for full hierarchy support.
> >
> >freezer_apply_date() is updated such that it can handle setting and
> >clearing of both flags.  The two flags are also exposed to userland
> >via read-only files self_freezing and parent_freezing.
> >
> >Other than the added cgroupfs files, this patch doesn't introduce any
> >behavior change.
> >
> >Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> What is the purpose of FREEZING_SELG/PARENT, having 2 flags and
> make it visible to users ?

SELF is the configuration of the current cgroup, PARENT is freezing
state inherited from an ancestor.  If either is set, the cgroup is
freezing.  Without the two conditions visible to userland, it can get
a bit confusing as echoing "THAWED" to state may not do anything to
the cgroup.

Thanks.

-- 
tejun
