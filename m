Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2AERfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:35:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35329 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2AERfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:35:39 -0500
Date: Thu, 5 Jan 2012 09:35:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20120105173530.GB18486@google.com>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
 <1325654312-32477-3-git-send-email-msb@chromium.org>
 <4F0506B1.1070909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0506B1.1070909@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Thu, Jan 05, 2012 at 10:10:57AM +0800, Li Zefan wrote:
> Mandeep Singh Baines wrote:
> > In cgroup_attach_proc, we indirectly call find_existing_css_set 3
> > times. It is an expensive call so we want to call it a minimum
> > of times. This patch only calls it once and stores the result so
> > that it can be used later on when we call cgroup_task_migrate.
> > 
> > This required modifying cgroup_task_migrate to take the new css_set
> > (which we obtained from find_css_set) as a parameter. The nice side
> > effect of this is that cgroup_task_migrate is now identical for
> > cgroup_attach_task and cgroup_attach_proc. It also now returns a
> > void since it can never fail.
> > 
> > Changes in V4:
> > * https://lkml.org/lkml/2011/12/22/421 (Li Zefan)
> >   * Avoid GFP_KERNEL (sleep) in rcu_read_lock by getting css_set in
> >     a separate loop not under an rcu_read_lock
> > Changes in V3:
> > * https://lkml.org/lkml/2011/12/22/13 (Li Zefan)
> >   * Fixed earlier bug by creating a seperate patch to remove tasklist_lock
> > Changes in V2:
> > * https://lkml.org/lkml/2011/12/20/372 (Tejun Heo)
> >   * Move find_css_set call into loop which creates the flex array
> > * Author
> >   * Kill css_set_refs and use group_size instead
> >   * Fix an off-by-one error in counting css_set refs
> >   * Add a retval check in out_list_teardown
> > 
> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> 
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>

I like this series but it's too late for the current merge window.
I'll apply them on for-3.4 once this merge window closes.  If I don't,
please ping me.

Thank you.

-- 
tejun
