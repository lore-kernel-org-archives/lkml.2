Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2CCO0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 09:26:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59552 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2CCO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 09:26:20 -0500
Date: Sat, 3 Mar 2012 08:26:04 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Lennart Poettering <lennart@poettering.net>, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120303142604.GA13187@peqn>
References: <20120221211938.GE12236@google.com>
 <m162em2efy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m162em2efy.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 4.  Only allow a single controller per hierarchy.  So that we can
> make reasonable choice points.  If the hierarchy is to be about
> policy I am baffled by concept of putting multiple controllers in
> a single hierarchy.  Because where you clump things together for
> policy for one controller in general does not seem to be where you
> want to clump things together for another controller.

This I agree with.  The only reasonably use I've seen for the
composed hierarchies is the ns cgroup, which was the wrong tool
for what it wanted to do anyway.  With ns cgroup deprecated, every
modern setup I've seen mounts each cgroup separately.

> > So, I mean, I don't know.  What do other people think?  Is this a
> > unnecessary worry?  Are people generally happy with the way things
> > are?  Lennart, Kay, what do you guys think?
> 
> I think the current situation is crazy.
> 
> I especially think it is crazy that inside a container I can't create
> a fresh set of cgroup mounts, and establish a fresh "hierarchy" relative
> to the process that created the cgroup mounts.  It sucks that
> controllers may nest fine but hierarchies don't nest.

Again I agree here.  In the past there has been brought up the idea
of fake cgroup roots ( http://thread.gmane.org/gmane.linux.kernel/1197643 )
I haven't looked in detail, but I know some people hated this particular
idea.  But it tried to solve this problem.

Perhaps we can attack this in two stages.

1. get rid of the ability to compose cgroups.  See how much this
simplifies the code.

2. add the ability to somehow namespace the cgroup mounts to allow a
container to freshly mount cgroups.

-serge
