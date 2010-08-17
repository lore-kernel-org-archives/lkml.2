Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0HQWby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:31:54 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55512 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751179Ab0HQWbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:31:46 -0400
Date: Tue, 17 Aug 2010 18:31:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Message-ID: <20100817223145.GC4641@Krystal>
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6B097E.7060505@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:30:53 up 207 days,  1:07,  3 users,  load average: 0.08, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Slaby (jirislaby@gmail.com) wrote:
> On 08/18/2010 12:09 AM, Mathieu Desnoyers wrote:
> > This is with these changes applied:
> 
> Hi, these are very wrong. Please use ones from:
> http://lkml.org/lkml/2010/8/12/98

Yep, my system boot fine now.

Any plans to fast-track these fixes to mainline ?

Thanks,

Mathieu

> 
> (there are three of them)
> 
> > --- linux.trees.git.orig/drivers/md/raid1.c	2010-08-17 17:40:52.000000000 -0400
> > +++ linux.trees.git/drivers/md/raid1.c	2010-08-17 17:42:59.000000000 -0400
> > @@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev,
> >  	struct bio_list bl;
> >  	struct page **behind_pages = NULL;
> >  	const int rw = bio_data_dir(bio);
> > -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
> > +	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;
> >  	bool do_barriers;
> >  	mdk_rdev_t *blocked_rdev;
> >  
> ...
> 
> regards,
> -- 
> js

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
