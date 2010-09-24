Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab0IXUVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:21:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab0IXUVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:21:21 -0400
Date: Fri, 24 Sep 2010 16:21:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, Mark Lord <mlord@pobox.com>
Subject: Re: [RFT PATCH] amiga, atari floppy: Use one request queue per disk
Message-ID: <20100924202106.GC7145@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
 <4C9CEFD6.3000106@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9CEFD6.3000106@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 08:37:10PM +0200, Jens Axboe wrote:
> On 2010-09-23 21:54, Vivek Goyal wrote:
> > Hi,
> > 
> > We seem to have deprecated the notion of sharing request queue across gendisks. Now we need to instanciate one request queue per disk.
> > 
> > There see to be still some drivers sharing request queue across disks. Arch
> > specific floppy drivers like amiga and atari are doing so.
> > 
> > These are two patches which should fix the issue. But these patches are
> > completely untested. Not even compilte tested. Don't have hardware to test
> > them. 
> > 
> > Would be great if somebody who has the hardware can lend a hand here to
> > see if these patches work.
> 
> I have (tentatively) added both patches to for-2.6.37/drivers. I used the
> latter version of 2/2.

Also which cross compiling for m68k, I noticed following commit fails
compilation. I had to reset git to older commit to test amiga and atari
flopply driver compilation.

*******************************************************************
block/blk-exec.c: In function 'blk_execute_rq':
block/blk-exec.c:101: error: 'sysctl_hung_task_timeout_secs' undeclared
(first use in this function)
block/blk-exec.c:101: error: (Each undeclared identifier is reported only
once
block/blk-exec.c:101: error: for each function it appears in.)
make[1]: *** [block/blk-exec.o] Error 1
make: *** [block] Error 2
***********************************************************************

commit 4b1977698ceb4c4caa800d475127139da49966f9
Author: Mark Lord <kernel@teksavvy.com>
Date:   Fri Sep 24 09:51:13 2010 -0400

    block: Prevent hang_check firing during long I/O
    
    During long I/O operations, the hang_check timer may fire,
    trigger stack dumps that unnecessarily alarm the user.
    
    Eg.  hdparm --security-erase NULL /dev/sdb  ## can take *hours* to
complete
    
    So, if hang_check is armed, we should wake up periodically
    to prevent it from triggering.  This patch uses a wake-up interval
    equal to half the hang_check timer period, which keeps overhead low
enough.
    
    Signed-off-by: Mark Lord <mlord@pobox.com>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

Thanks
Vivek
