Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab1LHP6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:58:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1LHP6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:58:48 -0500
Date: Thu, 8 Dec 2011 10:58:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111208155844.GA9281@redhat.com>
References: <cover.1322709471.git.psusi@cfl.rr.com>
 <4ED6F320.5060709@cfl.rr.com>
 <20111208123038.GA16493@nb.redhat.com>
 <4EE0C814.2000807@cfl.rr.com>
 <20111208151650.GB16934@nb.redhat.com>
 <4EE0D6E6.9000807@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE0D6E6.9000807@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 10:25:26AM -0500, Phillip Susi wrote:
> On 12/8/2011 10:16 AM, Karel Zak wrote:
> >  Is it safe to alter the partition size in arbitrary way if the
> >  partition is used by any process?
> >
> >  Vivek's BLKPG_EXTEND_PARTITIONV seems more safety, because it extends
> >  a partition size only, so all offsets in all running stuff are still
> >  valid.
> >
> >  Maybe you need to check bdevp->bd_openers and returns -EBUSY if you
> >  want to alter the begin of the partition.
> 
> I disallowed altering the start of the partition ( that would just
> be crazy ), but altering the end has been supported on lvm for years
> now. Ext4 can not perform an online shrink, but btrfs can, and I was
> able to successfully have btrfs shrink the fs and then use
> BLKPG_RES_PARTITION to shrink the partition.

So, if there is an IO in flight while partition shrinking is happening,
then IO can end up happening outside the partition?

part->nr_sects can be 64 bits on 32bit machines and update will be
non-atomic. I had used sequence counter to make sure read is able
to get to intermediate value. May be it is a good idea to address
this concenrn.

Thanks
Vivek
