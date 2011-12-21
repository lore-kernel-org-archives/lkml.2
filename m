Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1LUPSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:18:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1LUPSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:18:06 -0500
Date: Wed, 21 Dec 2011 16:12:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Pavel Mironchik <tibor0@gmail.com>,
        Alasdair G Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: mempool && io_schedule_timeout()
Message-ID: <20111221151236.GA27571@redhat.com>
References: <20111220221818.GJ10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220221818.GJ10752@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Tejun Heo wrote:
>
> -	if (!pool->curr_nr) {
> -		/*
> -		 * FIXME: this should be io_schedule().  The timeout is there
> -		 * as a workaround for some DM problems in 2.6.18.
> -		 */
> -		io_schedule_timeout(5*HZ);
> -	}
> -	finish_wait(&pool->wait, &wait);
>
> +	spin_unlock_irqrestore(&pool->lock, flags);
> +
> +	/*
> +	 * FIXME: this should be io_schedule().  The timeout is there as a
> +	 * workaround for some DM problems in 2.6.18.
> +	 */
> +	io_schedule_timeout(5*HZ);

Just curious... This was added by 0b1d647a in 2006.

Perhaps the problem was already fixed?

Oleg.

