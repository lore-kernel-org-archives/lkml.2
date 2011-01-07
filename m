Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1AGScI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:32:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab1AGScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:32:07 -0500
Date: Fri, 7 Jan 2011 13:32:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110107183202.GA13586@infradead.org>
References: <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104092501.GB2760@infradead.org>
 <20110104094922.GA4812@amd>
 <20110106204510.GA2872@infradead.org>
 <20110107044734.GA4552@amd>
 <20110107072430.GA32308@infradead.org>
 <20110107072934.GA2849@infradead.org>
 <20110107183047.GB21922@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107183047.GB21922@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 01:30:47PM -0500, Ted Ts'o wrote:
> > the write_inode in XFS is already trying to do it, it's just the
> > caller not copying with it:
> > 
> >  - if we can't get locks for a non-blocking ->write_inode we return
> >    EAGAIN, and the callers sets the dirty bits again.
> 
> I like that solution; it might be one of the easier ways to maintain
> backwards compatibility.  Especially since (correct me if I am wrong)
> the simpler file systems which always write out the inode in the case
> of a non-blocking write_inode, say, like say the fat file system, are
> immune from this specific problem, right?

Yes.  Also one of the patches in Nick's series actually implements
this already.  Looks like we lost that fact when arguing about other
things..
