Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2CLXA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:00:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41332 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab2CLXAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:00:25 -0400
Date: Mon, 12 Mar 2012 16:00:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312230020.GL23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <20120312223113.GB18359@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312223113.GB18359@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lennart.

On Mon, Mar 12, 2012 at 11:31:14PM +0100, Lennart Poettering wrote:
> > On Mon, Mar 12, 2012 at 11:22:18PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2012-03-12 at 15:10 -0700, Tejun Heo wrote:
> > > > 
> > > > * How to map controllers which aren't aware of full hierarchy is still
> > > >   an open question but I'm still standing by one active node on any
> > > >   root-to-leaf path w/ root group serving as the special rest group. 
> > > 
> > > What does this mean?
> > 
> > Let's say we have a tree like the following.
> > 
> >          root
> >       /   |   \
> >      G1  G2   G3
> >              /  \
> > 	   G31  G32
> > 
> > So, for cgroups which don't support full hierarchy, it'll be viewed as
> > either,
> > 
> >          root
> >       /   |   \
> >      G1  G2   G3
> > 
> > or
> > 
> >           root
> >       /   |   |  \
> >      G1  G2  G31 G32
> > 
> > With root being treated specially, probably as just being a equal
> > group as other groups, I'm not fully determined about that yet.
> 
> Note that at least systemd places all services by default beneath a
> single "super" group (/system/), hence the first suggestion would make
> little sense for us. The second suggestion would be fine however.

Ooh, both will be available to choose from.  I was trying to explain
that there can be configuration only at one layer for any task so that
it can be mapped to flat hierarchy.  Where to apply the config will be
selected by the user (or system tool).

Thanks.

-- 
tejun
