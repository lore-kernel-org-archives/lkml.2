Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2CLW2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:28:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47174 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab2CLW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:28:22 -0400
Date: Mon, 12 Mar 2012 15:28:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312222817.GI23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331590938.18960.57.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Mar 12, 2012 at 11:22:18PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 15:10 -0700, Tejun Heo wrote:
> > 
> > * How to map controllers which aren't aware of full hierarchy is still
> >   an open question but I'm still standing by one active node on any
> >   root-to-leaf path w/ root group serving as the special rest group. 
> 
> What does this mean?

Let's say we have a tree like the following.

         root
      /   |   \
     G1  G2   G3
             /  \
	   G31  G32

So, for cgroups which don't support full hierarchy, it'll be viewed as
either,

         root
      /   |   \
     G1  G2   G3

or

          root
      /   |   |  \
     G1  G2  G31 G32

With root being treated specially, probably as just being a equal
group as other groups, I'm not fully determined about that yet.

Thanks.

-- 
tejun
