Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2HBWlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:41:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47816 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752599Ab2HBWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:41:14 -0400
Message-ID: <1343947273.10710.4.camel@joe2Laptop>
Subject: Re: [PATCH v2 9/9] rbtree: remove prior augmented rbtree
 implementation
From: Joe Perches <joe@perches.com>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, peterz@infradead.org, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Date: Thu, 02 Aug 2012 15:41:13 -0700
In-Reply-To: <1343946858-8170-10-git-send-email-walken@google.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-10-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
> convert arch/x86/mm/pat_rbtree.c to the proposed augmented rbtree api
> and remove the old augmented rbtree implementation.

style trivia:

> +static u64 compute_subtree_max_end(struct memtype *data)
>  {
> -	struct memtype *data;
> -	u64 max_end, child_max_end;
> -
> -	if (!node)
> -		return;
> -
> -	data = container_of(node, struct memtype, rb);
> -	max_end = data->end;
> +	u64 max_end = data->end, child_max_end;
>  
> -	child_max_end = get_subtree_max_end(node->rb_right);
> +	child_max_end = get_subtree_max_end(data->rb.rb_right);

I think this reads better as:

	u64 max_end = data->end;
	u64 child_max_end = get_subtree_max_end(node->rb.rb_right);


