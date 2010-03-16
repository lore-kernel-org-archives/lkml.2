Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966180Ab0CPL2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:28:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966133Ab0CPL2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:28:33 -0400
Date: Tue, 16 Mar 2010 12:28:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] rcu: local_irq_disable() also delimits RCU_SCHED
 read-site critical sections
Message-ID: <20100316112822.GB5337@elte.hu>
References: <4B9F66E1.2060309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F66E1.2060309@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> It is documented that local_irq_disable() also delimits
> RCU_SCHED read-site critical sections.
> See the document of synchronize_sched() or
> Documentation/RCU/whatisRCU.txt.
> 
> So we have to test irqs_disabled() in rcu_read_lock_sched_held().
> Otherwise rcu-lockdep brings incorrect complaint.

It would be useful to include the warning in question in the changelog - so 
that others who might be affected by it can see the fix and can track its 
progress. (and dont start a parallel effort debugging/reporting/fixing it)

Thanks,

	Ingo
