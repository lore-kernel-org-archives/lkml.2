Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab2B1VyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:54:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:56434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2B1VyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:54:14 -0500
Message-ID: <1330466039.11248.103.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Tue, 28 Feb 2012 22:53:59 +0100
In-Reply-To: <20120228213526.GI9920@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <20120223213847.GK19691@redhat.com>
	 <20120223223457.GJ22536@google.com> <20120228211627.GH9920@redhat.com>
	 <1330464100.11248.94.camel@twins> <20120228213526.GI9920@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 16:35 -0500, Vivek Goyal wrote:
> Yes this is how scheduler does to handle hierarchy. Treat task and group
> at same level. 

...

> Whether it is a good thing or bad thing, I don't know. 

That's IMO what the cgroupfs interface provides for, if you do anything
different there's this shadow group that contains the tasks for which
you then have to provide extra parameter control.

Furthermore, by treating tasks and groups at the same level you can
create the extra group, but you can't do the reverse. So its the more
versatile solution as well.

> I think previous
> design was allocating a group for every user. I guess, in that case we
> will have fixed % share of each user (until and unless users are created/
> removed). 

Not even, it depended on if the user had anything runnable or not. It
was very much like the current cgroup stuff if you create a cgroup for
each user and stick the tasks in.

The cpu-cgroup stuff is purely runnable based, so every wakeup/sleep
changes the entire weight distribution, yay! :-)
