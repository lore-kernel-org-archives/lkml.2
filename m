Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab2ILMry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:47:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37207 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2ILMrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:47:53 -0400
Date: Wed, 12 Sep 2012 18:13:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: ananth@in.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com
Subject: Re: [PATCH] uprobes: don't put NULL pointer in uprobe_register()
Message-ID: <20120912124357.GE9582@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1346347582-20945-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1346347582-20945-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091212-7408-0000-0000-00000872E2FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [2012-08-30 19:26:22]:

> alloc_uprobe() might return a NULL pointer, put_uprobe() can't deal with
> this.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 7b3112c..30f3e23 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -897,7 +897,8 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
>  	}
> 
>  	mutex_unlock(uprobes_hash(inode));
> -	put_uprobe(uprobe);
> +	if (uprobe)
> +		put_uprobe(uprobe);
> 
>  	return ret;
>  }
> -- 
> 1.7.10.4
> 

