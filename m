Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2GQK7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:59:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab2GQK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:59:43 -0400
Date: Tue, 17 Jul 2012 12:59:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jovi Zhang <bookjovi@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: uprobe: checking probe event include directory
Message-ID: <20120717105936.GC28744@somewhere>
References: <CACV3sbLu81jrkfSXQxJ+_XtZHVTA6YfwJO3hjRxYsaDwbbLi6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACV3sbLu81jrkfSXQxJ+_XtZHVTA6YfwJO3hjRxYsaDwbbLi6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 06:12:28PM +0800, Jovi Zhang wrote:
> From 16ed13ee9098ae01705e8456005d1ad6d9909128 Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Wed, 18 Jul 2012 01:16:23 +0800
> Subject: [PATCH] uprobe: checking probe event include directory
> 
> Currently below command run successful:
> $ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> 
> this don't make sense, because /bin is a directory,
> so make this checking earily, not report error untill probe enable.
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

Adding Srikar in Cc.

> ---
>  kernel/trace/trace_uprobe.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 85158fa..cf382de 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -259,6 +259,11 @@ static int create_trace_uprobe(int argc, char **argv)
>  		goto fail_address_parse;
> 
>  	inode = igrab(path.dentry->d_inode);
> +	 if (S_ISDIR(inode->i_mode)) {
> +		ret = -EINVAL;
> +		pr_info("probe file cannot be directory.\n");
> +		goto fail_address_parse;
> +	}
> 
>  	argc -= 2;
>  	argv += 2;
> -- 
> 1.7.9.7
