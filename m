Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab1CCTif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:38:35 -0500
Received: from mout.perfora.net ([74.208.4.194]:63148 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912Ab1CCTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:38:34 -0500
Date: Thu, 3 Mar 2011 14:38:02 -0500
From: Stephen Wilson <wilsons@start.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable writing to /proc/PID/mem.
Message-ID: <20110303193802.GA4994@fibrous.localdomain>
References: <1299118074-13342-1-git-send-email-wilsons@start.ca> <20110303111240.B942.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303111240.B942.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:k1DZjB/HIjf8C/2PUjFhWxHBTkB67pVvN747usQvt8Z
 SiwiR8qCOuiMA6KVeDeZ+buEHE9DJJwauhaTsRkQ+G0OMO7kKg
 aE2TztH57ux6/2V6poDyK7jbD6ffR/8ycXK/aLYvpQv88Et8sg
 Z/kVjGaAc1ghcl2uBXly/ZQFdVksbMW/RtWCgnvfXaN6QgcFHh
 bsn2m6ZNSVmf5VYfmPUyl+KX3NSLN50DD9BpYxNiQU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 11:22:59AM +0900, KOSAKI Motohiro wrote:
> > For a long time /proc/PID/mem has provided a read-only interface, at least since
> > 2.4.0.  However, a write capability has existed "forever" in tree via the
> > function mem_write, disabled with an #ifdef along with the comment "this is a
> > security hazard".  Charles Wright, back in 2006, gave some history on the
> > subject:
> > 
> >     http://lkml.org/lkml/2006/3/10/224
> > 
> > Later, in commit 638fa202c, Roland McGrath updated mem_write to call
> > check_mem_permission which ensures an identical security policy for
> > /proc/PID/mem as for ptrace().  IOW, the proc interface provides a simpler, more
> > efficient, but otherwise equivalent mechanism for probing a processes memory as
> > available via ptrace.
> > 
> > There is no longer a security hazard and the world can safely use read/write
> > instead of ptrace PEEK/POKE's.  Remove the #ifdef.
> > 
> > Signed-off-by: Stephen Wilson <wilsons@start.ca>
> 
> I haven't found any problem in this patch. But, I really believe we need
> to understand why it was marked "security hazard". Al, I guess you know it,
> right? So, can you please talk us your mention?

I did a bit more digging trying to find why mem_write was marked a security
hazard.

It goes back to 2.4.0-test10pre4.  Unfortunately, the changelog entry is
not at all informative either:

	- disable writing to /proc/xxx/mem. Sure, it works now, but it's
	  still a security risk.

For the interested, some of the history is visible here:

	http://tinyurl.com/4aj4d3v


Personally, I have doubts that there is much to be gleaned from this
"security hazard" comment or any amount of archeology.

The code in question has been maintained for over a decade without use.
However, the implementation looks sane to me from a security POV as it
mirrors the policy for ptrace.  But it would be great to have a few more
eyes audit this change.

-- 
steve

