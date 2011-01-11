Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1AKXB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:01:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1AKXBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:01:25 -0500
Date: Tue, 11 Jan 2011 18:01:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com,
        akpm@linux-foundation.org, smcameron@yahoo.com
Subject: Re: [PATCH] hpsa: do not re-order commands in internal queues
Message-ID: <20110111230120.GA24406@infradead.org>
References: <20110111224658.24457.62925.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111224658.24457.62925.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static inline void addQ(struct hlist_head *list, struct CommandList *c)
> +static inline void addQ(struct list_head *list, struct CommandList *c)
>  {
> -	hlist_add_head(&c->list, list);
> +	list_add_tail(&c->list, list);
>  }
>  
>  static inline u32 next_command(struct ctlr_info *h)
> @@ -366,9 +366,9 @@ static void enqueue_cmd_and_start_io(struct ctlr_info *h,
>  
>  static inline void removeQ(struct CommandList *c)
>  {
> -	if (WARN_ON(hlist_unhashed(&c->list)))
> +	if (WARN_ON(list_empty(&c->list)))
>  		return;
> -	hlist_del_init(&c->list);
> +	list_del_init(&c->list);

Any reason to keep these helpers?  They don't really help
clarifying the code, and iterations also use the list directly, thus
breaking the abstraction.
