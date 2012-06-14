Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2FNUWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:22:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36457 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2FNUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:22:50 -0400
Message-ID: <4FDA4816.7000405@landley.net>
Date: Thu, 14 Jun 2012 15:22:46 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] doc: update mem= option's spec
References: <4FD99C88.2010002@cn.fujitsu.com>
In-Reply-To: <4FD99C88.2010002@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 03:10 AM, Wen Congyang wrote:
> Current mem= implementation seems buggy because specification and
> implementation doesn't match. Current mem= has been working
> for many years and it's not buggy, it works as expected. So
> we should update the specification.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  Documentation/kernel-parameters.txt |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index a92c5eb..924b1a4 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1471,9 +1471,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
>  			Amount of memory to be used when the kernel is not able
>  			to see the whole system memory or for test.
> -			[X86-32] Use together with memmap= to avoid physical
> -			address space collisions. Without memmap= PCI devices
> -			could be placed at addresses belonging to unused RAM.
> +			[X86-32] Work as limiting max address. Use together
> +			with memmap= to avoid physical address space collisions.
> +			Without memmap= PCI devices could be placed at addresses
> +			belonging to unused RAM.
>  
>  	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
>  			memory.

I have no objection to this but can't confirm it's true or not without
an awful lot more digging through the code I don't have time for right
now. (All the x86-32 machines I've used just had the 640k->1m hole and
the rest was contiguous memory, so the behavior would be the same either
way...)

Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
