Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0DFP3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:29:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:51906 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0DFP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:29:33 -0400
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>
In-Reply-To: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 17:29:29 +0200
Message-ID: <1270567769.20295.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 13:23 -0700, Darren Hart wrote:
> Lastly, I should mention that these results all underperform a simple
> pthread_mutex_lock()/pthread_mutex_unlock() pair. I'm looking into why but felt
> I was overdue in sharing what I have to date. A test comparing this to a
> sched_yield() style userspace spinlock would probably be more appropraite.

This really should be able to out-perform a regular pthread_mutex_lock()
we saw a significant performance gain when we added adaptive spins to
the kernel mutex implementation, so I'd expect a gain on the futex one
as well.


