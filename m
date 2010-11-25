Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0KYLzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:55:04 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:55345 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab0KYLzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:55:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPvb7Ux5LcZJ/2dsb2JhbACjCnK+KIVHBA
Date: Thu, 25 Nov 2010 22:54:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        Boaz Harrosh <bharrosh@panasas.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Bob Copeland <me@bobcopeland.com>, reiserfs-devel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Possible data integrity problems in lots of
 filesystems?
Message-ID: <20101125115457.GB3643@amd>
References: <20101125074909.GA4160@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125074909.GA4160@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 06:49:09PM +1100, Nick Piggin wrote:
> Second is confusing sync and async inode metadata writeout
> Core code clears I_DIRTY_SYNC and I_DIRTY_DATASYNC before calling
> ->write_inode *regardless* of whether it is a for-integrity call or
> not. This means background writeback can clear it, and subsequent
> sync_inode_metadata or sync(2) call will skip the next ->write_inode
> completely.

Hmm, this also means that write_inode_now(sync=1) is buggy. It
needs to in fact call ->fsync -- which is a file operation
unfortunately, Christoph didn't you have some patches to move it
into an inode operation?

