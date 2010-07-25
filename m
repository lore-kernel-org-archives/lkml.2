Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab0GYFFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 01:05:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60789 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab0GYFFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 01:05:18 -0400
Message-ID: <4C4BC5ED.3030104@zytor.com>
Date: Sat, 24 Jul 2010 22:04:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mrst: remove unused mrst_identify_cpu()
References: <1280033438.2419.5.camel@lenovo>
In-Reply-To: <1280033438.2419.5.camel@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob, is this obsolete or something that will be needed in future versions?

It seems that either __mrst_cpu_chip should be killed off, or read-only
users should be using the inline instead of __mrst_cpu_chip directly.

	-hpa

On 07/24/2010 09:50 PM, Javier Martinez Canillas wrote:
> mrst_identify_cpu() function is not been used anymore (at today linux-next). This patch removes it.
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  arch/x86/include/asm/mrst.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
> index 1635074..0d0e702 100644
> --- a/arch/x86/include/asm/mrst.h
> +++ b/arch/x86/include/asm/mrst.h
> @@ -26,10 +26,6 @@ enum mrst_cpu_type {
>  };
>  
>  extern enum mrst_cpu_type __mrst_cpu_chip;
> -static enum mrst_cpu_type mrst_identify_cpu(void)
> -{
> -	return __mrst_cpu_chip;
> -}
>  
>  enum mrst_timer_options {
>  	MRST_TIMER_DEFAULT,


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

