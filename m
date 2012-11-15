Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab2KOXa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:30:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41983 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2KOXa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:30:56 -0500
Message-ID: <50A57B2E.4000608@gmail.com>
Date: Thu, 15 Nov 2012 15:30:54 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Al Cooper <alcooperx@gmail.com>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, cernekee@gmail.com
Subject: Re: [PATCH] MIPS: Fix crash that occurs when function tracing is
 enabled
References: <y> <1353021374-3311-1-git-send-email-alcooperx@gmail.com>
In-Reply-To: <1353021374-3311-1-git-send-email-alcooperx@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 03:16 PM, Al Cooper wrote:
> A recent patch changed some irq routines from inlines to functions.
> These routines are called by the tracer code. Now that they're functions,
> if they are compiled for function tracing they will call the tracer
> and crash the system due to infinite recursion. The fix disables
> tracing in these functions by using "notrace" in the function
> definition.
>
> Signed-off-by: Al Cooper <alcooperx@gmail.com>

Makes sense,

Reviewed-by: David Daney <david.daney@cavium.com>


> ---
>   arch/mips/lib/mips-atomic.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/mips/lib/mips-atomic.c b/arch/mips/lib/mips-atomic.c
> index e091430..cd160be 100644
> --- a/arch/mips/lib/mips-atomic.c
> +++ b/arch/mips/lib/mips-atomic.c
> @@ -56,7 +56,7 @@ __asm__(
>   	"	.set	pop						\n"
>   	"	.endm							\n");
>
> -void arch_local_irq_disable(void)
> +notrace void arch_local_irq_disable(void)
>   {
.
.
.


