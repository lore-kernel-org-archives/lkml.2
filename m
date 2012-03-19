Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2CSKYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:24:15 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50734 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2CSKYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:24:14 -0400
Message-ID: <4F6708F4.4000604@parallels.com>
Date: Mon, 19 Mar 2012 14:22:44 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizf@cn.fujitsu.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <rni@google.com>, <ctalbott@google.com>
Subject: Re: [PATCHSET] cgroup: cftype based file interface
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
In-Reply-To: <1331940963-15756-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 03:35 AM, Tejun Heo wrote:
> Hello, guys.
>
> This patch replaces cgroup file interface with cftype based one which
> allows dynamic additions and removals of cftype arrays whether the
> target subsystem is attached or not.

Great

> This can be used to make subsys
> rebinding via remount work properly but I intentionally avoided doing
> that at the moment.
>
> This makes cgroup population simpler for controllers and will be used
> to allow controllers to be more dynamic.  e.g. blkio subsys has
> sub-policies which may come and go while blkio subsys is attached and
> it currently uses fixed set of files which stays blank if not in use.
> This will also be useful for implementing unified hierarchy.
>
> This patchset contains the following patches.
>
>   0001-cgroup-move-cgroup_clear_directory-call-out-of-cgrou.patch
>   0002-cgroup-build-list-of-all-cgroups-under-a-given-cgrou.patch
>   0003-cgroup-implement-cgroup_add_cftypes-and-friends.patch
>   0004-cgroup-merge-cft_release_agent-cftype-array-into-the.patch
>   0005-cgroup-convert-all-non-memcg-controllers-to-the-new-.patch
>   0006-cgroup-convert-memcg-controller-to-the-new-cftype-in.patch
>   0007-cgroup-remove-cgroup_add_file-s.patch
>   0008-cgroup-relocate-__d_cgrp-and-__d_cft.patch
>   0009-cgroup-introduce-struct-cfent.patch
>   0010-cgroup-implement-cgroup_rm_cftypes.patch
>
> and is on top of
>
>    cgroup/for-3.4 3ce3230a0cff484e5130153f244d4fb8a56b3a8b
> + [1] cgroup: deprecate remount option changes mount option
>
> and is also available in the following git branch.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cgroup-cftype
>
> Glauber, can you please try to move net kmem stuff out of
> ->populate().  If ->create() doesn't work for whatever reason, can you
> please explain it to me so that we can find a proper solution?

The main reason is twofold:

It first had to do with the order in which registerings take place at 
the kernel. But this matter most for the root cgroup. For the children, 
it should be all initialized anyway. So we can special case whatever is 
needed.

Another point was not to bloat the socket structures with more function 
calls, for populate and create. But we can possibly be able to store 
some data ourselves, and figure it out.

How should I do it? Do you want me to provide a patch ontop of your tree ?
