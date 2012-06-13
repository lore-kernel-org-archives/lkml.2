Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2FMLBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:01:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:48229 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2FMLBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:01:00 -0400
Message-Id: <20120613102823.373180763@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 13 Jun 2012 11:00:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: [RFC patch 0/5] Per cpu thread hotplug infrastructure
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements the infrastructure for parking and
unparking kernel threads to avoid the full teardown and fork on cpu
hotplug operations along with management infrastructure for hotplug
and users.

I've converted the most obvious (and simple) users ksoftirqd and
watchdog along with a driver (the latter is untested due to lack of
hardware).

Looking at the other (ab)users of per cpu kernel threads:

 - drivers/* should be rather trivial to convert all users

 - RCU needs more thought, but I'm sure that Paul will figure it out
   in no time :)

   The main issue with RCU are the per node threads, but it should be
   simple to extend the infrastructure to allow registration and
   handling of per node threads as well.

 - workqueues. I did not even try to think about converting it. The
   hotplug related code in there causes strong feelings related to
   zombies and chainsaws. (See https://lwn.net/Articles/378036/)

Thanks,

	tglx

