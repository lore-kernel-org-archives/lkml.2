Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2AZWal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:30:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab2AZWaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:30:39 -0500
Date: Thu, 26 Jan 2012 23:30:37 +0100
From: Jan Kara <jack@suse.cz>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
Subject: Ioctl warning for a partition
Message-ID: <20120126223037.GE28368@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  with your patches (commit 0bfc96cb in particular) to limit ioctl on
partitions we get warning:
dd: sending ioctl 80306d02 to a partition!
because dd checks whether given device is a tape (it's MTIOCGET ioctl).
It's easy enough to silence the warning the same way as
CDROM_GET_CAPABILITY since the ioctl is safe but it's not so simple for
32-bit userspace.  MTIOCGET32 is defined only in fs/compat_ioctl.c so we
cannot easily add it to scsi_verify_blk_ioctl(). Any opinion how to cleanly
solve this? The only idea I had was to define compat structures and ioctl
numbers in a special header and use it both in fs/compat_ioctl.c and in
block/scsi_ioctl.c.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
