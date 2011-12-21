Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1LUUqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:46:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1LUUqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:46:49 -0500
Date: Wed, 21 Dec 2011 15:46:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: joe@perches.com, kzak@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111221204641.GB27789@redhat.com>
References: <4EE6990A.9010202@cfl.rr.com>
 <1323735382-5972-1-git-send-email-psusi@cfl.rr.com>
 <20111219202527.GF7175@redhat.com>
 <4EF13C30.4050307@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF13C30.4050307@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 08:53:52PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/19/2011 03:25 PM, Vivek Goyal wrote:
> > Are there any restrictions on order of partition bdev and disk bdev
> > locking.
> 
> Good point, yes, it seems you need to take the partition first.  Now that I think about it though, I don't think we need the disk mutex at all.  I thought you needed to hold it in order to iterate over the partitions, but it looks like you don't since that uses an RCU, right?
> 

I guess taking disk mutex will help us providing mutual exclusion between
multiple ioctls or multiple instances of same ioctl. Like, while you are
extending a partition and checking for overlap, you don't want another call
making progress on next partition which might overlap with this partition.

Thanks
Vivek
