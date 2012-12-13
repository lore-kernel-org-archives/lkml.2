Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2LMBWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:22:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48004 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755076Ab2LMBWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:22:15 -0500
Message-ID: <1355361734.2164.9.camel@joe-AO722>
Subject: Re: [TRIVIAL PATCH 12/26] s390: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Dec 2012 17:22:14 -0800
In-Reply-To: <08ed143e48ebb9f16ae49daa9fb2d90f45c6e2cf.1355335228.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
	 <08ed143e48ebb9f16ae49daa9fb2d90f45c6e2cf.1355335228.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 10:19 -0800, Joe Perches wrote:
> Use the new vsprintf extension to avoid any possible
> message interleaving.
[]
> diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
[]
> @@ -91,8 +91,9 @@ __show_trace(unsigned long sp, unsigned long low, unsigned long high)
>  		if (sp < low || sp > high - sizeof(*sf))
>  			return sp;
>  		sf = (struct stack_frame *) sp;
> -		printk("([<%016lx>] ", sf->gprs[8] & PSW_ADDR_INSN);
> -		print_symbol("%s)\n", sf->gprs[8] & PSW_ADDR_INSN);
> +		printk("([<%016lx>] %pSR\n",

Sorry, this is defective, it needs a trailing ')' like:

+		printk("([<%016lx>] %pSR)\n",

> @@ -102,16 +103,18 @@ __show_trace(unsigned long sp, unsigned long low, unsigned long high)
>  			if (sp <= low || sp > high - sizeof(*sf))
>  				return sp;
>  			sf = (struct stack_frame *) sp;
> -			printk(" [<%016lx>] ", sf->gprs[8] & PSW_ADDR_INSN);
> -			print_symbol("%s\n", sf->gprs[8] & PSW_ADDR_INSN);
> +			printk(" [<%016lx>] %pSR\n",

here too

I'll resubmit.

