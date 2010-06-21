Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab0FUTDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:03:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab0FUTDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:03:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
In-Reply-To: Oleg Nesterov's message of  Monday, 21 June 2010 19:44:55 +0200 <20100621174455.GA14886@redhat.com>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621174455.GA14886@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100621190212.C8630400C5@magilla.sf.frob.com>
Date: Mon, 21 Jun 2010 12:02:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Paul, Roland, do you see any problems from the correctness pov,
> or a better fix for now?
> 
> Perhaps it also makes sense to keep the old variant renamed to
> while_each_thread_locked(), I dunno.

Did we verify that only de_thread() can create the situation where a
while_each_thread-style loop without either lock can be confused?  If
that's so, then just changing it to avoid the situation seems like it
would be less invasive overall.


Thanks,
Roland
