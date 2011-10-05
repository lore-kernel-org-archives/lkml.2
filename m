Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab1JEGD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 02:03:59 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12297 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975Ab1JEGD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 02:03:58 -0400
X-IronPort-AV: E=Sophos;i="4.68,489,1312156800"; 
   d="scan'208";a="8215106"
Subject: Re: [PATCH] stop_machine: fixup cut'n'paste error in stopped
 thread name
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1317657968.20367.35.camel@twins>
References: <1317643317.21903.36.camel@zakaz.uk.xensource.com>
	 <1317657968.20367.35.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 5 Oct 2011 07:03:56 +0100
Message-ID: <1317794636.24742.3.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 17:06 +0100, Peter Zijlstra wrote:
> On Mon, 2011-10-03 at 13:01 +0100, Ian Campbell wrote:
> > Noticed this while poking around. Seems like the code was lifted a bit
> > more thoroughly from the migration thread mgmt code than the author of
> > the preceding comment intended...
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > --- a/kernel/stop_machine.c
> > +++ b/kernel/stop_machine.c
> > @@ -312,7 +312,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
> >  		p = kthread_create_on_node(cpu_stopper_thread,
> >  					   stopper,
> >  					   cpu_to_node(cpu),
> > -					   "migration/%d", cpu);
> > +					   "stopper/%d", cpu);
> >  		if (IS_ERR(p))
> >  			return notifier_from_errno(PTR_ERR(p));
> >  		get_task_struct(p);
> > 
> 
> IIRC it was because userspace already knew about the migration thread
> and we didn't want to confuse things further. But yeah, its not
> particularly important.

I'm not sure what knowledge userspace has of either kernel thread but
fair enough, patch withdrawn.

Ian.

