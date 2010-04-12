Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0DLLQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 07:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab0DLLQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 07:16:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
To: David VomLehn <dvomlehn@cisco.com>
Cc: dhowells@redhat.com, to@dvomlehn-lnx2.corp.sa.net,
       "linux-arch@vger.kernel.org"@cisco.com, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Date: Mon, 12 Apr 2010 12:16:18 +0100
Message-ID: <24048.1271070978@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn <dvomlehn@cisco.com> wrote:

> +NORET_TYPE void panic(const char *fmt, ...)
> +{
> +	va_list args;
> +	const struct pt_regs *regs;
> +	int i;
> +
> +	preempt_disable();
> +	bust_spinlocks(1);
> +	regs = save_ptregs(&__get_cpu_var(panic_panic_regs));
> +	va_start(args, fmt);
> +	vpanic_with_regs(regs, fmt, args);
> +	/* Since vpanic_with_regs doesn't return, we skip va_end() */
> +	/* Infinite loop so compiler doesn't complain about this returning */
> +	for (i = 0; ; )
> +		mdelay(1);
> +}

Can the use of va_start() clobber lots of registers, thereby rendering the
exercise pointless on some arches?

Also, can the save_ptregs() function be out of line asm?  The FRV constructed
inline statement is huge (and wrong).

David
