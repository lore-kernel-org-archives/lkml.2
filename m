Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2JVFin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:38:43 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44818 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2JVFil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:38:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAKWKT+Z-SZb1=3rwLm+urs3fghQ3M6pdOR_rzXKCevoad11a5g@mail.gmail.com>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
	<20121019160425.GA10175@dhcp22.suse.cz>
	<CAKWKT+Z-SZb1=3rwLm+urs3fghQ3M6pdOR_rzXKCevoad11a5g@mail.gmail.com>
Date: Mon, 22 Oct 2012 11:08:40 +0530
Message-ID: <CAKTCnzmDhSd-POHSC0wx-ziVPUg9wFverK33Q1_SvCx3Gzuugg@mail.gmail.com>
Subject: Re: process hangs on do_exit when oom happens
From: Balbir Singh <bsingharora@gmail.com>
To: Qiang Gao <gaoqiangscut@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 7:46 AM, Qiang Gao <gaoqiangscut@gmail.com> wrote:
> I don't know whether  the process will exit finally, bug this stack lasts
> for hours, which is obviously unnormal.
> The situation:  we use a command calld "cglimit" to fork-and-exec the worker
> process,and the "cglimit" will
> set some limitation on the worker with cgroup. for now,we limit the
> memory,and we also use cpu cgroup,but with
> no limiation,so when the worker is running, the cgroup directory looks like
> following:
>
> /cgroup/memory/worker : this directory limit the memory
> /cgroup/cpu/worker :with no limit,but worker process is in.
>
> for some reason(some other process we didn't consider),  the worker process
> invoke global oom-killer,
> not cgroup-oom-killer.  then the worker process hangs there.
>
> Actually, if we didn't set the worker process into the cpu cgroup, this will
> never happens.
>

You said you don't use CPU limits right? can you also send in the
output of /proc/sched_debug. Can you also send in your
/etc/cgconfig.conf? If the OOM is not caused by cgroup memory limit
and the global system is under pressure in 2.6.32, it can trigger an
OOM.

Also

1. Have you turned off swapping (seems like it) right?
2. Do you have a NUMA policy setup for this task?

Can you also share the .config (not sure if any special patches are
being used) in the version you've mentioned.

Balbir
