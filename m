Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2KRUJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 15:09:18 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63308 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2KRUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 15:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <50A70199.9030109@us.ibm.com>
References: <20121105220059.GA6379@www.outflux.net>
	<509DA63E.7070500@us.ibm.com>
	<CAGXu5jKq0=+XfH6yDSaJMcd-S3=o7xB67kspPkCRcXjRSGgciw@mail.gmail.com>
	<20121117025355.GC29966@lizard>
	<50A70199.9030109@us.ibm.com>
Date: Sun, 18 Nov 2012 12:09:16 -0800
X-Google-Sender-Auth: mVY_kTUVAlvzgydMrVCloiC3h6E
Message-ID: <CAGXu5j+--cmhOHMR+7ewWt_ct-0p_o8sbK4bJWkgj067aeFjsw@mail.gmail.com>
Subject: Re: [PATCH v2] pstore/ram: no timekeeping calls when unavailable
From: Kees Cook <keescook@chromium.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 7:16 PM, John Stultz <johnstul@us.ibm.com> wrote:
> Yea, I wanted to revisit this, because it is an odd case.
>
> We don't want to call getnstimeofday() while the timekeeping code is
> suspended, since the clocksource cycle_last value may be invalid if the
> hardware was reset during suspend.  Kees is correct,  the WARN_ONs were
> there to make sure no one tries to use the timekeeping core before its
> resumed, so removing them is problematic.
>
> Your sugggestion of having the __do_gettimeofday() internal accessor that
> maybe returns an error if timekeeping has been suspended could work.
>
> The other possibility is depending on the needs for accuracy with the
> timestamp, current_kernel_time() might be a better interface to use, since
> it will return the time at the last tick, and doesn't require accessing the
> clocksource hardware.  Might that be a simpler solution? Or is sub-tick
> granularity necessary?

I think it's only useful to have this to the same granularity as
sched_clock(), so things can be correlated to dmesg output. If it's
the same, I'd be fine to switch to using current_kernel_time().

-Kees

-- 
Kees Cook
Chrome OS Security
