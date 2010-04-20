Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0DTMxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0DTMxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:53:04 -0400
Message-ID: <4BCDA46E.9030405@redhat.com>
Date: Tue, 20 Apr 2010 20:56:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Fix OOPS in crash_kernel_shrink
References: <87iq7n8toc.wl%vmayatsk@redhat.com>
In-Reply-To: <87iq7n8toc.wl%vmayatsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh wrote:
> Two "echo 0 > /sys/kernel/kexec_crash_size" OOPSes kernel. Also
> content of this file is invalid after first shrink to zero: it shows 1
> instead of 0.
> 
> This patch fixes it.

Hmmm, I certainly did tests for 'echo 0 > kexec_crash_size' when I
worked on this, but I didn't get any oops. Can you show me the full
oops?

But yes, the size calculation looks wrong.

> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 87ebe8a..474a847 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1134,11 +1134,9 @@ int crash_shrink_memory(unsigned long new_size)
>  
>  	free_reserved_phys_range(end, crashk_res.end);
>  
> -	if (start == end) {
> -		crashk_res.end = end;
> +	if (start == end)
>  		release_resource(&crashk_res);
> -	} else
> -		crashk_res.end = end - 1;
> +	crashk_res.end = end - 1;
>  

If we do this, crashk_res.end will be ahead of crashk.start.

Thanks.
