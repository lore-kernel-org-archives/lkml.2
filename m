Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1A0AQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:16:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab1A0AQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:16:52 -0500
Date: Wed, 26 Jan 2011 16:16:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup : remove the ns_cgroup
Message-Id: <20110126161648.39af9576.akpm@linux-foundation.org>
In-Reply-To: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr>
References: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 10:39:48 +0100
Daniel Lezcano <daniel.lezcano@free.fr> wrote:

> The ns_cgroup is an annoying cgroup at the namespace / cgroup frontier
> and leads to some problems:
> 
>         * cgroup creation is out-of-control
>         * cgroup name can conflict when pids are looping
>         * it is not possible to have a single process handling
>         a lot of namespaces without falling in a exponential creation time
>         * we may want to create a namespace without creating a cgroup
> 
>         The ns_cgroup was replaced by a compatibility flag 'clone_children',
>         where a newly created cgroup will copy the parent cgroup values.
>         The userspace has to manually create a cgroup and add a task to
>         the 'tasks' file.
> 
> This patch removes the ns_cgroup as suggested in the following thread:
> 
> https://lists.linux-foundation.org/pipermail/containers/2009-June/018616.html
> 
> The 'cgroup_clone' function is removed because it is no longer used.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Jamal Hadi Salim <hadi@cyberus.ca>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Paul Menage <menage@google.com>
> Acked-by: Matt Helsley <matthltc@us.ibm.com>
>
> ...
>
>  22 files changed, 4 insertions(+), 287 deletions(-)

I didn't see that one coming.

This change is userspace-visible, is it not?  What are the implications
of this?  There's some discussion in that nearly-two-year-old thread
regarding making provision for back-compatibility but I'm not seeing
such things in this patch?


