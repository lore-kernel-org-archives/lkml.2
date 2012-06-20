Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2FTGOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:14:07 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42291 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab2FTGOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:14:05 -0400
Message-ID: <4FE16A29.9050508@secunet.com>
Date: Wed, 20 Jun 2012 08:14:01 +0200
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
References: <4FDEC3C2.4060909@secunet.com> <x49fw9smohy.fsf@segfault.boston.devel.redhat.com> <4FE0155A.6010404@secunet.com> <x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jun 2012 06:14:02.0377 (UTC) FILETIME=[E351B790:01CD4EAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.06.2012 19:43, schrieb Jeff Moyer:

[...]

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

I can confirm that this patch fixes the problem for my test case too.
Here is the kernel output when performing the mount operation:

attempt to access beyond end of device
sda4: rw=0, want=4, limit=2
EXT3-fs (sda4): error: unable to read superblock

	Torsten
