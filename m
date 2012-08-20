Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2HTTpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:45:33 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36937 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2HTTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:45:29 -0400
X-Auth-Info: HuISAAUWNYhl1SElfBc63bxQUl70yxFQVK7Cgl2+7g8=
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
X-Yow: PUNK ROCK!!  DISCO DUCK!!  BIRTH CONTROL!!
Date: Mon, 20 Aug 2012 21:45:18 +0200
In-Reply-To: <503288ED.10306@linaro.org> (John Stultz's message of "Mon, 20
	Aug 2012 11:58:53 -0700")
Message-ID: <m2fw7h4ab5.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> I'm not very familiar w/ the iBook hardware, but does it use a 
> clocksource, or does it use arch_gettimeoffset()?

clocksource: timebase mult[3640e38e] shift[24] registered

> I suspect that the casting has avoided clipping some strange values from 
> the persistent clock.

That's my guess as well.

> Could you try with the following patch against Linus' HEAD? I suspect it 
> will let the box resume (although it will seem as though no time was 
> spent in resume) and then let me know what the JDB lines print out?

JDB: suspend_time: 1345491706:0  resume_time: 1345491737:0
JDB: Trying to add: 31:0

(Looks reasonable.)

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
