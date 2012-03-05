Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2CEDVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:21:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60320 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab2CEDVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:21:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.52.90.111 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Mon, 5 Mar 2012 04:21:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Cc: Aditya Kali <adityakali@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Max Kellermann <mk@cm4all.com>, Tim Hockin <thockin@hockin.org>,
        Glauber Costa <glommer@gmail.com>, Paul Menage <paul@paulmenage.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Containers <containers@lists.linux-foundation.org>,
        Papp =?iso-8859-1?Q?Tam=E1s?= <tompos@martos.bme.hu>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
Message-ID: <20120305032130.GD18143@somewhere.redhat.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <20120201163126.GA19837@google.com>
 <20120201184959.GH6731@somewhere.redhat.com>
 <20120201115107.93e11471.akpm@linux-foundation.org>
 <20120202145000.GC9071@somewhere.redhat.com>
 <4F4FFDE4.8050908@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4FFDE4.8050908@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 11:53:24PM +0100, Daniel Lezcano wrote:
> On 02/02/2012 03:50 PM, Frederic Weisbecker wrote:
> >On Wed, Feb 01, 2012 at 11:51:07AM -0800, Andrew Morton wrote:
> >>On Wed, 1 Feb 2012 19:50:01 +0100
> >>Frederic Weisbecker<fweisbec@gmail.com>  wrote:
> >>
> >>>On Wed, Feb 01, 2012 at 08:31:26AM -0800, Tejun Heo wrote:
> >>>>On Wed, Feb 01, 2012 at 04:37:40AM +0100, Frederic Weisbecker wrote:
> >>>>>Changes In this version:
> >>>>>
> >>>>>- Split 32/64 bits version of res_counter_write_u64() [1/10]
> >>>>>   Courtesy of Kirill A. Shutemov
> >>>>>
> >>>>>- Added Kirill's ack [8/10]
> >>>>>
> >>>>>- Added selftests [9/10], [10/10]
> >>>>>
> >>>>>Please consider for merging. At least two users want this feature:
> >>>>Has there been further discussion about this approach?  IIRC, we
> >>>>weren't sure whether this should be merged.
> >>>The doubts I have noticed were:
> >>>
> >>>Q: Can't we rather focus on a global solution to fight forkbombs?
> >>>
> >>>If we can find a reliable solution that works in any case and that
> >>>prevent from any forkbomb to impact the rest of the system then it
> >>>may be an acceptable solution. But I'm not aware of such feature.
> >>>
> >>>Besides, another point in having this task counter is that we
> >>>have a per container limit. Assuming all containers are running under
> >>>the same user, we can protect against a container starving all others
> >>>with a massive amount of processes close to the NR_PROC rlimit.
> >>>
> >>>Q: Can/should we implement a limitation on the number of "fork" as well?
> >>>    (as in https://lkml.org/lkml/2011/11/3/233 )
> >>>
> >>>I'm still not sure about why such a thing is needed. Is it really something we
> >>>want? Why can't the task counter be used instead?
> >>>
> >>>I need more details from the author of this patch. But I doubt we can merge
> >>>both subsystems, they have pretty different semantics.
> >>What I struggle with is "is this feature useful enough to warrant
> >>merging it"?
> >The reason why I've been working on it is because we need this feature
> >(at least) for LXC.
> 
> This feature is a recurrent request from the users of LXC. Recently,
> a container administrator complained an user was able to crash the
> entire host from a container.
> 
> http://sourceforge.net/mailarchive/message.php?msg_id=28915923
> 
> This feature is really useful to make the containers secure.

Time for me to try to wake up again this discussion.
Andrew, Tejun, Li, as you can see we don't lack the users
for this feature.

If you think we should solve our security problems on containers
by following another direction, please tell us so we know where to
go and we can move forward.

Otherwise please consider the task counter for merging.

Thanks.
