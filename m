Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab2KHDWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 22:22:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45986 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2KHDWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 22:22:00 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B2544.10409@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 12:21:40 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-4-git-send-email-tj@kernel.org>
In-Reply-To: <1351931915-1701-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/03 17:38), Tejun Heo wrote:
> Currently, cgroup doesn't provide any generic helper for walking a
> given cgroup's children or descendants.  This patch adds the following
> three macros.
> 
> * cgroup_for_each_child() - walk immediate children of a cgroup.
> 
> * cgroup_for_each_descendant_pre() - visit all descendants of a cgroup
>    in pre-order tree traversal.
> 
> * cgroup_for_each_descendant_post() - visit all descendants of a
>    cgroup in post-order tree traversal.
> 
> All three only require the user to hold RCU read lock during
> traversal.  Verifying that each iterated cgroup is online is the
> responsibility of the user.  When used with proper synchronization,
> cgroup_for_each_descendant_pre() can be used to propagate config
> updates to descendants in reliable way.  See comments for details.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

maybe better than using css->id in some(many) case.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>



