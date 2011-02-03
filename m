Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1BCJ3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:29:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:32827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1BCJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:29:42 -0500
Subject: Re: Regression: WARNINGS and lockdep spews in 2.6.38-rc3+
 (bisected).
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110203091227.GA1603@zhy>
References: <20110203031943.GA8910@elliptictech.com>
	 <20110203091227.GA1603@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 10:30:40 +0100
Message-ID: <1296725440.26581.354.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 17:12 +0800, Yong Zhang wrote:
>  #ifdef CONFIG_LOCKDEP
> +       unsigned long flags;
> +
>         local_bh_disable();
>         lock_map_acquire(&timer->lockdep_map);
>         lock_map_release(&timer->lockdep_map);
> -       local_bh_enable();
> +       /* raw_local_irq_[save|restore] is to protect _local_bh_enable() */
> +       raw_local_irq_save(flags);
> +       _local_bh_enable();
> +       raw_local_irq_restore(flags);
>  #endif 

_why_ are you doing the raw_local_irq stuff? That's just weird, and that
comment isn't helping.

Also, calling _local_bh_enable() will leave pending softirqs, not
particularly nice

