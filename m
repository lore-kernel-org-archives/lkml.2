Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1CHIXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:23:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57134 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1CHIX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dcR+yQfxgJKHYnvI9SZnaryvNH6PfAmRbq63vqE0R+cbMUh29OmJdfEcaM++hweYX0
         E1zzMq07woJ0xa7NVel9214GOmB7XeYIbpal9q61M+Y7wypWSvCsORIjLSGmxlTZHTew
         MDJkOosjpSncCtyk2G4Hu5IXU9Nh8rOI4kD4k=
MIME-Version: 1.0
In-Reply-To: <1299508052.8093.1.camel@marge.simson.net>
References: <1299486101.14465.25.camel@marge.simson.net>
	<AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	<1299490414.14465.74.camel@marge.simson.net>
	<1299508052.8093.1.camel@marge.simson.net>
Date: Tue, 8 Mar 2011 16:23:28 +0800
Message-ID: <AANLkTinToHNbC_Yu91GfzcSTDrzSFFb87qQDGJ1vj4sV@mail.gmail.com>
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 10:27 PM, Mike Galbraith <efault@gmx.de> wrote:
> sched: fix rt throttle runtime borrowing
>
> If allowed to borrow up to rt_period, the throttle has no effect on an out
> of control RT task, allowing it to consume 100% CPU indefinitely, blocking
> system critical SCHED_NORMAL threads indefinitely.
>
> To make the throttle a more effective safety mechanism, disable borrowing
> by default. while providing an opt-in switch for those who know the risks.
> Also fix the throttle such that it never silently bumps rt_runtime to the
> point that it disables itself (rt_runtime >= rt_period).
>
> Convert balance_runtime() and do_balance_runtime() to void since their
> return values are never used.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
>
> ---
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -1941,6 +1941,7 @@ static inline unsigned int get_sysctl_ti
>  #endif
>  extern unsigned int sysctl_sched_rt_period;
>  extern int sysctl_sched_rt_runtime;
> +extern int sysctl_sched_rt_borrow_runtime;

It should be under CONFIG_SMP.

Thanks,
Yong


-- 
Only stand for myself
