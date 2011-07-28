Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1G1Wyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:54:39 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51848 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753498Ab1G1Wyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:54:37 -0400
Date: Thu, 28 Jul 2011 15:54:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [GIT PULL] Fix compile error when tracing is disabled
Message-Id: <20110728155432.1e9d24ff.rdunlap@xenotime.net>
In-Reply-To: <4E31DEB8.8070609@goop.org>
References: <4E31DEB8.8070609@goop.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011 15:12:08 -0700 Jeremy Fitzhardinge wrote:

> Hi Linus,
> 
> Please pull this to fix compilation when tracing is disabled.
> 
> Thanks,
>     J

and now
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> The following changes since commit 55f9c40ff632d03c527d6a6ceddcda0a224587a6:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2011-07-28 05:59:19 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xen-tracing2
> 
> Jeremy Fitzhardinge (1):
>       xen/tracing: fix compile errors when tracing is disabled.
> 
>  arch/x86/xen/Makefile      |    4 +++-
>  include/trace/events/xen.h |    2 ++
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 6fdf366..ce69201 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -13,7 +13,9 @@ CFLAGS_mmu.o			:= $(nostackp)
>  obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>  			time.o xen-asm.o xen-asm_$(BITS).o \
>  			grant-table.o suspend.o platform-pci-unplug.o \
> -			p2m.o trace.o
> +			p2m.o
> +
> +obj-$(CONFIG_FUNCTION_TRACER) += trace.o
>  
>  obj-$(CONFIG_SMP)		+= smp.o
>  obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
> diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
> index 44d8dec..92f1a79 100644
> --- a/include/trace/events/xen.h
> +++ b/include/trace/events/xen.h
> @@ -8,6 +8,8 @@
>  #include <asm/paravirt_types.h>
>  #include <asm/xen/trace_types.h>
>  
> +struct multicall_entry;
> +
>  /* Multicalls */
>  DECLARE_EVENT_CLASS(xen_mc__batch,
>  	    TP_PROTO(enum paravirt_lazy_mode mode),
> 
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
