Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab1EaPgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:36:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab1EaPgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:36:18 -0400
Date: Tue, 31 May 2011 17:35:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 08/10] x86-64: Emulate legacy vsyscalls
Message-ID: <20110531153551.GA30353@elte.hu>
References: <cover.1306851090.git.luto@mit.edu>
 <ab5842ae2ac57f4004c3e86fdb9234451b1f4ac2.1306851090.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab5842ae2ac57f4004c3e86fdb9234451b1f4ac2.1306851090.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@mit.edu> wrote:

> +#ifdef CONFIG_X86_64
> +# define VSYSCALL_EMU_VECTOR		0xcc
> +#endif

> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -872,6 +872,10 @@ void __init trap_init(void)
>  	set_bit(SYSCALL_VECTOR, used_vectors);
>  #endif
>  
> +	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
> +	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
> +	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);

That is a generic section of traps.c so it won't build (and makes no 
point) on 32-bit.

	Ingo
