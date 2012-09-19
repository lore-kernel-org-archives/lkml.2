Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2ISPss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:48:48 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:32897 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666Ab2ISPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:48:45 -0400
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 11:48:45 EDT
Message-ID: <5059E581.8030600@rsk.demon.co.uk>
Date: Wed, 19 Sep 2012 16:32:17 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: jaxboe@fusionio.com, Mikulas Patocka <mpatocka@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] block: make struct block_device cacheline_aligned
References: <x49lig686kv.fsf@segfault.boston.devel.redhat.com> <x498vc683eq.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x498vc683eq.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/12 15:59, Jeff Moyer wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
> 
>> Hi,
>>
>> When testing against a pcie ssd or a ramdisk, making the block device
>> structure cacheline_aligned provided a significant increase in
>> performance:
> 
> Self-NACK on this one.  This results in a ton of warnings:
> 
> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> apply to types
> In file included from include/linux/debugfs.h:18,
>                  from kernel/trace/trace_probe.h:28,
>                  from kernel/trace/trace_kprobe.c:23:
> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> apply to types
> 
> And that leaves me with the task of figuring out if/why this actually
> helps.
> 
> Cheers,
> Jeff
>>
Hi,
block_device sits in bdev_inode which is already cache line aligned as
they're allocated in a kmem_cache with HWALIGN set.
So I wonder if swapping the order of bdev & inode in bdev_inode will help?

So it becomes this :-
struct bdev_inode {
	struct inode vfs_inode;
	struct block_device bdev;
};


regards
Richard

