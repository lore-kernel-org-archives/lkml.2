Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2B1WJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:09:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab2B1WJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:09:44 -0500
Date: Tue, 28 Feb 2012 17:09:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120228220932.GK9920@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com>
 <1329990094.24994.64.camel@twins>
 <20120223213847.GK19691@redhat.com>
 <20120223223457.GJ22536@google.com>
 <20120228211627.GH9920@redhat.com>
 <1330464100.11248.94.camel@twins>
 <20120228213526.GI9920@redhat.com>
 <1330466039.11248.103.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330466039.11248.103.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:53:59PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-28 at 16:35 -0500, Vivek Goyal wrote:
> > Yes this is how scheduler does to handle hierarchy. Treat task and group
> > at same level. 
> 
> ...
> 
> > Whether it is a good thing or bad thing, I don't know. 
> 
> That's IMO what the cgroupfs interface provides for, if you do anything
> different there's this shadow group that contains the tasks for which
> you then have to provide extra parameter control.
> 
> Furthermore, by treating tasks and groups at the same level you can
> create the extra group, but you can't do the reverse. So its the more
> versatile solution as well.

Agreed that it is more versatile. And one can move all the tasks to a
new group to achieve what a shadow group will do.

The only thing is what is a good default. If we are thinking of dividing
resources in terms of % and writing a user space tool, then in default
model we just don't know what's the %. May be it is dynamically varying
% and should be shown accordingly.

Or if idea of minimum % proportional bandwidth is more natural, then 
we shall have to change userspace and things like systemd to not run
any task in /. Then a user space tool can go through cgroup hierarchy
and calculate minimum % share of a group and display it.

> 
> > I think previous
> > design was allocating a group for every user. I guess, in that case we
> > will have fixed % share of each user (until and unless users are created/
> > removed). 
> 
> Not even, it depended on if the user had anything runnable or not. It
> was very much like the current cgroup stuff if you create a cgroup for
> each user and stick the tasks in.
> 
> The cpu-cgroup stuff is purely runnable based, so every wakeup/sleep
> changes the entire weight distribution, yay! :-)

:-). That's fine. If a group is not using its bandwidth because there is
no runnable task, then other groups get more cpu. I thought that's the 
proportional definition.

Thanks
Vivek
