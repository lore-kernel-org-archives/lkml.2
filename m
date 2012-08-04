Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2HDMMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:12:14 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51689 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2HDMMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:12:12 -0400
X-Nat-Received: from [202.181.97.72]:52806 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1344082236.4417
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de
Subject: Re: [3.6-rc1] sched: clock counts too quickly
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201208032318.FGJ64576.tOMVLOFHFQOFJS@I-love.SAKURA.ne.jp>
	<201208042024.GFG34353.OFtFVQJMLOHFSO@I-love.SAKURA.ne.jp>
In-Reply-To: <201208042024.GFG34353.OFtFVQJMLOHFSO@I-love.SAKURA.ne.jp>
Message-Id: <201208042110.EFH81212.OSVOLMOtFQHJFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 4 Aug 2012 21:10:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04082012 #8314118, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> > Under unknown condition, clock starts counting up too quickly which is enough
> > to confuse hangcheck timer to print stall warning.
> I wrote a test program.

I suspected that this is a problem within adjtimex() because strace reported clock
jump at adjtimex(). But I've just hit this problem with settimeofday() alone.

---------- test program 2 start ----------
#include <sys/timex.h>

int main(int argc, char *argv[])
{
        while (1) {
                struct timeval tv;
                struct timezone tz;
                gettimeofday(&tv, &tz);
                settimeofday(&tv, &tz);
        }
        return 0;
}
---------- test program 2 end ----------

Regards.
