Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2KSOGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:06:17 -0500
Received: from mail.bmw-carit.de ([62.245.222.98]:37882 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2KSOGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:06:16 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 09:06:16 EST
X-CTCH-RefID: str=0001.0A0C0201.50AA3B5F.01A8,ss=1,re=0.000,fgs=0
Message-ID: <50AA3B5E.3080701@bmw-carit.de>
Date: Mon, 19 Nov 2012 14:59:58 +0100
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <serge.hallyn@canonical.com>, <ebiederm@xmission.com>,
        <nhorman@tuxdriver.com>, <tgraf@suug.ch>, <davem@davemloft.net>,
        <lizefan@huawei.com>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
In-Reply-To: <1353123062-23193-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 17.11.2012 04:30, Tejun Heo wrote:
> Hello, guys.
> 
> This patchset implements proper hierarchy support for netcls_cgroup.
> Pretty simliar to the netprio one[3].  Simpler as each cgroup has
> single config value instead of array of them.
> 
> This patchset contains the following three patches.
> 
>   0001-netcls_cgroup-introduce-netcls_mutex.patch
>   0002-netcls_cgroup-introduce-cgroup_cls_state-is_local.patch
>   0003-netcls_cgroup-implement-proper-hierarchy-support.patch
> 
> This patchset is on top of
> 
> cgroup/for-3.8 ef9fe980c6 ("cgroup_freezer: implement proper hierarchy support")
> + [1] "[PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail"
> + [2] "[PATCH 1/2] cgroup: s/CGRP_CLONE_CHILDREN/CGRP_CPUSET_CLONE_CHILDREN/"
>        "[PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()"
> + [3] "[PATCHSET cgroup/for-3.8] netprio_cgroup: implement hierarchy support"
> 
> and available in the following git branch.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-netcls_cgroup-hierarchy
> 
> diffstat follows.
> 
>   include/net/cls_cgroup.h |    1
>   net/sched/cls_cgroup.c   |  102 ++++++++++++++++++++++++++++++++++++++++-------
>   2 files changed, 88 insertions(+), 15 deletions(-)
> 
> Thanks.

I played a bit around with this series, e.g. creating a hierarchy and and changing 
the root classid and seeing the change propagating through the hierarchy. Everything
worked as described in the documentation.

Sorry to bring this up again: how should to root cgroup behave? If the ultimate
goal to have only one single hierarchy then I would assume it is important that
the semantic for all controllers are the same. As you pointed out the networking
controllers are kind of a strange beast in the zoo of the cgroup controllers. 
But still I would assume that all root controllers behave the same. memcg or cpu*
are not expected to do any work in the root cgroup.

cheers,
daniel



