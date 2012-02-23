Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2BWJl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:41:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:39461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab2BWJly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:41:54 -0500
Message-ID: <1329990094.24994.64.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Thu, 23 Feb 2012 10:41:34 +0100
In-Reply-To: <20120222165714.GC4128@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 11:57 -0500, Vivek Goyal wrote:
> 
> Again, it does not mean I am advocating flat hiearchy. I am just wondering
> in case of fully nested hierarchies (task at same level as groups), how
> does one explain it to a layman user who understands things in terms of
> % of resources. 

If your complete control is % based then I would assume its a % of a %.
Simple enough.

If its bandwidth based then simply don't allow a child to consume more
bandwidth than its parent, also simple.

If your layman isn't capable of grokking that, he should stay the f*ck
away from it.

I'm really thinking that if we stick with the full hierarchical thing we
should mandate all controllers be fully hierarchical. And yes that
sucks, but so be it.

The scheduler thing tries to be completely hierarchical and yes it will
run into the ground if you push it hard enough simply because we're
hitting the limits of fixed point arithmetic, fractions can only go so
far, so the deeper you nest the crappier things get -- not that any
userspace cares about this.


