Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab0LTQ23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:28:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab0LTQ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:28:28 -0500
Date: Mon, 20 Dec 2010 17:21:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 11/16] signal: prepare for CLD_* notification changes
Message-ID: <20101220162120.GA15755@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
>  static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
>  {
>  	struct siginfo info;
>  	unsigned long flags;
>  	struct task_struct *parent;
>  	struct sighand_struct *sighand;
> +	struct signal_struct *sig;
> +	int notify = 0;
> +
> +	/*
> +	 * Determine whether and what to notify.  This should be done under
> +	 * @tsk's siglock.

Hmm... it is not clear why.

> +	spin_lock_irqsave(&sighand->siglock, flags);
>
> +	switch (why) {
> +	case CLD_CONTINUED:
> +	case CLD_STOPPED:
> +	case CLD_TRAPPED:
> +		notify = why;
> +		break;
> +	}

OK, with the next patches this code checks sig->flags, probably that
is why we take ->siglock. Still I can't understand this so far.
May be the comment could tell more?

> @@ -1640,6 +1684,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
>   	}
>
>  	sighand = parent->sighand;
> +	sig = parent->signal;

This looks unneeded.

Oleg.

