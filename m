Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2HUHOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:14:17 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42214 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2HUHOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:14:14 -0400
X-Auth-Info: ia2tC+3Xs5rq/rq3UbQ0+8EpbzeTPTDPh0SENgS6n7A=
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
	<m2fw7ilhnm.fsf@igel.home> <503288ED.10306@linaro.org>
	<m2fw7h4ab5.fsf@igel.home> <503296C1.4070906@linaro.org>
	<m2boi549ed.fsf@igel.home> <5033029A.2030201@linaro.org>
X-Yow: I wish I was on a Cincinnati street corner holding a clean dog!
Date: Tue, 21 Aug 2012 09:14:06 +0200
In-Reply-To: <5033029A.2030201@linaro.org> (John Stultz's message of "Mon, 20
	Aug 2012 20:38:02 -0700")
Message-ID: <m2d32kemyp.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> @@ -115,6 +115,7 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
>  {
>  	tk->xtime_sec += ts->tv_sec;
>  	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
> +	tk_normalize_xtime(tk);
>  }

Yes, that does it.  Failure to normalize is always bad.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
