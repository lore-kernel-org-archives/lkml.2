Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1GUKcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:32:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35678 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1GUKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:32:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Jul 2011 19:25:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] memcg: unify sync and async per-cpu charge cache
 draining
Message-Id: <20110721192525.56721c52.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <16dca2225fc14783a16d00c43f6680b67418da65.1311241300.git.mhocko@suse.cz>
References: <cover.1311241300.git.mhocko@suse.cz>
	<16dca2225fc14783a16d00c43f6680b67418da65.1311241300.git.mhocko@suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 09:50:00 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> Currently we have two ways how to drain per-CPU caches for charges.
> drain_all_stock_sync will synchronously drain all caches while
> drain_all_stock_async will asynchronously drain only those that refer to
> a given memory cgroup or its subtree in hierarchy.
> Targeted async draining has been introduced by 26fe6168 (memcg: fix
> percpu cached charge draining frequency) to reduce the cpu workers
> number.
> 
> sync draining is currently triggered only from mem_cgroup_force_empty
> which is triggered only by userspace (mem_cgroup_force_empty_write) or
> when a cgroup is removed (mem_cgroup_pre_destroy). Although these are
> not usually frequent operations it still makes some sense to do targeted
> draining as well, especially if the box has many CPUs.
> 
> This patch unifies both methods to use the single code (drain_all_stock)
> which relies on the original async implementation and just adds
> flush_work to wait on all caches that are still under work for the sync
> mode.
> We are using FLUSHING_CACHED_CHARGE bit check to prevent from waiting on
> a work that we haven't triggered.
> Please note that both sync and async functions are currently protected
> by percpu_charge_mutex so we cannot race with other drainers.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

hmm..maybe good.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


