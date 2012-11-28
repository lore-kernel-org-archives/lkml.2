Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2K1Txz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:53:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49868 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2K1Txw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:53:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121128194314.GF4939@ZenIV.linux.org.uk>
References: <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com> <20121128194314.GF4939@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 11:53:31 -0800
X-Google-Sender-Auth: _PllgQYRuL5ZjeOk2Lks8MLDnnI
Message-ID: <CA+55aFzfvQNtaS-B+A-vLk6jwOPy67n823Hua3kiR0sCTCw0yQ@mail.gmail.com>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:43 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>                     Have a
> private vm_operations - a copy of generic_file_vm_ops with ->open()/->close()
> added to it.

That sounds more reasonable.

However, I suspect the *most* reasonable thing to do is to just remove
the whole damn thing. We really shouldn't care about mmap. If somebody
does a mmap on a block device, and somebody else then changes the
block size, why-ever should we bother to go through any contortions at
*all* to make that kind of insane behavior do anything sane at all.

Just let people mmap things. Then just let the normal page cache
invalidation work right. In fact, it is entirely possible that we
could/should just not even invalidate the page cache at all, just make
sure that the buffer heads attached to any pages get disconnected. No?

                                  Linus
