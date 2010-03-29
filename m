Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab0C2Njg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:39:36 -0400
Received: from mail.openrapids.net ([64.15.138.104]:32888 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750753Ab0C2Njf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:39:35 -0400
Date: Mon, 29 Mar 2010 09:39:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com
Subject: Re: [patch 0/6] rcu head debugobjects
Message-ID: <20100329133933.GA23238@Krystal>
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal> <20100327232024.GB4685@Krystal> <20100327234314.GL2343@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327234314.GL2343@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:33:38 up 65 days, 16:10,  7 users,  load average: 0.00, 0.03,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thinking about the rcu head init topic, we might be able to drop the
init_rcu_head() initializer. The idea is the following:

- We need init_rcu_head_on_stack()/destroy_rcu_head_on_stack().
- call_rcu() populates the rcu_head and normally does not care about it being
  pre-initialized.
- The activation fixup can detect if a non-initialized rcu head is being
  activated and just perform the fixup without complaining.
- If we have two call_rcu() in a row in the same GP on the same rcu_head, the
  activation check will detect it.

So either we remove all the init_rcu_head(), as was originally proposed, or we
use one that is a no-op on !DEBUG configs and initialize the object with DEBUG
configs.

That removes the dependency on object_is_static().

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
