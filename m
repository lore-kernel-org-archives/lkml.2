Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2FLOcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:32:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2FLOcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:32:23 -0400
Date: Tue, 12 Jun 2012 16:32:20 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alex Elder <elder@kernel.org>, linux-fsdevel@suse.cz,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 18/27] xfs: Convert to new freezing code
Message-ID: <20120612143220.GG6021@quack.suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
 <1339510848-16992-19-git-send-email-jack@suse.cz>
 <20120612142346.GA25132@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612142346.GA25132@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-06-12 10:23:47, Christoph Hellwig wrote:
> > +	 * We will pass freeze protection with a transaction.  So tell lockdep
> > +	 * we released it.
> > +	 */
> > +	rwsem_release(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> > +		      1, _THIS_IP_);
> 
> I'll need some time to get through the whole series, but repeated use
> of constructs like this really screams for a helper abstracting it out
> and documenting it.
  It's there twice and only in XFS because XFS needs to pass the freeze
protection (along with a transaction) to a worker thread. I'm not against a
helper but then it should probably be in a form to allow easy
instrumentation of lockdep that we are passing a state of lock together
with a work struct?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
