Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0KJA4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:56:35 -0500
Received: from mail.perches.com ([173.55.12.10]:4872 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab0KJA4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:56:31 -0500
Subject: Re: [PATCH v2] msm: smd: Reduce driver log chatter
From: Joe Perches <joe@perches.com>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1289350168-20034-1-git-send-email-davidb@codeaurora.org>
References: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
	 <1289350168-20034-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 16:56:29 -0800
Message-ID: <1289350589.28590.74.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 16:49 -0800, David Brown wrote:
> The MSM smd driver logs numerous messages during startup that are
> useful for debug purposes.  Change these to pr_debug() to match their
> purpose.
> diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
[]
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

If you add this, you probably want to strip
a few prefixes from the formats.

> +
>  #include <linux/platform_device.h>
>  #include <linux/module.h>
>  #include <linux/fs.h>
> @@ -89,7 +91,7 @@ static void smd_diag(void)
[]
> -		pr_info("smem: DIAG '%s'\n", x);
> +		pr_debug("smem: DIAG '%s'\n", x);

probably just
		pr_debug("DIAG '%s'\n", x);

>  	}
>  }
>  
> @@ -312,7 +314,7 @@ static void smd_state_change(struct smd_channel *ch,
[]
> -	pr_info("SMD: ch %d %d -> %d\n", ch->n, last, next);
> +	pr_debug("SMD: ch %d %d -> %d\n", ch->n, last, next);

	pr_debug("ch %d %d -> %d\n", ch->n, last, next);


