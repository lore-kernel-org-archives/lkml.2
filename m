Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0KFNdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 09:33:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33305 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0KFNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 09:33:36 -0400
Date: Sat, 6 Nov 2010 13:33:30 +0000
From: James Hogan <james@albanarts.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/16 v2] pramfs: XIP operations
Message-ID: <20101106133330.GC13522@gandalf.local>
References: <4CD518EF.3030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CD518EF.3030306@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Nov 06, 2010 at 09:59:27AM +0100, Marco Stornelli wrote:
> diff -Nurp linux-2.6.36-orig/fs/pramfs/xip.c linux-2.6.36/fs/pramfs/xip.c
> --- linux-2.6.36-orig/fs/pramfs/xip.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/xip.c	2010-09-14 18:49:52.000000000 +0200
<snip>
> +static int pram_find_and_alloc_blocks(struct inode *inode, sector_t iblock,
> +				     sector_t *data_block, int create)
> +{
> +	int err = -EIO;
> +	u64 block;
> +
> +	mutex_lock(&PRAM_I(inode)->truncate_lock);

fs/pramfs/xip.c: In function ‘pram_find_and_alloc_blocks’:
fs/pramfs/xip.c:27: error: ‘struct pram_inode_vfs’ has no member named
‘truncate_lock’
fs/pramfs/xip.c:52: error: ‘struct pram_inode_vfs’ has no member named
‘truncate_lock’

i guess that should be truncate_mutex.

> +
> +	block = pram_find_data_block(inode, iblock);
> +
> +	if (!block) {
> +		if (!create) {
> +			err = -ENODATA;
> +			goto err;
> +		}
> +
> +		err = pram_alloc_blocks(inode, iblock, 1);
> +		if (err)
> +			goto err;
> +
> +		block = pram_find_data_block(inode, iblock);
> +		if (!block) {
> +			err = -ENODATA;
> +			goto err;
> +		}
> +	}
> +
> +	*data_block = block;
> +	err = 0;
> +
> + err:
> +	mutex_unlock(&PRAM_I(inode)->truncate_lock);

same here

> +	return err;
> +}

Cheers
James
