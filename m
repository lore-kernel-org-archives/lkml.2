Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0FXXGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:06:49 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51185 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0FXXGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:06:47 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=7yc1YO-cavgA:10 a=q8OS1GolVHwA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=SAn_kyeQSBpIsQccPjAA:9
 a=YWuWI40Vo9nLZnTZnOsA:7 a=IdaKXBCEj9y73LkJCuDe2MANk3QA:4 a=CjuIK1q_8ugA:10
Subject: Re: [rfc] new stat*fs-like syscall?
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4C2366F7.5010200@mit.edu>
Date: Thu, 24 Jun 2010 17:06:45 -0600
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9AFEC906-4EC6-49F3-8644-9230934E1D2C@dilger.ca>
References: <20100624131455.GA10441@laptop> <4C2366F7.5010200@mit.edu>
To: Andy Lutomirski <luto@mit.edu>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-24, at 08:08, Andy Lutomirski wrote:
> Something like fsid but actually specified to uniquely identify a superblock.  (Currently, fsid seems to be set by the filesystem, and nothing in particular ensures that two different filesystems couldn't have collisions.)  We could guarantee (or have a flag guaranteeing) that (fsid, st_inode) actually uniquely identifies an inode.

I think the right solution for this issue is to (gradually) start enforcing the "uniqueness" of the UUID in the filesystem superblock.  That is what it is supposed to be for.  Using (fsid, st_inode) doesn't necessarily help anything, if "fsid" isn't unique, and the same "st_inode" number is used on two different mountpoints.

To start, tracking the UUID at mount time an printing a non-fatal error at mount time if the mounted UUID is not unique would help, as would having e.g. fsck track the UUIDs of the underlying filesystems and printing a non-fatal error if it hits a duplicate UUID.  

At some point in the future, the kernel can be changed to refuse to mount a filesystem with a duplicate UUID.  I believe mount.xfs already does this.

Cheers, Andreas





