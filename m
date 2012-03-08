Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2CHCeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:34:01 -0500
Received: from ozlabs.org ([203.10.76.45]:46443 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab2CHCd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:33:57 -0500
From: Michael Neuling <mikey@neuling.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: manual merge of the powerpc tree with the arm tree
In-reply-to: <20120308120422.e071cba36425eacbee1f8d98@canb.auug.org.au>
References: <20120308120422.e071cba36425eacbee1f8d98@canb.auug.org.au>
Comments: In-reply-to Stephen Rothwell <sfr@canb.auug.org.au>
   message dated "Thu, 08 Mar 2012 12:04:22 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Thu, 08 Mar 2012 13:33:56 +1100
Message-ID: <25744.1331174036@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the powerpc tree got a conflict in
> arch/powerpc/Kconfig between commit 2ed86b16eabe ("irq: make SPARSE_IRQ
> an optionally hidden option") from the arm tree and commit ad5b7f1350c2
> ("powerpc: Make SPARSE_IRQ required") from the powerpc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/powerpc/Kconfig
> index bf7dbc2,4eecaaa..0000000
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@@ -133,7 -133,8 +133,8 @@@ config PP
>   	select HAVE_REGS_AND_STACK_ACCESS_API
>   	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
>   	select HAVE_GENERIC_HARDIRQS
>  -	select HAVE_SPARSE_IRQ
>  +	select MAY_HAVE_SPARSE_IRQ
> + 	select SPARSE_IRQ

Surely we only need SPARSE_IRQ now and not MAY_HAVE_SPARSE_IRQ.  

In fact, keeping MAY_HAVE_SPARSE_IRQ seems to make SPARSE_IRQ user
selectable, which we don't want anymore since ad5b7f1350c2.

Mikey
