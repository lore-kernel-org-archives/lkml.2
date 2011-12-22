Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1LVPko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:40:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45401 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1LVPkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:40:43 -0500
Date: Thu, 22 Dec 2011 07:40:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Mandeep Singh Baines <msb@chromium.org>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 4/4] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20111222154037.GC17084@google.com>
References: <1324527518-24461-1-git-send-email-msb@chromium.org>
 <1324527518-24461-4-git-send-email-msb@chromium.org>
 <4EF2C536.7070408@cn.fujitsu.com>
 <20111222094437.GO17668@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222094437.GO17668@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:44:39AM +0100, Frederic Weisbecker wrote:
> > >  		if (ent.cgrp == cgrp)
> > >  			continue;
> > > +		ent.cg = find_css_set(tsk->cgroups, cgrp);
> > 
> > unfortunately This won't work, because we are holding tasklist_lock.
> 
> I believe we can remove tasklist_lock now (in a seperate patch).
> 
> It was there in order to protect while_each_thread() against exec but
> now we have threadgroup_lock().
> 
> I think we only need to use rcu_read_lock() to protect against concurrent
> removal in exit.

Yeah, that should work and I really like this patch.

 kernel/cgroup.c |  152 ++++++++++++-------------------------------------------
 1 files changed, 32 insertions(+), 120 deletions(-)

Let's get it working. :)

Thanks.

-- 
tejun
