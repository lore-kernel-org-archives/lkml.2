Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab1LHPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:16:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab1LHPQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:16:56 -0500
Date: Thu, 8 Dec 2011 16:16:50 +0100
From: Karel Zak <kzak@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111208151650.GB16934@nb.redhat.com>
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F320.5060709@cfl.rr.com> <20111208123038.GA16493@nb.redhat.com> <4EE0C814.2000807@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE0C814.2000807@cfl.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 09:22:12AM -0500, Phillip Susi wrote:
> On 12/8/2011 7:30 AM, Karel Zak wrote:
>>   It seems very close to Vivek's BLKPG_EXTEND_PARTITION idea, see:
>>
>>      https://lkml.org/lkml/2011/9/1/351
>>
>>   It's evident that we (userspace) need something better than
>>   BLKPG_{ADD,DEL}_* and BLKRRPART, but no response from kernel side :-(
>
> Yes, this looks very similar to mine, except that I also wanted to allow  
> shrinking the partition, not just extending, since btrfs can handle this  
> ( tested ).

 Is it safe to alter the partition size in arbitrary way if the
 partition is used by any process?
 
 Vivek's BLKPG_EXTEND_PARTITIONV seems more safety, because it extends
 a partition size only, so all offsets in all running stuff are still
 valid.

 Maybe you need to check bdevp->bd_openers and returns -EBUSY if you
 want to alter the begin of the partition.

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
