Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2DEQMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:12:03 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54704 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab2DEQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:12:01 -0400
Date: Thu, 5 Apr 2012 09:11:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
Message-ID: <20120405161156.GB12854@google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
 <1333535915.7188.18.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
 <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
 <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
 <1333601231.7783.31.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333601231.7783.31.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 06:47:11AM +0200, Mike Galbraith wrote:
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
> 
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>

Li, I'm gonna route this through for-3.4-fixes.  Can you please ack
it?

Thanks.

-- 
tejun
