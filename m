Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3AFJ2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:28:50 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:25094 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3AFJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:28:47 -0500
Message-ID: <50E94392.2050509@huawei.com>
Date: Sun, 6 Jan 2013 17:27:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <paul@paulmenage.org>, <glommer@parallels.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] cpuset: drop cpuset->stack_list and ->parent, take#2
References: <1357249446-25075-1-git-send-email-tj@kernel.org>
In-Reply-To: <1357249446-25075-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/4 5:44, Tejun Heo wrote:
> Hello, guys.
> 
> This is the second take of "drop cpuset->stack_list and ->parent"
> patchset.  Other than being rebased on top of v3.8-rc2 + "cpuset:
> decouple cpuset locking from cgroup core, take#2", nothing really has
> changed.
> 
> The original patchset description follows.
> 
> cpuset implements its own descendant iteration using
> cpuset->stack_list and has its own ->parent pointer.  There's nothing
> cpuset specific about descendant walking or finding the parent.  This
> patchset makes cpuset use cgroup generic API instead.
> 
>  0001-cpuset-implement-cgroup_rightmost_descendant.patch
>  0002-cpuset-replace-cpuset-stack_list-with-cpuset_for_eac.patch
>  0003-cpuset-remove-cpuset-parent.patch
> 
> 0001 implements cgroup_rightmost_descendant() which can be used to
> skip subtree during pre-order tree walk.  Michal, maybe memcg can use
> it too?
> 
> 0002 replaces cpuset->stack_list with generic
> for_each_descendasnt_pre().
> 
> 0003 replaces cpuset->parent with cgroup->parent.
> 
> This patchset is on top of
> 
> v3.8-rc2 d1c3ed669a2d452cacfb48c2d171a1f364dae2ed
> + [1] "[PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from cgroup core, take#2"
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cpuset-iter
> 
>  include/linux/cgroup.h |    1 
>  kernel/cgroup.c        |   26 ++++++++
>  kernel/cpuset.c        |  151 +++++++++++++++++++++----------------------------
>  3 files changed, 92 insertions(+), 86 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

