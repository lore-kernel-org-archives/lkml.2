Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2HOLjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 07:39:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41756 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2HOLjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 07:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <1344454580-17031-1-git-send-email-john.stultz@linaro.org>
References: <1344454580-17031-1-git-send-email-john.stultz@linaro.org>
Date: Wed, 15 Aug 2012 07:39:19 -0400
Message-ID: <CA+5PVA7k8=E6NkrrNbzT3=6wPE7UdnrQ94EjkGfxW6kU9u5MWw@mail.gmail.com>
Subject: Re: [PATCH] time: Improve sanity checking of timekeeping inputs
From: Josh Boyer <jwboyer@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 3:36 PM, John Stultz <john.stultz@linaro.org> wrote:
> Thomas, Ingo,
>         Here's a fix against tip/timers/urgent that addresses
> timekeeping edge cases detected by both a bad BIOS and system
> fuzzing w/ trinity. Thanks to Sasha Levin and CAI Qian for
> finding and reporting these!
>
> Let me know if you have any tweaks you want to see.
>
> thanks
> -john
>
> Unexpected behavior could occur if the time is set to
> a value large enough to overflow a 64bit ktime_t
> (which is something larger then the year 2262).
>
> Also unexpected behavior could occur if large negative
> offsets are injected via adjtimex.
>
> So this patch improves the sanity check timekeeping inputs
> by improving the timespec_valid() check, and then makes better
> use of timespec_valid() to make sure we don't set the time to
> an invalid negative value or one that overflows ktime_t.
>
> Note: This does not protect from setting the time close to
> overflowing ktime_t and then letting natural accumulation
> cause the overflow.
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Zhouping Liu <zliu@redhat.com>
> Cc: CAI Qian <caiqian@redhat.com>
> Cc: Sasha Levin <levinsasha928@gmail.com>
> Cc: stable@vger.kernel.org
> Reported-by: CAI Qian <caiqian@redhat.com>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  include/linux/ktime.h     |    7 -------
>  include/linux/time.h      |   22 ++++++++++++++++++++--
>  kernel/time/timekeeping.c |   26 ++++++++++++++++++++++++--
>  3 files changed, 44 insertions(+), 11 deletions(-)

This patch fixes a boot regression on machines with crappy BIOS.  Is
this going to get committed soon?

https://bugzilla.redhat.com/show_bug.cgi?id=844249

josh
