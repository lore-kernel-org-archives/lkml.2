Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2DDKil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:38:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab2DDKik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:38:40 -0400
Message-ID: <1333535915.7188.18.camel@marge.simpson.net>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 04 Apr 2012 12:38:35 +0200
In-Reply-To: <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 00:15 -0700, David Rientjes wrote: 
> On Tue, 3 Apr 2012, Mike Galbraith wrote:
> 
> > The hazzards of moving kthreadd into a non-root cgroup is still present
> > in mainline.  Last go 'round stalled with Peter not liking the
> > cpuset,cpu per controller specific exclusion.  I agree that total
> > exclusion is the better option, and below is a respin doing that.
> > 
> 
> We've been through this several times now iterating between two different 
> functional changes.  I appreciate the persistence, but please, again, 
> explain why you are doing this at the cgroups level rather than the 
> cpusets level?
> 
> The last time we discussed this, you had proposed a patch to only do this 
> for cpusets after the points I'm about to bring up for the fifth time.  
> Peter ended up not responding and as I remember it didn't have strong 
> feelings against doing it only for cpusets.  And here we are, yet again, 
> back to the cgroups version.

Suggest a third version.

> There's _nothing_ wrong with attaching a kthread to most cgroups.  We do 
> it for memcg.  And now you're trying to break it for ABSOLUTELY NO REASON.

Oh, caps made that so much more legible.

One, I don't see what it's breaking, and two, the reason for this repeat
is that the last attempt with cpuset,cpu exclusion did not fly.

I don't care how it gets fixed.  I just thought I should mention that
the problem is still alive upstream, did that, and was told I should try
this way again with CCs.

Ok, so you NAK this way, Peter NAKS the other way, and the bug lives on
forever.  So be it.

-Mike

