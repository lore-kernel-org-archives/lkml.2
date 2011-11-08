Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab1KHX7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:59:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48456 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab1KHX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:59:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Nov 2011 08:58:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ben Blum <bblum@andrew.cmu.edu>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        Tim Hockin <thockin@hockin.org>, Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH -mm] cgroup: Fix task counter common ancestor logic
Message-Id: <20111109085841.ca5dfd3b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111108135111.6a74f1d2.akpm@linux-foundation.org>
References: <1320765670-14181-1-git-send-email-fweisbec@gmail.com>
	<20111108135111.6a74f1d2.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011 13:51:11 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue,  8 Nov 2011 16:21:10 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > To solve this, keep the original cgroup of each thread in the thread
> > group cached in the flex array and pass it to can_attach_task()/attach_task()
> > and cancel_attach_task() so that the correct common ancestor between the old
> > and new cgroup can be safely retrieved for each task.
> 
> OK, thanks.
> 
> We need to work out what to do with this patchset.  ie: should we merge
> it.  I'm not sure that the case has been made?
> 

My impression is positive....but as other guy proposed, I feel fork-limit
should be useful, too. It allows to limit or rate-limit the number of fork().
So, I wonder some fork-limit can be implemented in this task_counter cgroup.

> Let's please drag this thing onto the table and poke at it for a while.
> Probably everyone has forgotten everything so we'll need to start
> again, sorry.  Perhaps you can (re)start proceedings by telling us why
> it's useful to our users and why we should merge it?
> 
please ;)

> 
> Some mental notes:
> 
> Tim says it would be useful for the things he's doing but doesn't
> appear to have confirmed/tested that.
> 
> Kay has said that it would not be useful for his plumber's wishlist
> item, which is a shame.
> 
> I seem to recall complaining that it doesn't address the forkbomb issue
> for non-cgroups setups, so the forkbomb issue remains unaddressed.

For non-cgroup fork-bomb, I and Minchan proposed forkbomb-killer (in 
independent way). I stop it now but if someone has interests, I
recall it from grave.

Thanks,
-Kame
 






