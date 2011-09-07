Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1IGWqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 18:46:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59340 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985Ab1IGWqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 18:46:35 -0400
Date: Wed, 7 Sep 2011 15:46:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shakthi Kannan <shakthimaan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CRC calculation in Module.symvers
Message-ID: <20110907224632.GE4387@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 11:28:46AM +0530, Shakthi Kannan wrote:
> Greetings!
> 
> I would like to know as to:
> 
> 1. How the CRC is computed for an exported symbol present in
> Module.symvers file, and
> 2. Given a kernel .c file, how can I obtain the CRC checksums for a symbol.
> 
> For linux-3.0.2 (example), I compiled with CONFIG_MODVERSIONS=y, and
> running 'make' built vmlinux, and generated the Module.symvers file. I
> believe genksyms is used to create the Module.symvers file?
> 
> I had referred the "Kernel Symbols and CONFIG_MODVERSIONS"
> documentation [1] written by Mark McLoughlin. I tried the following in
> the top-level kernel sources:
> 
>  $ gcc -E -D__GENKSYMS__ -DCONFIG_MODVERSIONS -DEXPORT_SYMTAB
> crypto/api.c -I/tmp/linux-3.0.2/include
> -I/tmp/linux-3.0.2/arch/x86/include | ./scripts/genksyms/genksyms
> 
> and I get the following error output:
> 
> === Output ===
> 
> /tmp/linux-3.0.2/include/linux/jiffies.h:43:42: error: division by zero in #if
> In file included from /tmp/linux-3.0.2/include/linux/tracepoint.h:19:0,
>                 from /tmp/linux-3.0.2/include/linux/module.h:18,
>                 from crypto/api.c:22:
> /tmp/linux-3.0.2/include/linux/rcupdate.h:160:2: error: #error
> "Unknown RCU implementation specified to kernel configuration"

The above error message is emitted if none of CONFIG_TINY_RCU,
CONFIG_TINY_PREEMPT_RCU, CONFIG_TREE_RCU, and CONFIG_TREE_PREEMPT_RCU
is defined.  Given that these four are in a "choice", I suspect that
you have broken the kernel build pretty impressively.

							Thanx, Paul

> In file included from /tmp/linux-3.0.2/include/linux/module.h:21:0,
>                 from crypto/api.c:22:
> /tmp/linux-3.0.2/arch/x86/include/asm/module.h:59:2: error: #error
> unknown processor family
> 
> === End ===
> 
> The documentation for genksyms is old, and now there is no -k option?
> 
> Appreciate any inputs in this regard,
> 
> Thanks!
> 
> SK
> 
> [1] Kernel Symbols and CONFIG_MODVERSIONS.
> http://www.skynet.ie/~mark/pub/symbols.txt
> 
> -- 
> Shakthi Kannan
> http://www.shakthimaan.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
