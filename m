Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab2AZJkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:40:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab2AZJkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:40:04 -0500
Date: Thu, 26 Jan 2012 10:39:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Message-ID: <20120126093936.GA13963@elte.hu>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
 <1326721082.2442.234.camel@twins>
 <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
 <20120117090605.GD7612@elte.hu>
 <20120117151242.GA13290@redhat.com>
 <20120118094219.GE5842@elte.hu>
 <1327399885.2614.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327399885.2614.5.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > It can generate delays at the exact same place, and can 
> > generate much longer delays than an SMI, if a high-prio RT 
> > task comes along.
> 
> No it can't, since do_exit() plays silly games with 
> preempt_disable().

ok, it being a critical section on both -rt and vanilla upstream 
explains it.

Thanks,

	Ingo
