Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2GWTWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab2GWTWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:22:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, <amethyst623@163.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
References: <Pine.LNX.4.44L0.1207231505520.1633-100000@iolanthe.rowland.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Jul 2012 15:22:19 -0400
In-Reply-To: <Pine.LNX.4.44L0.1207231505520.1633-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon, 23 Jul 2012 15:07:24 -0400 (EDT)")
Message-ID: <x49394ith90.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 20 Jun 2012, Jeff Moyer wrote:
>
>> Alan Stern <stern@rowland.harvard.edu> writes:
>> 
>> > On Tue, 19 Jun 2012, Dima Tisnek wrote:
>> >
>> >> I made a microsd flash with 2 partitions, sdb1 is data partition, and
>> >> sdb2 is a sentinel partition, 1 block in size.
>> >> 
>> >> I attached the usb-microsd reader with that card in it and by mistake
>> >> tried to mount the sentinel partition, I ran:
>> >> mount /dev/sdb2 /mnt/flash/
>> >> 
>> >> mount got stuck, I was not able to kill or strace it, I pulled the usb
>> >> reader from the port, mount was still stuck, here's the dmesg log:
>> 
>> Hi, Dima,
>> 
>> Could you try the following patch?
>> 
>> Thanks,
>> Jeff
>> 
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 838a9cf..769b30b 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -930,7 +930,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>>  			bh->b_blocknr = block;
>>  			if (uptodate)
>>  				set_buffer_uptodate(bh);
>> -			if (block < end_block)
>> +			if (block <= end_block)
>>  				set_buffer_mapped(bh);
>>  		}
>>  		block++;
>
> Jeff, does this also fix Bugzilla #43269?

First, this patch is wrong.  I posted another version later on that got
merged for 3.5.

As for bug 43269, it does not look like the same symptoms, so I would
not expect the patches I posted to resolve that issue.  Sorry.

Cheers,
Jeff
