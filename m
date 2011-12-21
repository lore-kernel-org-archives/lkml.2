Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1LUAvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:51:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1LUAvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:51:00 -0500
Date: Tue, 20 Dec 2011 16:50:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Uvarov <maxim.uvarov@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        wim@iguana.be
Subject: Re: [PATCH] hpwd watchdog mark page executable
Message-Id: <20111220165059.4e79a416.akpm@linux-foundation.org>
In-Reply-To: <1323131139-32451-2-git-send-email-maxim.uvarov@oracle.com>
References: <1323131139-32451-1-git-send-email-maxim.uvarov@oracle.com>
	<1323131139-32451-2-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Dec 2011 16:25:39 -0800
Maxim Uvarov <maxim.uvarov@oracle.com> wrote:

> Mark hpwdt watchdog pages executable to prevent failing:
> BUG: unable to handle kernel paging request at c00f0000
>  IP: [<c00f0000>] 0xc00effff
>  *pdpt = 0000000000b7c001 *pde = 0000000000cf5067 *pte = 80000000000f0163
>  Oops: 0011 [#1] SMP
>
> ...
>
> --- a/drivers/watchdog/hpwdt.c
> +++ b/drivers/watchdog/hpwdt.c
> @@ -335,6 +335,8 @@ static int __devinit detect_cru_service(void)
>  	if (p == NULL)
>  		return -ENOMEM;
>  
> +	set_memory_x((unsigned long)p & PAGE_MASK, ROM_SIZE >> PAGE_SHIFT);
> +
>  	for (q = p; q < p + ROM_SIZE; q += 16) {
>  		rc = bios32_present(q);
>  		if (!rc)

Odd.  Either nobody else is using this driver, or there's something
special about your setup.  Are you able to explain this?  

Also, do you believe that this fix should be backported into earlier
stable kernels and if so, why?

Thanks.
