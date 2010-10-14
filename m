Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0JNO6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:58:38 -0400
Received: from mailhost-r5-p2.mangoosta.org ([195.5.209.65]:58858 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754185Ab0JNO6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:58:37 -0400
Date: Thu, 14 Oct 2010 16:58:13 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101014145813.GA2185@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929070153.GA2200@brouette>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> With 2.6.36-rc6, I'm seeing a load of around 0.60 when the machine is
> completely idle. This is similar to what someone reported for the latest
> 2.6.35.x stables. This is on a core i7 machine, but I've no time to
> bisect or test earlier versions right now, but I guess this is easy to
> reproduce on the same plateform.

After further investigation and cross-checking with the thread "PROBLEM:
Unusually high load average when idle in 2.6.35, 2.6.35.1 and later",
I came to the following results:

- the commit 74f5187ac873042f502227701ed1727e7c5fbfa9 isolated by Tim
  seems to be the culprit;
- reverting it solves the problem with 2.6.36-rc7 in NOHZ mode: the load
  when idle goes down to 0.00 (which it never does with the patch
  applied)
- using nohz=no with the commit reverted still gives correct behaviour
  (tested just in case)

- vanilla 2.6.36-rc7 with this commit applied has the problem (load is
  around 0.60 when machine idle, sometimes less after several hours
  of uptime, but never 0.00), and rebooting with nohz=no makes the
  problem disappear: load goes down to 0.00 quickly after boot process
  has finished.

I hope this answers the questions raised in the Tim's thread.

Could someone with knowledge of the commit take a look at the problem?
It would be a bit annoying to have this problem in 2.6.36, since Tim's
initial report dates back to 2 weeks ago...

I can help for further testing if needed.


Thanks in advance,
-- 
Damien
