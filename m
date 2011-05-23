Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab1EWRdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:33:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1EWRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:33:53 -0400
Date: Mon, 23 May 2011 13:33:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Alex Bligh <alex@alex.org.uk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and FS
 in general
Message-ID: <20110523173350.GA10554@infradead.org>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
 <20110523155550.GE4716@quack.suse.cz>
 <EC63F9E077B362A0FDCF3527@Ximines.local>
 <20110523172906.GH4716@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523172906.GH4716@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 07:29:06PM +0200, Jan Kara wrote:
>   Yes, but that's rather a deficiency in default mount options of ext3
> which is kept for backward buggy-for-performance compatibility. Anywone who
> seriously cares about the data should use barrier=1 and BTW SUSE or RH
> distros change the default to be barrier=1. Anyway, this is a seperate
> issue.

It really should be changed.  The previous (bad) excuse was that the
ordering barrier code was too much overhead.  Making a filesystem
non-safe by default is already a bad sin, but having the code to make
it safe around and not enabling it is plain criminal.

> > Would there be any interested in these patches if I cooked them up,
> > or did they die because of opposition before rather than apathy?
>   I guess you might come with some proposal and post it to linux-fsdevel
> (include Al Viro and Christoph Hellwig in CC) and see what happens...

There's no way to make it generic.  Fortunately adding support to a
filesystem is generally trivial, take a look at my recently added
cache flushing support for hfsplus for example.

