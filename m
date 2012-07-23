Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2GWTH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:07:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38474 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754520Ab2GWTH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:07:26 -0400
Date: Mon, 23 Jul 2012 15:07:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeff Moyer <jmoyer@redhat.com>
cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, <amethyst623@163.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
In-Reply-To: <x49lijhyg58.fsf@segfault.boston.devel.redhat.com>
Message-ID: <Pine.LNX.4.44L0.1207231505520.1633-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Jeff Moyer wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Tue, 19 Jun 2012, Dima Tisnek wrote:
> >
> >> I made a microsd flash with 2 partitions, sdb1 is data partition, and
> >> sdb2 is a sentinel partition, 1 block in size.
> >> 
> >> I attached the usb-microsd reader with that card in it and by mistake
> >> tried to mount the sentinel partition, I ran:
> >> mount /dev/sdb2 /mnt/flash/
> >> 
> >> mount got stuck, I was not able to kill or strace it, I pulled the usb
> >> reader from the port, mount was still stuck, here's the dmesg log:
> 
> Hi, Dima,
> 
> Could you try the following patch?
> 
> Thanks,
> Jeff
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 838a9cf..769b30b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -930,7 +930,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>  			bh->b_blocknr = block;
>  			if (uptodate)
>  				set_buffer_uptodate(bh);
> -			if (block < end_block)
> +			if (block <= end_block)
>  				set_buffer_mapped(bh);
>  		}
>  		block++;

Jeff, does this also fix Bugzilla #43269?

Alan Stern

