Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935804Ab1ETUPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:15:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43315 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935756Ab1ETUPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:15:39 -0400
Date: Fri, 20 May 2011 16:13:01 -0400 (EDT)
Message-Id: <20110520.161301.913577691507123777.davem@davemloft.net>
To: daniel@gaisler.com
Cc: sparclinux@vger.kernel.org, sfr@canb.auug.org.au, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix merge problem between sparc32 IPI patches and
 schedule_ipi() callback
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305900070-23492-1-git-send-email-daniel@gaisler.com>
References: <1305900070-23492-1-git-send-email-daniel@gaisler.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 20 May 2011 13:13:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Hellstrom <daniel@gaisler.com>
Date: Fri, 20 May 2011 16:01:09 +0200

> Fixes a merge conflict in arch/sparc/kernel/smp_32.c between commit
> d6d048192b1d ("sparc32: implement SMP IPIs using the generic functions")
> from the sparc tree and commit 184748cc50b2 ("sched: Provide
> scheduler_ipi() callback in response to smp_send_reschedule()").
> 
> The patch adds a call to scheduler_ipi() from the resched IPI handler in
> sparc32.
> 
> Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>

What I did to handle this was merge in enough of the upstream commit
by Peter such that both of these patches apply, via:

git merge --no-commit 317f394160e9beb97d19a84c39b7e5eb3d7815a8

then I added patch #1 into the merge commit.

Next, I applied patch #2 afterwards.

So we should be all set when I push this out to Linus, thanks!
