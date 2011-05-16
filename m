Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1EPQpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:45:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1EPQpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:45:14 -0400
Date: Mon, 16 May 2011 18:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation: Update augmented rbtree documentation
Message-ID: <20110516164449.GA10929@elte.hu>
References: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
 <20110516075652.4ae904ce.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516075652.4ae904ce.rdunlap@xenotime.net>
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


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Mon, 16 May 2011 12:56:42 +0300 Sasha Levin wrote:
> 
> > Current documentation referred to the old method
> > of handling augmented trees. Update documentation
> > to correspond with the changes done in commit
> > b945d6b2554d550fe95caadc61e521c0ad71fb9c.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: David Woodhouse <David.Woodhouse@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > ---
> >  Documentation/rbtree.txt |   23 ++++++++++++++---------
> >  1 files changed, 14 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
> > index 19f8278..b847598 100644
> > --- a/Documentation/rbtree.txt
> > +++ b/Documentation/rbtree.txt
> > @@ -196,15 +196,20 @@ Support for Augmented rbtrees
> >  Augmented rbtree is an rbtree with "some" additional data stored in each node.
> >  This data can be used to augment some new functionality to rbtree.
> >  Augmented rbtree is an optional feature built on top of basic rbtree
> > -infrastructure. rbtree user who wants this feature will have an augment
> > -callback function in rb_root initialized.
> > -
> > -This callback function will be called from rbtree core routines whenever
> > -a node has a change in one or both of its children. It is the responsibility
> > -of the callback function to recalculate the additional data that is in the
> > -rb node using new children information. Note that if this new additional
> > -data affects the parent node's additional data, then callback function has
> > -to handle it and do the recursive updates.
> > +infrastructure. rbtree user who wants this feature will have to call the
> > +augmentation functions with the user provided augmentation callback
> > +when inserting and erasing nodes.
> > +
> > +On insertion, The user must call rb_augment_insert() once the new node is in
> 
>                  the user
> 
> > +place. This will cause the augmentation function callback to be called for
> > +each node between the new node and the root which have been affected by the
> 
>                                                which has been
> 
> > +insertion.
> > +
> > +When erasing a node, The user must call rb_augment_erase_begin() first to
> 
>                         the user
> 
> > +retrieve the deepest node on the rebalance path. Then, After erasing the
> 
>                                                           after
> 
> > +original node, the user must call rb_augment_erase_end() with the deepest
> > +node found earlier. This will cause the augmentation function to be called
> > +for each affected node between the deepest node and the root.

Heh, you really rock at reviewing documentation!

I went through the text and could have sworn that beyond the small detail i 
pointed out it's otherwise perfect ;-)

Thanks,

	Ingo
