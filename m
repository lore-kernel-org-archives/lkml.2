Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0LOTGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:06:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0LOTGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:06:46 -0500
Date: Wed, 15 Dec 2010 19:59:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Chris Mason <chris.mason@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
Message-ID: <20101215185929.GA18803@redhat.com>
References: <20100520204810.GA19188@think> <1277114522.1875.469.camel@laptop> <1277117647.1875.503.camel@laptop> <1277125479.1875.510.camel@laptop> <4D06D968.9070004@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D06D968.9070004@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Frank Rowand wrote:
>
> I have not been able to make sense of the task_running() check in
> try_to_wake_up(), even with that clue.  The try_to_wake_up() code in
> question is:
> ...
>
> What am I missing, or is the task_running() test not needed?

I am afraid I can misuderstood this all, including the question ;)

But, with __ARCH_WANT_UNLOCKED_CTXSW task_running() checks ->oncpu.
However, schedule() drops rq->lock after prev was deactivated but
before it clears prev->oncpu.

Oleg.

