Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1HKQkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:40:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:35602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1HKQkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:40:21 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 11 Aug 2011 18:39:41 +0200
In-Reply-To: <201108111804.11136.tim.sander@hbm.com>
References: <1312580681.28695.44.camel@twins>
	 <201108111330.28168.tim.sander@hbm.com> <1313066498.8491.1.camel@twins>
	 <201108111804.11136.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313080781.8491.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 18:04 +0200, Tim Sander wrote:
> Yes it works for CONFIG_PREEMPT_RTB=y and as you say not for 
> CONFIG_PREEMPT_LL=y.

> +++ b/mm/filemap.c
> @@ -2040,7 +2040,7 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
>         char *kaddr;
>         size_t copied;
>  
> -       BUG_ON(!current->pagefault_disabled);
> +       BUG_ON(!(in_atomic() || current->pagefault_disabled)); 

Ah, I had hoped that bit would have cured the PREEMPT_LL=y config.


But let me untangle that posix_cpu_timer stuff first, maybe that's in
the way.
