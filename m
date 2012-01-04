Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2ADSsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:48:21 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35776
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab2ADSsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:48:19 -0500
Date: Wed, 4 Jan 2012 13:47:46 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20120104184746.GA8461@infradead.org>
References: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
 <20120103133942.GC31457@quack.suse.cz>
 <20120103144531.GA23916@ZenIV.linux.org.uk>
 <20120104021754.GD23916@ZenIV.linux.org.uk>
 <20120104025020.GW23662@dastard>
 <20120104180033.GE28907@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104180033.GE28907@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 07:00:33PM +0100, Jan Kara wrote:
> On Wed 04-01-12 13:50:20, Dave Chinner wrote:
> > On Wed, Jan 04, 2012 at 02:17:54AM +0000, Al Viro wrote:
> > > I'm still not
> > > sure about ->statfs(), BTW - any input on that would be welcome.  Can
> > > it end up blocked on a frozen fs until said fs is thawed?
> > 
> > I don't see why this should ever happen - ->statfs has to work on
> > read-only filesystems so shoul dnot be modifying state, and hence
> > should never need to care about the frozen state of the superblock.
>   Well, I'm also not aware of a filesystem where ->statfs would wait on
> frozen filesystem. Just note that e.g. for stat(2) frozen filesystem and
> RO filesystem *are* different because of atime updates. So stat(2) can
> block on frozen fs because of atime update while on RO filesystem it is
> just fine.

Neither of those should cause atime updates.

