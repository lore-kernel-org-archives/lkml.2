Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2BQAVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:21:46 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47847 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576Ab2BQAVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:21:44 -0500
X-Sasl-enc: HyqCvYTHoeGLfrn4KdVPtCA84jCzVrakG9q0LvTOl1cs 1329438102
Date: Thu, 16 Feb 2012 16:17:28 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20120217001728.GA7746@kroah.com>
References: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
 <20120216051552.GA5676@kroah.com>
 <c6634d7c-b264-4a87-bab1-74408341dab0@default>
 <20120217082559.6a094265da2d5c203bfc445f@canb.auug.org.au>
 <be7afe58-43f1-4f69-b0ae-89dd7607355b@default>
 <20120217103917.36721f3e8f75c35092c2dce2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217103917.36721f3e8f75c35092c2dce2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 10:39:17AM +1100, Stephen Rothwell wrote:
> Hi Dan,
> 
> On Thu, 16 Feb 2012 13:49:53 -0800 (PST) Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> >
> > Huh?  Do you do allyesconfig/allmodconfig build testing after you pull
> > each individual tree or only after all trees are pulled?  (Apparently
> > the former, as otherwise the ordering shouldn't matter, right?)
> 
> From my daily release note:
> 
> "Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
> and sparc64 defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary."
> 
> So yes, I build between each merge.  It allows me to isolate where
> problems are occurring so that they can be easily fixed in isolation.
> 
> > If you are doing the after-every-individual-tree build testing,
> > yes, if you could pull konrad's tmem tree first, that would
> > solve this problem I believe.**
> 
> Yes, I can do that (and will for today).  However, it does mean that the
> staging tree now cannot be merged into Linus' tree until after the tmem
> tree has been merged.   And if Linus decides not to take it, then Greg
> will have to remove these commits from his tree (or revert them) before
> he can get all the rest of the staging tree into Linus' tree.
> 
> > I suspect unit testing doesn't make much as much sense in staging
> > as it does in the core kernel.  I did testing of ramster in my
> 
> Of course it makes sense - at least at the "make sure it builds" level.
> 
> > public git tree (which includes the tmem patchset coming to you via
> > konrad) but, since it is a staging driver, the bits have to go
> > through Greg.
> 
> Maybe you should seek a dispensation from Greg to allow your ramster tree
> to exist independently in linux-next and be merged independently by
> Linus'.  Greg may want to keep watch in your tree, but that should not be
> much more effort than reviewing and applying your patches to the staging
> tree.

Ick, no, I'll just mark this as CONFIG_BROKEN for now, and things can be
fixed up later, during the 3.4 window as it should all settle down then.

thanks,

greg k-h
