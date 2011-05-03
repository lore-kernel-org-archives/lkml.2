Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1ECGia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:38:30 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52890 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1ECGi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:38:29 -0400
Date: Tue, 3 May 2011 08:38:17 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ying Han <yinghan@google.com>, Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: memcg: fix fatal livelock in kswapd
Message-ID: <20110503063817.GD10278@cmpxchg.org>
References: <1304366849.15370.27.camel@mulgrave.site>
 <20110502224838.GB10278@cmpxchg.org>
 <BANLkTikDyL9-XLpwyLwUQNuUfkBwbUBcZg@mail.gmail.com>
 <1304380698.15370.36.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304380698.15370.36.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 06:58:18PM -0500, James Bottomley wrote:
> On Mon, 2011-05-02 at 16:14 -0700, Ying Han wrote:
> > On Mon, May 2, 2011 at 3:48 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > I am very much for removing this hack.  There is still more scan
> > > pressure applied to memcgs in excess of their soft limit even if the
> > > extra scan is happening at a sane priority level.  And the fact that
> > > global reclaim operates completely unaware of memcgs is a different
> > > story.
> > >
> > > However, this code came into place with v2.6.31-8387-g4e41695.  Why is
> > > it only now showing up?
> > >
> > > You also wrote in that thread that this happens on a standard F15
> > > installation.  On the F15 I am running here, systemd does not
> > > configure memcgs, however.  Did you manually configure memcgs and set
> > > soft limits?  Because I wonder how it ended up in soft limit reclaim
> > > in the first place.
> 
> It doesn't ... it's standard FC15 ... the mere fact of having memcg
> compiled into the kernel is enough to do it (conversely disabling it at
> compile time fixes the problem).

Does this mean you have not set one up yourself, or does it mean that
you have checked no other software is setting up a soft-limited memcg?

Right now, I still don't see how we could enter the problematic path
without one memcg exceeding its soft limit.

So if you have not done this yet, can you check the cgroup fs for
memcgs, their memory.soft_limit_in_bytes and .usage_in_bytes right
before you would run the workload that reproduces the problem?

> > curious as well. if we have workload to reproduce it, i would like to try
> 
> Well, the only one I can suggest is the one that produces it (large
> untar).  There seems to be something magical about the memory size (mine
> is 2G) because adding more also seems to make the problem go away.

I'll try to reproduce this on my F15 as well.
