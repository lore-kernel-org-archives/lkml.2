Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2K2Tzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:55:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42719 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2K2Tzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:55:31 -0500
MIME-Version: 1.0
In-Reply-To: <20121129194840.GC3490@shiny>
References: <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk> <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny> <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 11:55:09 -0800
X-Google-Sender-Auth: 9QtWJ4G14ZFFaqz2yYP2pBgNMbc
Message-ID: <CA+55aFzosQ+Jo6fH2qr5s5YDPvW=CkTGokOLB0tYjZp6ujj3Nw@mail.gmail.com>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:48 AM, Chris Mason <chris.mason@fusionio.com> wrote:
>
> blkdev_get_blocks (called during DIO) is also checking i_blkbits, but I
> really don't get why that isn't byte based instead.  DIO is already
> doing the shift & mask game.

The blkdev_get_blocks() this is just sad.

The underlying data structure is actually byte-based (it's
"i_size_read(bdev->bd_inode"), but we convert it to a block-based
number.

Oops.

           Linus
