Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab2EaUV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:21:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57949 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159Ab2EaUV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:21:57 -0400
Message-ID: <4FC7D2AE.9080603@zytor.com>
Date: Thu, 31 May 2012 13:21:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: konrad@darnok.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        mingo@redhat.com, tglx@linutronix.de, stable@kernel.org
Subject: Re: [PATCH] x86/i386: Check PSE bit before using PAGE_KERNEL_LARGE.
References: <1338493218-25006-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1338493218-25006-1-git-send-email-konrad.wilk@oracle.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:40 PM, Konrad Rzeszutek Wilk wrote:
> During bootup we would unconditionally do this on any
> machine that was built with CONFIG_NUMA=y on i386:
> 
> setup_arch
>   \-initmem_init
>       \-x86_numa_init (with dummy_init as callback)
>           \- init_alloc_remap
>                \- set_pmd_pfn (with PAGE_PSE)
> 
> without checking to see if the CPU supports PSE. This
> patch adds that and also allows the init_alloc_remap function
> to properly work by falling back on PTEs.
> 

Well, the code looks like it is PAE-specific, and PAE implies PSE.

Xen breaks that, but that is a divergence of Xen from x86.

	-hpa



