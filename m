Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2B0Ub4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:31:56 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:34970 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2B0Ubz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:31:55 -0500
Date: Mon, 27 Feb 2012 17:27:47 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] security: fix ima kconfig warning
Message-ID: <20120227202747.GA2973@hardened-box.ibm.com>
References: <4F47E4C5.7060706@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F47E4C5.7060706@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022720-1524-0000-0000-00000196C6E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix IMA kconfig warning on non-X86 architectures:
> 
> warning: (IMA) selects TCG_TIS which has unmet direct dependencies
> (TCG_TPM && X86)
> 
> But why do TCG_TIS and TCG_NSC depend on X86??
>

These drivers only support the probing for TPM devices on this platform,
through PNP or a hardcoded address base.

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mimi Zohar <zohar@us.ibm.com>
> Cc: James Morris <jmorris@namei.org>
> ---
> No IMA/TPM builds have been tested with this change...
> 
>  security/integrity/ima/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- lnx-33-rc4.orig/security/integrity/ima/Kconfig
> +++ lnx-33-rc4/security/integrity/ima/Kconfig
> @@ -10,7 +10,7 @@ config IMA
>  	select CRYPTO_MD5
>  	select CRYPTO_SHA1
>  	select TCG_TPM if !S390 && !UML
> -	select TCG_TIS if TCG_TPM
> +	select TCG_TIS if TCG_TPM && X86
>  	help
>  	  The Trusted Computing Group(TCG) runtime Integrity
>  	  Measurement Architecture(IMA) maintains a list of hash
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Rajiv Andrade
Security Development
IBM Linux Technology Center

