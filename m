Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1G0UF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:05:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38624
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab1G0UFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:05:55 -0400
Date: Wed, 27 Jul 2011 16:05:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Message-ID: <20110727200550.GA23416@infradead.org>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
 <20110727160752.GC974@fieldses.org>
 <alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
 <20110727181111.GA23009@infradead.org>
 <alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
 <20110727193937.GA5354@infradead.org>
 <alpine.DEB.2.02.1107271540100.1451@p34.internal.lan>
 <20110727194722.GA9345@infradead.org>
 <4E306D09.5030704@netapp.com>
 <20110727200240.GA16054@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727200240.GA16054@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 04:02:40PM -0400, Christoph Hellwig wrote:
> But looking closer at it it only prints the directory name and not that
> of any of the matching cookies, making it pretty useless to debug any
> problem.  (and it makes my previous question to Justin look stupid..).
> 
> 
> But so far I still stick to my previous theory that this sounds like
> a directory offset getting reused.  How is cache invalidation for
> the array supposed to work?  And maybe more importantly, given that he
> can only reproduce it with a .38 client did any bugs get fixed in that
> code recently that might lead to issues with the cache invalidation?

Actually we won't even need cache invalidation bugs, see
nfsd_buffered_readdir() - we might do multiple vfs_readdir calls to
fill a single nfs reply, and between these two directory contents might
have been completely replaced, in the worst (pathological case) you
might get a second readdir having exactly the same offsets, but pointing
to completely different inodes.

