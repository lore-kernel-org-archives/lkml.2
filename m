Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0KJUQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:16:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42468 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab0KJUQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:16:47 -0500
Date: Wed, 10 Nov 2010 21:16:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jkacur@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, matt@console-pimps.org, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] futex: Address compiler warnings in
	exit_robust_list
Message-ID: <20101110201600.GA14145@pengutronix.de>
References: <1288897200-13008-1-git-send-email-dvhart@linux.intel.com> <tip-4c115e951d80aff126468adaec7a6c7854f61ab8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-4c115e951d80aff126468adaec7a6c7854f61ab8@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Thomas,

On Wed, Nov 10, 2010 at 12:30:44PM +0000, tip-bot for Darren Hart wrote:
> Commit-ID:  4c115e951d80aff126468adaec7a6c7854f61ab8
> Gitweb:     http://git.kernel.org/tip/4c115e951d80aff126468adaec7a6c7854f61ab8
> Author:     Darren Hart <dvhart@linux.intel.com>
> AuthorDate: Thu, 4 Nov 2010 15:00:00 -0400
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 10 Nov 2010 13:27:50 +0100
> 
> futex: Address compiler warnings in exit_robust_list
> 
> Since commit 1dcc41bb (futex: Change 3rd arg of fetch_robust_entry()
> to unsigned int*) some gcc versions decided to emit the following
> warning:
> 
> kernel/futex.c: In function ‘exit_robust_list’:
> kernel/futex.c:2492: warning: ‘next_pi’ may be used uninitialized in this function
> 
> The commit did not introduce the warning as gcc should have warned
> before that commit as well. It's just gcc being silly.
> 
> The code path really can't result in next_pi being unitialized (or
> should not), but let's keep the build clean. Annotate next_pi as an
> uninitialized_var.
> 
> [ tglx: Addressed the same issue in futex_compat.c and massaged the
>   	changelog ]
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Tested-by: Matt Fleming <matt@console-pimps.org>
> Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
I don't care much (at least until someone claims this change to
introduce a regression), but I didn't test it.  I only suggested to use 
uninitialized_var instead of = 0.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
