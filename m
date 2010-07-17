Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab0GQQOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 12:14:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59468 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0GQQOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 12:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mNN8vUHtvh8YKRCsJmEMmr5MWE2DKJdl4Nt7P1tjKxOOFTCtc7n19dsCFpOsU8+LZk
         R7sKFse565Nse98YLkM+grx16VcTM9Nx1tiz5F6iYsqwLdgTnj4bjLG9GSAXG4QpvUpW
         lp4oabjpwpHqNOtxe3KSNurDHbBGrhdn/j5+s=
MIME-Version: 1.0
In-Reply-To: <1279371808-24804-3-git-send-email-brgerst@gmail.com>
References: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
	<1279371808-24804-3-git-send-email-brgerst@gmail.com>
Date: Sat, 17 Jul 2010 19:14:38 +0300
X-Google-Sender-Auth: 5T_CVDQ34RLpSmdsV9fiBzuovXI
Message-ID: <AANLkTim7R3rNj0YdsTynQJUnk0crXRuAg2CHHqe1vttA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86-64: Simplify loading initial_gs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 4:03 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Load initial_gs as two 32-bit values instead of splitting a 64-bit value.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/kernel/head_64.S |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 3d1e6f1..239046b 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -234,9 +234,8 @@ ENTRY(secondary_startup_64)
>         * init data section till per cpu areas are set up.
>         */
>        movl    $MSR_GS_BASE,%ecx
> -       movq    initial_gs(%rip),%rax
> -       movq    %rax,%rdx
> -       shrq    $32,%rdx
> +       movl    initial_gs(%rip),%eax
> +       movl    initial_gs+4(%rip),%edx
>        wrmsr
>
>        /* esi is pointer to real mode structure with interesting info.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
