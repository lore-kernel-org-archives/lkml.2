Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab1DAQX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:23:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53068 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1DAQX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:23:57 -0400
Message-ID: <4D95FBDD.9050901@zytor.com>
Date: Fri, 01 Apr 2011 09:22:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-1.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop> <4D95F80D.7070201@kernel.org>
In-Reply-To: <4D95F80D.7070201@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 09:06 AM, Yinghai Lu wrote:
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -294,10 +294,17 @@ static void __init init_gbpages(void)
>      else
>          direct_gbpages = 0;
>  }
> +static void __init store_mmu_cr4(void)
> +{
> +    mmu_cr4_features = read_cr4();
> +}
>  #else
>  static inline void init_gbpages(void)
>  {
>  }
> +static void __init store_mmu_cr4(void)
> +{
> +}
>  static void __init cleanup_highmap(void)
>  {
>  }
> @@ -929,6 +936,8 @@ void __init setup_arch(char **cmdline_p)
>      /* max_pfn_mapped is updated here */
>      max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
>      max_pfn_mapped = max_low_pfn_mapped;
> +    /* after init_memory_mapping updating cr4*/
> +    store_mmu_cr4();
>  
>  #ifdef CONFIG_X86_64
>      if (max_pfn > max_low_pfn) {

This looks really, really, really wrong.

Why the heck should we save and restore CR4 only for x86-64?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

