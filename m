Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1BYHAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:00:11 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:57877 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1BYHAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:00:09 -0500
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Feb 2011 02:00:08 EST
Message-ID: <19815.20063.647326.437650@ipc1.ka-ro>
Date: Fri, 25 Feb 2011 07:38:23 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [TRIVIAL/PATCH] ARM: hw_breakpoint: Fix newlines in WARN messages
In-Reply-To: <1298573739-25144-1-git-send-email-sboyd@codeaurora.org>
References: <1298573739-25144-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stephen Boyd writes:
> These warnings are missing newlines and spaces causing confusing
> looking output when they trigger.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/kernel/hw_breakpoint.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> index d600bd3..5aab00e 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -238,8 +238,8 @@ static int enable_monitor_mode(void)
>  	ARM_DBG_READ(c1, 0, dscr);
>  
>  	/* Ensure that halting mode is disabled. */
> -	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN, "halting debug mode enabled."
> -				"Unable to access hardware resources.")) {
> +	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN, "halting debug mode enabled. "
> +				"Unable to access hardware resources.\n")) {
>
I'd prefer the message text not to be line wrapped, even if it
violates the general line length rule, because that makes it easier to
grep for the message in the source code.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
