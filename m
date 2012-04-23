Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2DWSFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:05:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56035 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2DWSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:05:10 -0400
Date: Mon, 23 Apr 2012 11:05:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Li Zefan <lizefan@huawei.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
Message-ID: <20120423180505.GC5406@google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
 <20120420175751.GF32324@google.com>
 <1334986264.5428.1.camel@marge.simpson.net>
 <4F9259C2.9040305@huawei.com>
 <1334992426.5428.7.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334992426.5428.7.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 09:13:46AM +0200, Mike Galbraith wrote:
> On Sat, 2012-04-21 at 14:54 +0800, Li Zefan wrote:
> 
> > forgot rcu_read_unlock() ?
> 
> Eek, we don't need another one of those. Thanks.
> 
> > Otherwise Acked-by: Li Zefan <lizefan@huawei.com>
> 
> cgroups: disallow attaching kthreadd or PF_THREAD_BOUND threads
> 
> Allowing kthreadd to be moved to a non-root group makes no sense, it being
> a global resource, and needlessly leads unsuspecting users toward trouble.
> 
> 1. An RT workqueue worker thread spawned in a task group with no rt_runtime
> allocated is not schedulable.  Simple user error, but harmful to the box.
> 
> 2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
> rendering the cpuset immortal.
> 
> Save the user some unexpected trouble, just say no.
> 
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.5.  Thanks.

-- 
tejun
