Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0KHHt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:49:57 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0KHHt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OVvucqyD/d7vNZAoglED9B5TAO1rEbPR9spfGEQOZY3xL7KbID4ObnPUBHpJ0UtJKu
         AWJcD2DCXO+REOS+s+K2acqsHm03nV1LYlhMAXAr5g0Epw1QmLCnm2uOXxIEOHMO8wIi
         66m545VWRPOuHF6D2vTnv2esKKze1XuS/OJcQ=
MIME-Version: 1.0
In-Reply-To: <4CD7076D.80507@bluewatersys.com>
References: <4CD518C5.6000509@gmail.com>
	<4CD7076D.80507@bluewatersys.com>
Date: Mon, 8 Nov 2010 08:49:54 +0100
Message-ID: <AANLkTinJJG0K=BPS0CPzDWcgpRn_yPxZ819N408SwD6d@mail.gmail.com>
Subject: Re: [PATCH 08/16 v2] pramfs: headers
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/7 Ryan Mallon <ryan@bluewatersys.com>:
> On 11/06/2010 09:58 PM, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Definitions for the PRAMFS filesystem.
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>> diff -Nurp linux-2.6.36-orig/fs/pramfs/pram.h linux-2.6.36/fs/pramfs/pram.h
>> --- linux-2.6.36-orig/fs/pramfs/pram.h        1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.36/fs/pramfs/pram.h     2010-10-30 12:02:45.000000000 +0200
>> @@ -0,0 +1,317 @@
>
>> +/*
>> + * Structure of the super block in PRAMFS
>> + */
>> +struct pram_super_block {
>> +     __be16  s_sum;          /* checksum of this sb, including padding */
>> +     __be64  s_size;         /* total size of fs in bytes */
>> +     __be32  s_blocksize;    /* blocksize in bytes */
>> +     __be32  s_inodes_count; /* total inodes count (used or free) */
>> +     __be32  s_free_inodes_count;/* free inodes count */
>> +     __be32  s_free_inode_hint;  /* start hint for locating free inodes */
>> +     __be32  s_blocks_count; /* total data blocks count (used or free) */
>> +     __be32  s_free_blocks_count;/* free data blocks count */
>> +     __be32  s_free_blocknr_hint;/* free data blocks count */
>> +     __be64  s_bitmap_start; /* data block in-use bitmap location */
>> +     __be32  s_bitmap_blocks;/* size of bitmap in number of blocks */
>> +     __be32  s_mtime;        /* Mount time */
>> +     __be32  s_wtime;        /* Write time */
>> +     __be16  s_magic;        /* Magic signature */
>> +     char    s_volume_name[16]; /* volume name */
>> +};
>
> Is there a particular reason to use big endian types for the data
> structures? On a little endian machine you will end up converting values
> everywhere. I assume that you don't expect the machine to change
> endianess between reboots :-). If this is for generating/reading
> filesystems from userspace, wouldn't it be better to have the userspace
> tools specify the target endianess and do the conversions there?
>
> ~Ryan

Yes, there is a reason. In the first review a comment was: the fs must
have a fix endianess layout. This fs is designed for the embedded
world mainly. Since most of cpus used in this case are big-endian, it
means that for typical use case, there is no cost for endianess
conversion.

Marco
