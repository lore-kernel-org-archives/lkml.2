Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0JTN15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:27:57 -0400
Received: from mailhost-v3-p3.internext.fr ([195.5.209.88]:31488 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751968Ab0JTN14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:27:56 -0400
Date: Wed, 20 Oct 2010 15:27:32 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101020132732.GA30024@brouette>
References: <20100929070153.GA2200@brouette>
 <20101014145813.GA2185@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014145813.GA2185@brouette>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > With 2.6.36-rc6, I'm seeing a load of around 0.60 when the machine
> > is completely idle. This is similar to what someone reported for the
> > latest 2.6.35.x stables. This is on a core i7 machine, but I've no
> > time to bisect or test earlier versions right now, but I guess this
> > is easy to reproduce on the same plateform.

> After further investigation and cross-checking with the thread "PROBLEM:
> Unusually high load average when idle in 2.6.35, 2.6.35.1 and later",
> I came to the following results:

> - the commit 74f5187ac873042f502227701ed1727e7c5fbfa9 isolated by Tim
>   seems to be the culprit;
> - reverting it solves the problem with 2.6.36-rc7 in NOHZ mode: the load
>   when idle goes down to 0.00 (which it never does with the patch
>   applied)

In fact, after several hours of uptime, I also came into a situation of
the load being around 0.80 or 0.60 when idle with the commit reverted.
So IMHO, just reverting is not a better option than keeping the
offending commit, and a real rework of the code is needed to clean up
the situation.

Should'nt we enlarge the list of CC, because for now, responsivity has
been close to 0 and it seems we will get a 2.6.36 with buggy load avg
calculation. Even if it is only statistics, many supervision tools rely
on the load avg, so for production environments, this is not a good
thing.


Best,
-- 
Damien
