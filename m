Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1EPKLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:11:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50665 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1EPKLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:11:16 -0400
Subject: Re: [PATCH] Documentation: Update augmented rbtree documentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
References: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 12:10:55 +0200
Message-ID: <1305540655.2466.4091.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 12:56 +0300, Sasha Levin wrote:
> Current documentation referred to the old method
> of handling augmented trees. Update documentation
> to correspond with the changes done in commit
> b945d6b2554d550fe95caadc61e521c0ad71fb9c.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: David Woodhouse <David.Woodhouse@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  Documentation/rbtree.txt |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
> index 19f8278..b847598 100644
> --- a/Documentation/rbtree.txt
> +++ b/Documentation/rbtree.txt
> @@ -196,15 +196,20 @@ Support for Augmented rbtrees
>  Augmented rbtree is an rbtree with "some" additional data stored in each node.
>  This data can be used to augment some new functionality to rbtree.
>  Augmented rbtree is an optional feature built on top of basic rbtree
> -infrastructure. rbtree user who wants this feature will have an augment
> -callback function in rb_root initialized.
> -
> -This callback function will be called from rbtree core routines whenever
> -a node has a change in one or both of its children. It is the responsibility
> -of the callback function to recalculate the additional data that is in the
> -rb node using new children information. Note that if this new additional
> -data affects the parent node's additional data, then callback function has
> -to handle it and do the recursive updates.
> +infrastructure. rbtree user who wants this feature will have to call the
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
>  
> 
>  Interval tree is an example of augmented rb tree. Reference -

