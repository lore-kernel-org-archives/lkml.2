Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab0FPUT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:19:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36011 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab0FPUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:19:56 -0400
Message-ID: <4C1931CF.6040200@zytor.com>
Date: Wed, 16 Jun 2010 13:19:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       Mitch Bradley <wmb@laptop.org>
Subject: Re: [PATCH] x86: OLPC: add support for calling into OpenFirmware
 (v3)
References: <20100616151335.039db487@dev.queued.net>
In-Reply-To: <20100616151335.039db487@dev.queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 12:13 PM, Andres Salomon wrote:
> @@ -658,6 +664,10 @@ ENTRY(stack_start)
>  	.long init_thread_union+THREAD_SIZE
>  	.long __BOOT_DS
>  
> +.globl olpc_ofw_pgd
> +olpc_ofw_pgd:
> +	.long olpc_ofw_pgd
> +
>  ready:	.byte 0
>  

This variable doesn't need to be initialized, and so belongs .bss.  You
don't need to declare it in an assembly file at all; it probably makes
more sense to just declare it a normal variable (possibly __init) inside
olpc_ofw.c.

Otherwise it's starting to look good.

	-hpa
