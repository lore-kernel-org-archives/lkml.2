Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2FQQgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 12:36:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41067 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab2FQQgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 12:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <201206171458.58462.Martin@lichtvoll.de>
References: <201206170841.20222.Martin@lichtvoll.de>
	<4FDDB667.4020609@earthlink.net>
	<201206171458.58462.Martin@lichtvoll.de>
Date: Sun, 17 Jun 2012 18:36:41 +0200
X-Google-Sender-Auth: i1FnIRH4jHBYR8ffkfyDf604rOI
Message-ID: <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: jdow <jdow@earthlink.net>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Sonntag, 17. Juni 2012 schrieb jdow:
> | JXFS 64 bit file system
> |
> | With AmigaOS 4.x a new file system has been introduced called JXFS. It is
> | a totally new 64 bit file system that supports partitions up to 16 TB in
> | size. It is a modern journalling file system, which means that it reduces
> | data loss if data writes to the disk are interrupted. It is the fastest
> | and most reliable file system ever created for AmigaOS.
>
> http://www.amigaos.net/content/1/features
>
> Well I asked AmigaOS 4 developers about this issue as well. Lets see what
> they say about 2 TB limits.

16 TB = 2 TB * 8. Perhaps they increased the block size from 512 to 4096?

block/partitions/amiga.c reads the block size from
RigidDiskBlock.rdb_BlockBytes,
but after conversion to 512-byte blocks, all further calculations are done on
"int", so it will overflow for disks larger than 2 TiB.

Note that in your profile-binary.img, the field is 0x200, i.e. 512
bytes per block,
so I'll have to get a deeper look into your RDB first...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
