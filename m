Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab2FOOXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:23:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab2FOOXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:23:06 -0400
Date: Fri, 15 Jun 2012 16:23:03 +0200
From: Jan Kara <jack@suse.cz>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Message-ID: <20120615142303.GB19045@quack.suse.cz>
References: <1339757457-15646-1-git-send-email-jack@suse.cz>
 <4FDB13B1.8040100@kernel.dk>
 <20120615135825.GA12847@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615135825.GA12847@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15-06-12 09:58:25, Nick Bowler wrote:
> On 2012-06-15 12:51 +0200, Jens Axboe wrote:
> > On 06/15/2012 12:50 PM, Jan Kara wrote:
> > > Sometimes, warnings about ioctls to partition happen often enough that they
> > > form majority of the warnings in the kernel log and users complain. In some
> > > cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> > > the warnings completely as they can ease debugging of userspace problems
> > > when ioctl is refused.
> > > 
> > > Since I have seen warnings from lots of commands, including some proprietary
> > > userspace applications, I don't think disallowing the ioctls for processes
> > > with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> > > stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> > 
> > Agree, merged, finally.
> 
> Hurray!
> 
> This should be -stable material as well, as >=3.2.y kernel versions are
> affected (I think 3.0.y is OK?).
  3.0 also spits those warnings. But I'm not convinced this is really a
-stable material. I don't see anybody loosing sleep over this...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
