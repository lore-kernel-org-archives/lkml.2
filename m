Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1HIPVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1HIPU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:20:59 -0400
Date: Tue, 9 Aug 2011 17:17:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 1/8] cgroups: Add res_counter_write_u64() API
Message-ID: <20110809151739.GB15311@redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311956010-32076-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Frederic Weisbecker wrote:
>
> +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> +{
> +	unsigned long long *target;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&counter->lock, flags);
> +	target = res_counter_member(counter, member);
> +	*target = val;
> +	spin_unlock_irqrestore(&counter->lock, flags);
> +}

Hmm. Why do we need counter->lock?

OK, probably it is for BITS_PER_LONG < 64. May be it makes sense
to ifdef, just to make the code more understandable.

Oleg.

