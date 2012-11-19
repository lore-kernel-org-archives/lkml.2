Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2KSIyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:54:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:6444 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2KSIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:54:52 -0500
Message-ID: <50A9F3B3.2010607@huawei.com>
Date: Mon, 19 Nov 2012 16:54:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mhocko@suse.cz>,
        <glommer@parallels.com>
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/13 11:01, Tejun Heo wrote:
> Hello,
> 
> This became a rather large patchset mostly because there are a lot of
> weirdities and subtle breakages in create/destroy/load/unload paths.
> The goal of the patchset is allowing ->post_create() to fail and
> renaming ->create/post_create/pre_destroy/destroy() to
> ->css_alloc/css_online/css_offline/css_free().
> 
> This patchset contains the following seventeen patches.
> 
>  0001-cgroup-remove-incorrect-dget-dput-pair-in-cgroup_cre.patch
>  0002-cgroup-initialize-cgrp-allcg_node-in-init_cgroup_hou.patch
>  0003-cgroup-open-code-cgroup_create_dir.patch
>  0004-cgroup-create-directory-before-linking-while-creatin.patch
>  0005-cgroup-cgroup-dentry-isn-t-a-RCU-pointer.patch
>  0006-cgroup-remove-duplicate-RCU-free-on-struct-cgroup.patch
>  0007-cgroup-make-CSS_-flags-bit-masks-instead-of-bit-posi.patch
>  0008-cgroup-trivial-cleanup-for-cgroup_init-load_subsys.patch
>  0009-cgroup-lock-cgroup_mutex-in-cgroup_init_subsys.patch
>  0010-cgroup-fix-harmless-bugs-in-cgroup_load_subsys-fail-.patch
>  0011-cgroup-separate-out-cgroup_destroy_locked.patch
>  0012-cgroup-introduce-CSS_ONLINE-flag-and-on-offline_css-.patch
>  0013-cgroup-simplify-cgroup_load_subsys-failure-path.patch
>  0014-cgroup-use-mutex_trylock-when-grabbing-i_mutex-of-a-.patch
>  0015-cgroup-update-cgroup_create-failure-path.patch
>  0016-cgroup-allow-post_create-to-fail.patch
>  0017-cgroup-rename-create-post_create-pre_destroy-destroy.patch
> 

Acked-by: Li Zefan <lizefan@huawei.com>

except 0006-cgroup-remove-duplicate-RCU-free-on-struct-cgroup.patch

> 0001 is a bugfix.  Tagged for -stable.  I don't I'll push it through
> for-3.7-fixes tho.  This has been broken forever and nobody reported
> anything yet.
> 
> 0002-0011 are various fixes and cleanups to prepare for the following
> changes.  Each should be self-explanatory.
> 
> 0012-0015 are preparation patches more directly related to allowing
> failure of ->post_create().
> 
> 0016 allows ->post_create() to fail.
> 
> 0017 renames ops and updates documentation.
> 
> This patchst is on top of cgroup/for-3.8 and available on the
> following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-online-may-fail

