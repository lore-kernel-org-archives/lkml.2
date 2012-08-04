Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2HDNt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 09:49:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63845 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2HDNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 09:49:26 -0400
X-Nat-Received: from [202.181.97.72]:50083 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1344087972.9564
To: john.stultz@linaro.org, mingo@kernel.org, tglx@linutronix.de
Cc: a.p.zijlstra@chello.nl, richardcochran@gmail.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.6-rc1] sched: clock counts too quickly
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201208032318.FGJ64576.tOMVLOFHFQOFJS@I-love.SAKURA.ne.jp>
	<201208042024.GFG34353.OFtFVQJMLOHFSO@I-love.SAKURA.ne.jp>
	<201208042110.EFH81212.OSVOLMOtFQHJFF@I-love.SAKURA.ne.jp>
In-Reply-To: <201208042110.EFH81212.OSVOLMOtFQHJFF@I-love.SAKURA.ne.jp>
Message-Id: <201208042246.HBH81275.FVOOSLtJFMQOFH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 4 Aug 2012 22:46:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04082012 #8314118, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bisected to 2a8c0883 "time: Move xtime_nsec adjustment underflow handling
timekeeping_adjust".

Would you check?

Regards.

Tetsuo Handa wrote:
> Tetsuo Handa wrote:
> > > Under unknown condition, clock starts counting up too quickly which is enough
> > > to confuse hangcheck timer to print stall warning.
> > I wrote a test program.
> 
> I suspected that this is a problem within adjtimex() because strace reported clock
> jump at adjtimex(). But I've just hit this problem with settimeofday() alone.
> 
> ---------- test program 2 start ----------
> #include <sys/timex.h>
> 
> int main(int argc, char *argv[])
> {
>         while (1) {
>                 struct timeval tv;
>                 struct timezone tz;
>                 gettimeofday(&tv, &tz);
>                 settimeofday(&tv, &tz);
>         }
>         return 0;
> }
> ---------- test program 2 end ----------
> 
> Regards.
