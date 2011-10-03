Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1JCQHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:07:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:53922 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab1JCQG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:06:58 -0400
Subject: Re: [PATCH] stop_machine: fixup cut'n'paste error in stopped thread
 name
From: Peter Zijlstra <peterz@infradead.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 03 Oct 2011 18:06:07 +0200
In-Reply-To: <1317643317.21903.36.camel@zakaz.uk.xensource.com>
References: <1317643317.21903.36.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317657968.20367.35.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 13:01 +0100, Ian Campbell wrote:
> Noticed this while poking around. Seems like the code was lifted a bit
> more thoroughly from the migration thread mgmt code than the author of
> the preceding comment intended...
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> 
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -312,7 +312,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
>  		p = kthread_create_on_node(cpu_stopper_thread,
>  					   stopper,
>  					   cpu_to_node(cpu),
> -					   "migration/%d", cpu);
> +					   "stopper/%d", cpu);
>  		if (IS_ERR(p))
>  			return notifier_from_errno(PTR_ERR(p));
>  		get_task_struct(p);
> 

IIRC it was because userspace already knew about the migration thread
and we didn't want to confuse things further. But yeah, its not
particularly important.


