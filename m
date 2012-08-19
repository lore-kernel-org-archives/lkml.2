Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2HSVCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 17:02:34 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37428 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2HSVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 17:02:31 -0400
X-Auth-Info: 8GHFiljgn5HaGhtrZJxWnB6Wuzo0SbC97KH+IlA2cTE=
From: Andreas Schwab <schwab@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/8] time: Condense timekeeper.xtime into xtime_sec
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
	<1342156917-25092-5-git-send-email-john.stultz@linaro.org>
X-Yow: Don't SANFORIZE me!!
Date: Sun, 19 Aug 2012 23:02:21 +0200
In-Reply-To: <1342156917-25092-5-git-send-email-john.stultz@linaro.org> (John
	Stultz's message of "Fri, 13 Jul 2012 01:21:53 -0400")
Message-ID: <m2fw7ilhnm.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> The timekeeper struct has a xtime_nsec, which keeps the
> sub-nanosecond remainder.  This ends up being somewhat
> duplicative of the timekeeper.xtime.tv_nsec value, and we
> have to do extra work to keep them apart, copying the full
> nsec portion out and back in over and over.
>
> This patch simplifies some of the logic by taking the timekeeper
> xtime value and splitting it into timekeeper.xtime_sec and
> reuses the timekeeper.xtime_nsec for the sub-second portion
> (stored in higher res shifted nanoseconds).
>
> This simplifies some of the accumulation logic. And will
> allow for more accurate timekeeping once the vsyscall code
> is updated to use the shifted nanosecond remainder.

This (together with b44d50d "time: Fix casting issue in tk_set_xtime and
tk_xtime_add") is causing resume to hang on the iBook (PowerBook6,7).
The fact that the add-on commit is needed to uncover the bug might give
a hint, but I'm unable to decipher it.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
