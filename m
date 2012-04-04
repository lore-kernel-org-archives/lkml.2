Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2DDHPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:15:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34678 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2DDHPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:15:03 -0400
Date: Wed, 4 Apr 2012 00:15:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-Reply-To: <1333475906.7439.7.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Mike Galbraith wrote:

> The hazzards of moving kthreadd into a non-root cgroup is still present
> in mainline.  Last go 'round stalled with Peter not liking the
> cpuset,cpu per controller specific exclusion.  I agree that total
> exclusion is the better option, and below is a respin doing that.
> 

We've been through this several times now iterating between two different 
functional changes.  I appreciate the persistence, but please, again, 
explain why you are doing this at the cgroups level rather than the 
cpusets level?

The last time we discussed this, you had proposed a patch to only do this 
for cpusets after the points I'm about to bring up for the fifth time.  
Peter ended up not responding and as I remember it didn't have strong 
feelings against doing it only for cpusets.  And here we are, yet again, 
back to the cgroups version.

There's _nothing_ wrong with attaching a kthread to most cgroups.  We do 
it for memcg.  And now you're trying to break it for ABSOLUTELY NO REASON.

Both points you mention in your changelog below have to do with bad 
_cpuset_ behavior, not _cgroup_ behavior.

So nack in this form, but I'm pretty sure you already knew that.

> cgroups: disallow attaching kthreadd
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
