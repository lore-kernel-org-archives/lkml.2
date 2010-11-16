Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0KPVmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:42:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:40948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab0KPVmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:42:36 -0500
Date: Tue, 16 Nov 2010 22:42:33 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] udf: Replace bkl with the inode->i_alloc_sem for
 protect udf_inode_info struct
Message-ID: <20101116214233.GB15180@quack.suse.cz>
References: <1289929249-4863-1-git-send-email-abogani@texware.it>
 <20101116180544.GA29896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116180544.GA29896@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-11-10 13:05:44, Christoph Hellwig wrote:
> On Tue, Nov 16, 2010 at 06:40:47PM +0100, Alessio Igor Bogani wrote:
> > Replace bkl with the inode->i_alloc_sem rw semaphore in udf_release_file(),
> > udf_symlink(), udf_symlink_filler(), udf_get_block() and udf_block_map().
> > Add protection in udf_evict_inode() using the same i_alloc_sem rw semaphore.
> 
> I'd rather prefer not to introduce new users of i_alloc_sem.  It's a
> quite nasty beast: the only rw_semaphore that is not released by the
> thread acquiring it.  Thomas asked me if there's a way to get rid of it,
> and I've come up with some schemes that I need to prototype.  Adding
> more uses that are unrelated to the original direct I/O use case are
> not very helpful in doing that.
  OK, I didn't know this. It's no problem to replace i_alloc_sem with a
private rw_semaphore so I can do that. I just thought we might as well use
it when it's there and not waste more inode memory...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
