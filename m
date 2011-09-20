Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1ITQ2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:28:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1ITQ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:28:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110920143942.GB15859@redhat.com>
References: <20110920143942.GB15859@redhat.com> <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] creds: kill __task_cred()->task_is_dead() check
Date: Tue, 20 Sep 2011 17:27:30 +0100
Message-ID: <5425.1316536050@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> From 8f92054e commit:
> 
>     Instead, add the following validation condition:
> 
>         task->exit_state >= 0
> 
>     to permit the access if the target task is dead and therefore unable to change
>     its own credentials.
> 
> OK, but afaics currently this can only help wait_task_zombie() which
> calls __task_cred() without rcu lock.
> 
> Remove this validation and change wait_task_zombie() to use task_uid()
> instead. This means we do rcu_read_lock() only to shut up the lockdep,
> but we already do the same in, say, wait_task_stopped().
> 
> Unfortunately, we can't kill task_is_dead() right now, it has already
> found the users in drivers/staging/, and I bet the usage is wrong.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>

It simplifies stuff in exchange for the most minor of slowdowns, so fair
enough.
