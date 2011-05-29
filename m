Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1E2T5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:57:45 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21084 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab1E2T5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:57:21 -0400
Date: Sun, 29 May 2011 21:49:31 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andy Lutomirski <luto@MIT.EDU>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
In-Reply-To: <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
Message-ID: <alpine.LNX.2.00.1105292146470.4411@swampdragon.chaosbits.net>
References: <cover.1306517576.git.luto@mit.edu> <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Andy Lutomirski wrote:

> Now the only way to issue a syscall with side effects through the
> vsyscall page is to call a misaligned instruction.  I haven't
> checked for that.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/include/asm/traps.h    |    4 +++
>  arch/x86/include/asm/vsyscall.h |    6 +++++
>  arch/x86/kernel/entry_64.S      |    2 +
>  arch/x86/kernel/traps.c         |    4 +++
>  arch/x86/kernel/vsyscall_64.c   |   47 ++++++++++++++++++++++++++++++++++-----
>  5 files changed, 57 insertions(+), 6 deletions(-)
> 

one very tiny nit below.

[...]
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index b9b6716..d34894e 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -872,6 +872,10 @@ void __init trap_init(void)
>  	set_bit(SYSCALL_VECTOR, used_vectors);
>  #endif
>  
> +	set_system_intr_gate(0xCC, &intcc);
> +	set_bit(0xCC, used_vectors);
> +	printk(KERN_ERR "intcc gate isntalled\n");

Let's spell the error message correctly:

	printk(KERN_ERR "intcc gate installed\n");

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

