Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab1BAVtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:49:53 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39505 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1BAVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:49:52 -0500
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134420.164172635@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134420.164172635@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:49:47 -0800
Message-ID: <1296596987.3336.83.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-clocks-introduce-dynamic-clocks.patch)
> From: Richard Cochran <richardcochran@gmail.com>
> 
> This patch adds support for adding and removing posix clocks. The
> clock lifetime cycle is patterned after usb devices. Each clock is
> represented by a standard character device. In addition, the driver
> may optionally implement custom character device operations.
> 
> The posix clock and timer system calls listed below now work with
> dynamic posix clocks, as well as the traditional static clocks.
> The following system calls are affected:
> 
>    - clock_adjtime (brand new syscall)
>    - clock_gettime
>    - clock_getres
>    - clock_settime
>    - timer_create
>    - timer_delete
>    - timer_gettime
>    - timer_settime
> 
> [ tglx: Adapted to the posix-timer cleanup. Moved clock_posix_dynamic
>   	to posix-clock.c and made all referenced functions static ]

I sort of worry about the naming collision with the term posix-clock, as
this is just one type of posix clock (I suspect most folks think of a
posix clock as the clockid passed to the existing posix api).

Could we maybe use posix-dynclock or posix-fdclock or something? I know
its already been changed from clkdev, so sorry for being finicky here
and not catching this earlier.

thanks
-john


