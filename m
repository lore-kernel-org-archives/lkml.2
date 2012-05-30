Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2E3XLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 19:11:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44401 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2E3XLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 19:11:32 -0400
Message-ID: <4FC6A897.6020005@zytor.com>
Date: Wed, 30 May 2012 16:09:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com> <20120530173247.GC15635@x1.osrc.amd.com> <4FC65D34.1060803@zytor.com> <20120530175150.GE15438@x1.osrc.amd.com> <4FC66037.6020506@zytor.com> <20120530181722.GF15438@x1.osrc.amd.com> <4FC664E1.9050504@zytor.com> <20120530223334.GB28417@andromeda.dapyr.net>
In-Reply-To: <20120530223334.GB28417@andromeda.dapyr.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:33 PM, Konrad Rzeszutek Wilk wrote:
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 75f33b2..e74df95 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1116,7 +1116,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
>  	.wbinvd = native_wbinvd,
>  
>  	.read_msr = native_read_msr_safe,
> +	.rdmsr_regs = native_rdmsr_safe_regs,
>  	.write_msr = xen_write_msr_safe,
> +	.wrmsr_regs = native_wrmsr_safe_regs,
> +
>  	.read_tsc = native_read_tsc,
>  	.read_pmc = native_read_pmc,
>  

Okay, tell me again:

why do we have these hooks again?  Can we please weed out paravirt
methods that have no users?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

