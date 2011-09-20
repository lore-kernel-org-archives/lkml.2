Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1ITQUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:20:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1ITQUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:20:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110920143959.GC15859@redhat.com>
References: <20110920143959.GC15859@redhat.com> <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] creds: __task_cred(current) doesn't need rcu_read_lock_held()
Date: Tue, 20 Sep 2011 17:19:11 +0100
Message-ID: <5088.1316535551@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Change __task_cred(task) to accept "task == current" without
> rcu_read_lock_held(). This is what current_cred() currently does,
> and with this change __task_cred() becomes more flexible/usable.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

NAK!

If you compare carefully:

> -	rcu_dereference_protected(current->cred, 1)

and:

> -		rcu_dereference_check(__t->real_cred, 0);		\

you'll notice they aren't quite the same in one very fundamental way.

David
