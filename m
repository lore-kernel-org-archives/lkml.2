Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1GTVIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:08:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:42339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1GTVIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:08:05 -0400
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
In-Reply-To: <20110720192949.GM2313@linux.vnet.ibm.com>
References: <201107192130.02080.edt@aei.ca> <201107192207.33813.edt@aei.ca>
	 <20110720044435.GB2400@linux.vnet.ibm.com>
	 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
	 <20110720133443.GG2400@linux.vnet.ibm.com>
	 <4E270A0E.6090902@candelatech.com>
	 <20110720171532.GB2313@linux.vnet.ibm.com> <20110720184413.GD17977@elte.hu>
	 <1311187978.29152.58.camel@twins>
	 <CA+55aFyuKTj3zEvWJEx4_RDzLQ+ipJ58UWFYH84nmcwGF_c4aA@mail.gmail.com>
	 <20110720192949.GM2313@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 23:05:53 +0200
Message-ID: <1311195953.29152.95.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 12:29 -0700, Paul E. McKenney wrote:

> Peter, does #4 (protect __rcu_read_unlock() against scheduler-using
> irq handlers) remove the need for #5 (Add irq_{enter,exit}() to
> scheduler_ipi()) and #6 (Inform RCU of irq_exit() activity)?  My guess is
> "no" for #5 and "yes" for #6.

More or less, we want to keep #5 for it does more than just fix RCU, but
yeah, I _think_ #4 obsoletes the direct need for #6.




