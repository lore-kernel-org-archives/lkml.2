Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847Ab2KBKVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:21:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37366 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab2KBKU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:20:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50939E76.1000801@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 19:20:38 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] cgroup: remove CGRP_WAIT_ON_RMDIR, cgroup_exclude_rmdir()
 and cgroup_release_and_wakeup_rmdir()
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-6-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/01 4:44), Tejun Heo wrote:
> CGRP_WAIT_ON_RMDIR is another kludge which was added to make cgroup
> destruction rollback somewhat working.  cgroup_rmdir() used to drain
> CSS references and CGRP_WAIT_ON_RMDIR and the associated waitqueue and
> helpers were used to allow the task performing rmdir to wait for the
> next relevant event.
> 
> Unfortunately, the wait is visible to controllers too and the
> mechanism got exposed to memcg by 887032670d ("cgroup avoid permanent
> sleep at rmdir").
> 
> Now that the draining and retries are gone, CGRP_WAIT_ON_RMDIR is
> unnecessary.  Remove it and all the mechanisms supporting it.  Note
> that memcontrol.c changes are essentially revert of 887032670d
> ("cgroup avoid permanent sleep at rmdir").
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

plz forget my comments on v1...But...

If swap-in makes a charge before css is deactivated, pre_destroy()->force_empty()
will cause infinite loop until it finds a newly charged page in LRU. I think
force_empty() will find it by lru_drain() and can make res_coutnter to be 0.

I think we need some test with swap-in handling..Anyway, 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


