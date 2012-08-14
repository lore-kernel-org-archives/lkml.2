Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2HNOnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:43:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2HNOnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:43:18 -0400
Date: Tue, 14 Aug 2012 11:43:11 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 4/6] floppy: properly handle failure on add_disk loop
Message-ID: <20120814144310.GD5277@herton-Z68MA-D2H-B3>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
 <1344881787-6422-5-git-send-email-herton.krzesinski@canonical.com>
 <1344915083.824.182.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344915083.824.182.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 04:31:23AM +0100, Ben Hutchings wrote:
> On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> > On do_floppy_init, if something failed inside the loop we call add_disk,
> > there was no cleanup of previous iterations in the error handling.
> > 
> > Cc: stable@vger.kernel.org
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> This depends on 3/6.  If that's replaced by my proposed fix, then:
> 
> > ---
> >  drivers/block/floppy.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> > index 9272203..3eafe93 100644
> > --- a/drivers/block/floppy.c
> > +++ b/drivers/block/floppy.c
> > @@ -4294,7 +4294,7 @@ static int __init do_floppy_init(void)
> >  
> >  		err = platform_device_register(&floppy_device[drive]);
> >  		if (err)
> > -			goto out_release_dma;
> > +			goto out_remove_drives;
> >  
> >  		err = device_create_file(&floppy_device[drive].dev,
> >  					 &dev_attr_cmos);
> > @@ -4313,6 +4313,14 @@ static int __init do_floppy_init(void)
> >  
> >  out_unreg_platform_dev:
> >  	platform_device_unregister(&floppy_device[drive]);
> > +out_remove_drives:
> > +	while (drive--) {
> > +		if (disk_registered[drive]) {
> 
> I think the test of allowed_drive_mask and FDC version before
> registering each driver should be factored out into a function that you
> can use here.  There would then no need for the disk_registered array.

Seems a better approach. I'll redo the patches, but I'm not sure how to
proceed now, since it depends on your change. Patches 4-6 that I did
needs to be dropped/redone. At first my patches 0001/0002 could be
applied with yours, then I would submit another series for the rest. Or
I could take your change and submit your patch along with my series.

> 
> Ben.
> 

-- 
[]'s
Herton
