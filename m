Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2KIJKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:10:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:35338 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2KIJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:09:55 -0500
Message-ID: <509CC855.4070203@huawei.com>
Date: Fri, 9 Nov 2012 17:09:41 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <mhocko@suse.cz>, <rjw@sisk.pl>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/9 v3] cgroup: add cgroup_subsys->post_create()
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-2-git-send-email-tj@kernel.org> <20121108190715.GD9672@htj.dyndns.org>
In-Reply-To: <20121108190715.GD9672@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/9 3:07, Tejun Heo wrote:
> Subject: cgroup: add cgroup_subsys->post_create()
> 
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
>     Michal.
> 
> v3: Forgot to add ->post_create() invocation to cgroup_load_subsys().
>     Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>

Li Zefan <lizefan@huawei.com

