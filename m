Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2DDVRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:17:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55470 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab2DDVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:17:39 -0400
Date: Wed, 4 Apr 2012 14:17:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-Reply-To: <1333542649.7188.40.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net> <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
 <1333542649.7188.40.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012, Mike Galbraith wrote:

> > I've never seen a nack from Peter on this, I only remember discussing 
> > whether this needs to be isolated to only cpusets or whether it needs to 
> > be a generic cgroup thing and I've always argued in favor of localizing it 
> > to cpusets because that cgroup happens to care about cpu affinity where 
> > others don't and this is why cgroups have ->can_attach() functions.  If a 
> > cgroup were created to have nothing to do with cpu affinity (only for 
> > collecting statistics for threads within it, for example), there's 
> > absolutely no reason why we need to exclude kthreadd.
> 
> Well, he didn't actually say "NAK", but was against it, which means
> pretty much the same thing as NAK to me.. we can call it a nak.
> 

People are able to change their minds and after our discussion about 
cgroups vs cpusets, I was under the impression we were at a common 
understanding of the problem.

Cpusets are a cgroup.  It wouldn't make much sense to NACK a patch that 
does this to cpusets if you're arguing in favor of doing it for all 
cgroups.

Your changelog mentions only cpusets issues, not cgroup issues.

So please propose your cpusets version so that the issue can be fixed.  If 
Peter wants to extend that to cgroups later, that's a discussion we can 
have at that time.  However, the bug being addressed here is for cpusets 
and is deserving of a patch now rather than later.  I'm concerned we're 
just going to drop this again and it will live on.
