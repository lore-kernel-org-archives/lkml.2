Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab0KPHjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:39:43 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41849 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab0KPHjm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 16 Nov 2010 02:39:42 -0500
Message-Id: <4CE2434A02000078000226C7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 16 Nov 2010 07:39:38 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <heukelum@fastmail.fm>,
        "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>,
        <hpa@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.37-rc2] x86, asm: Add parentheses around one
	 pushl_cfi argument
References: <201011160445.oAG4jGif079860@www262.sakura.ne.jp>
In-Reply-To: <201011160445.oAG4jGif079860@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.11.10 at 05:45, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> From ed935c12f0b2b09c1586d22925261378e0d7eb83 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Tue, 16 Nov 2010 13:33:07 +0900
> Subject: [PATCH] x86, asm: Add parentheses around one pushl_cfi argument
> 
> Commit df5d1874 "x86: Use {push,pop}{l,q}_cfi in more places" caused GNU
> assembler 2.15 (Debian Sarge) to fail. It is still failing as of commit
> 07bd8516 "x86, asm: Restore parentheses around one pushl_cfi argument".
> This patch solves build failure with GNU assembler 2.15.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Acked-by: Jan Beulich <jbeulich@novell.com>

> ---
>  arch/x86/kernel/entry_32.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 59e175e..591e601 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -395,7 +395,7 @@ sysenter_past_esp:
>  	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
>  	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
>  	 */
> -	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
> +	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE_asm+8+4*4)(%esp)
>  	CFI_REL_OFFSET eip, 0
>  
>  	pushl_cfi %eax




