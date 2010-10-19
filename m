Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab0JSL46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:56:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037Ab0JSL45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:56:57 -0400
Date: Tue, 19 Oct 2010 13:56:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Message-ID: <20101019115648.GD25371@elte.hu>
References: <1287479765.9920.9.camel@marge.simson.net>
 <1287487757.24189.40.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287487757.24189.40.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Using Mathieu Desnoyers' wakeup-latency testcase (attached):
> 
> With taskset -c 3 make -j 10 running..
> 
> taskset -c 3 ./wakeup-latency& sleep 30;killall wakeup-latency
> 
> without:
>  maximum latency: 42963.2 탎
>  average latency: 9077.0 탎
>  missed timer events: 0
> 
> with:
>  maximum latency: 4160.7 탎
>  average latency: 149.4 탎
>  missed timer events: 0
> 
> Patch makes a big difference in desktop feel under hefty load here.

That's really nice!

Could this feature realistically do block IO isolation as well? It's always annoying 
when some big IO job is making the desktop jerky. Especially as your patch is 
selecting the block cgroup feature already:

+       select BLK_CGROUP

Thanks,

	Ingo
