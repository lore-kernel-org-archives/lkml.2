Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2LJGaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:30:24 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46414 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2LJGaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:30:23 -0500
Date: Mon, 10 Dec 2012 11:30:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] uprobes: Kill the "uprobe != NULL" check in
 uprobe_unregister()
Message-ID: <20121210060001.GE22164@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121123202741.GA18858@redhat.com>
 <20121123202802.GA18884@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121123202802.GA18884@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121006-5806-0000-0000-00001CC422F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-11-23 21:28:02]:

> Trivial. uprobe can't be NULL after mutex_unlock(), it was already used.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index e9f22ed..13b247c 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -900,8 +900,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
>  	}
> 
>  	mutex_unlock(uprobes_hash(inode));
> -	if (uprobe)
> -		put_uprobe(uprobe);
> +	put_uprobe(uprobe);
>  }
> 
>  static struct rb_node *
> -- 
> 1.5.5.1
> 

