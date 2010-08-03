Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0HCJGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:06:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106Ab0HCJGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:06:21 -0400
Date: Tue, 3 Aug 2010 02:06:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3] x86: Setup early console as early as possible
Message-Id: <20100803020638.4e2177c3.akpm@linux-foundation.org>
In-Reply-To: <4C57C1DE.9050400@kernel.org>
References: <4C56701B.1030000@kernel.org>
	<20100802150958.GA5544@lenovo>
	<4C571B25.3080806@kernel.org>
	<20100802201750.GG5544@lenovo>
	<4C57C1DE.9050400@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 00:14:38 -0700 Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
> and call setup_early_serial8250_console() to init early serial console.
> 
> only can handle io port kind of 8250. because mmio need ioremap.
> 
> -v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
>      update after using x86 memblock patchset
> -v3: x86 memblock can not make into with 2.6.36 now
>      so update this patch to be applied before x86 memblock patchset again.
> 
> ...
>
> --- linux-2.6.orig/kernel/printk.c
> +++ linux-2.6/kernel/printk.c
> @@ -1203,6 +1203,10 @@ void register_console(struct console *ne
>  	if (console_drivers && newcon->flags & CON_BOOT) {
>  		/* find the last or real console */
>  		for_each_console(bcon) {
> +			/* not again */
> +			if (bcon == newcon)
> +				return;
> +
>  			if (!(bcon->flags & CON_BOOT)) {
>  				printk(KERN_INFO "Too late to register bootconsole %s%d\n",

Why this change?
