Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0FSTWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:22:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0FSTWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:22:10 -0400
Date: Sat, 19 Jun 2010 21:19:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Baines <msb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100619191909.GA4384@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <AANLkTimh-7F4VK8FI6j-JQ4EDnxtEI3ZlGY-2X-lq6iM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimh-7F4VK8FI6j-JQ4EDnxtEI3ZlGY-2X-lq6iM@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Mandeep Baines wrote:
>
> On Fri, Jun 18, 2010 at 12:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >
> > I _really_ hope I missed something, will recheck tomorrow with the fresh
> > head. Still I'd like to share my concerns...
>
> Yep. You're right. Not sure what I was thinking. This is only case
> where do_each_thread
> is protected by an rcu_read_lock. All others, correctly use read_lock.

No, no. while_each_thread() is supposed to be rcu-safe, we should fix it.
It has many rcu_read_lock() users.

The patch which fixes rcu_lock_break() is orthogonal to this problem.

Oleg.

