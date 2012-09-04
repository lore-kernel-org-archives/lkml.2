Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2IDVqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2IDVqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:46:07 -0400
Date: Tue, 4 Sep 2012 14:46:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        davej@redhat.com, ben@decadent.org.uk, a.p.zijlstra@chello.nl,
        pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346768300-10282-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Tue, Sep 04, 2012 at 06:18:15PM +0400, Glauber Costa wrote:
> As we have been extensively discussing, the cost and pain points for cgroups
> come from many places. But at least one of those is the arbitrary nature of
> hierarchies. Many people, including at least Tejun and me would like this to go
> away altogether. Problem so far, is breaking compatiblity with existing setups
> 
> I am proposing here a default-n Kconfig option that will guarantee that the cpu
> cgroups (for now) will be comounted. I started with them because the
> cpu/cpuacct division is clearly the worst offender. Also, the default-n is here
> so distributions will have time to adapt: Forcing this flag to be on without
> userspace changes will just lead to cgroups failing to mount, which we don't
> want.
> 
> Although I've tested it and it works, I haven't compile-tested all possible
> config combinations. So this is mostly for your eyes. If this gets traction,
> I'll submit it properly, along with any changes that you might require.

As I said during the discussion, I'm skeptical about how useful this
is.  This can't nudge existing users in any meaningfully gradual way.
Kconfig doesn't make it any better.  It's still an abrupt behavior
change when seen from userland.

Also, I really don't see much point in enforcing this almost arbitrary
grouping of controllers.  It doesn't simplify anything and using
cpuacct in more granular way than cpu actually is one of the better
justified use of multiple hierarchies.  Also, what about memcg and
blkcg?  Do they *really* coincide?  Note that both blkcg and memcg
involve non-trivial overhead and blkcg is essentially broken
hierarchy-wise.

Currently, from userland visible behavior POV, the crazy parts are

1. The flat hierarchy thing.  This just should go away.

2. Orthogonal multiple hierarchies.

I think we agree that #1 should go away one way or the other.  I
*really* wanna get rid of #2 but am not sure how.  I'll give it
another stab once the writeback thing is resolved.

Thanks.

-- 
tejun
