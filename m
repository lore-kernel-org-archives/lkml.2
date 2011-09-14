Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab1INUNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:13:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab1INUNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:13:34 -0400
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Wed, 14 Sep 2011 22:13:16 +0200
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316031196.5040.46.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> [[ For those getting this twice: I sent it previously to containers
>    ml, but I guess it was out. Sending now to a broader audience anyway ]]
> 
> Hi,
> 
> This patchset is a simple initial proposal for a per-cgroup/container
> display of /proc/stat. The display method is based on Daniel's idea of
> exposing a file that can be bind mounted (Daniel, is that more or less
> what you had in mind?)
> 
> To grab the stats themselves, I am (ab)using cpuacct cgroup. percpu counters
> are dropped in favor of normal percpu pointers, so we can easily track
> per-cpu quantities.
> 
> In case you guys like this idea, my TODO list would include the removal
> of the show stat code in fs/proc/stat.c altogether, and the displaying
> of some fields I haven't touched yet.
> 
> Also, to demonstrate one of the potential ideas for such method, I
> implemented a feature comonly found in hypervisors - steal time - on top
> of it. I arguee that containers can/should also display steal time when
> available. Turns out that due to the fact that we run on the same kernel,
> steal time is quite easy to implement once we have per-container tick
> accounting in place.
> 
> Please let me know what you guys think
> 
> Glauber Costa (9):
>   Remove parent field in cpuacct cgroup
>   Make cpuacct fields per cpu variables
>   Include nice values in cpuacct
>   Include irq and softirq fields in cpuacct
>   Include guest fields in cpuacct
>   Include idle and iowait fields in cpuacct
>   Create cpuacct.proc.stat file
>   per-cgroup boot time
>   Report steal time for cgroup
> 
>  kernel/sched.c |  265 +++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 234 insertions(+), 31 deletions(-)

I hate it already.. it just smells of more senseless accounting
overhead.

Guys we should seriously trim back a lot of that code, not grow ever
more and more. The sad fact is that if you build a kernel with
cpu-cgroup support the context switch cost is more than double that of a
kernel without, and then you haven't even started creating cgroups yet.

Also, how doesn't all this duplicate part of cpuacct-cgroup?

/me won't actually look at the patches for a little while longer.
