Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2BVQ51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:57:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab2BVQ5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:57:25 -0500
Date: Wed, 22 Feb 2012 11:57:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120222165714.GC4128@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222163858.GB4128@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 11:38:58AM -0500, Vivek Goyal wrote:

[..]
> > 
> >    Most importantly, we would need to clean up how nesting is handled
> >    across different subsystems.  Handling internal and leaf nodes as
> >    equals simply can't work.  Membership should be recursive, and for
> >    subsystems which can't support proper nesting, the right thing to
> >    do would be somehow ensuring that only single node in the path from
> >    root to leaf is active for the controller.  We may even have to
> >    introduce an alternative of operation to support this (yuck).
> > 
> >    This path would require the most amount of work and we would be
> >    excluding a feature - support for multiple orthogonal
> >    categorizations - which has been available till now, probably
> >    through deprecation process spanning years; however, this at least
> >    gives us hope that we may reach sanity in the end, how distant that
> >    end may be.  Oh, hope. :)
> 
> Yes this is something needs to be cleaned up. Everybody seems to have
> dealt with hiearchy in its own way.
> 
> For blkio controller, initially we provided fully nested hiearchies like
> cpu controller but then implementation became too complex (CFQ is already
> complicated and implementing fully nested hiearchies made it much more
> complicated without any significant gain). So, I converted it into
> flat model where internally we treat the whole hierarchy flat. (It
> might have been a bad decision though).

IIRC, another reason to implement flat hierachy was that some people
believed that's more natural way of doing things. For example, when
you talk about cgroup, people ask, ok, give me a cgroup with 25% IO
bandwidth. Now this does not come naturally with completely nested
hierarchies where task and groups are treated at the same level. As
group's peer tasks share the bandwidth, and task come and go a group's
% share varies dynamically.

Again, it does not mean I am advocating flat hiearchy. I am just wondering
in case of fully nested hierarchies (task at same level as groups), how
does one explain it to a layman user who understands things in terms of
% of resources.

Just saying that your group has weight X does not mean much in absolute
terms. And % bandwidth achieved by group will vary dynamically. (Hey,
you told me that one can divide the system resources somewhat
deterministically. But bandwidth varying dynamically does not sound the
same).

Thanks
Vivek
