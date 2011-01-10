Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1AJK6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:58:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:32861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJK6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:58:51 -0500
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: bharata@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1294655388.8197.22.camel@marge.simson.net>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 Jan 2011 11:59:14 +0100
Message-ID: <1294657154.2016.459.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 11:29 +0100, Mike Galbraith wrote:
> 
> Right, autogroup should be excluding CONFIG_RT_GROUP_SCHED, since it
> doesn't currently support it.
> 
> sched: SCHED_AUTOGROUP selection excludes RT_GROUP_SCHED
> 
> Autogroup does not support realtime task groups, so make selection of
> SCHED_AUTOGROUP exclude RT_GROUP_SCHED.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Reported-by:Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> ---
>  init/Kconfig |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6/init/Kconfig
> ===================================================================
> --- linux-2.6.orig/init/Kconfig
> +++ linux-2.6/init/Kconfig
> @@ -699,6 +699,7 @@ config RT_GROUP_SCHED
>         bool "Group scheduling for SCHED_RR/FIFO"
>         depends on EXPERIMENTAL
>         depends on CGROUP_SCHED
> +       depends on !SCHED_AUTOGROUP
>         default n
>         help
>           This feature lets you explicitly allocate real CPU bandwidth
> @@ -807,6 +808,10 @@ config SCHED_AUTOGROUP
>           desktop applications.  Task group autogeneration is currently based
>           upon task session.
>  
> +         Note: SCHED_AUTOGROUP does not support realtime tasks, and prevents
> +         enabling RT_GROUP_SCHED.  If you intend to use group scheduling for
> +         realtime tasks, do not enable this option.
> +
>  config MM_OWNER
>         bool
>   

Uhm, no. The right way is to put tasks back into the root group and then
perform sched_setscheduler().
