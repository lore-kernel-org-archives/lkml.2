Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2DKLKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:10:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab2DKLKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:10:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120410194625.GB7196@redhat.com>
References: <20120410194625.GB7196@redhat.com> <20120410194554.GA7196@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] creds: kill __task_cred()->task_is_dead() validation
Date: Wed, 11 Apr 2012 11:41:34 +0100
Message-ID: <13911.1334140894@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> commit 8f92054e:
> 
>     add the following validation condition:
> 
>         task->exit_state >= 0
> 
>     to permit the access if the target task is dead and therefore
>     unable to change its own credentials.
> 
> OK, but afaics currently this can only help wait_task_zombie() which
> calls __task_cred() without rcu lock.
> 
> Remove this validation and change wait_task_zombie() to use task_uid()
> instead. This means we do rcu_read_lock() only to shut up the lockdep,
> but we already do the same in, say, wait_task_stopped().
> 
> task_is_dead() should die, task->exit_state != 0 means that this task
> has passed exit_notify(), only do_wait-like code paths should use this.
> 
> Unfortunately, we can't kill task_is_dead() right now, it has already
> found the bugy users in drivers/staging/, the fix already exists.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
