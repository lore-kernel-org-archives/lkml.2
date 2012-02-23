Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab2BWHvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:51:47 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:37573 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2BWHvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:51:46 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 02:51:45 EST
Date: Thu, 23 Feb 2012 07:45:26 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Lennart Poettering <lennart@poettering.net>, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120223074526.GA15835@mail.hallyn.com>
References: <20120221211938.GE12236@google.com>
 <20120221212106.GF12236@google.com>
 <4F44EEE4.2000809@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F44EEE4.2000809@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Glauber Costa (glommer@parallels.com):
> >>The support for multiple process hierarchies always struck me as
> >>rather strange.  If you forget about the current cgroup controllers
> >>and their implementations, the *only* reason to support multiple
> >>hierarchies is if you want to apply resource limits based on different
> >>orthogonal categorizations.
> >>

Right, the old lwn writeup took the same approach:
http://lwn.net/Articles/236038/

> >>Documentation/cgroups.txt seems to be written with this consideration
> >>on mind.  It's giving an example of applying limits accoring to two
> >>orthogonal categorizations - user groups (profressors, students...)
> >>and applications (WWW, NFS...).  While it may sound like a valid use
> >>case, I'm very skeptical how useful or common mixing such orthogonal
> >>categorizations in a single setup would be.

My first inclination is to agree, but counterexamples do come to mind.

I could imagine a site saying "users can run (X) (say, ftpds), but the
memory consumed by all those ftpds must not be > 10% total RAM".  At
the same time, they may run several apaches but want them all locked to
two of the cpus.

It might be worth a formal description of the new limits on use cases
such changes (both dropping support for orthogonal cgroups, and limiting
cgroups hierarchies to a mirror pstrees, separately) would bring.

To me personally the hierarchy limitation is more worrying.  There have
been times when I've simply created cgroups for 'compile' and 'image
build', with particular cpu and memory limits.  If I started a second
simultaneous compile, I'd want both compiles confined together.  (That's
not to say the simplification might not be worth it, just bringing up
the other side)

-serge
