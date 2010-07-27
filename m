Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0G0SB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:01:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:47202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0G0SB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:01:57 -0400
Date: Tue, 27 Jul 2010 20:01:31 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100727180131.GG6820@quack.suse.cz>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
 <20100727170903.GA9034@infradead.org>
 <20100727172437.GE6820@quack.suse.cz>
 <20100727172731.GA25727@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727172731.GA25727@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-07-10 13:27:31, Christoph Hellwig wrote:
> On Tue, Jul 27, 2010 at 07:24:38PM +0200, Jan Kara wrote:
> >   Always returning inode->i_sb->s_bdi wouldn't be a right thing IMHO.
> > That would file inode for /dev/sda to BDI list of tmpfs mounted on /dev/
> > which isn't what you want...
> 
> It shouldn't.  Block device nodes are on the bdev filesystems, and
  Ok, so inode->i_sb->s_bdi will actually point to noop_backing_dev_info
as set by set_anon_super(). Or am I completely out?

> we twist the file->mapping pointer so that all the low-level read/write
> code always deals with the bdev fs inode, and not the device node
> filesystem.
  Yes, I know this but I fail to see how this influences where </dev/sda's
inode>->i_sb->s_bdi ends up...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
