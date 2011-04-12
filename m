Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1DLAfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 20:35:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52001 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab1DLAfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 20:35:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] remove boost_dying_task_prio()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrey Vagin <avagin@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110411145832.ae133cf8.akpm@linux-foundation.org>
References: <20110411143215.0074.A69D9226@jp.fujitsu.com> <20110411145832.ae133cf8.akpm@linux-foundation.org>
Message-Id: <20110412093503.43EF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 09:35:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Mon, 11 Apr 2011 14:31:18 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > This is a almost revert commit 93b43fa (oom: give the dying
> > task a higher priority).
> > 
> > The commit dramatically improve oom killer logic when fork-bomb
> > occur. But, I've found it has nasty corner case. Now cpu cgroup
> > has strange default RT runtime. It's 0! That said, if a process
> > under cpu cgroup promote RT scheduling class, the process never
> > run at all.
> 
> hm.  How did that happen?  I thought that sched_setscheduler() modifies
> only a single thread, and that thread is in the process of exiting?

If admin insert !RT process into a cpu cgroup of setting rtruntime=0,
usually it run perfectly because !RT task isn't affected from rtruntime
knob, but If it promote RT task, by explicit setscheduler() syscall or
OOM, the task can't run at all.

In short, now oom killer don't work at all if admin are using cpu
cgroup and don't touch rtruntime knob.



