Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2EIGQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:16:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40142 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab2EIGQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:16:35 -0400
Date: Wed, 9 May 2012 01:16:21 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [ 153/167] [PATCH] x86, relocs: Remove an unused variable
Message-ID: <20120509061621.GA32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055050.693943991@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055050.693943991@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
[...]
> commit 7c77cda0fe742ed07622827ce80963bbeebd1e3f upstream.
>
> sh_symtab is set but not used.
>
> [ hpa: putting this in urgent because of the sheer harmlessness of the patch:
>   it quiets a build warning but does not change any generated code. ]
[...]
> --- a/arch/x86/boot/compressed/relocs.c
> +++ b/arch/x86/boot/compressed/relocs.c
> @@ -403,13 +403,11 @@ static void print_absolute_symbols(void)
>  	for (i = 0; i < ehdr.e_shnum; i++) {
>  		struct section *sec = &secs[i];
>  		char *sym_strtab;
> -		Elf32_Sym *sh_symtab;
>  		int j;
>  
>  		if (sec->shdr.sh_type != SHT_SYMTAB) {
>  			continue;
>  		}
> -		sh_symtab = sec->symtab;

This patch is a no-op.

The explanation in brackets above makes perfect sense in the context
of mainline, but I don't think this belongs in stable.

Thanks,
Jonathan
