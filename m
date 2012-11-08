Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2KHDAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 22:00:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55429 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2KHDAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 22:00:06 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B201D.3060909@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 11:59:41 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/9 v2] cgroup: add cgroup_subsys->post_create()
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-2-git-send-email-tj@kernel.org> <20121107171508.GF2660@mtj.dyndns.org>
In-Reply-To: <20121107171508.GF2660@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/08 2:15), Tejun Heo wrote:
> Currently, there's no way for a controller to find out whether a new
> cgroup finished all ->create() allocatinos successfully and is
> considered "live" by cgroup.
>
> This becomes a problem later when we add generic descendants walking
> to cgroup which can be used by controllers as controllers don't have a
> synchronization point where it can synchronize against new cgroups
> appearing in such walks.
>
> This patch adds ->post_create().  It's called after all ->create()
> succeeded and the cgroup is linked into the generic cgroup hierarchy.
> This plays the counterpart of ->pre_destroy().
>
> When used in combination with the to-be-added generic descendant
> iterators, ->post_create() can be used to implement reliable state
> inheritance.  It will be explained with the descendant iterators.
>
> v2: Added a paragraph about its future use w/ descendant iterators per
>      Michal.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Cc: Glauber Costa <glommer@parallels.com>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


