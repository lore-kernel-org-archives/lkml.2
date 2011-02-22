Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1BVOVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:21:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1BVOU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:20:59 -0500
Date: Tue, 22 Feb 2011 09:20:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, neilb@suse.de,
        tj@kernel.org, jmoyer@redhat.com, snitzer@redhat.com
Subject: Re: [PATCH 2/3] loop: No need to initialize ->queue_lock explicitly
 before calling blk_cleanup_queue()
Message-ID: <20110222142050.GB28269@redhat.com>
References: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
 <1298346817-26144-3-git-send-email-vgoyal@redhat.com>
 <20110222073032.GA4555@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222073032.GA4555@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:30:32AM +0200, Sergey Senozhatsky wrote:
> On (02/21/11 22:53), Vivek Goyal wrote:
> > o Now we initialize ->queue_lock at queue allocation time so driver does
> >   not have to worry about initializing it before calling blk_cleanup_queue().
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  drivers/block/loop.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> > index 49e6a54..44e18c0 100644
> > --- a/drivers/block/loop.c
> > +++ b/drivers/block/loop.c
> > @@ -1641,9 +1641,6 @@ out:
> >  
> >  static void loop_free(struct loop_device *lo)
> >  {
> > -	if (!lo->lo_queue->queue_lock)
> > -		lo->lo_queue->queue_lock = &lo->lo_queue->__queue_lock;
> > -
> >  	blk_cleanup_queue(lo->lo_queue);
> >  	put_disk(lo->lo_disk);
> >  	list_del(&lo->lo_list);
> 
> Hi,
> 
> (just for note) 
> There is an incremental patch fixing this case in Andrew's mm tree: 
> https://lkml.org/lkml/2011/2/11/165
>                                    
> (block-fix-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v4.patch
> added to -mm tree).

Hi Sergey,

Thinking more about it, initializing queue lock in blk_alloc_queue() seems
to be even more cleaner to me instead of initializing it to internal lock
during blk_cleanup_queue(). If others like the idea, then we can either
ask Andrew to drop the patch or I can generate one on top of it.

Thanks
Vivek
