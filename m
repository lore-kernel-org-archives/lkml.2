Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1FXJTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 05:19:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1FXJTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 05:19:38 -0400
Subject: Re: [PATCH 0/3 v3] rcu: Detect rcu uses under extended quiescent
 state
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Jun 2011 11:18:45 +0200
Message-ID: <1308907125.27849.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 01:12 +0200, Frederic Weisbecker wrote:
> This time I have no current practical cases to fix. Those I fixed
> in previous versions were actually using rcu_dereference_raw(), which
> is legal in extended qs.
> 
> Frederic Weisbecker (3):
>   rcu: Detect illegal rcu dereference in extended quiescent state
>   rcu: Inform the user about dynticks idle mode on PROVE_RCU warning
>   rcu: Warn when rcu_read_lock() is used in extended quiescent state
> 
>  include/linux/rcupdate.h |   68 +++++++++++++++++++++++++++++++++++++++-------
>  kernel/lockdep.c         |    4 +++
>  kernel/rcupdate.c        |    4 +++
>  kernel/rcutiny.c         |   13 +++++++++
>  kernel/rcutree.c         |   14 +++++++++
>  5 files changed, 93 insertions(+), 10 deletions(-)

Right, so the only comment I have is that it might have been nice to
explain what the heck an extended qs is :-) I've since figured it out,
but it did require waking up my brain.
