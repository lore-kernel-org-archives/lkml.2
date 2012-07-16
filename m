Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2GPLRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:17:18 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49300 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab2GPLRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:17:17 -0400
Date: Mon, 16 Jul 2012 16:46:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: rob@landley.net, Ingo Molnar <mingo@redhat.com>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: uprobes: fix uprobe tracer wrong documentation
Message-ID: <20120716111650.GA5272@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <CACV3sb+mHoxLWtEGbxzGQ8Lfn2JDc5F=PNMMfmU2Ayw4-JHb+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CACV3sb+mHoxLWtEGbxzGQ8Lfn2JDc5F=PNMMfmU2Ayw4-JHb+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071611-5806-0000-0000-0000175535D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jovi Zhang <bookjovi@gmail.com> [2012-07-16 16:49:03]:

> From e382d2d14b8177bcd2e6bac2fee004fd1f052cb5 Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Tue, 17 Jul 2012 00:35:30 +0800
> Subject: [PATCH] uprobes: fix uprobe tracer wrong documentation
> 
> The uprobe example is wrong in current kernel:
> $ echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> -bash: echo: write error: Invalid argument
> 
> It should be as following:
> $ echo 'p /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

Right, the colon is only needed if we want to provide the optional event
name.

> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  Documentation/trace/uprobetracer.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/trace/uprobetracer.txt
> b/Documentation/trace/uprobetracer.txt
> index 24ce682..8932726 100644
> --- a/Documentation/trace/uprobetracer.txt
> +++ b/Documentation/trace/uprobetracer.txt
> @@ -40,7 +40,7 @@ Usage examples
>  To add a probe as a new event, write a new definition to uprobe_events
>  as below.
> 
> -  echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> +  echo 'p /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> 
>   This sets a uprobe at an offset of 0x4245c0 in the executable /bin/bash
> 
> -- 
> 1.7.9.7

