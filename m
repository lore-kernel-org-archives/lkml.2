Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0KLEW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 23:22:58 -0500
Received: from mail.perches.com ([173.55.12.10]:4976 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0KLEW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 23:22:57 -0500
Subject: Re: [PATCH v4] msm: smd: Reduce driver log chatter
From: Joe Perches <joe@perches.com>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1289516079-24632-1-git-send-email-davidb@codeaurora.org>
References: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
	 <1289516079-24632-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 20:22:54 -0800
Message-ID: <1289535774.6519.54.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 14:54 -0800, David Brown wrote:
> The MSM smd driver logs numerous messages during startup that are
> useful for debug purposes.  Change some of these to pr_debug() to
> match their purpose, and remove others that aren't really useful.

Hi David.

>  arch/arm/mach-msm/smd.c |   17 +++++++----------
> @@ -725,7 +727,7 @@ int smd_close(smd_channel_t *ch)
>  {
>  	unsigned long flags;
>  
> -	pr_info("smd_close(%p)\n", ch);
> +	pr_debug("smd_close(%p)\n", ch);

Why keep a printk for close without a printk for open?
I suggest removing this one too.

