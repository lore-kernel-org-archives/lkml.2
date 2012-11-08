Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2KHEsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:48:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45028 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2KHEsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:48:45 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B3999.6060505@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 13:48:25 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com
Subject: Re: [PATCH 8/9] cgroup_freezer: add ->post_create() and ->pre_destroy()
 and track online state
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-9-git-send-email-tj@kernel.org>
In-Reply-To: <1351931915-1701-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/03 17:38), Tejun Heo wrote:
> A cgroup is online and visible to iteration between ->post_create()
> and ->pre_destroy().  This patch introduces CGROUP_FREEZER_ONLINE and
> toggles it from the newly added freezer_post_create() and
> freezer_pre_destroy() while holding freezer->lock such that a
> cgroup_freezer can be reilably distinguished to be online.  This will
> be used by full hierarchy support.
> 
> ONLINE test is added to freezer_apply_state() but it currently doesn't
> make any difference as freezer_write() can only be called for an
> online cgroup.
> 
> Adjusting system_freezing_cnt on destruction is moved from
> freezer_destroy() to the new freezer_pre_destroy() for consistency.
> 
> This patch doesn't introduce any noticeable behavior change.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>   kernel/cgroup_freezer.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index b8ad93c..4f12d31 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -23,6 +23,7 @@
>   #include <linux/seq_file.h>
>   
>   enum freezer_state_flags {
> +	CGROUP_FREEZER_ONLINE	= (1 << 0), /* freezer is fully online */

Could you explain what 'online' means here again, rather than changelog ?
BTW, 'online' is a shared concept, between post_create() and pre_destroy(), among
developpers ? Is it new ?

Anyway, the patch itself is simple.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


