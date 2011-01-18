Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1ARFtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 00:49:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45264 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1ARFtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 00:49:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kb9/dwcJlzmOuDCcId82oeg/iyPNok8o5E9gMJdrtRqSiAzFaHvv469jicLVch603e
         j9WlFGZGAekiVXVn8/4KrujBmiTn9+t7klclVlWnuvVuPrU/Md0Ubbh88v7kIs6hBTmA
         P6rQH9BxjzFyziQRahUJ8g+DTV/xgqTgm5WAY=
MIME-Version: 1.0
In-Reply-To: <653CEFD4210E904494F3E2FB9F6A479716464979C7@FLMX07.iccur.com>
References: <653CEFD4210E904494F3E2FB9F6A479716464979C7@FLMX07.iccur.com>
Date: Tue, 18 Jan 2011 13:49:15 +0800
Message-ID: <AANLkTinf++svN-+C0MaUeDDeD65ubVqLfxCkyDh_jzSt@mail.gmail.com>
Subject: Re: [PATCH] fix bad delta time values in /proc/timer_list
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Shaffer, Scott" <scott.shaffer@ccur.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 4:20 AM, Shaffer, Scott <scott.shaffer@ccur.com> wrote:
> elapsed times printed from /proc/timer_list are incorrect for the
> CLOCK_REALTIME timer list.
>
> print_timer() is passed monotonic nsecs as current time, but should
> be passed monotonic nsecs + hrtimer_clock_base.offset for the
> timer list it is printing.
>
> This patch fixes CLOCK_REALTIME timer lists, and does not break
> CLOCK_MONOTONIC timer lists.
>
>
> This shows a thread's timer that is <10ms:
>
> xunil2.ccur.com # grep -A 9 "cpu: 1" /proc/timer_list
> cpu: 1
>  clock 0:
>  .base:       f67031d0
>  .index:      0
>  .resolution: 1 nsecs
>  .get_time:   ktime_get_real
>  .offset:     1294953310697580572 nsecs
> active timers:
>  #0: <f518ff3c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, pthread_sleep2/7067
>  # expires at 1295021767185712301-1295021767185712301 nsecs [in 1294953310698070434 to 1294953310698070434 nsecs]
>
>
> With the patch below, that thread's timer looks like:
>
>  #0: <f37d7f3c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, pthread_sleep2/9403
>  # expires at 1295022944770566772-1295022944770566772 nsecs [in 5305914 to 5305914 nsecs]
>
>
> Signed-off-by: Scott Shaffer <scott.shaffer@ccur.com>

Looks good.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
