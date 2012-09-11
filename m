Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2IKXle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:41:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:13236 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab2IKXlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,407,1344236400"; 
   d="scan'208";a="220944876"
Date: Wed, 12 Sep 2012 07:41:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup - CPU#1 stuck for 1024s!
Message-ID: <20120911234130.GA13382@localhost>
References: <20120909075927.GA13058@localhost>
 <504E1E19.9050106@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504E1E19.9050106@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:06:33AM -0700, John Stultz wrote:
> On 09/09/2012 12:59 AM, Fengguang Wu wrote:
> >Hi John,
> >
> >The below lockup warning pops up very occasionally in kvm guest
> >kernels and it's bisected down to
> >
> >         commit 2a8c0883c3cfffcc148ea606e2a4e7453cd75e73
> >         Author: John Stultz <john.stultz@linaro.org>
> >         Date:   Fri Jul 13 01:21:56 2012 -0400
> >
> >             time: Move xtime_nsec adjustment underflow handling timekeeping_adjust
> >
> >[    8.340327] Freeing unused kernel memory: 460k freed
> >[ 1107.515496] [sched_delayed] sched: RT throttling activated
> >[ 1107.516439] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
> 
> 
> Thanks so much for sending this. One detail I'm curious about is
> that these kernels from the Bug messages seem to be v3.6-rc1 or
> earlier.
> 
> Ingo had a fix 1d17d17484d40f2d5b35c79518597a2b25296996 ("time: Fix
> adjustment cleanup bug in timekeeping_adjust") that landed in
> 3.6-rc2
> 
> Has this issue actually been seen on a 3.6-rc2+ kernel?

Nope. I tested -rc5 for 10000+ boots and it's obviously free from the bug.
Sorry for the noise!

Thanks,
Fengguang
