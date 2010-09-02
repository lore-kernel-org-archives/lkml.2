Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0IBDxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:53:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54072 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0IBDxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:53:23 -0400
MIME-Version: 1.0
X-Originating-IP: [192.55.54.36]
In-Reply-To: <4c7d2072.8eecd80a.6e3a.2dd0@mx.google.com>
References: <4c7d2072.8eecd80a.6e3a.2dd0@mx.google.com>
Date: Thu, 2 Sep 2010 11:53:21 +0800
Message-ID: <AANLkTinoED59y9Nad1fNdPp0u-mJ3z_fGt=p6GBaVDt+@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup monitoring
From: Lin Ming <lin@ming.vg>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 11:25 PM, Stephane Eranian <eranian@google.com> wrote:
> This series of patches adds per-container (cgroup) filtering capability
> to per-cpu monitoring. In other words, we can monitor all threads belonging
> to a specific cgroup and running on a specific CPU.
>
> This is useful to measure what is going on inside a cgroup. Something that
> cannot easily and cheaply be achieved with either per-thread or per-cpu mode.
> Cgroups can span multiple CPUs. CPUs can be shared between cgroups. Cgroups
> can have lots of threads. Threads can come and go during a measurement.
>
> To measure per-cgroup today requires using per-thread mode and attaching to
> all the current threads inside a cgroup and tracking new threads. That would
> require scanning of /proc/PID, which is subject to race conditions, and
> creating an event for each thread, each event requiring kernel memory.
>
> The approach taken by this patch is to leverage the per-cpu mode by simply
> adding a filtering capability on context switch only when necessary. That
> way the amount of kernel memory used remains bound by the number of CPUs.
> We also do not have to scan /proc. We are only interested in cgroup level
> counts, not per-thread.
>
> The cgroup to monitor is designated by passing a file descriptor opened
> on a new per-cgroup file in the cgroup filesystem (perf_event.perf). The
> option must be activated by setting perf_event_attr.cgroup=1 and passing
> a valid file descriptor in perf_event_attr.cgroup_fd. Those are the only
> two ABI extensions.
>
> The patch also includes changes to the perf tool to make use of cgroup
> filtering. Both perf stat and perf record have been extended to support
> cgroup via a new -G option. The cgroup is specified per event:
>
> $ perf stat -a -e cycles:u,cycles:u -G test1,test2 -- sleep 1
>  Performance counter stats for 'sleep 1':
>         2368881622  cycles                   test1
>                  0  cycles                   test2
>        1.001938136  seconds time elapsed

I have tried this new feature. Cool!

perf stat [<options>] [<command>]

Is the command ("sleep 1" in above example) also counted?

Thanks,
Lin Ming
