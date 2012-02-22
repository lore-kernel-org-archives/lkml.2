Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2BVSn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:43:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33290 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab2BVSnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:43:24 -0500
Date: Wed, 22 Feb 2012 10:43:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120222184318.GE32694@google.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222165714.GC4128@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 22, 2012 at 11:57:14AM -0500, Vivek Goyal wrote:
> IIRC, another reason to implement flat hierachy was that some people
> believed that's more natural way of doing things. For example, when
> you talk about cgroup, people ask, ok, give me a cgroup with 25% IO
> bandwidth. Now this does not come naturally with completely nested
> hierarchies where task and groups are treated at the same level. As
> group's peer tasks share the bandwidth, and task come and go a group's
> % share varies dynamically.

I don't see how that is more "natural".  While I don't think
supporting full nesting is necessary for all controllers, the
semantics is very clear - build grouped trees according to active
configurations and distritbute resources top to bottom (network qdiscs
do exactly this).  Flat case is proper degenerate case of nesting.
There's nothing more or less natural.  It's just matter of trade off
between complexity and requirements.

> Again, it does not mean I am advocating flat hiearchy. I am just wondering
> in case of fully nested hierarchies (task at same level as groups), how
> does one explain it to a layman user who understands things in terms of
> % of resources.

I don't know whether we want nesting for block cgroup or not but at
the same time that doesn't really matter.  Sharing hierarchy doesn't
require every controller supporting full hierarchy.  I'm not sure how
the interface should be tho - maybe we can fail specifying config if
there already is an effective config encompassing that node or maybe
we can just break the existing config, I don't know.

Thank you.

-- 
tejun
