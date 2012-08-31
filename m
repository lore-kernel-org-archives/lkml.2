Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2HaOIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:08:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab2HaOIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:08:22 -0400
Date: Fri, 31 Aug 2012 16:05:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: ananth@in.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com
Subject: Re: [PATCH] uprobes: don't put NULL pointer in uprobe_register()
Message-ID: <20120831140539.GA18975@redhat.com>
References: <1346347582-20945-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346347582-20945-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30, Sebastian Andrzej Siewior wrote:
>
> alloc_uprobe() might return a NULL pointer, put_uprobe() can't deal with
> this.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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

Applied as cf54f5c8, thanks.

Oleg.

