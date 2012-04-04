Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2DDIBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2DDIBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:01:47 -0400
Date: Wed, 4 Apr 2012 11:01:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, KVM <kvm@vger.kernel.org>,
        SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>,
        Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Message-ID: <20120404080149.GC22658@redhat.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
 <4F7582B0.5010609@cn.fujitsu.com>
 <20120330152606.GB28934@google.com>
 <20120330152808.GC28934@google.com>
 <4F78FE89.2070707@cn.fujitsu.com>
 <20120402072009.GF30360@redhat.com>
 <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
 <1333392978.2971.25.camel@dabdike>
 <20120402190045.GC16226@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402190045.GC16226@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 12:00:45PM -0700, Tejun Heo wrote:
> Hello, James.
> 
> On Mon, Apr 02, 2012 at 11:56:18AM -0700, James Bottomley wrote:
> > So if we're agreed no other devices going forwards should ever use this
> > interface, is there any point unifying the interface?  No matter how
> > many caveats you hedge it round with, putting the API in a central place
> > will be a bit like a honey trap for careless bears.   It might be safer
> > just to leave it buried in the three current drivers.
> 
> Yeah, that was my hope but I think it would be easier to enforce to
> have a common function which is clearly marked legacy so that new
> driver writers can go look for the naming code in the existing ones,
> find out they're all using the same function which is marked legacy
> and explains what to do for newer drivers.
> 
> Thanks.

I think I'm not the only one to be confused about the
preferred direction here.
James, do you agree to the approach above?

It would be nice to fix virtio block for 3.4, so
how about this:
- I'll just apply the original bugfix patch for 3.4 -
  it only affects virtio
- Ren will repost the refactoring patch on top, and we can
  keep up the discussion

Ren if you agree, can you make this a two patch series please?

> -- 
> tejun
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
