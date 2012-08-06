Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2HFO3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:29:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:58350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2HFO3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:29:37 -0400
Message-ID: <1344263368.27828.60.camel@twins>
Subject: Re: [PATCH v2 8/9] rbtree: faster augmented rbtree manipulation
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 06 Aug 2012 16:29:28 +0200
In-Reply-To: <1343946858-8170-9-git-send-email-walken@google.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-9-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
> +void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
> +       void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
> +{
> +       __rb_insert(node, root, augment_rotate);
> +}
> +EXPORT_SYMBOL(__rb_insert_augmented);
> +
> +void rb_erase_augmented(struct rb_node *node, struct rb_root *root,
> +                       const struct rb_augment_callbacks *augment)
> +{
> +       __rb_erase(node, root, augment);
> +}
> +EXPORT_SYMBOL(rb_erase_augmented); 

>From a symmetry POV I'd say have both take the rb_augment_callbacks
thing. The two taking different arguments is confusing at best.
