Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab1JNPiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:38:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49898 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab1JNPix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:38:53 -0400
Date: Fri, 14 Oct 2011 17:38:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111014153844.GP14968@somewhere>
References: <1317943022.1095.25.camel@mop>
 <20111011161600.6145aa6b.akpm@linux-foundation.org>
 <20111012005935.GD14968@somewhere>
 <20111012174014.GE6281@google.com>
 <20111012181641.GZ15413@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012181641.GZ15413@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 10:16:41PM +0400, Cyrill Gorcunov wrote:
> On Wed, Oct 12, 2011 at 10:40:14AM -0700, Tejun Heo wrote:
> ...
> > 
> > In general, I think making freezer work nicely with the rest of the
> > system is a good idea and have been working towards that direction.
> > Allowing a frozen task to be killed is not only handy for use cases
> > like above but also makes solving freezer involved deadlocks much less
> > likely and easier to solve.  Another that I have in mind is allowing
> > ptrace from unfrozen task to a frozen task.  This can be helpful in
> > general debugging (currently attaching to multi-threaded, violently
> > cloning process is quite cumbersome) and userland checkpointing.
> 
> Yeah, being able to ptrace a frozen cgroup would be great for us.
> We stick with signals start/stop cycle at moment but the final target
> is the cgroups and freezer of course. (btw while were poking freezer
> code I noticed that there is no shortcut to move all tasks in cgroup
> into the root cgroup, so I guess say "echo -1 > tasks" might be a good
> addition to move all tasks from some particular cgroup to the root
> by single action).

Well, wouldn't it be better to pull that complexity to userspace?
After all, moving tasks from a cgroup to another is not a performance
critical operation so that probably doesn't need to be all handled by
the kernel.

If one worries about concurrent clone/fork while moving tasks, then
freezing the cgroup and moving its tasks away from userspace could
be enough?
