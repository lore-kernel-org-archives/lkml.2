Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966205Ab2DLVuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:50:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966081Ab2DLVue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:50:34 -0400
Date: Thu, 12 Apr 2012 23:50:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <andrea@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stack usage: Add pid to warning printk in
	check_stack_usage
Message-ID: <20120412215002.GA31852@redhat.com>
References: <4F85BD04.3070407@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F85BD04.3070407@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Tim Bird wrote:
>
> In embedded systems, sometimes the same program (busybox)
> is the cause of multiple warnings.  Outputting the pid
> with the program name in the warning printk helps
> distinguish which instances of a program are using
> the stack most.
>
> This is a small patch, but useful.

Agreed, pid_nr alone is useless if you read the logs when this
app has already terminated.

> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  exit.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index b8a6a09..bad923d 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -898,9 +898,9 @@ static void check_stack_usage(void)
> 
>  	spin_lock(&low_water_lock);
>  	if (free < lowest_to_date) {
> -		printk(KERN_WARNING "%s used greatest stack depth: %lu bytes "
> -				"left\n",
> -				current->comm, free);
> +		printk(KERN_WARNING "%s (%d) used greatest stack depth: "
> +				"%lu bytes left\n",
> +				current->comm, task_pid_nr(current), free);
>  		lowest_to_date = free;
>  	}
>  	spin_unlock(&low_water_lock);
> 

