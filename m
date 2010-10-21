Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab0JUNkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:40:10 -0400
Received: from kroah.org ([198.145.64.141]:39349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab0JUNkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:40:07 -0400
Date: Thu, 21 Oct 2010 06:38:48 -0700
From: Greg KH <greg@kroah.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: [B.A.T.M.A.N.] [resend][PATCHv2] staging: batman-adv: remove
	useless addr_to_string()
Message-ID: <20101021133848.GC20184@kroah.com>
References: <1287589664-25447-1-git-send-email-andy.shevchenko@gmail.com> <20101020221636.GA21132@sven-atom.lazhur.ath.cx> <20101020223958.GA17011@kroah.com> <201010211441.39483.sven.eckelmann@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010211441.39483.sven.eckelmann@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 02:41:37PM +0200, Sven Eckelmann wrote:
> Greg KH wrote:
> > On Thu, Oct 21, 2010 at 12:16:37AM +0200, Sven Eckelmann wrote:
> > > On Wed, Oct 20, 2010 at 01:57:49PM -0700, Greg KH wrote:
> > > > On Wed, Oct 20, 2010 at 10:51:15PM +0200, Sven Eckelmann wrote:
> > > > > On Wed, Oct 20, 2010 at 06:47:44PM +0300, Andy Shevchenko wrote:
> > > > > > Since all *printf() methods in the kernel understand '%pM' modifier
> > > > > > the conversion to the string is useless beforehand.
> > > > > > 
> > > > > > Additionally this patch decreases batman_if structure by 20 bytes.
> > > > > 
> > > > > Thanks for your patch. I have problems with compiling due to other
> > > > > patches in the queue. I will fix that and recommend it as patch for
> > > > > 2.6.38.
> > > > 
> > > > What do you mean by this?  It applies just fine to my tree, so why
> > > > can't I take it now?
> > > 
> > > If you want then do so, but the stuff in batman-adv's master must be
> > > fixed so they have to apply the v3 version of the patch and not the v2
> > > version Andy sent.
> > 
> > That's one of the problems with having an out-of-tree tree.  Please
> > don't do that at all anymore.
> 
> I don't see a difference in a in-tree tree and and out-of-tree tree when 
> applying patches somewhere else out of order. In both situations we have a 
> merge conflict (not that the scm says "omg, i cannot merge it" but that the 
> thing doesn't compile after the merge).

Not true at all, the in-linux-next tree builds just fine with this
patch.  In fact, it's now in linux-next already.

> I always thought that even when the source is in the kernel (or in staging) 
> that there are still a maintainer responsible for it. That this person has to 
> go through the patches and look if they do whatever they claim to do and that 
> this isn't against what the original implementation had to do or should do.

Yes, but sometimes, especially for trivial patches, the maintainer is
routed around and patches go in through other trees.

Remember a maintainer is not someone who can say "no" to all patches
that comes in, sorry, we don't work that way.

> > I'll go apply this patch to mine, and you can handle any merge issues if
> > you continue to wish to keep an external tree (hint, I STRONGLY
> > recommend that you do not, for these reasons and many others.)
> 
> The development of batman-adv is mainly done by people which need it 
> externally - so out of kernel. That means if we are not allowed anymore to 
> have some kind of external tree that we can use, it must be done the other way 
> around aka compat-wireless like and without the ability to test experimental 
> stuff with the community unless by sending it to you and reverting it before a 
> new linux release is made. Otherwise we would only have a external tree which 
> is in another form (quilt, loose patches, ...) and would be nothing different 
> than what we have currently.

As your stuff is now in the kernel, I would recommend dropping your
external tree.  It will only cause more problems in the future.

thanks,

greg k-h
