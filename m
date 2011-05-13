Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1EMH2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:28:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab1EMH2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:28:30 -0400
Date: Fri, 13 May 2011 09:28:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sysfs: remove "last sysfs file:" line from the oops
 messages
Message-ID: <20110513072815.GA10584@elte.hu>
References: <20110512230102.GA19069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512230102.GA19069@kroah.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> ---------------
> I'm going to queue this up for the .40 kernel merge window, any
> objections?
> ---------------

> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -279,7 +279,6 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  	printk("DEBUG_PAGEALLOC");
>  #endif
>  	printk("\n");
> -	sysfs_printk_last_file();
>  	if (notify_die(DIE_OOPS, str, regs, err,
>  			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
>  		return 1;

Good idea - that line has become quite a bit less useful over the past few 
years and oops output is valuable screen real estate.

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
