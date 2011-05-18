Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab1ERNxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab1ERNxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:53:13 -0400
Date: Wed, 18 May 2011 09:53:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4] watchdog: fix rounding issues in get_sample_period()
Message-ID: <20110518135302.GM29881@redhat.com>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305588901-8141-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 04:34:58PM -0700, Mandeep Singh Baines wrote:
> In get_sample_period(), softlockup_thresh is integer divided by 5 before
> the multiplication by NSEC_PER_SEC. This results in softlockup_thresh
> being rounded down to the nearest integer multiple of 5.
> 
> For example, a softlockup_thresh of 4 rounds down to 0.

Mandeep,

Thanks for the patches.  Unfortunately, I am taking some time off so I'll
shephard these patches when I get back.  For the most part they look fine,
aside from Ingo's comments.

Cheers,
Don

> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/watchdog.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 14733d4..a06972d 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -110,7 +110,7 @@ static unsigned long get_sample_period(void)
>  	 * increment before the hardlockup detector generates
>  	 * a warning
>  	 */
> -	return softlockup_thresh / 5 * NSEC_PER_SEC;
> +	return softlockup_thresh * (NSEC_PER_SEC / 5);
>  }
>  
>  /* Commands for resetting the watchdog */
> -- 
> 1.7.3.1
> 
