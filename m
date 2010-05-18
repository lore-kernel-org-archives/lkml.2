Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0ERDlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:41:50 -0400
Received: from xenotime.net ([72.52.115.56]:47916 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753348Ab0ERDls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:41:48 -0400
Date: Mon, 17 May 2010 20:41:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa x86_64 use generic percpu var numa_node_id
 implementation fix3  [was Re: mmotm 2010-05-14-13-33 uploaded]
Message-Id: <20100517204140.b396ea83.rdunlap@xenotime.net>
In-Reply-To: <1274147210.24007.146.camel@useless.americas.hpqcorp.net>
References: <201005142101.o4EL1Mf2022381@imap1.linux-foundation.org>
	<20100516163754.14cf8bbb.rdunlap@xenotime.net>
	<1274147210.24007.146.camel@useless.americas.hpqcorp.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 21:46:50 -0400 Lee Schermerhorn wrote:

> On Sun, 2010-05-16 at 16:37 -0700, Randy Dunlap wrote: 
> > include/linux/topology.h:248: error: implicit declaration of function 'cpu_to_node'
> > 
> > 
> > config attached.
> 
> Hmmm, i386 NUMA.
> 
> With the following patch, your config builds correctly.  !NUMA i386
> still builds, as well.

Yes, thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> Lee
> 
> Fix i386 numa build:  define cpu_to_node() stub same as
> early_cpu_to_node() for i386 numa builds.  Just return node
> from cpu_to_node_map[].
> 
> Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
> 
>  arch/x86/include/asm/topology.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.34-rc7-mmotm-100514-1333/arch/x86/include/asm/topology.h
> ===================================================================
> --- linux-2.6.34-rc7-mmotm-100514-1333.orig/arch/x86/include/asm/topology.h	2010-05-17 08:40:47.000000000 -0400
> +++ linux-2.6.34-rc7-mmotm-100514-1333/arch/x86/include/asm/topology.h	2010-05-17 10:49:08.000000000 -0400
> @@ -53,10 +53,12 @@
>  extern int cpu_to_node_map[];
>  
>  /* Returns the number of the node containing CPU 'cpu' */
> -static inline int early_cpu_to_node(int cpu)
> +static inline int __cpu_to_node(int cpu)
>  {
>  	return cpu_to_node_map[cpu];
>  }
> +#define early_cpu_to_node __cpu_to_node
> +#define cpu_to_node __cpu_to_node
>  
>  #else /* CONFIG_X86_64 */
>  
> 
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
