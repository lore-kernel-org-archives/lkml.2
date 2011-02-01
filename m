Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1BAICn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:02:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1BAICl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:02:41 -0500
Date: Tue, 1 Feb 2011 09:02:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
Message-ID: <20110201080223.GB20372@elte.hu>
References: <4D473FD5.1090903@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D473FD5.1090903@free.fr>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* matthieu castet <castet.matthieu@free.fr> wrote:

>  static inline int is_kernel_text(unsigned long addr)
>  {
> +#if defined(CONFIG_X86_32) && defined(CONFIG_ACPI_SLEEP)
> +	/*
> +	 * We need to make the wakeup trampoline in first 1MB !NX
> +	 */
> +	if (addr >= PAGE_OFFSET && addr <= (PAGE_OFFSET + (1<<20)))
> +		return 1;
> +#endif

That's pretty ugly. Why not use set_memory_x()/set_memory_nx(), and only for the 
trampoline itself? Does the whole 1MB need to be marked X?

Same goes for the Xen fix.

Thanks,

	Ingo
