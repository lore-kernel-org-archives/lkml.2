Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1FKHtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 03:49:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab1FKHtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 03:49:23 -0400
Date: Sat, 11 Jun 2011 08:49:08 +0100
From: Joe Thornber <thornber@redhat.com>
To: "Amir G." <amir73il@users.sourceforge.net>
Cc: Lukas Czerner <lczerner@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Message-ID: <20110611074908.GC2517@ubuntu>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
 <BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
 <BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
 <alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
 <20110610101142.GA10144@ubuntu>
 <BANLkTi=zjU3-FV3AVpYsknzKFgaS7byb_Q@mail.gmail.com>
 <20110610150129.GA17585@ubuntu>
 <BANLkTikUZadpVJRcfX_MLMZ-p_G0bT_8uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikUZadpVJRcfX_MLMZ-p_G0bT_8uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 07:01:36AM +0300, Amir G. wrote:
> OK. Now I am convinced that there is no I/O ordering issue,
> since you are never overwriting shared data in-place.
> 
> Now I also convinced that the origin will be so heavily fragmented,
> to the point that the solution will not be practical for performance
> sensitive applications. Specifically, applications that use spinning
> media storage and require consistent and predictable performance.

I am also convinced multisnap wont be suitable for every use case.  I
want to be very careful to only advocate it for people with suitable
tasks.  Over time I'm sure we'll broaden the suitable apps, for
example by tinkering with the allocator, or doing some preemptive
defrag.  It would be disappointing for everyone to write it off, just
because it isn't suitable for say high performance database apps.

The very simple allocator I'm using at the moment will try and place
new blocks together.  My hope is that past io patterns will be similar
to future ones.  So while the volumes will be fragmented, blocks for
the typical io access patterns will still be together.  Much more
experimentation is needed.

This is very early days for multisnap, the code is still changing.
Only a few people have run it.  For instance Lukas tested it on
Thursday and got some unexpectedly poor results.  I'm there'll be a
quick fix for it (eg, wrong cache size, too much disk seeking due to
the metadata and data volumes being at opposite ends of a spindle
device), but this shows that I need more people to play with it.

> I do have a crazy idea, though, how to combine the power of the
> multisnap features with the speed of a raw ext4 fs.

I need to think this through over the weekend.  The metadata interface
is pretty clean, so you could start by looking at that.  However I do
find this suggestion surprising.  My priority is block level
snapshots, if I can expose interfaces for you such that we share code
then that would be great.

- Joe
