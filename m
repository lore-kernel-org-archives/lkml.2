Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2BWR3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:29:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48524 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2BWR3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:29:21 -0500
Date: Thu, 23 Feb 2012 09:29:15 -0800
From: Tejun Heo <tj@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Lennart Poettering <lennart@poettering.net>, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120223172915.GC22536@google.com>
References: <20120221211938.GE12236@google.com>
 <20120221212106.GF12236@google.com>
 <4F44EEE4.2000809@parallels.com>
 <20120223074526.GA15835@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223074526.GA15835@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Serge.

On Thu, Feb 23, 2012 at 07:45:26AM +0000, Serge E. Hallyn wrote:
> > >>Documentation/cgroups.txt seems to be written with this consideration
> > >>on mind.  It's giving an example of applying limits accoring to two
> > >>orthogonal categorizations - user groups (profressors, students...)
> > >>and applications (WWW, NFS...).  While it may sound like a valid use
> > >>case, I'm very skeptical how useful or common mixing such orthogonal
> > >>categorizations in a single setup would be.
> 
> My first inclination is to agree, but counterexamples do come to mind.
> 
> I could imagine a site saying "users can run (X) (say, ftpds), but the
> memory consumed by all those ftpds must not be > 10% total RAM".  At
> the same time, they may run several apaches but want them all locked to
> two of the cpus.

Orthogonal hierarchies is a feature and it does allow use cases which
aren't possible to support otherwise.  It's not too difficult to come
up with a use case crafted to exploit the feature.  The main thing is
whether the added functionality justifies the complexity and other
disadvantages described earlier in the thread.  To me, the scenarios
seem not realistic, common place or essential enough.

Also, it's not like there's only one problem to solve these issues.
It may not be exactly the same thing but that's just part of the
trade-off game we all play.

> It might be worth a formal description of the new limits on use cases
> such changes (both dropping support for orthogonal cgroups, and limiting
> cgroups hierarchies to a mirror pstrees, separately) would bring.

The word "formal" scares me. :)

> To me personally the hierarchy limitation is more worrying.  There have
> been times when I've simply created cgroups for 'compile' and 'image
> build', with particular cpu and memory limits.  If I started a second
> simultaneous compile, I'd want both compiles confined together.  (That's
> not to say the simplification might not be worth it, just bringing up
> the other side)

Yeah, that's an interesting point, but wouldn't something like the
following work too?

1. create_cgroup --cpu 40% --mem 20% screen
2. tell screen to create as many build screens you want
3. issue builds from those screens

To me, something like the above seems far more consistent with
everything else we have on the system than moving tasks around by
echoing pids to some sysfs file.

Thanks.

-- 
tejun
