Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0FNOaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:30:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29826 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0FNOaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:30:00 -0400
Date: Mon, 14 Jun 2010 07:27:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 6/14] Uprobes Implementation
Message-Id: <20100614072706.d29f3cbd.randy.dunlap@oracle.com>
In-Reply-To: <20100614082903.29068.62439.sendpatchset@localhost6.localdomain6>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
	<20100614082903.29068.62439.sendpatchset@localhost6.localdomain6>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4C163C5E.00A8:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 13:59:03 +0530 Srikar Dronamraju wrote:

> diff --git a/arch/Kconfig b/arch/Kconfig
> index 16541af..995f7f2 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -58,6 +58,16 @@ config USER_BKPT
>  	  This service is used by components such as uprobes.
>  	  If in doubt, say "N".
>  
> +config UPROBES
> +	bool "User-space probes (EXPERIMENTAL)"
> +	depends on MODULES && USER_BKPT_XOL

depends on having CONFIG_MODULES enabled.  Please explain.


> +	depends on HAVE_UPROBES
> +	help
> +	  Uprobes enables kernel modules to establish probepoints
> +	  in user applications and execute handler functions when
> +	  the probepoints are hit. For more information, refer to
> +	  Documentation/uprobes.txt. If in doubt, say "N".
> +
>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	bool
>  	help


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
