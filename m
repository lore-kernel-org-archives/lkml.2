Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2DDXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:09:28 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52542 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211Ab2DDXJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:09:27 -0400
Date: Wed, 4 Apr 2012 16:09:22 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
Message-ID: <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
 <1333535915.7188.18.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
 <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 02:17:36PM -0700, David Rientjes wrote:
> On Wed, 4 Apr 2012, Mike Galbraith wrote:
> 
> > > I've never seen a nack from Peter on this, I only remember discussing 
> > > whether this needs to be isolated to only cpusets or whether it needs to 
> > > be a generic cgroup thing and I've always argued in favor of localizing it 
> > > to cpusets because that cgroup happens to care about cpu affinity where 
> > > others don't and this is why cgroups have ->can_attach() functions.  If a 
> > > cgroup were created to have nothing to do with cpu affinity (only for 
> > > collecting statistics for threads within it, for example), there's 
> > > absolutely no reason why we need to exclude kthreadd.
> > 
> > Well, he didn't actually say "NAK", but was against it, which means
> > pretty much the same thing as NAK to me.. we can call it a nak.
> > 
> 
> People are able to change their minds and after our discussion about 
> cgroups vs cpusets, I was under the impression we were at a common 
> understanding of the problem.
> 
> Cpusets are a cgroup.  It wouldn't make much sense to NACK a patch that 
> does this to cpusets if you're arguing in favor of doing it for all 
> cgroups.
> 
> Your changelog mentions only cpusets issues, not cgroup issues.
> 
> So please propose your cpusets version so that the issue can be fixed.  If 
> Peter wants to extend that to cgroups later, that's a discussion we can 
> have at that time.  However, the bug being addressed here is for cpusets 
> and is deserving of a patch now rather than later.  I'm concerned we're 
> just going to drop this again and it will live on.

I don't see much problem with the proposed solution and am gonna take
it unless there are pretty good reasons not to.

Thanks.

-- 
tejun
