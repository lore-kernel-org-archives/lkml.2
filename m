Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2KEFgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:36:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:46917 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2KEFgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:36:50 -0500
Message-ID: <5097504E.60809@huawei.com>
Date: Mon, 5 Nov 2012 13:36:14 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in cgroup_create()
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-4-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/1 3:44, Tejun Heo wrote:
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

Acked-by: Li Zefan <lizefan@huawei.com>


