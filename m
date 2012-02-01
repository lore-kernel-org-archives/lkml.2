Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2BASuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:50:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45908 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2BASuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:50:07 -0500
Date: Wed, 1 Feb 2012 19:50:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Tim Hockin <thockin@hockin.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
Message-ID: <20120201184959.GH6731@somewhere.redhat.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <20120201163126.GA19837@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201163126.GA19837@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 08:31:26AM -0800, Tejun Heo wrote:
> On Wed, Feb 01, 2012 at 04:37:40AM +0100, Frederic Weisbecker wrote:
> > Changes In this version:
> > 
> > - Split 32/64 bits version of res_counter_write_u64() [1/10]
> >   Courtesy of Kirill A. Shutemov
> > 
> > - Added Kirill's ack [8/10]
> > 
> > - Added selftests [9/10], [10/10]
> > 
> > Please consider for merging. At least two users want this feature:
> 
> Has there been further discussion about this approach?  IIRC, we
> weren't sure whether this should be merged.

The doubts I have noticed were:

Q: Can't we rather focus on a global solution to fight forkbombs?

If we can find a reliable solution that works in any case and that
prevent from any forkbomb to impact the rest of the system then it
may be an acceptable solution. But I'm not aware of such feature.

Besides, another point in having this task counter is that we
have a per container limit. Assuming all containers are running under
the same user, we can protect against a container starving all others
with a massive amount of processes close to the NR_PROC rlimit.

Q: Can/should we implement a limitation on the number of "fork" as well?
   (as in https://lkml.org/lkml/2011/11/3/233 )

I'm still not sure about why such a thing is needed. Is it really something we
want? Why can't the task counter be used instead?

I need more details from the author of this patch. But I doubt we can merge
both subsystems, they have pretty different semantics.
