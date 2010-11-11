Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0KKWHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709Ab0KKWHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:07:08 -0500
Date: Thu, 11 Nov 2010 23:00:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Thelen <gthelen@google.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
	kernel/pid.c:419 invoked rcu_dereference_check() without protection!
Message-ID: <20101111220048.GA19979@redhat.com>
References: <xr93fwwbdh1d.fsf@ninji.mtv.corp.google.com> <20101107182028.GZ15561@linux.vnet.ibm.com> <20101108151509.GA3702@redhat.com> <20101109202900.GV4032@linux.vnet.ibm.com> <20101110155530.GA1905@redhat.com> <20101110160211.GA2562@redhat.com> <4CDBD12C.4010807@kernel.dk> <20101111123015.GA25991@redhat.com> <4CDBE401.7040401@kernel.dk> <xr93sjz73ar6.fsf@ninji.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr93sjz73ar6.fsf@ninji.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Greg Thelen wrote:
>
> a) my original report added rcu_read_lock() to sys_ioprio_get() and
>    claims that "something" is needed in sys_ioprio_set().
>
> c) http://lkml.org/lkml/2010/10/29/168 added rcu locks to both
>    sys_ioprio_get() and sys_ioprio_set() thus addressing the issues
>    raised in a).  However, I do not see this patch in -mm.

Well, I do not know what happened with this patch, but

>    I can resubmit my patch, but want to know if there is a reason that
>    http://lkml.org/lkml/2010/10/29/168 did not make it into either -mm
>    or linux-next?

I am looking at http://lkml.org/lkml/2010/10/29/168 now, and I think
it should be dropped or you can submit the patch on top of it.

It only adds rcu_read_lock() around of find_task_by_vpid(), but we can
use rcu_read_lock() instead of tasklist_lock.

> d) the sys_ioprio_set() comment indicating that "we can't use
>    rcu_read_lock()" needs to be updated to be more clear.  I'm not sure
>    what this should be updated to, which leads into the next
>    sub-topic...

It should be just removed. It doesn't match the reality today.

> e) possibly removing tasklist_lock,

Yes.

> though there seems to be some
>    concern that this might introduce task->io_context usage race.

No!

I am sorry for confusion, those ->io_context races are completely
orthogonal to s/tasklist/rcu/.

Oleg.

