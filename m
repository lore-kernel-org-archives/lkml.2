Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2K2Uwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:52:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61971 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2K2Uwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:52:44 -0500
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
Date: Thu, 29 Nov 2012 12:52:22 -0800
X-Google-Sender-Auth: 3hrpFjdFDLcpcnIyfPZwmsC8Mws
Message-ID: <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
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
> It was all a trick to get you to say the AIO code was sane.

It's only sane compared to the DIO code.

That said, I hate AIO much less these days that we've largely merged
the code with the regular IO. It's still a horrible interface, but at
least it is no longer a really disgusting separate implementation in
the kernel of that horrible interface.

So yeah, I guess AIO really is pretty sane these days.

> It looks like we could use the private copy of i_blkbits that DIO is
> already recording.

Yes. But that didn't fix the blkdev_get_blocks() mess you pointed out.

I've pushed out two more commits to the 'block-dev' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux block-dev

in case anybody wants to take a look.

It is - as usual - entirely untested. It compiles, and I *think* that
blkdev_get_blocks() makes a whole lot more sense this way - as you
said, it should be byte-based (although it actually does the block
number conversion because I worried about overflow - probably
unnecessarily).

Comments?

                  Linus
