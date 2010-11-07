Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0KGUIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:08:22 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:62425 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751441Ab0KGUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:08:20 -0500
Message-ID: <4CD7076D.80507@bluewatersys.com>
Date: Mon, 08 Nov 2010 09:09:17 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/16 v2] pramfs: headers
References: <4CD518C5.6000509@gmail.com>
In-Reply-To: <4CD518C5.6000509@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 09:58 PM, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Definitions for the PRAMFS filesystem.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> diff -Nurp linux-2.6.36-orig/fs/pramfs/pram.h linux-2.6.36/fs/pramfs/pram.h
> --- linux-2.6.36-orig/fs/pramfs/pram.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/pram.h	2010-10-30 12:02:45.000000000 +0200
> @@ -0,0 +1,317 @@

> +/*
> + * Structure of the super block in PRAMFS
> + */
> +struct pram_super_block {
> +	__be16	s_sum;          /* checksum of this sb, including padding */
> +	__be64	s_size;         /* total size of fs in bytes */
> +	__be32	s_blocksize;    /* blocksize in bytes */
> +	__be32	s_inodes_count;	/* total inodes count (used or free) */
> +	__be32	s_free_inodes_count;/* free inodes count */
> +	__be32	s_free_inode_hint;  /* start hint for locating free inodes */
> +	__be32	s_blocks_count;	/* total data blocks count (used or free) */
> +	__be32	s_free_blocks_count;/* free data blocks count */
> +	__be32	s_free_blocknr_hint;/* free data blocks count */
> +	__be64	s_bitmap_start; /* data block in-use bitmap location */
> +	__be32	s_bitmap_blocks;/* size of bitmap in number of blocks */
> +	__be32	s_mtime;	/* Mount time */
> +	__be32	s_wtime;	/* Write time */
> +	__be16	s_magic;	/* Magic signature */
> +	char	s_volume_name[16]; /* volume name */
> +};

Is there a particular reason to use big endian types for the data
structures? On a little endian machine you will end up converting values
everywhere. I assume that you don't expect the machine to change
endianess between reboots :-). If this is for generating/reading
filesystems from userspace, wouldn't it be better to have the userspace
tools specify the target endianess and do the conversions there?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
