Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0JVMuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:50:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:46086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0JVMup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:50:45 -0400
Subject: Re: [PATCH 0/7] cgroups: Allow to bind/unbind subsystems to/from
 non-trival hierarchy
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
In-Reply-To: <4CC146A4.9090505@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Oct 2010 14:50:01 +0200
Message-ID: <1287751801.15336.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 16:09 +0800, Li Zefan wrote:
> Stephane posted a patchset to add perf_cgroup subsystem, so perf can
> be used to monitor all threads belonging to a cgroup.
> 
> But if you already mounted a cgroup hierarchy but without perf_cgroup
> and the hierarchy has sub-cgroups, you can't bind perf_cgroup to it,
> and thus you're not able to use per-cgroup perf feature.
> 
> This patchset alleviates the pain, and then a subsytem can be
> bound/unbound to/from a hierarchy which has sub-cgroups in it.
> 
> Some subsystems still can't take advantage of this patchset, memcgroup
> and cpuset in specific.
> 
> For cpuset, if a hierarchy has a sub-cgroup and the cgroup has tasks,
> we can't decide sub-cgroup's cpuset.mems and cpuset.cpus automatically
> if we try to bind cpuset to this hierarchy.
> 
> For memcgroup, memcgroup uses css_get/put(), and due to some complexity,
> for now bindable subsystems should not use css_get/put().
> 
> Usage:
> 
> # mount -t cgroup -o cpuset xxx /mnt
> # mkdir /mnt/tmp
> # echo $$ > /mnt/tmp/tasks
> 
> (add cpuacct to the hierarchy)
> # mount -o remount,cpuset,cpuacct xxx /mnt
> 
> (remove it from the hierarchy)
> # mount -o remount,cpuset xxx /mnt
> 
> There's another limitation, cpuacct should not be bound to any mounted
> hierarchy before the above operation. But that's not a problem, as you
> can remove it from a hierarchy and bind it to another one.

Right, so the only remaining problem I see with this approach is that
you cannot profile two different hierarchies at the same time, but I
can't really think of a solution to that problem (nor do I care very
much).

Seems like a nice approach, Thanks Li!
