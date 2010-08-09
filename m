Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0HIUP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:15:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:39052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab0HIUP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:15:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,345,1278313200"; 
   d="scan'208";a="594423103"
Message-ID: <4C6061DE.4030300@linux.intel.com>
Date: Mon, 09 Aug 2010 13:15:26 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: bifferos <bifferos@yahoo.co.uk>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what
 c_ident is
References: <66994.33108.qm@web27001.mail.ukl.yahoo.com>
In-Reply-To: <66994.33108.qm@web27001.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 02:33 AM, bifferos wrote:
> 
> The quick fix for this is:
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 490dac6..06a2dac 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -497,6 +497,9 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
>                if (!cpu_devs[i])
>                        break;
> 
> +               if (!cpu_devs[i]->c_ident[0])
> +                       continue;
> +
>                if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
>                    (cpu_devs[i]->c_ident[1] &&
>                     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
> 
> 
> however, Peter's requirement to remove c_ident renders my patch 
> somewhat less useful back on RDC.  /proc/cpuinfo then lists the 
> vendor as 'RDC' (an improvement over not applying the patch) and 
> the model name as '486' (also an improvement), but for some 
> reason the variants in my case statement then no longer make it 
> through to /proc/info.  I don't think this is a big deal, and I
> still think the patch is worth applying with this change.
> 

Well, as I said, the generic code probably needs to change somewhat to
print that stuff.

	-hpa
