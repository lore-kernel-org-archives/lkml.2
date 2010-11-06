Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0KFPD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:03:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51967 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0KFPDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gJbG+Ed2kkIECRyaKtWuHKrqIIanleQb9VftXQbzKCsbPcsCwOfuK0MlyGf9QH6MrK
         CdbzZPSdqCoP8eDZcmoujWrjN2xmeCE7mYQPRd+TM7HACJlwvVvBr7T4LZaXZ9FXNhZF
         92nfNWDzp19fQqO+7uj93SPBZuEvB6s/VJ/OQ=
Message-ID: <4CD56D79.5080701@gmail.com>
Date: Sat, 06 Nov 2010 16:00:09 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Hogan <james@albanarts.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/16 v2] pramfs: XIP operations
References: <4CD518EF.3030306@gmail.com> <20101106133330.GC13522@gandalf.local>
In-Reply-To: <20101106133330.GC13522@gandalf.local>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/11/2010 14:33, James Hogan ha scritto:
> Hi,
> 
> On Sat, Nov 06, 2010 at 09:59:27AM +0100, Marco Stornelli wrote:
>> diff -Nurp linux-2.6.36-orig/fs/pramfs/xip.c linux-2.6.36/fs/pramfs/xip.c
>> --- linux-2.6.36-orig/fs/pramfs/xip.c	1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.36/fs/pramfs/xip.c	2010-09-14 18:49:52.000000000 +0200
> <snip>
>> +static int pram_find_and_alloc_blocks(struct inode *inode, sector_t iblock,
>> +				     sector_t *data_block, int create)
>> +{
>> +	int err = -EIO;
>> +	u64 block;
>> +
>> +	mutex_lock(&PRAM_I(inode)->truncate_lock);
> 
> fs/pramfs/xip.c: In function ‘pram_find_and_alloc_blocks’:
> fs/pramfs/xip.c:27: error: ‘struct pram_inode_vfs’ has no member named
> ‘truncate_lock’
> fs/pramfs/xip.c:52: error: ‘struct pram_inode_vfs’ has no member named
> ‘truncate_lock’
> 
> i guess that should be truncate_mutex.
> 

Oops, my fault, yes it's truncate_mutex. I'll fix it asap.

Marco
