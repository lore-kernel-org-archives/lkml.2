Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662Ab2FEJjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:39:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:45244 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761546Ab2FEJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:39:44 -0400
Date: Tue, 5 Jun 2012 11:39:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix the MCE poll timer logic
In-Reply-To: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206051139180.3086@ionos>
References: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Chen Gong wrote:

> In commit 82f7af09 (x86/mce: Cleanup timer mess), Thomas just forgot
> the "/ 2" there while cleaning up.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 0a687fd..a97f3c4 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1274,7 +1274,7 @@ static void mce_timer_fn(unsigned long data)
>  	 */
>  	iv = __this_cpu_read(mce_next_interval);
>  	if (mce_notify_irq())
> -		iv = max(iv, (unsigned long) HZ/100);
> +		iv = max(iv / 2, (unsigned long) HZ/100);
>  	else
>  		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
>  	__this_cpu_write(mce_next_interval, iv);
> -- 
> 1.7.10
> 
> 
