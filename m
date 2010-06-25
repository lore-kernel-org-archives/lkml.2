Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab0FYGiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 02:38:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab0FYGiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 02:38:01 -0400
Date: Fri, 25 Jun 2010 02:37:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Andy Lutomirski <luto@mit.edu>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100625063755.GB4128@infradead.org>
References: <20100624131455.GA10441@laptop>
 <4C2366F7.5010200@mit.edu>
 <9AFEC906-4EC6-49F3-8644-9230934E1D2C@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9AFEC906-4EC6-49F3-8644-9230934E1D2C@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 05:06:45PM -0600, Andreas Dilger wrote:
> I think the right solution for this issue is to (gradually) start enforcing the "uniqueness" of the UUID in the filesystem superblock.  That is what it is supposed to be for.  Using (fsid, st_inode) doesn't necessarily help anything, if "fsid" isn't unique, and the same "st_inode" number is used on two different mountpoints.
> 
> To start, tracking the UUID at mount time an printing a non-fatal error at mount time if the mounted UUID is not unique would help, as would having e.g. fsck track the UUIDs of the underlying filesystems and printing a non-fatal error if it hits a duplicate UUID.  
> 
> At some point in the future, the kernel can be changed to refuse to mount a filesystem with a duplicate UUID.  I believe mount.xfs already does this.

Tracking and exposing the uuid to be exact.  Having the full uuid in a
statfs/statvfs-like system call is one first step.  And yes, XFS does
check the uuid during mount.  But it's actually in kernelspace, not in a
mount helper which XFS doesn't have.  Take a look at xfs_uuid_mount().

