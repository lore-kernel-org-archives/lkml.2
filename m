Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2HEAus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 20:50:48 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58491 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2HEAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 20:50:45 -0400
X-Nat-Received: from [202.181.97.72]:52621 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1344127823.11699
To: mingo@kernel.org
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.p.zijlstra@chello.nl,
        richardcochran@gmail.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: Fix adjustment cleanup bug in timekeeping_adjust()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201208032318.FGJ64576.tOMVLOFHFQOFJS@I-love.SAKURA.ne.jp>
	<201208042024.GFG34353.OFtFVQJMLOHFSO@I-love.SAKURA.ne.jp>
	<201208042110.EFH81212.OSVOLMOtFQHJFF@I-love.SAKURA.ne.jp>
	<201208042246.HBH81275.FVOOSLtJFMQOFH@I-love.SAKURA.ne.jp>
	<20120804192114.GA28347@gmail.com>
In-Reply-To: <20120804192114.GA28347@gmail.com>
Message-Id: <201208050950.IHH64070.QMLFSHOFFVOtOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 5 Aug 2012 09:50:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04082012 #8317918, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> > Bisected to 2a8c0883 "time: Move xtime_nsec adjustment 
> > underflow handling timekeeping_adjust".
> > 
> > Would you check?
> 
> probably caused by this stray return in timekeeping_adjust():
> 
>         } else
>                 return;
> 
> which should really be a proper goto - like the (totally 
> untested!) patch below.
> 
> Does this fix the bug for you?
> 
> Thanks,
> 
> 	Ingo
> 
Yes, this fixed the bug.

Thank you.
