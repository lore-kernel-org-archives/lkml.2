Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab1ELK6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:58:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53294 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1ELK6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZTqxY9ZnNu99Zc6IShPShH4Idrl4fRP9cVnnn1Ungeh2VlHZQz2j/Y6kZyy5/B2HWK
         rrXFrKDaNj3nQCXMX7ItxFaYtpHJazRnKYfTQ4zoKfXgENhlLMmja3x1vNEiADW20YqX
         coJn9RPvVncssOGHxFYpc0ctmDMBbSTmTLR+U=
Date: Thu, 12 May 2011 18:57:56 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: lock_stat &rq->lock/1 class name meaning
Message-ID: <20110512105756.GA3329@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4DCAB8A2.8060605@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DCAB8A2.8060605@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 06:26:10PM +0200, Juri Lelli wrote:
> Hi,
> I'm trying to collect contention statistics through /proc/lock_stat
> about scheduler data structures.
> 
> What I obtain if a do "cat /proc/lock_stat" is something like:
> ...
> &rq->lock:         13128          13128           0.43
> 190.53    103881.26          97454        3453404           0.00
> 401.11    13224683.11
> ---------
> &rq->lock            645          [<ffffffff8103bfc4>]
> task_rq_lock+0x43/0x75
> &rq->lock            297          [<ffffffff8104ba65>]
> try_to_wake_up+0x127/0x25a
> &rq->lock            360          [<ffffffff8103c4c5>]
> select_task_rq_fair+0x1f0/0x74a
> &rq->lock            428          [<ffffffff81045f98>]
> scheduler_tick+0x46/0x1fb
> ---------
> &rq->lock             77          [<ffffffff8103bfc4>]
> task_rq_lock+0x43/0x75
> &rq->lock            174          [<ffffffff8104ba65>]
> try_to_wake_up+0x127/0x25a
> &rq->lock           4715          [<ffffffff8103ed4b>]
> double_rq_lock+0x42/0x54
> &rq->lock            893          [<ffffffff81340524>] schedule+0x157/0x7b8
> .
> .
> .
> ...
> &rq->lock/1:         11526          11488           0.33
> 388.73      136294.31          21461          38404           0.00
> 37.93      109388.53
> -----------
> &rq->lock/1          11526          [<ffffffff8103ed58>]
> double_rq_lock+0x4f/0x54
> -----------
> &rq->lock/1           5645          [<ffffffff8103ed4b>]
> double_rq_lock+0x42/0x54
> &rq->lock/1           1224          [<ffffffff81340524>]
> schedule+0x157/0x7b8
> &rq->lock/1           4336          [<ffffffff8103ed58>]
> double_rq_lock+0x4f/0x54
> &rq->lock/1            181          [<ffffffff8104ba65>]
> try_to_wake_up+0x127/0x25a
> 
> I guess the first one is about the per-rq (per-CPU) spinlock, but
> what about the second? What the "/1" stands for?

It is also rq but it's subclass is 1.

Take a look at raw_spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
in _double_lock_balance()

> Since every rq has a different spinlock, does &rq->lock group
> numbers from all the runqueues?

Yup.

Thanks,
Yong

> 
> Thanks a lot,
> 	Juri
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
