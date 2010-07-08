Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0GIACS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:02:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145Ab0GIAAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:00:20 -0400
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
In-Reply-To: Oleg Nesterov's message of  Monday, 21 June 2010 22:06:33 +0200 <20100621200633.GA21099@redhat.com>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621174455.GA14886@redhat.com>
	<20100621190212.C8630400C5@magilla.sf.frob.com>
	<20100621200633.GA21099@redhat.com>
X-Zippy-Says: Are we on STRIKE yet?
Message-Id: <20100708235925.A71DA4A967@magilla.sf.frob.com>
Date: Thu,  8 Jul 2010 16:59:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We can't do call_rcu(release_task),
> we can't take tasklist for writing in the softirq context. But even
> if we could, this can't help in fact or I missed something.

Ah, I had missed that constraint of call_rcu.  (It's not mentioned in the
kerneldoc comment directly, and is only buried in a couple of brief
mentions in Documentation/RCU/.)  I was thinking that would suffice because
it does it between rcu_read_lock critical sections, but I guess it actually
only does it after the last one and doesn't prevent a new one from having
started on another CPU.  (And we can't use it anyway.)


Thanks,
Roland
