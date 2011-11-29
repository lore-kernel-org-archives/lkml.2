Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1K2T1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:27:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab1K2T1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:27:42 -0500
Date: Tue, 29 Nov 2011 20:22:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] sysctl: Add the kernel.ns_last_pid control
Message-ID: <20111129192245.GA7764@redhat.com>
References: <4ED3A6F5.6070606@parallels.com> <20111129174741.GA32209@redhat.com> <4ED52083.8090605@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED52083.8090605@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Pavel Emelyanov wrote:
>
> On 11/29/2011 09:47 PM, Oleg Nesterov wrote:
> >> +
> >> +static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
> >> +
> >>  static __init int pid_namespaces_init(void)
> >>  {
> >>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
> >> +	register_sysctl_paths(kern_path, pid_ns_ctl_table);
> >>  	return 0;
> >>  }
> >
> > Hmm. This way it depends on CONFIG_PID_NS.
>
> Yes, since this _is_ for namespaces. As we've found out this is close to completely
> unusable in the initial namespace in which tasks are just forking without caring
> much about what CAP_SYS_ADMIN-s think about this.

I agree, it is not very much usable. Still I think it can be used.
Say, init can write RESERVED_PIDS to this file. Or you can use it
to test the pid-reuse problems.

> > Can't we simply add an entry into kern_table[] ?
>
> And store the .proc_handler function dealing with somewhat which is pid namespace
> specific in the same generic file?

Why not? In fact I think that, say, /proc/sys/kernel/pid_max should
act per-namespace too.

> > And without ns_, just /proc/sys/kernel/last_pid.
>
> But that's the namespace's last pid, not just some system-wide last pid.

Sure, it is not system wide. Unless you use it from the root ns.


OK. I do not really care. I think the patch is correct, lets do it
this way.

Oleg.

