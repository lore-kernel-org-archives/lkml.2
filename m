Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab2AFJDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 04:03:00 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53714 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2AFJC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 04:02:56 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f06aa69274cf6.26578607@nextmail.ru>
References: <NEXT-4f06aa69274cf6.26578607@nextmail.ru>
Date: Fri, 6 Jan 2012 14:32:55 +0530
Message-ID: <CAD2nsn1-Oo=n8CY97sXW=kfsEeE2oknpXLayMtyxRA7VMMkHmQ@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/6 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
>  > >  > :) no problem. i hope for you can recreate the issue consistently ,
>  > >  > can you please test with the attached patch and another debug patch.
>  >>  > please let me know if there is no panic but there are warnings (or)
>  >if
>  > >  > there are no warnings (or) the issue still appears(also the trace
>  > >  > thanks) , also if you need any help
>  > > Should I apply the patch to Linux 3.2-rc7 or 3.2 release?
>  >Oh, I see. 3.2 release has this fix already. I will build it with
> debugging
>  > patch and report warnings now.
>
> I have some unpleasant news: it looks like it takes slightly longer with the
> fix, but the crash still managed to occur with 3.2 and I lack ESP to check
> for warnings immediately before that. I thought that 8 hours is enough
> testing, heh. It simply took 9 and a half under nigh-ideal conditions
> (stable signal from fixed AP with notebook also steadily in one place).

:(  i had put those warnings to prevent the crash itself and what's causing it.
may be i had missed that pos can be < 0 in addition to (pos > 37).
i am just looking at those areas of code for some other issue. hope i
can a find a fix
for both of them

>
> Good news is that I remembered to decrease console font size before the
> crash. So now I could see that the long stack trace was just a decoy to
> ensure that the first Oops scrolls too far up. I now have photos of the
> first one, too.
>
> Process: kworker/u:2 (pid: 1419, threadinfo ffff88013dc38000, task
> ffff8800891020d0)
> Stack:
>  ffff88013dc39c10 ffff880136111ae0 ffff880136110460 0000000000000040
>  ffff880136114000 0000000000000000 ffff88013dc39d20 ffffffffa0560a35
>  0000000000000001 0000000000000202 ffff8801361140f0 ffff88013ed3ea48
> Call trace:
>  ath9k_config+0x115/0x780 [ath9k]
>  ? queue_work+0x1a/0x20
>  ? queue_delayed_work+0x25/0x30
>  ? ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
>  ? ath9k_flush+0x155/0x1d0 [ath9k]
>  ieee80211_hw_config+0xe2/0x160 [mac80211]
>  ieee80211_scan_work+0x243/0x5c0 [mac80211]
>  ? __schedule+0x2d7/0x7b0
>  ? ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
>  process_one_work+0x111/0x390
>
> Only after this happens "unable to complete kernel paging request" in
> ath_update_survey_stats
>  worker_thread+0x162/0x340
>  ? manage_workers.clone.26+0x240/0x240
>  kthread+0x96/0xa0
>  kernel_thread_helper+0x4/0x10
>  ? kthread_worker_fn+0x190/0x190
>  ? gs_change+0x13/0x13
>
>



-- 
shafi
