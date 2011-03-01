Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1CAMID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:08:03 -0500
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:56924 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab1CAMIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:08:01 -0500
Message-ID: <4D6CE187.5090806@ece.ntua.gr>
Date: Tue, 01 Mar 2011 14:07:35 +0200
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110225 Lightning/1.0b3pre Lanikai/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] x86-64: fix UML build after adding CFI annotations to
  lib/rwsem_64.S
References: <4D6CE3400200007800034498@vpn.id2.novell.com>
In-Reply-To: <4D6CE3400200007800034498@vpn.id2.novell.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Tue, 01 Mar 2011 14:07:37 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 01:14 PM, Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jeff Dike <jdike@addtoit.com>
>
> ---
>  arch/um/Kconfig.x86     |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> --- 2.6.38-rc6/arch/um/Kconfig.x86
> +++ 2.6.38-rc6-x86_64-cfi-annotate-rwsem-UML/arch/um/Kconfig.x86
> @@ -19,6 +19,9 @@ config X86_32
>  	def_bool !64BIT
>  	select HAVE_AOUT
>  
> +config X86_64
> +	def_bool 64BIT
> +
>  config RWSEM_XCHGADD_ALGORITHM
>  	def_bool X86_XADD
>  
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml
tested it and works(build + boot).
i think that you could add "select HAVE_AOUT" to x86_64 too, or move it to
config UML_X86, to catch both configs.

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

