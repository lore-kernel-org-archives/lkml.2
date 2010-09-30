Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab0I3EvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:51:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab0I3EvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:51:09 -0400
Date: Wed, 29 Sep 2010 21:52:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] kernel: add bl_list
Message-Id: <20100929215208.b0206460.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-2-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-2-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:33 +1000 Dave Chinner <david@fromorbit.com> wrote:

> From: Nick Piggin <npiggin@suse.de>
> 
> Introduce a type of hlist that can support the use of the lowest bit
> in the hlist_head. This will be subsequently used to implement
> per-bucket bit spinlock for inode hashes.
> 
>
> ...
>
> +static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
> +{
> +	h->next = NULL;
> +	h->pprev = NULL;
> +}

No need to shout.

>
> ...
>
> +static inline void hlist_bl_del(struct hlist_bl_node *n)
> +{
> +	__hlist_bl_del(n);
> +	n->next = LIST_POISON1;
> +	n->pprev = LIST_POISON2;
> +}

I'd suggest creating new poison values for hlist_bl's, leave
LIST_POISON1 and LIST_POISON2 for list_head (and any other list
variants which went and used them :()

>
> ...
>

