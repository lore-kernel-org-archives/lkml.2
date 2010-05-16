Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0EPS0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 14:26:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56465 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab0EPS0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 14:26:37 -0400
Date: Sun, 16 May 2010 20:26:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: ERR_PTR and PTR_ERR
In-Reply-To: <20100516173729.GE31073@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1005162025560.12921@ask.diku.dk>
References: <Pine.LNX.4.64.1005161055580.6573@ask.diku.dk>
 <Pine.LNX.4.64.1005161104520.6573@ask.diku.dk> <20100516173729.GE31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010, Al Viro wrote:

> On Sun, May 16, 2010 at 11:05:23AM +0200, Julia Lawall wrote:
> > On Sun, 16 May 2010, Julia Lawall wrote:
> > 
> > > I see a number of occurrences of code like the following:
> > > 
> > >  	if (IS_ERR(alg))
> > > 		return ERR_PTR(PTR_ERR(alg));
> > > 
> > > Is there any reason why the second line couldn't just be return alg?
> > 
> > Hmm, never mind.  It seems to address a type problem.
> 
> More idiomatic way to deal with that is ERR_CAST(); see e.g. ext2_lookup() for
> use case:

Thanks.  That looks much nicer than ERR_PTR(PTR_ERR(alg)).

julia


> 	...
> 	inode = NULL;
> 	if (ino) {
> 		inode = ext2_iget(dir->i_sb, ino);
> 		if (unlikely(IS_ERR(inode))) {
> 			if (PTR_ERR(inode) == -ESTALE) {
> 				ext2_error(dir->i_sb, __func__,
> 						"deleted inode referenced: %lu",
> 						(unsigned long) ino);
> 				return ERR_PTR(-EIO);
> 			} else {
> 				return ERR_CAST(inode);
> 			}
> 		}
> 	}
> 	return d_splice_alias(inode, dentry);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
