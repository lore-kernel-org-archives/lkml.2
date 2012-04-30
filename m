Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab2D3OQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 10:16:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2D3OP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 10:15:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
Date: Mon, 30 Apr 2012 14:15:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301415.56690.arnd@arndb.de>
X-Provags-ID: V02:K0:t9Qq+NhQyh3i2us9spLB//KbE/oJVjG+3laQaWMGtcS
 b/NqNiTeYKFl2dpQ+9ndaKDs/H+DFHFuGeIrNUeOBZhVE1tlni
 hXByvi0PmXZfYyal6e7wFv9OGy7gbC1KUPIG5GoRntj9waVNuK
 Nejh4Ej74M4rkU/sH+1LnO++0YrORiS1J1egvLYpHJ1Mzb34bI
 zyPTb7tHWMpsFTkcXu1JOt5pM54CuAmQPQ3ejqoNV6K+DX0QXs
 ZUnOpWfGHYPsUK85hSwcl3IC3MnF9dH6n2598JdwMYPKgbE8sz
 zyfZHRRf0ikLVNj91AAL9ao/6pya73/lbUeOcg2gktd0+GBLmW
 /4ogefEKtGO6x3u+2QDk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2012, Stephen Boyd wrote:
> diff --git a/include/asm-generic/current.h b/include/asm-generic/current.h
> index 5e86f6a..bbfb795 100644
> --- a/include/asm-generic/current.h
> +++ b/include/asm-generic/current.h
> @@ -1,9 +1,16 @@
>  #ifndef __ASM_GENERIC_CURRENT_H
>  #define __ASM_GENERIC_CURRENT_H
>  
> +#include <linux/compiler.h>
>  #include <linux/thread_info.h>
>  
> -#define get_current() (current_thread_info()->task)
> +struct task_struct;
> +
> +static __always_inline struct task_struct *get_current(void)
> +{
> +       return current_thread_info()->task;
> +}
> +
>  #define current get_current()
>  
>  #endif /* __ASM_GENERIC_CURRENT_H */

Does this need to be an inline function rather than a macro? I think I
remember having trouble with header file dependencies when I tried making
it an inline function initially and I don't know if those have been
resolved.

I realize that the macro is ugly, but if you don't mind keeping it,
that would be the safer option in terms of breaking some architecture
in the process. If course if you can prove that all architectures using
the generic implementation can use the inline function, I'm all for
the change.

Aside from this, I very much like your patch.

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
