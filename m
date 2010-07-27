Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0G0R1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:27:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0G0R1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:27:31 -0400
Date: Tue, 27 Jul 2010 13:27:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100727172731.GA25727@infradead.org>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
 <20100727170903.GA9034@infradead.org>
 <20100727172437.GE6820@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727172437.GE6820@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 07:24:38PM +0200, Jan Kara wrote:
>   Always returning inode->i_sb->s_bdi wouldn't be a right thing IMHO.
> That would file inode for /dev/sda to BDI list of tmpfs mounted on /dev/
> which isn't what you want...

It shouldn't.  Block device nodes are on the bdev filesystems, and
we twist the file->mapping pointer so that all the low-level read/write
code always deals with the bdev fs inode, and not the device node
filesystem.

