Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2IJRIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:08:39 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55308 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2IJRIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:08:37 -0400
Message-ID: <504E1E19.9050106@linaro.org>
Date: Mon, 10 Sep 2012 10:06:33 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup - CPU#1 stuck for 1024s!
References: <20120909075927.GA13058@localhost>
In-Reply-To: <20120909075927.GA13058@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091017-5518-0000-0000-00000789E142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 12:59 AM, Fengguang Wu wrote:
> Hi John,
>
> The below lockup warning pops up very occasionally in kvm guest
> kernels and it's bisected down to
>
>          commit 2a8c0883c3cfffcc148ea606e2a4e7453cd75e73
>          Author: John Stultz <john.stultz@linaro.org>
>          Date:   Fri Jul 13 01:21:56 2012 -0400
>
>              time: Move xtime_nsec adjustment underflow handling timekeeping_adjust
>
> [    8.340327] Freeing unused kernel memory: 460k freed
> [ 1107.515496] [sched_delayed] sched: RT throttling activated
> [ 1107.516439] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]


Thanks so much for sending this. One detail I'm curious about is that 
these kernels from the Bug messages seem to be v3.6-rc1 or earlier.

Ingo had a fix 1d17d17484d40f2d5b35c79518597a2b25296996 ("time: Fix 
adjustment cleanup bug in timekeeping_adjust") that landed in 3.6-rc2

Has this issue actually been seen on a 3.6-rc2+ kernel?

thanks
-john

