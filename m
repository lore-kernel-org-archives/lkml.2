Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1LOIzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:55:51 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49882 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab1LOIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:55:48 -0500
Date: Thu, 15 Dec 2011 00:55:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] oom: add trace points for debugging.
In-Reply-To: <20111213181225.673e19db.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1112150055010.10848@chino.kir.corp.google.com>
References: <20111213181225.673e19db.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, KAMEZAWA Hiroyuki wrote:

> Subject: [PATCH] tracepoint: add tracepoints for debugging oom_score_adj.
> 
> oom_score_adj is used for guarding processes from OOM-Killer. One of problem
> is that it's inherited at fork(). When a daemon set oom_score_adj and
> make children, it's hard to know where the value is set.
> 
> This patch adds some tracepoints useful for debugging. This patch adds
> 3 trace points.
>   - creating new task
>   - renaming a task (exec)
>   - set oom_score_adj
> 
> To debug, users need to enable some trace pointer. Maybe filtering is useful as
> 
> # EVENT=/sys/kernel/debug/tracing/events/task/
> # echo "oom_score_adj != 0" > $EVENT/task_newtask/filter
> # echo "oom_score_adj != 0" > $EVENT/task_rename/filter
> # echo 1 > $EVENT/enable
> # EVENT=/sys/kernel/debug/tracing/events/oom/
> # echo 1 > $EVENT/enable
> 
> output will be like this.
> # grep oom /sys/kernel/debug/tracing/trace
> bash-7699  [007] d..3  5140.744510: oom_score_adj_update: pid=7699 comm=bash oom_score_adj=-1000
> bash-7699  [007] ...1  5151.818022: task_newtask: pid=7729 comm=bash clone_flags=1200011 oom_score_adj=-1000
> ls-7729  [003] ...2  5151.818504: task_rename: pid=7729 oldcomm=bash newcomm=ls oom_score_adj=-1000
> bash-7699  [002] ...1  5175.701468: task_newtask: pid=7730 comm=bash clone_flags=1200011 oom_score_adj=-1000
> grep-7730  [007] ...2  5175.701993: task_rename: pid=7730 oldcomm=bash newcomm=grep oom_score_adj=-1000
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for being persistant with this!
