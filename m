Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1JMKQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:16:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59830 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1JMKQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:16:30 -0400
Subject: Re: [PATCH RFC V4 04/10] x86/jump_label: drop
 arch_jump_label_text_poke_early()
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <07d7a349087d253549be9946d6fe8e3219492cda.1318464413.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
	 <07d7a349087d253549be9946d6fe8e3219492cda.1318464413.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Oct 2011 12:15:52 +0200
Message-ID: <1318500952.19425.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 17:08 -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> It is no longer used.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Acked-by: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/kernel/jump_label.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 3fee346..2ad0298 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -42,10 +42,4 @@ void arch_jump_label_transform(struct jump_entry *entry,
>  	put_online_cpus();
>  }
>  
> -void arch_jump_label_text_poke_early(jump_label_t addr)
> -{
> -	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
> -			JUMP_LABEL_NOP_SIZE);
> -}
> -
>  #endif

This was the (first and) last usage site outside of alternative.c, so at
the very least we should clean up arch/x86/include/asm/alternative.h.

However, since stop_machine now works early, is there any reason to keep
text_poke_early() itself? Shouldn't we also convert alternative.c's use
of text_poke_early and simply kill the thing off?
