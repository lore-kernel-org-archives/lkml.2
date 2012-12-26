Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2LZKVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 05:21:31 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64335 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2LZKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 05:21:29 -0500
Message-ID: <50DACF5B.6050705@huawei.com>
Date: Wed, 26 Dec 2012 18:20:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <paul@paulmenage.org>, <glommer@parallels.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] cpuset: cleanup cpuset[_can]_attach()
References: <1354138460-19286-1-git-send-email-tj@kernel.org> <1354138460-19286-7-git-send-email-tj@kernel.org>
In-Reply-To: <1354138460-19286-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/29 5:34, Tejun Heo wrote:
> cpuset_can_attach() prepare global variables cpus_attach and
> cpuset_attach_nodemask_{to|from} which are used by cpuset_attach().
> There is no reason to prepare in cpuset_can_attach().  The same
> information can be accessed from cpuset_attach().
> 
> Move the prepartion logic from cpuset_can_attach() to cpuset_attach()
> and make the global variables static ones inside cpuset_attach().
> 
> While at it, convert cpus_attach to cpumask_t from cpumask_var_t.
> There's no reason to mess with dynamic allocation on a static buffer.
> 

But Rusty had been deprecating the use of cpumask_t. I don't know why
the final deprecation hasn't been completed yet.
