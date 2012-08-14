Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2HNOd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:33:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2HNOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:33:56 -0400
Date: Tue, 14 Aug 2012 11:33:48 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v3 3/6] floppy: avoid leaking extra reference to queue on
 do_floppy_init error handling
Message-ID: <20120814143346.GC5277@herton-Z68MA-D2H-B3>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
 <1344881787-6422-4-git-send-email-herton.krzesinski@canonical.com>
 <1344914439.824.178.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344914439.824.178.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 04:20:39AM +0100, Ben Hutchings wrote:
> It's totally ridiculous that a driver should have to do this.  Any
> registered disk should have the GENHD_FL_UP flag set... so why can't
> genhd check it?  It doesn't look like floppy is the only driver affected
> by this problem, either.  So I suggest the following general fix
> (untested):
> 
> ---
> Subject: genhd: Make put_disk() safe for disks that have not been registered
> 
> Since commit 9f53d2f ('block: fix __blkdev_get and add_disk race
> condition'), add_disk() adds a reference to disk->queue, which is then
> dropped by disk_release().  But if a disk is destroyed without being
> registered through add_disk() (or if add_disk() fails at the first
> hurdle) then we have a reference imbalance.
> 
> Use the GENHD_FL_UP flag to tell whether this extra reference has been
> added.  Remove the incomplete workaround from the floppy driver.

Indeed this is a more sane/right approach.

Acked-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

Just the changelog is pointing to the wrong commit as already noted by
Stanislaw.

> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@vger.kernel.org

-- 
[]'s
Herton
