Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2AZVvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:51:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab2AZVvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:51:04 -0500
Date: Thu, 26 Jan 2012 16:50:55 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Niels de Vos <ndevos@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
In-Reply-To: <20120126214534.GA9319@infradead.org>
Message-ID: <Pine.LNX.4.64.1201261646570.28710@hs20-bc2-1.build.redhat.com>
References: <4F213E1A.4060808@redhat.com> <1327584802-14298-1-git-send-email-ndevos@redhat.com>
 <20120126134051.6add3cd2.akpm@linux-foundation.org> <20120126214534.GA9319@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jan 2012, Christoph Hellwig wrote:

> On Thu, Jan 26, 2012 at 01:40:51PM -0800, Andrew Morton wrote:
> > The Right Thing To Do here is to make the kernel behave logically and
> > predictably, then modify the userspace tools.  But if we're modifying
> > the userspace tools then we would just change userspace to issue a
> > BLKFLSBUF to /dev/sda and leave the kernel alone.
> 
> The right fix is to make partition and whole disk access coherent,
> which is fairly simply:
> 
>  - create the block device inode/mapping per gendisk, and only reference
>    count it per block_device
>  - make sure blkdev_get_block(s) applies the correct offset if used on
>    partitions

... and what if you use 4kB blocksize and the partition start is not 
aligned on 4kB? (quite common case, because partitions are often aligned 
on 63 sectors) Then, you can't translate partition block numbers into disk 
block numbers.

Mikulas
