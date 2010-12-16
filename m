Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0LPPPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:15:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab0LPPPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:15:40 -0500
Date: Thu, 16 Dec 2010 16:07:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, mathieu.desnoyers@efficios.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
	automated per session task groups
Message-ID: <20101216150757.GA5841@redhat.com>
References: <1290281700.28711.9.camel@maggy.simson.net> <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org> <20101215175010.GA14267@redhat.com> <1292486036.10931.314.camel@maggy.simson.net> <1292508592.5940.28.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292508592.5940.28.camel@maggy.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Mike Galbraith wrote:
>
> I'd also have to disable interrupts though,

Even irq_disable can't help, I think.

> so may as well just lock it.

this also looks simpler.

> I didn't do the -ESRCH or no display bit.  As far as autogroup is
> concerned, if you couldn't lock, it's history, so belongs to init.

Agreed. I considered this option too, but I was worried about
sched_group_set_shares(root).

However, as you pointed out,

> sched_group_set_shares() does the right thing, says no to changing the
> root task group's shares.

Aha, I see, thanks.


I believe the patch is correct and closes the hole.

Oleg.

