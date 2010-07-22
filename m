Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab0GVPOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:14:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36344 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0GVPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:14:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C48602B.70805@jp.fujitsu.com>
Date: Fri, 23 Jul 2010 00:13:47 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, hpa@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com
Subject: Re: [PATCH] x86: ioremap: fix wrong physical address handling in
 PAT code
References: <4C47DDCF.80300@jp.fujitsu.com>
In-Reply-To: <4C47DDCF.80300@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good catch!

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>


(2010/07/22 14:57), Yasuaki Ishimatsu wrote:
> From: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
>
> The following two commits fixed a problem that x86 ioremap() doesn't handle
> physical address higher than 32-bit properly in X86_32 PAE mode.
>
> ffa71f33a820d1ab3f2fc5723819ac60fb76080b (x86, ioremap: Fix incorrect physical address handling in
> PAE mode)
> 35be1b716a475717611b2dc04185e9d80b9cb693 (x86, ioremap: Fix normal ram range check)
>
> But these fixes are not enough, since pat_pagerange_is_ram() in PAT code
> also has a same problem. This patch fixes it.
>
> Signed-off-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
>
> ---
>
> It is for -tip tree.
>
> Index: linux-2.6-x86/arch/x86/mm/pat.c
> ===================================================================
> --- linux-2.6-x86.orig/arch/x86/mm/pat.c	2010-07-22 03:04:38.000000000 +0900
> +++ linux-2.6-x86/arch/x86/mm/pat.c	2010-07-22 03:47:36.000000000 +0900
> @@ -158,7 +158,7 @@ static unsigned long pat_x_mtrr_type(u64
>   	return req_type;
>   }
>
> -static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
> +static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
>   {
>   	int ram_page = 0, not_rampage = 0;
>   	unsigned long page_nr;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


