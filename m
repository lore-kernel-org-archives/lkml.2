Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0JTDH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:07:27 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:47962 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754587Ab0JTDHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:07:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMj4vUx5LdoF/2dsb2JhbAChVnLCZYVKBA
Date: Wed, 20 Oct 2010 14:07:04 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 26/35] fs: icache alloc anonymous inode allocation
Message-ID: <20101020030704.GH3740@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034658.215515030@kernel.dk>
 <20101019163327.GA5987@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019163327.GA5987@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:33:27PM -0400, Christoph Hellwig wrote:
> On Tue, Oct 19, 2010 at 02:42:42PM +1100, npiggin@kernel.dk wrote:
> > Provide new_anon_inode function for inodes without a default inode number, and
> > not on sb list. This can enable filesystems to reduce locking. "Real"
> > filesystems can also reduce locking by allocating anonymous inode first, then
> > adding it to lists after finding the inode number.
> 
> Having an _anon inode allocation for fileystsem that do manage the inode
> lifetime is fine, but please don't mix that up with i_ino assignment,
> as they are two totally different things.
> 
> Disk and network filesystem do not need a default i_ino, but they
> absolutely do no need their inodes to be on the per-sb list.
> anonfs/pipe/socket (and nothing else) can do away with the per-sb list,
> but they do need a pseudo inode number.

Probably bad wording of "anon". It should be "raw", maybe. The
filesystem is then of course responsible for adding i_ino and/or
to lists.


> I have a version of this port to Dave's tree which gets this right.
> i_ino assignment is already moved out by my patch (which should apply
> to your tree with minimal differences), so the new _anon only does not
> put the inode on the list.  The other difference is that we don't bother
> initializing i_sb_list in the main inode allocation path, but only in
> new_anon_inode, and that the function is not exported - it really should
> only be used for built-in filesystems that never get unmounted to be
> safe.

I'll check it.

