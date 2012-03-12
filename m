Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab2CLWbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:31:25 -0400
Received: from tango.0pointer.de ([85.214.72.216]:49313 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab2CLWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:31:24 -0400
Date: Mon, 12 Mar 2012 23:31:14 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312223113.GB18359@tango.0pointer.de>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312222817.GI23255@google.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12.03.12 15:28, Tejun Heo (tj@kernel.org) wrote:

> 
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

Note that at least systemd places all services by default beneath a
single "super" group (/system/), hence the first suggestion would make
little sense for us. The second suggestion would be fine however.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
