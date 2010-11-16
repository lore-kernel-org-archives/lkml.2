Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0KPSFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:05:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab0KPSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:05:50 -0500
Date: Tue, 16 Nov 2010 13:05:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] udf: Replace bkl with the inode->i_alloc_sem for
 protect udf_inode_info struct
Message-ID: <20101116180544.GA29896@infradead.org>
References: <1289929249-4863-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289929249-4863-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 06:40:47PM +0100, Alessio Igor Bogani wrote:
> Replace bkl with the inode->i_alloc_sem rw semaphore in udf_release_file(),
> udf_symlink(), udf_symlink_filler(), udf_get_block() and udf_block_map().
> Add protection in udf_evict_inode() using the same i_alloc_sem rw semaphore.

I'd rather prefer not to introduce new users of i_alloc_sem.  It's a
quite nasty beast: the only rw_semaphore that is not released by the
thread acquiring it.  Thomas asked me if there's a way to get rid of it,
and I've come up with some schemes that I need to prototype.  Adding
more uses that are unrelated to the original direct I/O use case are
not very helpful in doing that.

