Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266Ab2KBKEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:04:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42268 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2KBKEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:04:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50939A82.8080203@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 19:03:46 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in cgroup_create()
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-4-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/01 4:44), Tejun Heo wrote:
> This patch makes cgroup_create() fail if @parent is marked removed.
> This is to prepare for further updates to cgroup_rmdir() path.
> 
> Note that this change isn't strictly necessary.  cgroup can only be
> created via mkdir and the removed marking and dentry removal happen
> without releasing cgroup_mutex, so cgroup_create() can never race with
> cgroup_rmdir().  Even after the scheduled updates to cgroup_rmdir(),
> cgroup_mkdir() and cgroup_rmdir() are synchronized by i_mutex
> rendering the added liveliness check unnecessary.
> 
> Do it anyway such that locking is contained inside cgroup proper and
> we don't get nasty surprises if we ever grow another caller of
> cgroup_create().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



