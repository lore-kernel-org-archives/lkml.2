Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1GFAVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 20:21:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51050 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1GFAVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 20:21:50 -0400
Date: Wed, 6 Jul 2011 02:21:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Aditya Kali <adityakali@google.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
Message-ID: <20110706002142.GA10010@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <1308527474-20704-5-git-send-email-fweisbec@gmail.com>
 <BANLkTin_MA+Yc7=q=cK5s2CbCfu_xmqTAQ@mail.gmail.com>
 <20110623134759.GC8058@somewhere.redhat.com>
 <BANLkTimiQBkDZ=L9UR-yGMATw9o-3JVtMEaMP36zey=_9pxL9Q@mail.gmail.com>
 <loom.20110628T193035-346@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20110628T193035-346@post.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please keep the Cc list, everybody may has missed your message. I just found
it while browsing randomly my lkml INBOX.

On Tue, Jun 28, 2011 at 05:37:17PM +0000, Aditya Kali wrote:
> Paul Menage <menage <at> google.com> writes:
> > What we need is a res_counter_move_charge(A, B, amount) function which will:
> > 
> > - locate C, the nearest common ancestor of A and B
> > - lock up the chain from B up to but not including C, adding the new charge
> > - unlock up the chain from B to C
> > - uncharge along the chain from A up to but not including C (not sure
> > how much locking is needed there since there's no need for roll back).
> > 
> > Paul
> > 
> 
> Another alternative is to use the 'attach' callback in struct cgroup_subsys which
> gets both the old cgroup and the new cgroup as parameters and do
> rlim_remove_proc(old_cgrp) and res_counter_charge(new_cgrp) in this same
> function under the protection of a spinlock.
> It would be good to add a return value to the 'attach' callback too.

But the it would require a global lock, or a per hierarchy one, if you want
to protect against forks and exits. And that wouldn't scale due to these fork/exit
that would take that big lock.
