Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab0C2SOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:14:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0C2SOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:14:34 -0400
Date: Mon, 29 Mar 2010 20:12:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/4] cputimers/proc: do_task_stat: don't walk through
	the thread list under ->siglock
Message-ID: <20100329181204.GA16356@redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com> <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com> <20100329125415.GA22451@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329125415.GA22451@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Oleg Nesterov wrote:
>
> Yes sure. I dislike the do_task_stat() case because we always do this,
> even if this info is not needed, say, for /bin/ps.

Note also that nobody else in /fs/proc needs ->siglock. Except
do_io_accounting(), but in this case the user-space explicitly asks for
this info.


OK, This is V2. Still RFC, although I think 1/4 makes sense in any case.

Please comment. Again, I am more or less sure these changes are "correct",
but I don't know what /bin/top can think ;)

I don't really like the fact thread_group_times() takes cputimer.lock,
but imho lock_task_sighand() in do_task_stat() is much worse.

Oleg.

