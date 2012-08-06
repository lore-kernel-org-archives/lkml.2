Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2HFOW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:22:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37148 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab2HFOW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:22:26 -0400
Message-ID: <1344262930.27828.57.camel@twins>
Subject: Re: [PATCH v2 3/9] rbtree: add __rb_change_child() helper function
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 06 Aug 2012 16:22:10 +0200
In-Reply-To: <1343946858-8170-4-git-send-email-walken@google.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-4-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
> +static inline void

I would make that __always_inline, just to make sure GCC doesn't go
creative on us.

> +__rb_change_child(struct rb_node *old, struct rb_node *new,
> +                 struct rb_node *parent, struct rb_root *root)
> +{
> +       if (parent) {
> +               if (parent->rb_left == old)
> +                       parent->rb_left = new;
> +               else
> +                       parent->rb_right = new;
> +       } else
> +               root->rb_node = new;
> +} 
