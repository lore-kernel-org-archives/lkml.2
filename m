Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0KMLT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:19:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:40019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab0KMLTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:19:24 -0500
Message-ID: <4CDE73EB.2090208@kernel.org>
Date: Sat, 13 Nov 2010 12:18:03 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH UPDATED 1/5] mtd: fix bdev exclusive open bugs in block2mtd::add_device()
References: <1288628129-12811-1-git-send-email-tj@kernel.org>	 <1288628129-12811-2-git-send-email-tj@kernel.org>	 <4CDE6FAA.9030605@kernel.org> <1289646865.2218.27.camel@localhost>
In-Reply-To: <1289646865.2218.27.camel@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Nov 2010 11:18:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/13/2010 12:14 PM, Artem Bityutskiy wrote:
> On Sat, 2010-11-13 at 11:59 +0100, Tejun Heo wrote:
>> There are two bdev exclusive open bugs.
>>
>> * open_bdev_exclusive() must not be called with NULL holder.  Use dev
>>   as the holder.
>>
>> * open_by_devnum() doesn't open the bdev exclusively but
>>   block2mtd_free_device() always assumes it.  Explicitly claim the
>>   bdev.
>>
>> The latter is rather clumsy but will be simplified with future
>> blkdev_get/put() cleanups.
>>
>> - Updated to use local variable @mode to cache FMODE_* masks as
>>   suggested by Artem Bityutskiy.
> 
> Do you want this patch to go in via Jens' tree with the rest of the
> series, or as an independent patch via the mtd tree?

It probably would be easier if this is routed through Jens' tree as
it's necessary for later patches in the series, but this being a fix,
this should be merged during this cycle rather than the next one.
Jens, how do you want to proceed?

Thank you.

-- 
tejun
