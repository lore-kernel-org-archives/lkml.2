Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2ISPYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab2ISPYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:24:37 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] block: make struct block_device cacheline_aligned
References: <x49lig686kv.fsf@segfault.boston.devel.redhat.com>
	<x498vc683eq.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209191116240.30172@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 19 Sep 2012 11:24:35 -0400
In-Reply-To: <Pine.LNX.4.64.1209191116240.30172@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Wed, 19 Sep 2012 11:16:51 -0400 (EDT)")
Message-ID: <x494nmu828c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> On Wed, 19 Sep 2012, Jeff Moyer wrote:
>
>> Jeff Moyer <jmoyer@redhat.com> writes:
>> 
>> > Hi,
>> >
>> > When testing against a pcie ssd or a ramdisk, making the block device
>> > structure cacheline_aligned provided a significant increase in
>> > performance:
>> 
>> Self-NACK on this one.  This results in a ton of warnings:
>> 
>> include/linux/fs.h:727: warning: ???__section__??? attribute does not
>> apply to types
>> In file included from include/linux/debugfs.h:18,
>>                  from kernel/trace/trace_probe.h:28,
>>                  from kernel/trace/trace_kprobe.c:23:
>> include/linux/fs.h:727: warning: ???__section__??? attribute does not
>> apply to types
>> 
>> And that leaves me with the task of figuring out if/why this actually
>> helps.
>> 
>> Cheers,
>> Jeff
>
> Hi
>
> Use ____cacheline_aligned instead of __cacheline_aligned

struct block_device is allocated as part of the bdev_inode:

struct bdev_inode {
        struct block_device bdev;
        struct inode vfs_inode;
};

The bdev_inode is allocated from the bdev_cachep, which uses
SLAB_HWCACHE_ALIGN.  So, in theory, this should already be aligned.

-Jeff
