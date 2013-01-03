Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3ACNgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:36:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3ACNgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:36:07 -0500
X-Authority-Analysis: v=2.0 cv=IsacgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HQJ7cb7SADkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MBbGe7VapwAA:10 a=_yQ7T62BJPnK7OCB1SUA:9 a=PUjeQqilurYA:10 a=7WXxVVU_M1Exfc6f:21 a=7q4DL_NwLTitsvdc:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357220165.10284.30.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
From: Steven Rostedt <rostedt@goodmis.org>
To: Keun-O Park <kpark3469@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, fweisbec@gmail.com,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sahara <keun-o.park@windriver.com>
Date: Thu, 03 Jan 2013 08:36:05 -0500
In-Reply-To: <CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
	 <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
	 <20130103103815.GL2631@n2100.arm.linux.org.uk>
	 <CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 20:36 +0900, Keun-O Park wrote:

>         
>         So what have you done about the issue referred in this
>         comment?  Or do you
>         believe that fixing warnings (even if they are explicit
>         #warning statements)
>         is far more important than code being functionally correct?
> 
> I admit that I missed to add notrace to unwind.c.
> Do you think there's more to add?

I think Russell wants a better change log. What was written sounds like
the fix was to remove a warning. It wasn't very clear to how the warning
is no longer relevant because of the new changes.

The old change log:

---
This fixes a warning saying:

    warning: #warning "TODO: return_address should use unwind tables"

And, this enables return_address using unwind information. If ARM_UNWIND is
selected, unwind_frame in unwind.c will be called in walk_stackframe.
---


Maybe you wanted to say something like:

---
Now that the return_address code can safely use unwind tables, fix up
the #ifdef statements to reflect this.
---

Or something similar, if that's what was done.

-- Steve


> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index 00df012..52ff2d4 100644
> --- a/arch/arm/kernel/unwind.c
> +++ b/arch/arm/kernel/unwind.c
> @@ -327,7 +327,7 @@ static int unwind_exec_insn(struct
> unwind_ctrl_block *ctrl)
>   * Unwind a single frame starting with *sp for the symbol at *pc. It
>   * updates the *pc and *sp with the new values.
>   */
> -int unwind_frame(struct stackframe *frame)
> +int notrace unwind_frame(struct stackframe *frame)
>  {
>         unsigned long high, low;
>         const struct unwind_idx *idx;
> 


