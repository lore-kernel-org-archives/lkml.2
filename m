Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1LHQ2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:28:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1LHQ2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:28:52 -0500
Date: Thu, 8 Dec 2011 11:28:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111208162847.GB9281@redhat.com>
References: <cover.1322709471.git.psusi@cfl.rr.com>
 <4ED6F320.5060709@cfl.rr.com>
 <20111208123038.GA16493@nb.redhat.com>
 <4EE0C814.2000807@cfl.rr.com>
 <20111208151650.GB16934@nb.redhat.com>
 <4EE0D6E6.9000807@cfl.rr.com>
 <20111208155844.GA9281@redhat.com>
 <4EE0E085.8000907@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE0E085.8000907@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 11:06:29AM -0500, Phillip Susi wrote:
> On 12/8/2011 10:58 AM, Vivek Goyal wrote:
> >So, if there is an IO in flight while partition shrinking is happening,
> >then IO can end up happening outside the partition?
> 
> Yes.  Of course if there was an in flight IO at the time you
> truncate the partition, then you did something wrong ( didn't shrink
> the fs first ).

Ok, so one needs to shrink filesystem. So if partition is part of a
volume group one is supposed to first reduce the size using pvresize
and then shrink actual partition?

> 
> >part->nr_sects can be 64 bits on 32bit machines and update will be
> >non-atomic. I had used sequence counter to make sure read is able
> >to get to intermediate value. May be it is a good idea to address
> >this concenrn.
> 
> Isn't that what the mutex is for?

I thought I have found couple of places where we don't take mutex. For
example.

drive_stat_acct()
 disk_map_sector_rcu()
  sector_in_part()
    --> read part->nr_sects without mutex.

printk_all_partitions()
   ---> read part->nr_sects without mutex.

show_partition()
   ---> read part->nr_sects without mutex.

Thanks
Vivek
