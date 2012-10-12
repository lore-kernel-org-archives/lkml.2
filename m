Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2JLKuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:50:51 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37067 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2JLKut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:50:49 -0400
Message-ID: <5077F600.9090605@linux.vnet.ibm.com>
Date: Fri, 12 Oct 2012 16:20:40 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH 3/3] Convert mce_disabled
References: <1349878801-15956-1-git-send-email-bp@amd64.org> <1349878801-15956-4-git-send-email-bp@amd64.org>
In-Reply-To: <1349878801-15956-4-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101210-9574-0000-0000-000004D5CDFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 07:50 PM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
>
> Not-Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>   arch/x86/include/asm/mce.h       |  9 +++++----
>   arch/x86/kernel/cpu/mcheck/mce.c | 12 +++++-------
>   arch/x86/lguest/boot.c           |  2 +-
>   3 files changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 18a66ac35fc5..e8ed5a3a0512 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -126,7 +126,6 @@ extern void mce_unregister_decode_chain(struct notifier_block *nb);
>   #include <linux/init.h>
>   #include <linux/atomic.h>
>
> -extern int mce_disabled;
>   extern int mce_p5_enabled;
>
>   #ifdef CONFIG_X86_MCE
> @@ -208,9 +207,11 @@ extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
>   				    size_t usize, loff_t *off));
>
>   struct mca_config {
> -	u64 dont_log_ce	: 1,
> -#define MCA_CFG_DONT_LOG_CE	0
> -	    __resv1	: 63;
> +	u64	dont_log_ce	: 1,
> +#define MCA_CFG_DONT_LOG_CE	  0
> +		mca_disabled	: 1,
> +#define MCA_CFG_MCA_DISABLED	  1
> +	    __resv1	: 62;
>   };

Hi Boris,
Thanks for getting to this before I could!

I had a look but I still feel boolean is a better way to go. With bool, 
we can get rid of the #defines above and more importantly, the aux field 
in dev_ext_attribute since that is used in other places too. Further, I 
suspect we'll still end up using the same or less memory since we don't 
have that many boolean members within the MCA code.

Regards,
Naveen

