Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1CUNfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:35:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63330 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1CUNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:35:23 -0400
Message-ID: <4D8753B5.2050401@ru.mvista.com>
Date: Mon, 21 Mar 2011 16:33:41 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Carl Vanderlip <carlv@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-fbdev@vger.kernel.org,
        Brian Swetland <swetland@google.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Dima Zavin <dima@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 15/20] video: msm: convert printk to pr_*
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org> <1300485552-27519-1-git-send-email-carlv@codeaurora.org>
In-Reply-To: <1300485552-27519-1-git-send-email-carlv@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Carl Vanderlip wrote:

> Reword debugging messages to use pr_err and pr_warning

> Authors:
> Dima Zavin <dima@android.com>
> Rebecca Schultz Zavin <rebecca@android.com>
> Colin Cross <ccross@android.com>

> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
> ---
>  drivers/video/msm/mdp.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)

> diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
> index 8184ca9..b03204d 100644
> --- a/drivers/video/msm/mdp.c
> +++ b/drivers/video/msm/mdp.c
> @@ -42,16 +42,13 @@ DEFINE_MUTEX(mdp_mutex);
>  
>  static int locked_enable_mdp_irq(struct mdp_info *mdp, uint32_t mask)
>  {
> -	int ret = 0;
> -
>  	BUG_ON(!mask);
>  
>  	/* if the mask bits are already set return an error, this interrupt
>  	 * is already enabled */
>  	if (mdp_irq_mask & mask) {
> -		printk(KERN_ERR "mdp irq already on already on %x %x\n",
> -		       mdp_irq_mask, mask);
> -		ret = -1;
> +		pr_err("mdp irq already on %x %x\n", mdp_irq_mask, mask);
> +		return -1;

    This change to *return* is not described.

WBR, Sergei

