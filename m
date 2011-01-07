Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1AGSa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:30:57 -0500
Received: from THUNK.ORG ([69.25.196.29]:45348 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab1AGSaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:30:55 -0500
Date: Fri, 7 Jan 2011 13:30:47 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110107183047.GB21922@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104092501.GB2760@infradead.org>
 <20110104094922.GA4812@amd>
 <20110106204510.GA2872@infradead.org>
 <20110107044734.GA4552@amd>
 <20110107072430.GA32308@infradead.org>
 <20110107072934.GA2849@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107072934.GA2849@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:29:34AM -0500, Christoph Hellwig wrote:
> Btw, there's an easy way how we could get this right, in fact
> the write_inode in XFS is already trying to do it, it's just the
> caller not copying with it:
> 
>  - if we can't get locks for a non-blocking ->write_inode we return
>    EAGAIN, and the callers sets the dirty bits again.

I like that solution; it might be one of the easier ways to maintain
backwards compatibility.  Especially since (correct me if I am wrong)
the simpler file systems which always write out the inode in the case
of a non-blocking write_inode, say, like say the fat file system, are
immune from this specific problem, right?

						- Ted
