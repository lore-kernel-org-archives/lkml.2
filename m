Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab0JYBGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:06:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63454 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0JYBGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:06:31 -0400
Message-ID: <4CC4D84C.5000705@cn.fujitsu.com>
Date: Mon, 25 Oct 2010 09:07:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 0/7] cgroups: Allow to bind/unbind subsystems to/from
 non-trival hierarchy
References: <4CC146A4.9090505@cn.fujitsu.com> <1287751801.15336.35.camel@twins>
In-Reply-To: <1287751801.15336.35.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2010-10-22 at 16:09 +0800, Li Zefan wrote:
>> Stephane posted a patchset to add perf_cgroup subsystem, so perf can
>> be used to monitor all threads belonging to a cgroup.
>>
>> But if you already mounted a cgroup hierarchy but without perf_cgroup
>> and the hierarchy has sub-cgroups, you can't bind perf_cgroup to it,
>> and thus you're not able to use per-cgroup perf feature.
>>
>> This patchset alleviates the pain, and then a subsytem can be
>> bound/unbound to/from a hierarchy which has sub-cgroups in it.
>>
>> Some subsystems still can't take advantage of this patchset, memcgroup
>> and cpuset in specific.
>>
>> For cpuset, if a hierarchy has a sub-cgroup and the cgroup has tasks,
>> we can't decide sub-cgroup's cpuset.mems and cpuset.cpus automatically
>> if we try to bind cpuset to this hierarchy.
>>
>> For memcgroup, memcgroup uses css_get/put(), and due to some complexity,
>> for now bindable subsystems should not use css_get/put().
>>
>> Usage:
>>
>> # mount -t cgroup -o cpuset xxx /mnt
>> # mkdir /mnt/tmp
>> # echo $$ > /mnt/tmp/tasks
>>
>> (add cpuacct to the hierarchy)
>> # mount -o remount,cpuset,cpuacct xxx /mnt
>>
>> (remove it from the hierarchy)
>> # mount -o remount,cpuset xxx /mnt
>>
>> There's another limitation, cpuacct should not be bound to any mounted
>> hierarchy before the above operation. But that's not a problem, as you
>> can remove it from a hierarchy and bind it to another one.
> 
> Right, so the only remaining problem I see with this approach is that
> you cannot profile two different hierarchies at the same time, but I
> can't really think of a solution to that problem (nor do I care very
> much).
> 

Paul had a patch to allow some subsystems to be added to multi-hierarchies,
which may help. But it forbids accessing t->cgroups, which makes this
feature of limited use.

Anyway I too don't care much about this.

> Seems like a nice approach, Thanks Li!
> 

Thanks!
