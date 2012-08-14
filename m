Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2HNO1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:27:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab2HNO1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:27:04 -0400
Date: Tue, 14 Aug 2012 11:26:53 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 3/6] floppy: avoid leaking extra reference to queue on
 do_floppy_init error handling
Message-ID: <20120814142652.GB5277@herton-Z68MA-D2H-B3>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
 <1344881787-6422-4-git-send-email-herton.krzesinski@canonical.com>
 <1344914439.824.178.camel@deadeye.wl.decadent.org.uk>
 <20120814090330.GC2423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814090330.GC2423@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 11:03:30AM +0200, Stanislaw Gruszka wrote:
> On Tue, Aug 14, 2012 at 04:20:39AM +0100, Ben Hutchings wrote:
> > It's totally ridiculous that a driver should have to do this.  Any
> > registered disk should have the GENHD_FL_UP flag set... so why can't
> > genhd check it?  It doesn't look like floppy is the only driver affected
> > by this problem, either.  So I suggest the following general fix
> > (untested):
> > 
> > ---
> > Subject: genhd: Make put_disk() safe for disks that have not been registered
> > 
> > Since commit 9f53d2f ('block: fix __blkdev_get and add_disk race
> > condition'), add_disk() adds a reference to disk->queue,
> 
> I do not see this? Commit 9f53d2fe insert disk_alloc_events() to add_disk(),
> but disk_alloc_events() function does not get any reference to disk->queue,
> I missed something?

I think he meant commit 523e1d3 ("block: make gendisk hold a reference
to its queue") instead.

> 
> Stanislaw
> 

-- 
[]'s
Herton
