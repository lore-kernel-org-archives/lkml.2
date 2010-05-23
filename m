Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0EWMi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 08:38:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44361 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0EWMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 08:38:24 -0400
Date: Sun, 23 May 2010 13:38:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: tom.leiming@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
Message-ID: <20100523123801.GC950@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 07:48:48PM +0800, tom.leiming@gmail.com wrote:
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 2c1db77..ed471a7 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -58,7 +58,7 @@ work_resched:
>   */
>  ENTRY(ret_to_user)
>  ret_slow_syscall:
> -	disable_irq				@ disable interrupts
> +	disable_irq_notrace				@ disable interrupts

I think this one does need to be traced - the pending work functions are
all C code which could call back into lockdep.

Also, I'm nervious about applying this patch without seeing more people
test it.
