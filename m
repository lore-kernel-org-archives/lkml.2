Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1K3Gw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:52:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1K3Gw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:52:56 -0500
Date: Wed, 30 Nov 2011 01:52:22 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jan Kara <jack@suse.cz>
cc: Alasdair G Kergon <agk@redhat.com>, esandeen@redhat.com,
        Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
In-Reply-To: <20111129133239.GA9926@quack.suse.cz>
Message-ID: <Pine.LNX.4.64.1111300143340.31264@hs20-bc2-1.build.redhat.com>
References: <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz> <20111129102156.GA7463@quack.suse.cz>
 <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
 <20111129111136.GC5635@quack.suse.cz> <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com>
 <20111129130913.GE5635@quack.suse.cz> <20111129131811.GS7595@agk-dp.fab.redhat.com>
 <20111129133239.GA9926@quack.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > dm-ioctl.h:
> > /*
> >  * Set this to avoid attempting to freeze any filesystem when suspending.
> >  */
> > #define DM_SKIP_LOCKFS_FLAG     (1 << 10) /* In */
>   Thanks. I was now checking in detail and indeed FIFREEZE fails if
> ->freeze_fs is not set. And only xfs, ext3, ext4, reiserfs, jfs, nilfs2,
> and gfs2 provide this function. So I was correct in assuming that when
> filesystem supports FIFREEZE it must make sure no modifications happen to
> the filesystem. So I believe that my original plan for sync to skip frozen
> filesystem is correct.
> 
> 								Honza

LVM doesn't suspend with FIFREEZE, it calls freeze_bdev directly from 
drivers/md/dm.c (and it works for all filesystems, including ext2). So if 
you skip sync of frozen filesystems, you introduce a data corruption if 
someone takes a snapshot of ext2.

Mikulas
