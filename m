Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0LXI2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 03:28:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53054 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0LXI2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:28:06 -0500
Date: Fri, 24 Dec 2010 08:27:36 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Takashi Iwai'" <tiwai@suse.de>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassi.brar@samsung.com>
Subject: Re: linux-next: manual merge of the sound tree with the s5p tree
Message-ID: <20101224082736.GA31540@flint.arm.linux.org.uk>
References: <20101223115339.1ce18216.sfr@canb.auug.org.au> <003f01cba28c$872214f0$95663ed0$%kim@samsung.com> <s5hk4j0n43g.wl%tiwai@suse.de> <004001cba292$3827d2d0$a8777870$%kim@samsung.com> <s5hvd2ku49r.wl%tiwai@suse.de> <004101cba294$8639de30$92ad9a90$%kim@samsung.com> <s5h7hf0tvct.wl%tiwai@suse.de> <008f01cba30a$72f5c160$58e14420$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008f01cba30a$72f5c160$58e14420$%kim@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 10:32:33AM +0900, Kukjin Kim wrote:
> Takashi Iwai wrote:
> > I basically don't like to rebase and the commits have been already in
> > sound tree, but if this is the only way and Russell prefers this, it
> > can be a possible option.
> > 
> I agree with you...now, rebase stuff is unnecessary load to you.
> 
> Ok...firstly, need to ask to Russell.
> (Added Russell in To)
> 
> Hi Russell,
> 
> Sorry for bothering...
> If possible, please read this thread :-)
> 
> So...
> 
> May/Should I merge sound tree for avoiding build error and conflict between
> each other for 37 merge window instead of cherry-pick?

IMHO it is never appropriate to cherry pick commits from someone elses
tree into your own tree as it creates duplicates in the history.

What would be better is to talk to the person who owns the tree with
the commits you're interested in, and see about merging the minimal
set of commits you need into your own tree.  They may tell you the
name of a branch for you to merge into your tree (preferred), or more
obscurely tell you a commit id in their tree.

Now there are two options:
- If you know the branch you need, you can then either pull that branch
  into your tree, and commit the dependent patches on top of that.

- If you only have a commit ID in the remote tree, you can fetch their
  tree first, use gitk to visualize the history and check you have it,
  and then do:
    git merge --no-commit <commitid>
  in your tree.  Then commit the result with your own commit message
  explaining what's going on.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
