Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030640Ab2GMF6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:58:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56896 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2GMF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:58:49 -0400
Date: Fri, 13 Jul 2012 07:58:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] ntp: Fix STA_INS/DEL clearing bug
Message-ID: <20120713055843.GB18065@gmail.com>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
 <1342156917-25092-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342156917-25092-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> From: John Stultz <johnstul@us.ibm.com>
> 
> In commit 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d, I
> introduced a bug that kept the STA_INS or STA_DEL bit
> from being cleared from time_status via adjtimex()
> without forcing STA_PLL first.
> 
> Usually once the STA_INS is set, it isn't cleared
> until the leap second is applied, so its unlikely this
> affected anyone. However during testing I noticed it
> took some effort to cancel a leap second once STA_INS
> was set.
> 
> This issue affects 3.4 and up.
> 
> Since this isn't urgent (issue is only observed in testing,
> the behavior doesn't affect ntpd, nor is a leapsecond due
> for at least ~6 months), and we're late in the 3.5-rc
> cycle, I'm holding this off for 3.6 merge window,
> where I'll then backport to 3.5-stable and 3.4-stable.

> CC: stable@vger.kernel.org

We generally don't do such a workflow. Either it's valid for 
tip:timers/urgent and it can have a -stable tag, or it should 
not be backported, and not have a -stable tag.

The rule is: if it's important enough for -stable then it's 
doubly important for the current -rc kernel!

Thanks,

	Ingo
