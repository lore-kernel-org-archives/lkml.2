Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1ITPk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1ITPky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:40:54 -0400
Date: Tue, 20 Sep 2011 17:35:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] creds: __task_cred(current) doesn't need
	rcu_read_lock_held()
Message-ID: <20110920153542.GA17731@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com> <20110920143959.GC15859@redhat.com> <20110920150726.GA6234@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920150726.GA6234@peqn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, Serge Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > Change __task_cred(task) to accept "task == current" without
> > rcu_read_lock_held(). This is what current_cred() currently does,
> > and with this change __task_cred() becomes more flexible/usable.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> So to check whether I've got this straight, the original __task_cred()
> was allowing rcu read lock to not be held for a non-running task, but
> required rcu read lock if task was running?  With these two patches,
> rcu read lock will not be needed if task == current?

Yes.

> If so, then that sounds good to me, and an unconditional rcu_read_lock()
> at wait_task_zombie() seems better than at send_signal()...

Agreed.

Although sometimes I think it would be better to use rcu_dereference_raw()
with a comment in some places.

Oleg.

