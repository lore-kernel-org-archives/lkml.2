Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2E2KHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:07:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:52821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2E2KHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:07:43 -0400
Message-ID: <1338286038.26856.20.camel@twins>
Subject: Re: [RFC][PATCH 00/15] sched: SCHED_DEADLINE v5
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Date: Tue, 29 May 2012 12:07:18 +0200
In-Reply-To: <4FC34011.4040505@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
	 <1337942569.9783.183.camel@laptop> <4FC34011.4040505@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-28 at 11:06 +0200, Juri Lelli wrote:
>   o  The only "big problem" I fear is related to the current deadline
>      inheritance mechanism. As Steven pointed out during the last review,
>      a task could force more bandwidth than was allowed if:
> 
>         - it takes a futex;
>         - it is boosted while holding it;
>         - never releases the futex;
> 
>      and this is sadly achievable since, if boosted, a task inherits top
>      waiter parameters and the enforcement mechanism is temporarily
>      disabled for it. 

/me goes read patch 12 in detail..

Wouldn't it be possible to enforce pi_se (aka. pi_task)'s bandwidth in
the dl-boosts-dl case?

Since afaict that's the only case we need to worry about. If you can
spawn FIFO/RR tasks you already loose bandwidth caps etc..


