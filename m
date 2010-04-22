Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0DVHHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:07:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:35061 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0DVHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:07:11 -0400
Date: Thu, 22 Apr 2010 15:06:25 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Lockdep usage
Message-ID: <20100422070625.GA17515@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <4BCFEBFF.4090505@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4BCFEBFF.4090505@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Apr 2010 07:06:27.0925 (UTC) FILETIME=[53DFC050:01CAE1EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:26:07PM -0700, Darren Hart wrote:
> I'm having some trouble with lockstat. I've enabled
> CONFIG_LOCK_STATS and then run the following commands to collect the
> lock statistics for the futex_lock test case. I expect this test
> case to generate a fair amount of contention on the futex hash
> bucket locks, but they don't show up in the stats (in fact, nothing
> shows up in the stats). I have seen much longer lock_stat files when
> I forgot to clear them before the test, but no hb locks showed up
> there either.
> 
> Is my usage below incorrect? Do I have to somehow annotate the
> hb->lock in order for lockstat to track it?

IMHO, you don't need to do that.

> lock.lockstat; echo 0 > /proc/sys/kernel/lock_stat
> futex_lock: Measure FUTEX_LOCK operations per second
>         Arguments: iterations=10000000 threads=256 adaptive=no
>                    period=1000 duty-cycle=20%
> Result: 731 Kiter/s
> 
> # cat lock.lockstat
> lock_stat version 0.3
> *WARNING* lock debugging disabled!! - possibly due to a lockdep warning

This means lockdep has detect there is something wrong.
Can you show your 'dmesg'?

Thanks,
Yong

> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    con-bounces
> contentions   waittime-min   waittime-max waittime-total
> acq-bounces acquisitions   holdtime-min   holdtime-max
> holdtime-total
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
> #
> 
> Thanks,
> 
> -- 
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
