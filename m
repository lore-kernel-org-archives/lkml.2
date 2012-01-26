Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2AZKrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:47:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38649 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab2AZKrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:47:01 -0500
Date: Thu, 26 Jan 2012 11:46:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] MCE recovery changes
Message-ID: <20120126104646.GF3853@elte.hu>
References: <4f1f396019579c94fb@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f1f396019579c94fb@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> Ingo,
> 
> Time to move these from "ras" tree to "tip" so they will be nicely
> seasoned for the 3.4 merge window.
> 
> I tried to follow the instructions in
>  http://git-blame.blogspot.com/2012/01/using-signed-tag-in-pull-requests.html
> to use the fancy new signed tag scheme. If something is wrong here, then it
> is most likely that I typoed (or thinkoed) while following them.

It worked perfectly.

> 
> -Tony
> 
> The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:
> 
>   Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-recovery-for-tip
> 
> for you to fetch changes up to 5f7b88d51e89771f64c15903b96b5933dd0bc6d8:
> 
>   x86/mce: Recognise machine check bank signature for data path error (2012-01-03 12:07:07 -0800)
> 
> ----------------------------------------------------------------
> MCE recovery (data path only)
> 
> ----------------------------------------------------------------
> Tony Luck (6):
>       HWPOISON: Clean up memory_failure() vs. __memory_failure()
>       HWPOISON: Add code to handle "action required" errors.
>       x86/mce: Create helper function to save addr/misc when needed
>       x86/mce: Add mechanism to safely save information in MCE handler
>       x86/mce: Handle "action required" errors
>       x86/mce: Recognise machine check bank signature for data path error
> 
>  arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 +++-
>  arch/x86/kernel/cpu/mcheck/mce.c          |  179 ++++++++++++++++++++---------
>  drivers/base/memory.c                     |    2 +-
>  include/linux/mm.h                        |    4 +-
>  mm/hwpoison-inject.c                      |    4 +-
>  mm/madvise.c                              |    2 +-
>  mm/memory-failure.c                       |   96 ++++++++--------
>  7 files changed, 197 insertions(+), 106 deletions(-)

Pulled, thanks!

One thing i noticed was the magic constant 0x134:

+               SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),

don't we want that defined a bit more clearly?

Thanks,

	Ingo
