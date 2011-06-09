Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab1FINsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:48:12 -0400
Received: from fifo99.com ([67.223.236.141]:38672 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682Ab1FINsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:48:10 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jun 2011 09:48:09 EDT
Subject: Re: [PATCH] msm: timer: compensate for timer shift in
 msm_read_timer_count
From: Daniel Walker <dwalker@fifo99.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, stable@kernel.org
In-Reply-To: <1307591042-2369-1-git-send-email-johlstei@codeaurora.org>
References: <1307591042-2369-1-git-send-email-johlstei@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 06:41:50 -0700
Message-ID: <1307626910.16418.1.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 20:44 -0700, Jeff Ohlstein wrote:
> Some msm targets have timers whose lower bits are unreliable. So, we
> present our timers as lower frequency than they actually are, and ignore
> the bottom 5 bits on such targets. This compensation was erroneously
> removed from the msm_read_timer_count function, so restore it.
> 
> This was broken by 94790ec25 "msm: timer: SMP timer support for msm".
> 
> Change-Id: I8c56bdf82629638748ccf352118ea664f967b87d

Drop this Change-ID ..

> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> ---
>  arch/arm/mach-msm/timer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
> index 38b95e9..b3579fe 100644
> --- a/arch/arm/mach-msm/timer.c
> +++ b/arch/arm/mach-msm/timer.c
> @@ -100,7 +100,7 @@ static cycle_t msm_read_timer_count(struct clocksource *cs)
>  {
>  	struct msm_clock *clk = container_of(cs, struct msm_clock, clocksource);
>  
> -	return readl(clk->global_counter);
> +	return readl(clk->global_counter) >> clk->shift;
>  }

Could you comment in the code with something explaining what the shift
is doing.

Daniel

