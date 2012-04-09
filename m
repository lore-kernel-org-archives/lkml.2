Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2DIOBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:01:32 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40016 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2DIOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:01:31 -0400
Message-ID: <4F82EB5C.7090003@parallels.com>
Date: Mon, 9 Apr 2012 10:59:56 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Paul Turner <pjt@google.com>, <cgroups@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: bind() call in cgroup's css structure
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

During your cgroup refactor, I was wondering if you have any plans to 
get rid of the bind() callback that is called when hierarchies are moved?

At least in tree, there seems to be no users for that.
I actually planned to use it myself, to start or remove a jump label
when cpuacct and cpu cgroups were comounted.

Problem is, because we have some calls in the cpuset cgroup from inside 
the cpu hotplug handler, we end up taking the almighty cgroup_mutex from 
inside the cpu_hotplug.lock.

jump labels take it in most arches through the get_online_cpus() 
function call. This means we effectively can't apply jump labels with 
the cgroup_mutex held, which is the case throughout the whole bind() call.

All that explained, I figured I might as well ask before I attempted a 
solution to that myself: as much as populate(), bind seems to be one of 
the overly complicated callbacks, designed for a scenario in which 
everything can come and go at will, which is something we're trying to fix.

thanks in advance for your answer!
