Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1AOO3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 09:29:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45626 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab1AOO32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:29:28 -0500
Date: Sat, 15 Jan 2011 15:28:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        paul.mckenney@linaro.org, rmk+kernel@arm.linux.org.uk,
        weber@corscience.de, paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] rcu: avoid pointless blocked-task warnings
Message-ID: <20110115142857.GA8610@elte.hu>
References: <tip-b24efdfdf679cf9b05947c531971905fc727dd40@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-b24efdfdf679cf9b05947c531971905fc727dd40@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Paul E. McKenney <paul.mckenney@linaro.org> wrote:

> Commit-ID:  b24efdfdf679cf9b05947c531971905fc727dd40
> Gitweb:     http://git.kernel.org/tip/b24efdfdf679cf9b05947c531971905fc727dd40
> Author:     Paul E. McKenney <paul.mckenney@linaro.org>
> AuthorDate: Wed, 12 Jan 2011 14:18:11 -0800
> Committer:  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Fri, 14 Jan 2011 04:58:08 -0800
> 
> rcu: avoid pointless blocked-task warnings
> 
> If the RCU callback-processing kthread has nothing to do, it parks in
> a wait_event().  If RCU remains idle for more than two minutes, the
> kernel complains about this.  This commit changes from wait_event()
> to wait_event_interruptible() to prevent the kernel from complaining
> just because RCU is idle.

Btw., a sidenote, it's not just about the blocked-tasks lockup detector warning, 
uninterruptible sleeps will also artificially inflate the load average of the box, 
+1.0 per such task. So it's definitely a bug to sleep for a very long time 
uninterruptible.

Thanks,

	Ingo
