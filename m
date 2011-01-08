Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1AIABQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 19:01:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab1AIABP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 19:01:15 -0500
Date: Sat, 8 Jan 2011 15:56:08 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Quick merge window note..
Message-ID: <20110108235608.GA4470@suse.de>
References: <AANLkTi=eNucM5d=+zq5euz3dZirJEhPaH9f9ZXuHymEM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=eNucM5d=+zq5euz3dZirJEhPaH9f9ZXuHymEM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 05:32:46PM -0800, Linus Torvalds wrote:
> But it's rather impressive and I really wanted to merge it, because
> some of the performance numbers are pretty stunning. For example, a
> hot-cache "find . -size" on my home directory (which basically just
> does name lookups to get the stat information for every file
> recursively) became 35% faster. And that's the _unthreaded_ case. Not
> some odd high-end scalability thing, and not some recompiled binary
> taking advantage of new facilities. Pathname lookup is just simply
> faster.
> 
> On the scary side, it's worth noticing that if you see any problems,
> and you think it might be due to the new rcu lookup, rather than
> bisect _everything_ (the merge window has already brought in 3700+
> commits), it may be worth just checking the VFS scale tip itself.
> That's fairly easy, because it's based on plain 2.6.37 (which if it
> isn't stable for you, we have bigger problems than the RCU lookup),
> and is just 57 commits up until commit b3e19d924b6e ("fs: scale
> mntget/mntput").

Thanks for the heads up.  In some initial testing here, it all looks
good to me.

greg k-h
