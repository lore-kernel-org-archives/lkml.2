Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0C2OmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:42:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:48735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0C2OmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:42:02 -0400
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting
 till after load update period
From: Peter Zijlstra <peterz@infradead.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 16:41:58 +0200
Message-ID: <1269873718.12097.342.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 09:41 -0400, Chase Douglas wrote:
> There's a period of 10 ticks where calc_load_tasks is updated by all the
> cpus for the load avg. Usually all the cpus do this during the first
> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
> However, if they wake up calc_load_tasks is not incremented. Thus, if
> cpus go idle during the 10 tick period, calc_load_tasks may be
> decremented to a non-representative value. This issue can lead to
> systems having a load avg of exactly 0, even though the real load avg
> could theoretically be up to NR_CPUS.
> 
> This change defers calc_load_tasks accounting after each cpu updates the
> count until after the 10 tick period.

>From reading the above changelog it seems to me there should be a
callback from leaving nohz mode, your proposed patch has no such thing.

