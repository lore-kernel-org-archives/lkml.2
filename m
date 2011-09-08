Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab1IHHjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:39:52 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53651 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab1IHHju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:39:50 -0400
Date: Thu, 8 Sep 2011 15:39:43 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: TAO HU <tghk48@motorola.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: Tasks schedule/migration issue with CPU hotplug?
Message-ID: <20110908073943.GC11124@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <CAOwKts_WTDBLkz9=0MBhs6wzc67XD_bYgGMiZ-JUM+8O7gP_fw@mail.gmail.com>
 <CAOwKts8pXt6spknNfBV-wy4_KoSp-JaZsdbzOxxWTqu=f6X3Bg@mail.gmail.com>
 <20110908072801.GA11124@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110908072801.GA11124@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 03:28:01PM +0800, Yong Zhang wrote:
> On Thu, Sep 08, 2011 at 02:47:08PM +0800, TAO HU wrote:
> > Resend with linux-kernel mail list included.
> 
> Hmm, could you give a try with commit da7a735e?
> 
> Thanks,
> Yong
> 
> ---
> commit da7a735e51f9622eb3e1672594d4a41da01d7e4f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Jan 17 17:03:27 2011 +0100
> 
>     sched: Fix switch_from_fair()
>     
>     When a task is taken out of the fair class we must ensure the vruntime
>     is properly normalized because when we put it back in it will assume
>     to be normalized.
>     
>     The case that goes wrong is when changing away from the fair class
>     while sleeping. Sleeping tasks have non-normalized vruntime in order
>     to make sleeper-fairness work. So treat the switch away from fair as a
>     wakeup and preserve the relative vruntime.
>     
>     Also update sysrq-n to call the ->switch_{to,from} methods.
>     
>     Reported-by: Onkalo Samu <samu.p.onkalo@nokia.com>
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     LKML-Reference: <new-submission>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> > 
> > On Wed, Sep 7, 2011 at 10:22 PM, TAO HU <tghk48@motorola.com> wrote:
> > > <4>[ 6950.136230] cfs_rq[0]:/
> > > <4>[ 6950.136230] ? .exec_clock ? ? ? ? ? ? ? ? ? ?: 6520265.283900
> > > <4>[ 6950.136260] ? .MIN_vruntime ? ? ? ? ? ? ? ? ?: 2223057.428522
> > > <4>[ 6950.136260] ? .min_vruntime ? ? ? ? ? ? ? ? ?: 2223057.428522
> > > <4>[ 6950.136291] ? .max_vruntime ? ? ? ? ? ? ? ? ?: 2223114.709956
> > > <4>[ 6950.136291] ? .spread ? ? ? ? ? ? ? ? ? ? ? ?: 57.281434
> > > <4>[ 6950.136291] ? .spread0 ? ? ? ? ? ? ? ? ? ? ? : 0.000000
> > > <4>[ 6950.136322] ? .nr_running ? ? ? ? ? ? ? ? ? ?: 212
> > > <4>[ 6950.136322] ? .load ? ? ? ? ? ? ? ? ? ? ? ? ?: 217650
> > > <4>[ 6950.136352] ? .nr_spread_over ? ? ? ? ? ? ? ?: 125034
> > > <4>[ 6950.136352] ? .shares ? ? ? ? ? ? ? ? ? ? ? ?: 0
> > > <4>[ 6950.136352]
> > > <4>[ 6950.136566] runnable tasks:
> > > <4>[ 6950.136566] ? ? ? ? ? ? task ? PID ? ? ? ? tree-key ?switches
> > > prio ? ? exec-runtime ? ? ? ? sum-exec ? ? ? ?sum-sleep
> > > <4>[ 6950.136596]
> > > ----------------------------------------------------------------------------------------------------------
> > > <4>[ 6950.136627] ? ? ?omap2_mcspi ? ?21 ? 2223062.886210 ?29451523

The tree-key(2223062.886210) almost equals to cfs_rq.min_vruntime,
so maybe you hit the bug which is cured by the mentioned commit.

Thanks,
Yong
