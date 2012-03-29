Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab2C2NkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:40:02 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:32217 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421Ab2C2Nj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:39:56 -0400
Message-ID: <4F74662A.7040704@tilera.com>
Date: Thu, 29 Mar 2012 09:39:54 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <satyam@infradead.org>, <peterz@infradead.org>, <cmetcalf@tilera.com>,
        <tglx@linutronix.de>, <sboyd@codeaurora.org>
CC: <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Fix __schedule_bug() output when called
 from an interrupt
References: <1332979847-27102-1-git-send-email-sboyd@codeaurora.org> <tip-6135fc1eb4b1c9ae5f535507ed59591bab51e630@git.kernel.org>
In-Reply-To: <tip-6135fc1eb4b1c9ae5f535507ed59591bab51e630@git.kernel.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/2012 3:16 AM, tip-bot for Stephen Boyd wrote:
> Commit-ID:  6135fc1eb4b1c9ae5f535507ed59591bab51e630
> Gitweb:     http://git.kernel.org/tip/6135fc1eb4b1c9ae5f535507ed59591bab51e630
> Author:     Stephen Boyd <sboyd@codeaurora.org>
> AuthorDate: Wed, 28 Mar 2012 17:10:47 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 29 Mar 2012 08:34:45 +0200
>
> sched: Fix __schedule_bug() output when called from an interrupt
>
> If schedule is called from an interrupt handler __schedule_bug()
> will call show_regs() with the registers saved during the
> interrupt handling done in do_IRQ(). This means we'll see the
> registers and the backtrace for the process that was interrupted
> and not the full backtrace explaining who called schedule().
>
> This is due to 838225b ("sched: use show_regs() to improve
> __schedule_bug() output", 2007-10-24) which improperly assumed
> that get_irq_regs() would return the registers for the current
> stack because it is being called from within an interrupt
> handler. Simply remove the show_reg() code so that we dump a
> backtrace for the interrupt handler that called schedule().
>
> [ I ran across this when I was presented with a scheduling while
>   atomic log with a stacktrace pointing at spin_unlock_irqrestore().
>   It made no sense and I had to guess what interrupt handler could
>   be called and poke around for someone calling schedule() in an
>   interrupt handler. A simple test of putting an msleep() in
>   an interrupt handler works better with this patch because you
>   can actually see the msleep() call in the backtrace. ]
>
> Also-reported-by: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Satyam Sharma <satyam@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1332979847-27102-1-git-send-email-sboyd@codeaurora.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

We have been using this same exact patch internally for a while now, and by
a curious fluke of timing, I sent email to Ingo and to Satyam Sharma
pointing out that we really should re-look at the original change just
yesterday :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

