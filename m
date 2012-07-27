Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2G0UEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:04:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:56603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2G0UEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:04:35 -0400
Message-ID: <1343419466.32120.50.camel@twins>
Subject: Re: [PATCH 4/6] rbtree: faster augmented insert
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jul 2012 22:04:26 +0200
In-Reply-To: <1342787467-5493-5-git-send-email-walken@google.com>
References: <1342787467-5493-1-git-send-email-walken@google.com>
	 <1342787467-5493-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 05:31 -0700, Michel Lespinasse wrote:
> +static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
> +{
> +       struct test_node *old = rb_entry(rb_old, struct test_node, rb);
> +       struct test_node *new = rb_entry(rb_new, struct test_node, rb);
> +
> +       /* Rotation doesn't change subtree's augmented value */
> +       new->augmented = old->augmented;
> +       old->augmented = augment_recompute(old);
> +} 

> +static inline void augment_propagate(struct rb_node *rb)
> +{
> +       while (rb) {
> +               struct test_node *node = rb_entry(rb, struct test_node, rb);
> +               node->augmented = augment_recompute(node);
> +               rb = rb_parent(&node->rb);
> +       }
> +}

So why do we have to introduce these two new function pointers to pass
along when they can both be trivially expressed in the old single
augment function?


