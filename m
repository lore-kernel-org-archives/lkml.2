Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1DYWLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:11:14 -0400
Received: from claw.goop.org ([74.207.240.146]:47629 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab1DYWLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:11:13 -0400
Message-ID: <4DB5F17C.8040105@goop.org>
Date: Mon, 25 Apr 2011 15:11:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Anders Kaseorg <andersk@ksplice.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, vdso: SHN_LORESERVE is an inclusive lower bound
References: <alpine.DEB.2.02.1104251020170.26664@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.2.02.1104251020170.26664@dr-wily.mit.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2011 07:28 AM, Anders Kaseorg wrote:
> Test for >= SHN_LORESERVE instead of > SHN_LORESERVE.

Yep, seems reasonable.  Did this cause a problem, or is it just
something you noticed?

    J

> Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
> ---
>  arch/x86/vdso/vdso32-setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
> index 468d591..226bfad 100644
> --- a/arch/x86/vdso/vdso32-setup.c
> +++ b/arch/x86/vdso/vdso32-setup.c
> @@ -88,7 +88,7 @@ static __init void reloc_symtab(Elf32_Ehdr *ehdr,
>  		    sym->st_shndx == SHN_ABS)
>  			continue;  /* skip */
>  
> -		if (sym->st_shndx > SHN_LORESERVE) {
> +		if (sym->st_shndx >= SHN_LORESERVE) {
>  			printk(KERN_INFO "VDSO: unexpected st_shndx %x\n",
>  			       sym->st_shndx);
>  			continue;

