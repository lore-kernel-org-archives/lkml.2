Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab2CLWdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:33:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:53579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2CLWdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:33:05 -0400
Message-ID: <1331591568.18960.61.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Date: Mon, 12 Mar 2012 23:32:48 +0100
In-Reply-To: <20120312222817.GI23255@google.com>
References: <20120221211938.GE12236@google.com>
	 <20120312221050.GG23255@google.com> <1331590938.18960.57.camel@twins>
	 <20120312222817.GI23255@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 15:28 -0700, Tejun Heo wrote:
> Hey,
> 
> On Mon, Mar 12, 2012 at 11:22:18PM +0100, Peter Zijlstra wrote:
> > On Mon, 2012-03-12 at 15:10 -0700, Tejun Heo wrote:
> > > 
> > > * How to map controllers which aren't aware of full hierarchy is still
> > >   an open question but I'm still standing by one active node on any
> > >   root-to-leaf path w/ root group serving as the special rest group. 
> > 
> > What does this mean?
> 
> Let's say we have a tree like the following.
> 
>          root
>       /   |   \
>      G1  G2   G3
>              /  \
> 	   G31  G32
> 
> So, for cgroups which don't support full hierarchy, it'll be viewed as
> either,
> 
>          root
>       /   |   \
>      G1  G2   G3
> 
> or
> 
>           root
>       /   |   |  \
>      G1  G2  G31 G32
> 
> With root being treated specially, probably as just being a equal
> group as other groups, I'm not fully determined about that yet.

I'm assuming that G31/G32's tasks end up in G3 in the first case, but
where do the tasks in G3 go to in the second case?

Also, why allow non-hierarchical controllers to begin with? I would very
much argue for mandating that all controllers work the same wrt
hierarchy and if that means ditching hierarchy support we should do that
and modify cgroupfs to not allow creation of directories deeper than 1.

But allowing controllers that implement hierarchy proper and controllers
that do not and then force them in the same mount point, that just
doesn't make any friggin sense what so ever.
