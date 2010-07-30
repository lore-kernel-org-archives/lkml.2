Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0G3KE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:04:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34870 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0G3KE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:04:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100730095854.GA26949@infradead.org>
References: <1280482741.1851.3.camel@yio.site> <20100730094038.GA9570@infradead.org> 
	<AANLkTik-htE1mbJbnGCNwsjVJyWF24nA9dNbsRNMzuia@mail.gmail.com> 
	<20100730095854.GA26949@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 30 Jul 2010 12:04:09 +0200
Message-ID: <AANLkTinUOgBPY=CYf-FGq1VcrUkR9+75vxXGYKsRQzqj@mail.gmail.com>
Subject: Re: [PATCH] block: move del_gendisk() from fs/partitions/check.c to 
	block/genhd.c
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 11:58, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jul 30, 2010 at 11:56:56AM +0200, Kay Sievers wrote:
>> > Sounds fine for del_gendisk, but read_dev_sector which isn't mentioned
>> > here really is for partitioning.
>>
>> Right, the next patch moves it to /block/partition.c, because all the
>> sysfs and driver core code really should not be below fs/.
>>
>> If you want me to re reshuffle that, let me know. I was just annoyed
>> again, and after all these years I though it's time to move that stuff
>> around. :)
>
> So then please keep read_dev_sector in the file where it is right now,
> and just move the whole directory from fs/partitions/ to
> block/partitions.  While you're at it fs/bio.c and fs/block_dev.c
> really belong into block/, too.  The latter could also need some split
> up.

Hehe, the usual thing: "If you want that, fix all of it." :)

Are you sure, that partition formats don't belong in fs/? It's kinda
specific on-disk-layout like a fs, and I would have no problem with
that staying in fs/.

Kay
