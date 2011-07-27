Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1G0VUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:20:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069Ab1G0VUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:20:13 -0400
Date: Wed, 27 Jul 2011 14:19:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "George G. Davis" <gdavis@mvista.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc-omap: Fix initialization of control register
Message-Id: <20110727141907.53225270.akpm@linux-foundation.org>
In-Reply-To: <1310381866-25584-1-git-send-email-dg@emlix.com>
References: <1310381866-25584-1-git-send-email-dg@emlix.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 12:57:46 +0200
Daniel Gl__ckner <dg@emlix.com> wrote:

> As the comment explains, the intention of the code is to clear the
> OMAP_RTC_CTRL_MODE_12_24 bit, but instead it only clears the
> OMAP_RTC_CTRL_SPLIT and OMAP_RTC_CTRL_AUTO_COMP bits, which should be
> kept. OMAP_RTC_CTRL_DISABLE, OMAP_RTC_CTRL_SET_32_COUNTER,
> OMAP_RTC_CTRL_TEST, and OMAP_RTC_CTRL_ROUND_30S are also better off
> being cleared.
> 
> Signed-off-by: Daniel Gl__ckner <dg@emlix.com>
> ---
>  drivers/rtc/rtc-omap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index bcae8dd..7789002 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -368,7 +368,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
>  		pr_info("%s: already running\n", pdev->name);
>  
>  	/* force to 24 hour mode */
> -	new_ctrl = reg & ~(OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
> +	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
>  	new_ctrl |= OMAP_RTC_CTRL_STOP;
>  
>  	/* BOARD-SPECIFIC CUSTOMIZATION CAN GO HERE:

Decisions need to be made about which kernel version(s) this should be
merged into.  To make and support those decisions we need to know the
user-visible effects of the bug.  But the changelog is silent on this
important thing.

What were the user-visible effects of the bug?

