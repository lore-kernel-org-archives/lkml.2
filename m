Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab1HXBOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:14:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50436 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab1HXBOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:14:35 -0400
Date: Wed, 24 Aug 2011 03:14:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate
 subsys methods
Message-ID: <20110824011428.GC23979@somewhere>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314138000-2049-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:19:54AM +0200, Tejun Heo wrote:
> Hello,
> 
> cgroup has grown quite some number of subsys methods.  Some of them
> are overlapping, inconsistent with each other and called under
> different conditions depending on whether they're called for a single
> task or whole process.  Unfortunately, these callbacks are complicated
> and incomplete at the same time.
> 
> * ->attach_task() is called after migration for task attach but before
>   for process.
> 
> * Ditto for ->pre_attach().
> 
> * ->can_attach_task() is called for every task in the thread group but
>   ->attach_task() skips the ones which don't actually change cgroups.
> 
> * Task attach becomes noop if the task isn't actually moving.  Process
>   attach is always performed.
> 
> * ->attach_task() doesn't (or at least aren't supposed to) have access
>   to the old cgroup.
> 
> * During cancel, there's no way to access the affected tasks.
> 
> This patchset introduces cgroup_taskset along with some accessors and
> iterator, updates methods to use it, consolidates usages and drops
> superflous methods.
> 
> It contains the following six patches.
> 
>  0001-cgroup-subsys-attach_task-should-be-called-after-mig.patch
>  0002-cgroup-improve-old-cgroup-handling-in-cgroup_attach_.patch
>  0003-cgroup-introduce-cgroup_taskset-and-use-it-in-subsys.patch
>  0004-cgroup-don-t-use-subsys-can_attach_task-or-attach_ta.patch
>  0005-cgroup-cpuset-don-t-use-ss-pre_attach.patch
>  0006-cgroup-kill-subsys-can_attach_task-pre_attach-and-at.patch

I don't understand the point on patches 3,4,5,6

Why pushing the task iterations down to the subsystems?
