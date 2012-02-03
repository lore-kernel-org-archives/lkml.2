Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2BCHg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:36:26 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:36515 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2BCHgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:36:24 -0500
Date: Fri, 3 Feb 2012 08:36:20 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [Patch] avr32: select GENERIC_ATOMIC64
Message-ID: <20120203073620.GA13215@samfundet.no>
References: <1328252580-2630-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328252580-2630-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 03 Feb 2012 15:03:00 +0800 or thereabout, Cong Wang wrote:
> avr32 doesn't implement atomic64_ operations, if not select this,
> we would get:
> 
> kernel/trace/trace_clock.c:117: error: syntax error before 'trace_counter'
> kernel/trace/trace_clock.c:126: error: implicit declaration of function 'atomic64_add_return'
> 
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks Cong, but Fabio beat you to it; https://lkml.org/lkml/2012/2/2/406

The above patch (similar to yours), was just pulled into Andrews tree.

> ---
> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> index 197e96f..6ecb8f4 100644
> --- a/arch/avr32/Kconfig
> +++ b/arch/avr32/Kconfig
> @@ -11,6 +11,7 @@ config AVR32
>  	select HARDIRQS_SW_RESEND
>  	select GENERIC_IRQ_SHOW
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	select GENERIC_ATOMIC64
>  	help
>  	  AVR32 is a high-performance 32-bit RISC microprocessor core,
>  	  designed for cost-sensitive embedded applications, with particular

-- 
mvh
Hans-Christian Egtvedt
