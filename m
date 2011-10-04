Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab1JDWBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:01:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65259 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab1JDWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:01:15 -0400
Date: Tue, 4 Oct 2011 15:01:11 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-Id: <20111004150111.e9337268.akpm00@gmail.com>
In-Reply-To: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Oct 2011 21:07:02 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Andrew,
> 
> This contains minor changes, mostly documentation and changelog
> updates, off-case build fix, and a code optimization in
> res_counter_common_ancestor().

I'd normally duck a patch series like this when we're at -rc8 and ask
for it to be resent late in -rc1.  But I was feeling frisky so I
grabbed this lot for a bit of testing and will sit on it until -rc1.

I'm still not convinced that the kernel has a burning need for a "task
counter subsystem".  Someone convince me that we should merge this!

> It's hard to put some statistic numbers while testing this feature
> given that the result is rather binary: we launch a forkbomb and
> either we stop and kill it or the system become unresponsive.
>     
> Meanwhile, one can find a testsuite at this address:
> https://tglx.de/~fweisbec/task_counter_test.tar.gz

I do think that we should merge tests like this into the main tree.  So
I can do "cd tests ; make ; ./run-tests".  The first step is for some hero
to propose the (simple!) framework and to drop a first test in there.

> It performs several checks to ensure the interface and the behaviour
> are reliable after common events like moving tasks around over cgroups
> in a hierarchy, forking inside, etc.. It also launches a forkbomb,
> tries to stop and kill it. So beware, don't run it on a system that
> is doing serious things.

Good stuff, that.  Then, when people propose additions or fix bugs, I can
whine at them for not updating the test suite.

> Ensure you have CGROUP_TASK_COUNTER set
> before, or it may compress the Ten Plagues in your MBR and
> inflate the whole after your next reboot.

That problem would need to be fixed.  Either probe for the feature
up-front, or don't build the test at all if CONFIG_CGROUP_TASK_COUNTER=n.

