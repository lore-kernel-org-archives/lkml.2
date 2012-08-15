Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2HOTh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:37:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37851 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2HOThz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+W4afY+sCn5KMa-4ONmr7YnCu1m6d5P+aboSKe5=mgOMQ@mail.gmail.com>
References: <CALF0-+W4afY+sCn5KMa-4ONmr7YnCu1m6d5P+aboSKe5=mgOMQ@mail.gmail.com>
Date: Wed, 15 Aug 2012 16:37:54 -0300
Message-ID: <CALF0-+VWdyPmJEqC69hJXxufKgd9q77TBVEgLS3ryi9isLxW7A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] trace: Add early event trace support
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Tim Bird <tim.bird@am.sony.com>, lizefan@huawei.com,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 12:20 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hi Steven,
>
> This patch is my first attempt to address the "early tracing issue".
> Right now, trace events are registered on fs_initcall, which is very late
> if you want to capture boot-up events.
>
> This feature is in developers wish list as this old (2009) thread shows [1].
>
> By splitting the initialization, separating the ftrace enable from the
> sysfs entry
> creation, it is possible to move events enable to early_initcall.
> (which is also late, but I wouldn't expect more from such a small patch).
>
> Without this patch, and using
> "trace_event=kmem:kmalloc,kmem:kmalloc_node,kmem:kfree"
> as kernel parameter, on a bare kernel I can start capturing kmallocs
> from ~0.4 secs,
> and I get 186 callers.
>
> This patch moves the capture to ~ 0.2 secs and captures 220 callers.
>
> The caller count is inaccurate since gcc does some automatic inlining
> (I have another RFC PATCH for that), but it shows a rough increase.
>
> Also, this enable is not time-consuming:
> [    0.190000] calling  event_trace_enable+0x0/0xad @ 1
> [    0.190000] initcall event_trace_enable+0x0/0xad returned 0 after 0 usecs
>
> This patch is intended to trigger this discussion: to be honest I'm
> not sure how ugly
> this is. So some feedback about it would be greatly appreciated.
>
> Also, I'd like to ask for some guidelines (not solutions, just some guidelines)
> on how to attack this problem.
> I'm interesting on capturing kmem events, from the very first kmalloc onwards.
> Though, it would be nice to extend the solution to other event classes.
>
> Thanks,
> Ezequiel.
>
> [1] http://lkml.indiana.edu/hypermail/linux/kernel/0911.3/00036.html


I forgot to add this work is part of a project funded by CE workgroup.
You can find more details here:

http://elinux.org/Kernel_dynamic_memory_allocation_tracking_and_reduction

Thanks,
Ezequiel.
