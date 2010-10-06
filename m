Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab0JFKza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:55:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63112 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab0JFKz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:55:29 -0400
Message-ID: <4CAC5537.9040904@mvista.com>
Date: Wed, 06 Oct 2010 14:53:43 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Adam Jiang <jiang.adam@gmail.com>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mips: irq: add stackoverflow detection
References: <1286361676-10743-1-git-send-email-jiang.adam@gmail.com>
In-Reply-To: <1286361676-10743-1-git-send-email-jiang.adam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-10-2010 14:41, Adam Jiang wrote:

> Add stackoverflow detection to mips arch

    There's no such word: stackoverflow. Space is needed.

> This is the 3rd version of the smiple patch. 2K is too big for many
> system, so I Modified the warning line by following Ralf's suggestion.

> Signed-off-by: Adam Jiang<jiang.adam@gmail.com>
[...]

> diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> index c6345f5..b43edb7 100644
> --- a/arch/mips/kernel/irq.c
> +++ b/arch/mips/kernel/irq.c
> @@ -151,6 +151,28 @@ void __init init_IRQ(void)
>   #endif
>   }
>
> +#ifdef CONFIG_DEBUG_STACKOVERFLOW
> +static inline void check_stack_overflow(void)
> +{
> +	unsigned long sp;
> +
> +	asm volatile("move %0, $sp" : "=r" (sp));
> +	sp = sp & THREAD_MASK;

    Why not:

	sp &= THREAD_MASK;

    It's C, after all! :-)

WBR, Sergei
