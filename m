Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1EPO45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:56:57 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:49112 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755837Ab1EPO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:56:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JqLXqI/HQcePbeQTZXwdEstm1o4YnvTOBRotpaF7wnBOp6e79b0lD4muS8L+cIXoiQ2Fr2rAVbDXy8jegj8YW2cRf13KwrEVmNmoORK5JIcrau9VD8E/QT//XiYH3Cpi;
Date: Mon, 16 May 2011 07:56:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation: Update augmented rbtree documentation
Message-Id: <20110516075652.4ae904ce.rdunlap@xenotime.net>
In-Reply-To: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
References: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 12:56:42 +0300 Sasha Levin wrote:

> Current documentation referred to the old method
> of handling augmented trees. Update documentation
> to correspond with the changes done in commit
> b945d6b2554d550fe95caadc61e521c0ad71fb9c.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

                 the user

> +place. This will cause the augmentation function callback to be called for
> +each node between the new node and the root which have been affected by the

                                               which has been

> +insertion.
> +
> +When erasing a node, The user must call rb_augment_erase_begin() first to

                        the user

> +retrieve the deepest node on the rebalance path. Then, After erasing the

                                                          after

> +original node, the user must call rb_augment_erase_end() with the deepest
> +node found earlier. This will cause the augmentation function to be called
> +for each affected node between the deepest node and the root.
>  
>  
>  Interval tree is an example of augmented rb tree. Reference -
> -- 



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
