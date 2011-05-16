Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1EPKjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:39:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab1EPKjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:39:31 -0400
Date: Mon, 16 May 2011 12:38:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation: Update augmented rbtree documentation
Message-ID: <20110516103845.GB19837@elte.hu>
References: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <levinsasha928@gmail.com> wrote:

> Current documentation referred to the old method
> of handling augmented trees. Update documentation
> to correspond with the changes done in commit
> b945d6b2554d550fe95caadc61e521c0ad71fb9c.

>  Augmented rbtree is an rbtree with "some" additional data stored in each node.
>  This data can be used to augment some new functionality to rbtree.
>  Augmented rbtree is an optional feature built on top of basic rbtree
> +infrastructure. rbtree user who wants this feature will have to call the

s/rbtree user/An rbtree user

> +augmentation functions with the user provided augmentation callback
> +when inserting and erasing nodes.
> +
> +On insertion, The user must call rb_augment_insert() once the new node is in
> +place. This will cause the augmentation function callback to be called for
> +each node between the new node and the root which have been affected by the
> +insertion.
> +
> +When erasing a node, The user must call rb_augment_erase_begin() first to
> +retrieve the deepest node on the rebalance path. Then, After erasing the
> +original node, the user must call rb_augment_erase_end() with the deepest
> +node found earlier. This will cause the augmentation function to be called
> +for each affected node between the deepest node and the root.

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
