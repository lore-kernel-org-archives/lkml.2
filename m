Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1KHVvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:51:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1KHVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:51:14 -0500
Date: Tue, 8 Nov 2011 13:51:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Blum <bblum@andrew.cmu.edu>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        Tim Hockin <thockin@hockin.org>, Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -mm] cgroup: Fix task counter common ancestor logic
Message-Id: <20111108135111.6a74f1d2.akpm@linux-foundation.org>
In-Reply-To: <1320765670-14181-1-git-send-email-fweisbec@gmail.com>
References: <1320765670-14181-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Nov 2011 16:21:10 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> To solve this, keep the original cgroup of each thread in the thread
> group cached in the flex array and pass it to can_attach_task()/attach_task()
> and cancel_attach_task() so that the correct common ancestor between the old
> and new cgroup can be safely retrieved for each task.

OK, thanks.

We need to work out what to do with this patchset.  ie: should we merge
it.  I'm not sure that the case has been made?

Let's please drag this thing onto the table and poke at it for a while.
Probably everyone has forgotten everything so we'll need to start
again, sorry.  Perhaps you can (re)start proceedings by telling us why
it's useful to our users and why we should merge it?


Some mental notes:

Tim says it would be useful for the things he's doing but doesn't
appear to have confirmed/tested that.

Kay has said that it would not be useful for his plumber's wishlist
item, which is a shame.

I seem to recall complaining that it doesn't address the forkbomb issue
for non-cgroups setups, so the forkbomb issue remains unaddressed.


