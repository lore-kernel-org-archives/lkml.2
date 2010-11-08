Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0KHVLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:11:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59759 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0KHVLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:11:04 -0500
Date: Mon, 8 Nov 2010 13:09:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 18/23] sys-rq: Add option to soft dump
Message-Id: <20101108130939.13436673.randy.dunlap@oracle.com>
In-Reply-To: <20101108203322.22479.47929.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
	<20101108203322.22479.47929.stgit@crlf.mtv.corp.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Nov 2010 12:33:23 -0800 Mike Waychison wrote:

> It is very useful to provide some means to force the kernel logs to make it out
> via the kmsg_oops implementations on the console.  Add a new option 'Y' to
> sysrq to allow dumping of logs to kmsg_dumper drivers.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>

Hi,

Please add 'y' to Documentation/sysrq.txt .

> ---
>  drivers/char/sysrq.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> index eaa5d3e..058d3c8 100644
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -41,6 +41,7 @@
>  #include <linux/oom.h>
>  #include <linux/slab.h>
>  #include <linux/input.h>
> +#include <linux/kmsg_dump.h>
>  
>  #include <asm/ptrace.h>
>  #include <asm/irq_regs.h>
> @@ -395,6 +396,17 @@ static struct sysrq_key_op sysrq_unrt_op = {
>  	.enable_mask	= SYSRQ_ENABLE_RTNICE,
>  };
>  
> +static void sysrq_handle_softdump(int key)
> +{
> +	kmsg_dump(KMSG_DUMP_SOFT, NULL);
> +}
> +static struct sysrq_key_op sysrq_softdump_op = {
> +	.handler	= sysrq_handle_softdump,
> +	.help_msg	= "soft-dump(Y)",
> +	.action_msg	= "Trigger a soft dump",
> +	.enable_mask	= SYSRQ_ENABLE_DUMP,
> +};
> +
>  /* Key Operations table and lock */
>  static DEFINE_SPINLOCK(sysrq_key_table_lock);
>  
> @@ -451,7 +463,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>  	/* x: May be registered on ppc/powerpc for xmon */
>  	NULL,				/* x */
>  	/* y: May be registered on sparc64 for global register dump */
> -	NULL,				/* y */
> +	&sysrq_softdump_op,		/* y */
>  	&sysrq_ftrace_dump_op,		/* z */
>  };


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
