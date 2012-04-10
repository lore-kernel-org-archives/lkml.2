Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2DJA7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:59:40 -0400
Received: from szxga03-in.huawei.com ([58.251.152.66]:49286 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2DJA7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:59:38 -0400
Date: Tue, 10 Apr 2012 08:59:33 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: bind() call in cgroup's css structure
In-reply-to: <4F82EB5C.7090003@parallels.com>
X-Originating-IP: [10.166.88.147]
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Paul Turner <pjt@google.com>,
        cgroups@vger.kernel.org, "devel@openvz.org" <devel@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4F8385F5.1020901@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <4F82EB5C.7090003@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:

> Hello Tejun,
> 
> During your cgroup refactor, I was wondering if you have any plans to get rid of the bind() callback that is called when hierarchies are moved?


I planned to remove it long ago, and Paul M agreed. But after some time, I was
trying to make use of it in a patchset, which was used to fix the problem that
remount with different subsys bits will fail for !root cgroups.

> 
> At least in tree, there seems to be no users for that.
> I actually planned to use it myself, to start or remove a jump label
> when cpuacct and cpu cgroups were comounted.
> 
> Problem is, because we have some calls in the cpuset cgroup from inside the cpu hotplug handler, we end up taking the almighty cgroup_mutex from inside the cpu_hotplug.lock.
> 
> jump labels take it in most arches through the get_online_cpus() function call. This means we effectively can't apply jump labels with the cgroup_mutex held, which is the case throughout the whole bind() call.
> 
> All that explained, I figured I might as well ask before I attempted a solution to that myself: as much as populate(), bind seems to be one of the overly complicated callbacks, designed for a scenario in which everything can come and go at will, which is something we're trying to fix.
> 


As we aim for single hierarchy, it defenitely should be removed.

