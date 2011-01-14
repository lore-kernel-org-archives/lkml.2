Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab1ANDDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:03:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41678 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab1ANDD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:03:26 -0500
Date: Fri, 14 Jan 2011 03:03:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@gmail.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: vfs-scale, d_revalidate from nfsd
Message-ID: <20110114030325.GU19804@ZenIV.linux.org.uk>
References: <8855.1294927436@jrobl>
 <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 01:57:55PM +1100, Nick Piggin wrote:
> On Fri, Jan 14, 2011 at 1:03 AM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
> >
> > NFSD calls filesystem's ->d_revalidate() with the parameter nd == NULL.
> > So every
> > ? ? ? ?if (nd->flags & LOOKUP_RCU)
> > ? ? ? ? ? ? ? ?return -ECHILD;
> > code which was added to ->d_revalidate() of FS which supports NFS
> > exporting will crash.
> >
> > If we rewrite it as
> > ? ? ? ?if (nd && (nd->flags & LOOKUP_RCU))
> > ? ? ? ? ? ? ? ?return -ECHILD;
> > the problem may not occur.
> > But I am not sure whether lookup_one_len() call in NFSD support rcu-walk.
> 
> Ah, good catch.
> 
> I'm going to change the d_revalidate API so it takes and inode and rcu-walk
> flag parameter to make it easier for filesystems to implement rcu-walk.
> 
> That will take care of this NULL nd case.

Oh, for fuck sake...  Would you at least mind posting your API change
description to fsdevel before going for it?

->d_revalidate() is one sick puppy and it's intimately involved in atomic
open rewrite.  Please, *please* don't make that shit even messier...
