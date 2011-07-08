Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1GHA33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 20:29:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1GHA31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 20:29:27 -0400
Message-ID: <4E164F51.3080301@zytor.com>
Date: Thu, 07 Jul 2011 17:29:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Anupam Chanda <achanda@nicira.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        stefano.stabellini@eu.citrix.com, jeremy.fitzhardinge@citrix.com,
        eddie.dong@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change hypervisor detection order
References: <1310062788-9445-1-git-send-email-achanda@nicira.com>
In-Reply-To: <1310062788-9445-1-git-send-email-achanda@nicira.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 11:19 AM, Anupam Chanda wrote:
> Detect Xen before HyperV because in Viridian compatibility mode Xen presents
> itself as HyperV.
> 
> Signed-off-by: Anupam Chanda <achanda@nicira.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/kernel/cpu/hypervisor.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index 8095f86..ca23091 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -33,10 +33,10 @@
>  static const __initconst struct hypervisor_x86 * const hypervisors[] =
>  {
>  	&x86_hyper_vmware,
> -	&x86_hyper_ms_hyperv,
>  #ifdef CONFIG_XEN_PVHVM
>  	&x86_hyper_xen_hvm,
>  #endif
> +	&x86_hyper_ms_hyperv,
>  };
>  
>  const struct hypervisor_x86 *x86_hyper;

Any reason to not hoist it to the top?  I'm guessing Xen emulating
VMware is more likely than the opposite...
	
	-hpa
