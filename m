Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab2KTOXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:23:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab2KTOXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:23:43 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH v1 0/9] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 20 Nov 2012 09:23:18 -0500
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org> (Darrick
	J. Wong's message of "Mon, 19 Nov 2012 23:41:16 -0800")
Message-ID: <x49pq38jquh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> Hi everybody,
>
> On March 29th, Jeff Moyer posted to lkml a patchset with this note:
>
>> Currently, AIO+DIO+O_SYNC writes are not actually sync'd (for xfs), or they
>> are sync'd before the I/O is actually issued (everybody else).  The following
>> patch series fixes this in two parts.  First, for the file systems that use
>> the generic routines, Jan has provided some generic infrastructure to perform
>> the syncs after the I/O is completed.  Second, for those file systems which
>> require some endio processing of their own for O_DIRECT writes (xfs and
>> ext4), [Jeff] implemented file system specific syncing.  This passes the
>> updated xfs-tests 113 test [Jeff] posted earlier, as well as all of the tests
>> in the aio group.  [Jeff] tested ext3, ext4, xfs, and btrfs only.
>
> Since the original post a few months ago, this patchset doesn't seem to have
> made any progress.  An internal testing team here discovered that the issue
> also affects O_SYNC+AIO+DIO writes to block devices.  Worse yet, since the
> flushes were being issued (and waited upon) directly in the io_submit call
> graph, the io_submit calls themselves would take a very long time to complete.
> Therefore, I added another patch to move the flush to the io_end processing.
>
> The blockdev patch was written by me.  The ext4 patch had to be updated to
> accomodate a rework of the ext4 endio code that landed since March.  Everything
> else has been passed through from Jeff's March 30th resend, with few changes.
>
> This patchset has been tested (albeit lightly) against 3.7-rc6 on x64, with
> ext4, xfs, btrfs, vfat, jfs, hfsplus, ext2, ext3, and raw block devices.
>
> Comments and questions are, as always, welcome.

Hi, Darrick,

I just finished testing my version of this patch set on ext4 and xfs
(btrfs is next), but you beat me to the posting!  Sorry, I should have
been more clear when I said I would see about refreshing the series.

How have you tested these patches?  You just said "lightly", and I'm
afraid I don't know what that means.  xfstests?  You should at least run
them through test 113.

Would you like to push the set in, or should I post the patches I've
got?  Doesn't matter to me, just let me know.

Cheers,
Jeff
