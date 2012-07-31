Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2GaLbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 07:31:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46975 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 07:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
Date: Tue, 31 Jul 2012 07:31:00 -0400
Message-ID: <CA+5PVA47uHmxYh9V5A8ZTLW5yEpCYpYYe0Q=TRoj4A-9jGH0zA@mail.gmail.com>
Subject: Re: [PATCH 0/2][RFC] Better handling of insane CMOS values
From: Josh Boyer <jwboyer@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 2:35 AM, John Stultz <john.stultz@linaro.org> wrote:
> So CAI Qian noticed recent boot trouble on a machine that had its CMOS
> clock configured for the year 8200.
> See: http://lkml.org/lkml/2012/7/29/188
>
> While running with a crazy CMOS clock isn't advised, and a simple
> "don't do that" might be reasonable, the behavior has in effect
> regressed recently due to changes in the hrtimer/timekeeping
> interactions.
>
> This patchset tries to resolve this issue in two ways:
> 1) Change ktime_get_update_offsets to match ktime_get and avoid
> possible precision loss with extremely large timespecs.
>
> 2) Catch any stop attempt to set the time to a value (circa the
> year 2264) large enough to overflow ktime_t.
>
> The end fix here might be an either/or/both combination of these
> two changes, so I wanted to send them out for comment. I'm also
> looking at further ways to test and improve robustness around
> these more extreme time values.
>
> I've also only been able to lightly test. If you want to try this out
> you can add the following to timekeeping_init after the
> read_persistent_clock() call:
>
>         now.tv_sec = 196469280000LL;
>
> thanks
> -john
>
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Zhouping Liu <zliu@redhat.com>
> Cc: CAI Qian <caiqian@redhat.com>

These should be CC'd to stable, right?  CAI hit this with a 3.5-rcX
kernel, and the hrtimer stuff was backported to 3.4 and before I
thought.

josh
